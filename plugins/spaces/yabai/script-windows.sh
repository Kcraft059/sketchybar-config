#!/bin/bash

##
# Yabai (macOS native) workspace windows indicator
# This script updates workspace labels to show app icons for windows in each workspace
#	This script is ran by the separator x times the number of worspaces,
# $INFO providing { "space": <spaceId>, "apps": { "<appName>": <numberOfWindows> } }
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

# Toggle space icon strip visibility
toggle_space_visibility() { # $1 -> true/false $2 -> spaceIndex
	local state=$1
	local space="$2"

	visible_spaces=($(yabai -m query --spaces | jq -r '.[] | select(.["is-visible"] == true) | .index'))

	if $state; then
		# When switching space on

		if [[ "${visible_spaces[*]}" =~ "$space" ]]; then
			# If space is visible, no background
			sketchybar --set space.$space \
				background.drawing=off
		else
			# If space is not visible, background
			sketchybar --set space.$space \
				background.drawing=on

			# If space was empty before, play animation
			if [[ $(sketchybar --query space.$space | jq -r .label.drawing) == "off" ]]; then
				sketchybar --set space.$space label.width=0 label.drawing=on
				sketchybar --animate tanh 20 --set space.$space label.width=dynamic
			fi
		fi

	else
		# When switching space off

		if [[ "${visible_spaces[*]}" =~ "$space" && $HIDE_EMPTY_SPACES ]]; then
			# If empty spaces are hidden but space is selected, draw anyaway
			sketchybar --set space.$space drawing=on
		elif $HIDE_EMPTY_SPACES; then
			sketchybar --set space.$space drawing=off
		fi
		sketchybar --set space.$space label.drawing=off background.drawing=off

	fi
}

# Set space item style & label
update_workspace_windows() {
	# Get space and active apps
	space="$(echo "$INFO" | jq -r '.space')"
	apps="$(echo "$INFO" | jq -r '.apps | keys[]')"

	icon_strip=" "
	if [ "${apps}" != "" ]; then
		# If there are active apps, make label

		while read -r app; do
			icon_strip+=" $(
				__icon_map "$app"
				echo $icon_result
			)"
		done <<<"${apps}"
		sketchybar --set space.$space label="$icon_strip"

		# If there are active apps, show label
		toggle_space_visibility true $space
	else
		sketchybar --set space.$space label="$icon_strip"
		# If there's no active apps, don't show label
		toggle_space_visibility false $space
	fi
}

## Main logic
if [ "$SENDER" = "space_windows_change" ]; then
	update_workspace_windows
fi
