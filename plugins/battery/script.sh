#!/bin/bash
export RELPATH=$(dirname $0)/../..
source $RELPATH/set_colors.sh
source $RELPATH/log_handler.sh

## Information querying
PERCENTAGE="$(pmset -g batt | grep -Eo "[0-9]+%" | cut -d% -f1)"
ACCONNECTED="$(pmset -g batt | grep 'AC Power')"
NOTCHARGING="$(pmset -g batt | grep 'not charging')"

if [[ -z "$PERCENTAGE" ]]; then
	sendWarn "No battery detected" "debug"
	exit 0
fi

## Private functions
update() {
	# Defaults
	DRAWING=on
	COLOR=$TEXT

	# Configure icon + color depending on charge level
	case ${PERCENTAGE} in
	9[0-9] | 100)
		ICON=􀛨
		COLOR=$SELECT
		;;
	[6-8][0-9])
		ICON=􀺸
		COLOR=$GLOW
		;;
	[3-5][0-9])
		ICON=􀺶
		COLOR=$NOTICE
		;;
	[1-2][0-9])
		ICON=􀛩
		COLOR=$WARN
		;;
	*)
		ICON=􀛪
		COLOR=$CRITICAL
		;;
	esac

	if [[ $ACCONNECTED != "" ]]; then
		ICON=􀢋
		if [[ $NOTCHARGING != "" ]]; then
			COLOR=$SUBTLE
		else
			COLOR=$ACTIVE
		fi
	fi

	sketchybar --set $NAME icon="$ICON" \
		icon.color=$COLOR \
		label="$PERCENTAGE %" \
		drawing=$DRAWING
		
	sendLog "Updated battery" "vomit"
}

## Main logic
update
