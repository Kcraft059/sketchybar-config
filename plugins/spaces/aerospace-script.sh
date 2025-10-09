#!/bin/bash

# Get workspace ID from command line argument or extract from NAME
WORKSPACE_ID=${1:-${NAME#space.}}

# Set RELPATH for accessing other scripts
export RELPATH=$(dirname $0)/../..

# Debug: Always log when script is called
echo "$(date): Script called with SENDER='$SENDER' NAME='$NAME' WORKSPACE_ID='$WORKSPACE_ID'" >> /tmp/aerospace-script-debug.log

update() {
  # Get current focused workspace if not provided
  if [ -z "$FOCUSED_WORKSPACE" ]; then
    FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused 2>/dev/null)
  fi

  # Check if this workspace is the focused one
  if [ "$FOCUSED_WORKSPACE" = "$WORKSPACE_ID" ]; then
    SELECTED="true"
  else
    SELECTED="false"
  fi

  WIDTH="dynamic"
  BACKGROUND="on"
  if [ "$SELECTED" = "true" ]; then
    WIDTH="0"
    BACKGROUND="off"
  fi

  sketchybar --animate tanh 20 --set $NAME icon.highlight=$SELECTED label.width=$WIDTH background.drawing=$BACKGROUND
}

update_all_workspaces() {
  # Get current focused workspace if not provided
  if [ -z "$FOCUSED_WORKSPACE" ]; then
    FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused 2>/dev/null)
  fi

  # Get all existing workspaces dynamically
  workspaces=$(aerospace list-workspaces --all 2>/dev/null)

  # Update all workspace items with the current focused workspace
  for workspace in $workspaces; do
    if [ "$FOCUSED_WORKSPACE" = "$workspace" ]; then
      sketchybar --animate tanh 20 --set space.$workspace icon.highlight=on label.width=0 background.drawing=off
    else
      sketchybar --animate tanh 20 --set space.$workspace icon.highlight=off label.width=dynamic background.drawing=on
    fi
  done
}

mouse_clicked() {
  if [ "$BUTTON" = "right" ]; then
    # Aerospace doesn't support destroying workspaces the same way as yabai
    # This would be a no-op or could trigger a custom action
    echo "Right click on aerospace workspace not supported"
  else
    # Focus the aerospace workspace
    aerospace workspace "$WORKSPACE_ID" 2>/dev/null

    # Update highlighting for all workspaces after click (since exec-on-workspace-change isn't working)
    FOCUSED_WORKSPACE="$WORKSPACE_ID"
    update_all_workspaces
  fi
}

case "$SENDER" in
"mouse.clicked")
  mouse_clicked
  ;;
"aerospace_workspace_change")
  # Debug: Log what we receive
  echo "$(date): aerospace_workspace_change called for $NAME with FOCUSED_WORKSPACE='$FOCUSED_WORKSPACE'" >> /tmp/aerospace-script-debug.log
  # For global workspace change events, update all workspace items
  update_all_workspaces
  # Update window indicators for all workspaces
  $RELPATH/plugins/spaces/aerospace-windows.sh
  ;;
*)
  update
  # Update window indicators for this workspace
  $RELPATH/plugins/spaces/aerospace-windows.sh "$WORKSPACE_ID"
  ;;
esac