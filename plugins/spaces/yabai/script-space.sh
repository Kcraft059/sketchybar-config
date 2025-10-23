#!/bin/bash

##
# Yabai (macOS native) workspace status indicator
# This script highlights the current focused / active space
# And also manages the animations for space switching
##

## Exports
export RELPATH=$(dirname $0)/../../..
source "$RELPATH/icon_map.sh"
if [[ -n "$SKETCHYBAR_CONFIG" && -f "$SKETCHYBAR_CONFIG" ]]; then
	source "$SKETCHYBAR_CONFIG"
elif [[ -f "$RELPATH/config.sh" ]]; then
	source "$RELPATH/config.sh"
fi
: "${HIDE_EMPTY_SPACES:=false}"

## Function definition
mouse_clicked() {
	if [ "$BUTTON" = "right" ]; then
		yabai -m space --destroy $SID
		sketchybar --trigger space_change --trigger windows_on_spaces
	else
		yabai -m space --focus $SID 2>/dev/null
	fi
}

update() {

	# Space hiding logic
	if $HIDE_EMPTY_SPACES; then
		# Check if space empty using space label value
		if [[ "$(sketchybar --query $NAME | jq -r .label.value)" == " " ]]; then
			DRAWING=off
		fi
		# If space is active space draw anyway.
		if [[ "$SELECTED" == "true" ]]; then
			DRAWING=on
		fi
		# If $DRAWING has no value don't update
		if [[ -n "$DRAWING" ]]; then
			sketchybar --set $NAME drawing=$DRAWING
		fi
	fi

	WIDTH="dynamic"
	if [ "$SELECTED" = "true" ]; then
		WIDTH="0"
		sketchybar --set $NAME background.drawing=off
	fi

	sketchybar --animate tanh 20 --set $NAME icon.highlight=$SELECTED label.width=$WIDTH
}

## Main logic
case "$SENDER" in
"mouse.clicked")
	mouse_clicked
	;;
*)
	# Update focused state
	update
	;;
esac
