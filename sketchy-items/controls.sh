#!/bin/bash

## Scripts
SCRIPT_CLICK_MENU_ITEM="export PATH=$PATH; $RELPATH/plugins/controls/click.sh"

## Item properties
alias=( 
	drawing=off
	padding_left=-3
	padding_right=-7
	alias.color=$GLOW
	label.drawing=off
	icon.drawing=off
	click_script="$SCRIPT_CLICK_MENU_ITEM"
)

## Control name formating in order to handle white spaces
for item in "${MENU_CONTROLS[@]}"; do
	new_item=$(echo "$item" | sed -e 's/__/ /g')
	menuitem+=("$new_item")
done

## Addition of each items
for item in "${menuitem[@]}"; do
	sketchybar --add alias "$item" right \
		--set "$item" "${alias[@]}"

	sendLog "Added alias $item" "vomit"
done
