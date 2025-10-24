#!/bin/bash
export RELPATH=$(dirname $0)/../..
source $RELPATH/log_handler.sh

## Default and global settings
menuitems=($1) # What items will be in the moremenu
INNER_PADDINGS=$2
FONT="$3"

## Define state depending on the icon of the separator (this is a bad practice tho)
ICON_VALUE="$(sketchybar --query $NAME | sed 's/\\n//g; s/\\\$//g; s/\\ //g' | jq -r '.icon.value')"
GRAPHSTATE="$(sketchybar --query graph | sed 's/\\n//g; s/\\\$//g; s/\\ //g' | jq -r '.geometry.drawing')"

if [[ $ICON_VALUE = '|' ]]; then
	STATE=on
else
	STATE=off
fi

## Internal functions
menu_set() {
	sendLog "Toggle moremenu to $1" "debug"

	# Toggle drawing of each menu item
	for item in ${menuitems[@]}; do
		item=$(echo "$item" | sed -e "s/__/ /g")
		sketchybar --animate tanh 15 \
			--set "$item" drawing=$1
		sendLog "Set \"$item\" drawing to $1" "vomit"
	done

	# When setting to on, then update menu items
	if [ $1 = "on" ]; then
		separator=(
			icon="|"
			icon.font="$FONT:Bold:16.0"
			icon.padding_left=0
			icon.padding_right=0
		)
		sketchybar --set $NAME icon.y_offset=2 \
			--animate tanh 15 \
			--set $NAME "${separator[@]}"
		sketchybar --trigger more-menu-update
	else
		separator=(
			icon="􀯶"
			icon.font="$FONT:Semibold:14.0"
			icon.padding_left=$INNER_PADDINGS
			icon.padding_right=$INNER_PADDINGS
		)
		sketchybar --set $NAME icon.y_offset=0 \
			--animate tanh 15 \
			--set $NAME "${separator[@]}"
	fi
}

graph_set() {
	sendLog "Toggle graph to $1" "debug"

	if [ $1 = "off" ]; then
		icon=􀯶
	else
		icon=􀫰
	fi

	sketchybar --set '/graph.*/' drawing=$1 \
		--set $NAME icon=$icon \
		--trigger activities_update

	[ $1 = "off" ] && for ((i = 0; i <= 140; ++i)); do
		sketchybar --push graph 0.0
	done
}

## Main logic
if [ "$STATE" = "off" ]; then
	if [ "$MODIFIER" = "alt" ] && [ "$GRAPHSTATE" = "off" ]; then
		graph_set "on"
	elif [ $GRAPHSTATE = "on" ]; then
		graph_set "off"
	else
		menu_set "on"
	fi
else
	menu_set "off"
fi
