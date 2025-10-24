#!/bin/bash
SCRIPT_CLICK_DISPLAY="export PATH=$PATH; $RELPATH/plugins/display/click.sh"
SCRIPT_DISPLAY="export PATH=$PATH; $RELPATH/plugins/display/script.sh"

display=(
  icon=􀨧
  click_script="$SCRIPT_CLICK_DISPLAY"
  script="$SCRIPT_DISPLAY"
  icon.color=$SELECT
  icon.padding_right=2
  label.max_chars=10
  label.font="$FONT:Semibold:10.0"
  scroll_texts=on
  #scroll_duration=100
  padding_left=0
  padding_right=0
  label.drawing=off
)

sketchybar --add item display right \
  --set display "${display[@]}" \
  --subscribe display system_woke display_change

sendLog "Added display item" "vomit"
