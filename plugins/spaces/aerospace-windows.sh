#!/bin/bash

# Aerospace workspace windows indicator
# This script updates workspace labels to show app icons for windows in each workspace

export RELPATH=$(dirname $0)/../..
source "$RELPATH/icon_map.sh"

update_workspace_windows() {
  local workspace_id=$1

  # Get apps in this workspace
  apps=$(aerospace list-windows --workspace "$workspace_id" --format '%{app-name}' 2>/dev/null | sort -u)

  icon_strip=""
  if [ -n "$apps" ] && [ "$apps" != "" ]; then
    while IFS= read -r app; do
      if [ -n "$app" ]; then
        __icon_map "$app"
        icon_strip+=" $icon_result"
      fi
    done <<< "$apps"
    sketchybar --set space.$workspace_id label="$icon_strip" label.drawing=on
  else
    # No apps in workspace, hide label
    sketchybar --set space.$workspace_id label.drawing=off
  fi
}

# Update all workspaces
update_all_workspace_windows() {
  workspaces=$(aerospace list-workspaces --all 2>/dev/null)
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