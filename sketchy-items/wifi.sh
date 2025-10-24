#!/bin/bash
SCRIPT_WIFI="export PATH=$PATH; $RELPATH/plugins/wifi/script.sh $WIFI_UNREDACTOR"

SCRIPT_CLICK_WIFI="export PATH=$PATH; $RELPATH/plugins/wifi/click.sh"

wifi=(
  script="$SCRIPT_WIFI"
  click_script="$SCRIPT_CLICK_WIFI"
  label="Searching…"
  icon=􀙥
  icon.color=$SUBTLE
  icon.padding_right=0
  label.max_chars=10
  label.font="$FONT:Semibold:10.0"
  #scroll_texts=on
  #scroll_duration=100
  #update_freq=5
  padding_left=0
  padding_right=0
)

sketchybar --add item wifi right \
  --set wifi "${wifi[@]}" \
  --subscribe wifi wifi_change mouse.entered mouse.exited

sendLog "Added wifi item" "vomit"