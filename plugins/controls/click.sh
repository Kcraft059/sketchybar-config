#!/bin/bash
export RELPATH=$(dirname $0)/../..
source $RELPATH/log_handler.sh
command -v 'menubar' 2>/dev/null 1>&2 || alias menubar="$RELPATH/menubar"

## Main logic
menubar -s "$NAME"

items="$(sketchybar --query default_menu_items | jq -r '.[]')"
[[ $items =~ "$NAME" ]] || sendErr "Might not be able to trigger $NAME because it is not in menubar" "debug"
