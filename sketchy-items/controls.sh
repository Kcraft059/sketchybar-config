#!/bin/bash
for item in "${MENU_CONTROLS[@]}"; do
  new_item=$(echo "$item" | sed -e 's/__/ /g')
  menuitem+=("$new_item")
done

for item in "${menuitem[@]}"; do
  SCRIPT_CLICK_MENU_ITEM="export PATH=$PATH; $RELPATH/plugins/controls/click.sh"
	
  alias=(
    drawing=off
    #background.color=0xffff0000
    padding_left=-3
    padding_right=-7
    #x_offset=20
    alias.color=$GLOW
    label.drawing=off
    icon.drawing=off
    click_script="$SCRIPT_CLICK_MENU_ITEM"
  )

  sketchybar --add alias "$item" right \
    --set "$item" "${alias[@]}"
	
	sendLog "Added alias $item" "vomit"

done
