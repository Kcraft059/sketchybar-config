#!/bin/bash

## Scripts
SCRIPT_CLICK_MENUS="export PATH=$PATH; $RELPATH/plugins/menus/click.sh"

## Properties
menu_dummy=(
	label.drawing=off
	click_script="$SCRIPT_CLICK_MENUS"
	drawing=off
	padding_left=4
)

## Item addition
for ((i = 1; i <= 14; ++i)); do
	menu=("${menu_dummy[@]}")

	menu+="icon=$i"
	[ $i = 1 ] && menu+=( # Properties for application main menu
		icon.font="$FONT:Heavy:14.0"
		icon.color=$GLOW
	)

	sketchybar --add item menu.$i left \
		--set menu.$i "${menu[@]}"
done

sketchybar --add bracket menus '/menu\..*/' \
	--set menus "${zones[@]}"

sendLog "Added menus items" "vomit"
