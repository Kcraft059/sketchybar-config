#!/bin/bash

##
#	Good to know, rift can pass additionnal args
#	run_on_start = [
#	  "rift-cli subscribe cli --event workspace_changed --command /bin/bash --args -c --args 'sketchybar --trigger rift_workspace_changed FOCUSED_WORKSPACE=\\\"$RIFT_WORKSPACE_NAME\\\"'",
#	  "rift-cli subscribe cli --event windows_changed --command /bin/bash --args -c --args 'sketchybar --trigger rift_windows_changed RIFT_WORKSPACE_NAME=\\\"$RIFT_WORKSPACE_NAME\\\" RIFT_WINDOW_COUNT=\\\"$RIFT_WINDOW_COUNT\\\"'"
#	]
##

# Get workspace ID from command line argument or extract from NAME
WORKSPACE_ID=${1:-${NAME#space.}}                      # Space with formated name for sketchybar (s/ /__/g)
RIFT_SPACE_ID=$(echo "$WORKSPACE_ID" | sed 's/__/ /g') # Space with full name for rift

# Set RELPATH for accessing other scripts
export RELPATH=$(dirname $0)/../../..
source $RELPATH/set_colors.sh

update() {
	# Get current focused workspace
	FOCUSED_WORKSPACE=$(rift-cli query workspaces | jq -r '.[] | select(.is_active == true) | .name')

	# Check if this workspace is the focused one
	if [ "$FOCUSED_WORKSPACE" = "$RIFT_SPACE_ID" ]; then
		SELECTED="true"
	else
		SELECTED="false"
	fi

	WIDTH="dynamic"
	if [ "$SELECTED" = "true" ]; then
		WIDTH="0"
		sketchybar --set $NAME background.drawing=off
	fi

	sketchybar --animate tanh 20 --set $NAME \
		icon.highlight=$SELECTED \
		label.width=$WIDTH
}

mouse_clicked() {
	if [ "$BUTTON" = "right" ]; then
		# Right click could be used for destroying workspaces if needed
		echo "Right click on rift workspace not supported"
	else
		# Query from workspace name in cas of custom name
		WORKSPACE_INDEX=$(rift-cli query workspaces 2>/dev/null | jq -r --arg name "$RIFT_SPACE_ID" '.[] | select(.name == $name) | .index')

		# Focus the rift workspace
		rift-cli execute workspace switch "$WORKSPACE_INDEX" >/dev/null
	fi
}

case "$SENDER" in
"mouse.clicked")
	mouse_clicked
	;;
"rift_windows_changed")
	# Only update windows in case of a window change
	$RELPATH/plugins/spaces/rift/script-windows.sh "$WORKSPACE_ID"
	;;
*)
	# Update icons
	$RELPATH/plugins/spaces/rift/script-windows.sh "$WORKSPACE_ID"
	# Update focused state when workspace changes
	update
	;;
esac
