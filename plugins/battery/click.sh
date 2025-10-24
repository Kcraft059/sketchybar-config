#!/bin/bash
export RELPATH=$(dirname $0)/../..
source $RELPATH/log_handler.sh
command -v 'menubar' 2>/dev/null 1>&2 || alias menubar="$RELPATH/menubar"

items="$(sketchybar --query default_menu_items | jq -r '.[]')"

## Main logic
case "$BUTTON" in
"right")
	menubar -s "Control Center,Battery"
	[[ $items =~ "Control Center,Battery" ]] || sendErr "Might not be able to trigger "Control Center,Battery" because it is not in menubar" "debug"
	;;
"left")
	if [[ $items =~ "Battery Toolkit,Item-0" ]]; then ## Check for battery toolkit presence
		menubar -s "Battery Toolkit,Item-0"
	else
		menubar -s "Control Center,Battery"
		sendWarn "Battery toolkit item is not present in native menubar, falling back to battery item" "debug"
		[[ $items =~ "Control Center,Battery" ]] || sendErr "Might not be able to trigger "Control Center,Battery" because it is not in menubar" "debug"
	fi
	;;
esac
