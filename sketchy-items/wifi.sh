#!/bin/bash

## Scripts
SCRIPT_WIFI="export PATH=$PATH; $RELPATH/plugins/wifi/script.sh $WIFI_UNREDACTOR"
SCRIPT_CLICK_WIFI="export PATH=$PATH; $RELPATH/plugins/wifi/click.sh"

## Item properties
wifi=(
  script="$SCRIPT_WIFI"
  click_script="$SCRIPT_CLICK_WIFI"
  label="Searching…"
  icon=􀙥
  icon.color=$SUBTLE
  icon.padding_right=0
  label.max_chars=10
  label.font="$FONT:Semibold:10.0"
  padding_left=0
  padding_right=5
)

## Item addition
sketchybar --add item wifi right \
  --set wifi "${wifi[@]}" \
  --subscribe wifi wifi_change mouse.entered mouse.exited

sendLog "Added wifi item" "vomit"