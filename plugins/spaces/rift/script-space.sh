#!/bin/bash

# Get workspace ID from command line argument or extract from NAME
WORKSPACE_ID=${1:-${NAME#space.}}

# Set RELPATH for accessing other scripts
export RELPATH=$(dirname $0)/../../..
source $RELPATH/set_colors.sh

update() {
    # Get current focused workspace
    FOCUSED_WORKSPACE=$(rift-cli query workspaces | jq -r '.[] | select(.is_active == true) | .name')

    # Check if this workspace is the focused one
    if [ "$FOCUSED_WORKSPACE" = "$WORKSPACE_ID" ]; then
        SELECTED="true"
    else
        SELECTED="false"
    fi

    WIDTH="dynamic"
    if [ "$SELECTED" = "true" ]; then
        WIDTH="0"
    fi

    sketchybar --animate tanh 20 --set $NAME \
        icon.highlight=$SELECTED \
        label.width=$WIDTH
}

update_all_workspaces() {
    # Get current focused workspace
    FOCUSED_WORKSPACE=$(rift-cli query workspaces | jq -r '.[] | select(.is_active == true) | .name')

    # Get all existing workspaces
    workspaces=$(rift-cli query workspaces | jq -r '.[].name')

    # Update all workspace items with the current focused workspace
    for workspace in $workspaces; do
        if [ "$FOCUSED_WORKSPACE" = "$workspace" ]; then
            sketchybar --animate tanh 20 --set space.$workspace icon.highlight=on label.width=0
        else
            sketchybar --animate tanh 20 --set space.$workspace icon.highlight=off label.width=dynamic
        fi
    done
}

mouse_clicked() {
    if [ "$BUTTON" = "right" ]; then
        # Right click could be used for destroying workspaces if needed
        echo "Right click on rift workspace not supported"
    else
        # Rift uses 0-based indexing for switch command, but workspace names are 1-based
        # Convert workspace name to 0-based index
        WORKSPACE_INDEX=$((WORKSPACE_ID - 1))

        # Focus the rift workspace
        rift-cli execute workspace switch "$WORKSPACE_INDEX"

        # Update highlighting for all workspaces after click
        update_all_workspaces
    fi
}

case "$SENDER" in
"mouse.clicked")
    mouse_clicked
    ;;
"rift_workspace_change")
    # Update focused state when workspace changes
    update
    ;;
*)
    # Update focused state
    update
    # Update icons
    $RELPATH/plugins/spaces/rift/script-windows.sh $1
    ;;
esac
