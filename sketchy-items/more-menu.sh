#!/bin/bash
# sketchybar --query default_menu_items

menuitems=(
  "pkgs"
  "user"
  "notif"
)

SCRIPT_CLICK_SEPARATOR_MORE="export PATH=$PATH; \
$RELPATH/plugins/more-menu/script.sh \
\"${MENU_CONTROLS[@]}\" \"${menuitems[@]}\" $INNER_PADDINGS \"$FONT\" "

separator=(
  icon=􀯶
  label.drawing=off
  icon.font="$FONT:Semibold:14.0"
  #click_script='yabai -m space --create && sketchybar --trigger space_change'
  icon.color=$SUBTLE
  click_script="$SCRIPT_CLICK_SEPARATOR_MORE"
)

sketchybar --add item separator-more right \
  --set separator-more "${separator[@]}" \
  --add event more-menu-update

sendLog "Added separator toggle for 'more-menu' to toggle : ${MENU_CONTROLS[*]} ${menuitems[*]}" "vomit"