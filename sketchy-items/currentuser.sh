#!/bin/bash
command -v 'menubar' 2>/dev/null 1>&2 || alias menubar="$RELPATH/menubar"

SCRIPT_USER="export PATH=$PATH; $RELPATH/plugins/currentuser/script.sh"
SCRIPT_CLICK_USER="export PATH=$PATH; menubar -s \"Control Center,UserSwitcher\""

user=(
  icon=􀅷
  icon.color=$ACTIVE
  icon.font="$FONT:Medium:12.0"
  icon.y_offset=1
  icon.padding_right=0
  icon.padding_left=0
  drawing=off
  click_script="$SCRIPT_CLICK_USER"
  script="$SCRIPT_USER"
  label.font="$FONT:Medium:13.0"
  #scroll_duration=100
  padding_left=$INNER_PADDINGS
  padding_right=$(($INNER_PADDINGS / 2))
  label.color=$TEXT
  label.drawing=on
  label.padding_right=0
  label.padding_left=3
  update_freq=0
)

sketchybar --add item moremenu.user right \
  --set moremenu.user "${user[@]}" \
  --subscribe moremenu.user more-menu-update

sendLog "Added current user item for $(whoami)" "vomit"
