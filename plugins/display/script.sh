#!/bin/bash
export PATH=/opt/homebrew/bin/:$PATH
export RELPATH=$(dirname $0)/../..
source $RELPATH/log_handler.sh

## Defaults
# List of possible display groups
displaygroups=(
	"Built-in"
	"Built-in + External"
	"Dual External"
)

# Default item
ICON="􀢹"

## Private functions
match_displayGroup() {
	for displayGroup in "${displaygroups[@]}"; do
		if [[ "$(betterdisplaycli get --name="$displayGroup" --active)" == "on" ]]; then
			# Get Active display groupe name

			# Assign icon depending on active display group
			case "$displayGroup" in
			'Built-in')
				ICON="􁈸"
				;;
			'Built-in + External')
				ICON="􂤓"
				;;
			'Dual External')
				ICON="􀨧"
				;;
			*)
				sendErr "Unrecognized displayGroup $displayGroup" "debug"
				;;
			esac
		fi
	done

	sketchybar --set $NAME icon="$ICON" drawing="on"

	sendLog "Updated displayGroup icon" "vomit"
}

## Main logic
if [[ -n "$(pgrep "BetterDisplay")" ]]; then
	match_displayGroup
else
	sendWarn "BetterDisplay App is not running, hiding display item" "info"
	sketchybar --set $NAME drawing="off"
fi
