#!/bin/bash

# Get workspace ID from command line argument or extract from NAME
WORKSPACE_ID=${1:-${NAME#space.}}

# Set RELPATH for accessing other scripts
export RELPATH=$(dirname $0)/../../..
source $RELPATH/set_colors.sh
shopt -s expand_aliases
command -v 'ft-haptic' 2>/dev/null 1>&2 || alias ft-haptic="$RELPATH/ft-haptic"

# Debug: Always log when script is called -> will be introduced later
# echo "$(date): Script called with SENDER='$SENDER' NAME='$NAME' WORKSPACE_ID='$WORKSPACE_ID'" >> /tmp/aerospace-script-debug.log

# Get current focused workspace if not provided
FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused 2>/dev/null)

# Check if this workspace is the focused one
if [ "$FOCUSED_WORKSPACE" = "$WORKSPACE_ID" ]; then
	SELECTED="true"
else
	SELECTED="false"
fi

update() {

	WIDTH="dynamic"
	if [ "$SELECTED" = "true" ]; then
		WIDTH="0"
	fi

	sketchybar --animate tanh 20 --set $NAME \
		icon.highlight=$SELECTED \
		label.width=$WIDTH

}

mouse_clicked() {
	if [ "$BUTTON" = "right" ]; then
		# Aerospace doesn't support destroying workspaces the same way as yabai
		# This would be a no-op or could trigger a custom action
		echo "Right click on aerospace workspace not supported"
	else
		# Focus the aerospace workspace
		aerospace workspace "$WORKSPACE_ID" 2>/dev/null

	fi
}

case "$SENDER" in
"mouse.clicked")
	mouse_clicked
	;;
"mouse.entered")
	if [[ "$(sketchybar --query $NAME | jq -r .label.value)" != " " ]] && [[ $SELECTED != true ]]; then
		ft-haptic -n 1
	fi
	;;
*)
	# Update icons
	$RELPATH/plugins/spaces/aerospace/script-windows.sh "$WORKSPACE_ID"
	# Update focused state
	update
	;;
esac
