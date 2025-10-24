#!/bin/bash
# sketchybar --query default_menu_items

## Included moremenu.x sketchybar items
menuitems=("${MENU_CONTROLS[@]}")
menuitems+=(
  moremenu.pkgs
  moremenu.user
  moremenu.notif
)

## Scripts
SCRIPT_CLICK_SEPARATOR_MORE="export PATH=$PATH; \
$RELPATH/plugins/more-menu/script.sh \
\"${menuitems[*]}\" $INNER_PADDINGS \"$FONT\" "

## Item properties
separator=(
  icon=􀯶
  label.drawing=off
  icon.font="$FONT:Semibold:14.0"
  #click_script='yabai -m space --create && sketchybar --trigger space_change'
  icon.color=$SUBTLE
  click_script="$SCRIPT_CLICK_SEPARATOR_MORE"
)

## Item addition
sketchybar --add item separator-more right \
  --set separator-more "${separator[@]}" \
  --add event more-menu-update

sendLog "Added separator toggle for 'more-menu' to toggle : ${MENU_CONTROLS[*]} ${menuitems[*]}" "vomit"