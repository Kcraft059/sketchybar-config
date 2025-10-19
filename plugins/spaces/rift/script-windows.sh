#!/bin/bash

# Rift workspace windows indicator
# This script updates workspace labels to show app icons for windows in each workspace

# Get workspace ID from command line argument or extract from NAME
WORKSPACE_ID=${1:-${NAME#space.}}                      # Space with formated name for sketchybar
RIFT_SPACE_ID=$(echo "$WORKSPACE_ID" | sed 's/__/ /g') # Space with full name for rift

# Set RELPATH for accessing other scripts
export RELPATH=$(dirname $0)/../..
source "$RELPATH/../icon_map.sh"

update_workspace_windows() {
	# Get apps in this workspace (using bundle_id as app identifier)
	apps=$(rift-cli query workspaces | jq -r ".[] | select(.name == \"$RIFT_SPACE_ID\") | .windows[].bundle_id" | sort -u)

	icon_strip=" "
	if [ "${apps}" != "" ]; then
		while read -r app; do
			icon_strip+=" $(
				__icon_map "$app"
				echo $icon_result
			)"
		done <<<"${apps}"
		sketchybar --set space.$WORKSPACE_ID label="$icon_strip" label.drawing=on

		# Get focused workspace to determine background drawing
		FOCUSED_WORKSPACE=$(rift-cli query workspaces | jq -r '.[] | select(.is_active == true) | .name')

		if ! [ "$FOCUSED_WORKSPACE" = "$RIFT_SPACE_ID" ]; then
			sketchybar --set space.$WORKSPACE_ID background.drawing=on
		else
			sketchybar --set space.$WORKSPACE_ID background.drawing=off
		fi

	else
		# No apps in workspace, hide label
		icon_strip=" -"
		sketchybar --set space.$WORKSPACE_ID label.drawing=off background.drawing=off
	fi
}

update_workspace_windows
