#!/bin/bash
export RELPATH=$(dirname $0)/../..
source $RELPATH/colors.sh

ICONS_MICROPHONE=(􀊲 􀊰 􀊱) # Set mic icons

update_icon() {
  VOLUME=$(osascript -e 'set ivol to input volume of (get volume settings)')
  # Set icon + color depending on volume
  case $VOLUME in
  [6-9][0-9] | 100)
    ICON=${ICONS_MICROPHONE[2]}
    COLOR=$IRIS
    ;;
  [1-9] | [1-5][0-9])
    ICON=${ICONS_MICROPHONE[1]}
    COLOR=$ROSE
    ;;
  *)
    ICON=${ICONS_MICROPHONE[0]}
    COLOR=$LOVE
    ;;
  esac

  sketchybar --animate tanh 30 --set $NAME icon=$ICON icon.color=$COLOR
}

update_label() {
  VOLUME=$(osascript -e 'set ivol to input volume of (get volume settings)')
  if [ $VOLUME != 0 ]; then
    # Store current volume in item's label
    mic=(
      label=$VOLUME
      label.drawing=off
    )
    sketchybar --set $NAME "${mic[@]}"
  fi
}

mute_mic() {
  osascript -e 'set volume input volume 0'
}

unmute_mic() {
  # Restore from saved volume in label
  STORED_VOLUME=$(sketchybar --query $NAME | sed 's/\\n//g; s/\\\$//g; s/\\ //g' | jq -r '.label.value')
  osascript -e "set volume input volume $STORED_VOLUME"
}

toggle_mic() {
  VOLUME=$(osascript -e 'set ivol to input volume of (get volume settings)')
  if [ $VOLUME = 0 ]; then
    update_label
    unmute_mic
  else
    mute_mic
  fi
}

case "$SENDER" in
"mouse.clicked")
  toggle_mic
  update_icon
  ;;
*)
  update_label
  update_icon
  ;;
esac
