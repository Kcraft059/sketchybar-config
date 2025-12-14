#!/bin/bash
export RELPATH=$(dirname $0)/../..;
shopt -s expand_aliases
WIDTH=100

command -v 'menubar' 2>/dev/null 1>&2 || alias menubar="$RELPATH/menubar"

detail_on() {
  sketchybar --animate tanh 30 --set volume slider.width=$WIDTH
}

detail_off() {
  sketchybar --animate tanh 30 --set volume slider.width=0
}

toggle_detail() {
  if [ $BUTTON = "left" ]; then
    INITIAL_WIDTH=$(sketchybar --query volume | sed 's/\\n/\\\\n/g; s/\\\$/$/g' | jq -r '.slider.width')
    if [ "$INITIAL_WIDTH" -eq "0" ]; then
      detail_on
    else
      detail_off
    fi
  else
    menubar -s "Control Center,Sound"
  fi
}

toggle_detail