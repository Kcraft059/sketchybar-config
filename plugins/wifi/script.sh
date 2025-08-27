#!/bin/bash
export RELPATH=$(dirname $0)/../..;
source $RELPATH/colors.sh

ICON_HOTSPOT=􀉤
ICON_WIFI=􀙇
ICON_WIFI_ERROR=􀙥
ICON_WIFI_OFF=􀙈

getname() {
  WIFI_PORT=$(networksetup -listallhardwareports | awk '/Hardware Port: Wi-Fi/{getline; print $2}')
  WIFI="$(system_profiler SPAirPortDataType | awk '/Current Network/ {getline;$1=$1; gsub(":",""); print;exit}')" #$(ipconfig getsummary $WIFI_PORT | awk -F': ' '/ SSID : / {print $2}')
  HOTSPOT=$(ipconfig getsummary $WIFI_PORT | grep sname | awk '{print $3}')
  IP_ADDRESS=$(scutil --nwi | grep address | sed 's/.*://' | tr -d ' ' | head -1)
  PUBLIC_IP=$(curl -m 2 https://ipinfo.io 2>/dev/null 1>&2; echo $?)

  ### Set icon according to wifi state

  if [[ $HOTSPOT != "" ]]; then
    ICON=$ICON_HOTSPOT
    ICON_COLOR=$FOAM
    LABEL=$HOTSPOT
  elif [[ $WIFI != "" ]]; then
    ICON=$ICON_WIFI
    ICON_COLOR=$PINE
    LABEL="$WIFI"
  elif [[ $IP_ADDRESS != "" ]]; then
    ICON=$ICON_WIFI
    ICON_COLOR=$ROSE
    LABEL="on"
  else
    ICON=$ICON_WIFI_OFF
    ICON_COLOR=$LOVE
    LABEL="off"
  fi

  ### If no access to internet change icon + add a notice to the label

  if [[ $PUBLIC_IP != "0" && $LABEL != "off" ]];then
    ICON=$ICON_WIFI_ERROR
    ICON_COLOR=$SUBTLE
    LABEL="$WIFI (no internet)"
  fi
  


  wifi=(
    icon=$ICON
    label="$LABEL"
    icon.color=$ICON_COLOR
  )

  sketchybar --set $NAME "${wifi[@]}"
}

setscroll() {

  ### For performances, only scroll on hover

  STATE="$(sketchybar --query $NAME | sed 's/\\n//g; s/\\\$//g; s/\\ //g' | jq -r '.geometry.scroll_texts')"

  case "$1" in
    "on") target="off"
    ;;
    "off") target="on"
    ;;
  esac

  if [[ "$STATE" == "$target" ]]; then
    sketchybar --set "$NAME" scroll_texts=$1
  fi

}

case "$SENDER" in
  "mouse.entered") setscroll on 
  ;;
  "mouse.exited") setscroll off
  ;;
  *) getname
  ;;
esac
