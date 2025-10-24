#!/bin/bash
SCRIPT_CLICK_BATTERY="export PATH=$PATH; $RELPATH/plugins/battery/click.sh"
SCRIPT_BATTERY="export PATH=$PATH; $RELPATH/plugins/battery/script.sh"

battery=(
  drawing=off
  script=$SCRIPT_BATTERY
  click_script="$SCRIPT_CLICK_BATTERY"
  #icon=􀺸
  icon.font="$FONT:Regular:16.0"
  icon.padding_left=$(($OUTER_PADDINGS - 4))
  icon.padding_right=0
  label=""
  label.font="$FONT:Semibold:10.0"
  label.padding_left=$INNER_PADDINGS
  label.padding_right=$OUTER_PADDINGS
  update_freq=120
  updates=on
)

sketchybar --add item battery right \
  --set battery "${battery[@]}" \
  --subscribe battery power_source_change system_woke

sendLog "Added battery item" "vomit"