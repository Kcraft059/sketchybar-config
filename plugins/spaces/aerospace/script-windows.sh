#!/bin/bash
export RELPATH=$(dirname $0)/../..
source "$RELPATH/../icon_map.sh"

##
# Aerospace workspace windows indicator
# This script updates workspace labels to show app icons for windows in each workspace
#	This script is ran by each space item and thus shouldn't update all the spaces but only the caller.
##

update_workspace_windows() {
	local workspace_id=$1

	# Get apps in this workspace
	apps=$(aerospace list-windows --workspace "$workspace_id" --format '%{app-name}' 2>/dev/null | sort -u)

	icon_strip=" "
	if [ "${apps}" != "" ]; then
		while read -r app; do
			icon_strip+=" $(
				__icon_map "$app"
				echo $icon_result
			)"
		done <<<"${apps}"
		sketchybar --set space.$workspace_id label="$icon_strip" label.drawing=on

		FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused 2>/dev/null)

		if ! [ "$FOCUSED_WORKSPACE" = "$workspace_id" ]; then
			sketchybar --set space.$workspace_id background.drawing=on
		else
			sketchybar --set space.$workspace_id background.drawing=off
		fi

	else
		# No apps in workspace, hide label
		icon_strip=" -"
		sketchybar --set space.$workspace_id label.drawing=off background.drawing=off
	fi
}

update_workspace_windows "$1"
