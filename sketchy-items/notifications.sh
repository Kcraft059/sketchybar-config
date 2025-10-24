#!/bin/bash
SCRIPT_NOTIF="export PATH=$PATH; $RELPATH/plugins/notifications/script.sh $GITHUB_TOKEN"
SCRIPT_CLICK_NOTIF="export PATH=$PATH; open \"https://github.com/notifications\""

notif=(
  drawing=off
  script="$SCRIPT_NOTIF"
  click_script="$SCRIPT_CLICK_NOTIF"
  icon=􀋞
  icon.color=$NOTICE
  icon.font="$FONT:Regular:14.0"
  icon.padding_left=0 #$(($OUTER_PADDINGS - 4))
  icon.padding_right=0
  label=--
  label.font="$FONT:Semibold:10.0"
  label.padding_left=$INNER_PADDINGS
  label.padding_right=0
  padding_left=$INNER_PADDINGS
  padding_right=$(($INNER_PADDINGS / 2))
  update_freq=1800
  updates=when_shown
)

sketchybar --add item moremenu.notif right \
  --set moremenu.notif "${notif[@]}" \
  --subscribe moremenu.notif more-menu-update wifi_change

sendLog "Added notification item" "vomit"