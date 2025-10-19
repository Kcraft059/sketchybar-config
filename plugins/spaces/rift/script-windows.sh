#!/bin/bash

# Rift workspace windows indicator
# This script updates workspace labels to show app icons for windows in each workspace

export RELPATH=$(dirname $0)/../..
source "$RELPATH/../icon_map.sh"

update_workspace_windows() {
    local workspace_id=$1

    # Get apps in this workspace (using bundle_id as app identifier)
    apps=$(rift-cli query workspaces | jq -r ".[] | select(.name == \"$workspace_id\") | .windows[].bundle_id" | sort -u)

    icon_strip=" "
    if [ "${apps}" != "" ]; then
        while read -r app; do
        icon_strip+=" $(
        __icon_map "$app"
        echo $icon_result
        )"
        done <<<"${apps}"
        sketchybar --set space.$workspace_id label="$icon_strip" label.drawing=on

        # Get focused workspace to determine background drawing
        FOCUSED_WORKSPACE=$(rift-cli query workspaces | jq -r '.[] | select(.is_active == true) | .name')

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

# Update all workspaces
update_all_workspace_windows() {
    workspaces=$(rift-cli query workspaces | jq -r '.[].name')
    for workspace in $workspaces; do
        update_workspace_windows "$workspace"
    done
}

# Main logic
if [ -n "$1" ]; then
    # Update specific workspace
    update_workspace_windows "$1"
else
    # Update all workspaces
    update_all_workspace_windows
fi
