#!/bin/bash

## Scripts
SCRIPT_CLICK_MENUS="export PATH=$PATH; $RELPATH/plugins/menus/click.sh"

## Properties
space_dummy=(
	label.drawing=off
	click_script="$SCRIPT_CLICK_MENUS"
	drawing=off
	padding_left=4
)

## Item addition
for ((i = 1; i <= 14; ++i)); do
	space=("${space_dummy[@]}")

	space+="icon=$i"
	[ $i = 1 ] && space+=( # Properties for Apple logo
		icon.font="$FONT:Heavy:14:0"
		icon.color=$GLOW
	)

	sketchybar --add item menu.$i left \
		--set menu.$i "${space[@]}"
done

sketchybar --add bracket menus '/menu\..*/' \
	--set menus "${zones[@]}"

sendLog "Added menus items" "vomit"
