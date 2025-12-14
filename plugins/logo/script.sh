#!/bin/bash
export RELPATH=$(dirname $0)/../..
source $RELPATH/set_colors.sh
shopt -s expand_aliases

FONT=$1
X_BAR_PADDING=$2
MENUBAR_AUTOHIDE=$3

command -v 'menubar' 2>/dev/null 1>&2 || alias menubar="$RELPATH/menubar"
command -v 'ft-haptic' 2>/dev/null 1>&2 || alias ft-haptic="$RELPATH/ft-haptic"

# Get state from background drawing of logo (should be changed)
STATE="$(sketchybar --query $NAME | sed 's/\\n//g; s/\\\$//g; s/\\ //g' | jq -r '.geometry.background.drawing')"

if [[ -z "$STATE" ]]; then STATE="off"; fi

# Show menu titles
menu_on() {
	# For each space in the bracket - change their appearance to on
	for space in $(sketchybar --query spaces | jq -r '.bracket[]'); do
		sketchybar --set $space drawing=off
	done
	sketchybar --set spaces drawing=off \
		--set separator drawing=off \
		--set front_app drawing=off \
		--animate tanh 15 --set $NAME background.drawing=on \
		icon.color=$SELECT \
		icon=􀣺 \
		icon.font="$FONT:Black:17.0" \
		icon.y_offset=1 \
		padding_right=5 \
		padding_left=5
	update_menus

	if $MENUBAR_AUTOHIDE; then
		sleep 30
		menu_off
	fi
}

menu_off() {
	# For each space in the bracket - change their appearance to off
	for space in $(sketchybar --query spaces | jq -r '.bracket[]'); do
		sketchybar --set $space drawing=on
	done
	sketchybar --set spaces drawing=on \
		--set separator drawing=on \
		--set front_app drawing=on \
		--animate tanh 15 --set $NAME background.drawing=off \
		icon.color=$TEXT \
		icon=􀆔 \
		icon.font="$FONT:Semibold:14.0" \
		icon.y_offset=0 \
		padding_right=10 \
		padding_left=$X_BAR_PADDING

	for ((i = 1; i <= 14; ++i)); do
		sketchybar --set menu.$i drawing=off
	done
}

toggle_menu() {

	### Perform different actions depending on state

	if [ $BUTTON = "right" ]; then
		if [ $STATE = "off" ]; then
			menu_on
		elif [ $STATE = "on" ]; then
			menu_off
		fi
	elif [ $MODIFIER = "shift" ]; then
		sketchybar --reload
	else
		if [ $STATE = "off" ]; then
			/System/Applications/Mission\ Control.app/Contents/MacOS/Mission\ Control
		elif [ $STATE = "on" ]; then
			menubar -s 0
		fi
	fi
}

update_menus() {
	mid=1
	while IFS= read -r menu; do
		sketchybar --set menu.$mid icon="$menu" drawing=on
		mid=$(($mid + 1))
	done < <(menubar -l)

	### Only set off for menu that have not been updated

	while [[ $mid -le 14 ]]; do
		sketchybar --set menu.$mid drawing=off
		mid=$((mid + 1))
	done
}

case "$SENDER" in
"mouse.clicked")
	toggle_menu
	;;
"mouse.entered")
	ft-haptic -n 1
	;;
"front_app_switched")
	if [ $STATE = "on" ]; then
		update_menus
		sleep 1
		update_menus
	fi
	;;
*) if [ $STATE = "on" ]; then update_menus; fi ;;
esac
