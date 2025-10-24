#!/bin/bash
export RELPATH=$(dirname $0)/../..
source $RELPATH/log_handler.sh

setscroll() {
  STATE="$(sketchybar --query "music.title" | sed 's/\\n//g; s/\\\$//g; s/\\ //g' | jq -r '.geometry.scroll_texts')"
	
  
	case "$1" in
  "on")
    target="off"
    ;;
  "off")
    target="on"
    ;;
  esac

  if [[ "$STATE" == "$target" ]]; then
		sendLog "Toggled scroll for media title to $1" "vomit"
    sketchybar --set "music.title" scroll_texts=$1
    sketchybar --set "music.subtitle" scroll_texts=$1
  fi

}

### Only scroll text on mouse hover for better performances

case "$SENDER" in
"mouse.entered")
  setscroll on
  ;;
"mouse.exited")
  setscroll off
  ;;
esac
