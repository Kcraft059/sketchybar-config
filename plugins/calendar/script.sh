#!/bin/bash
export RELPATH=$(dirname $0)/../..
source $RELPATH/log_handler.sh

## Private function

# Updates time precisely
update() {
	sendLog "Updating date..." "vomit"

	# Check delay before next full minute
	delay=$((59 - $(date '+%-S')))

	sendLog "Sleeping before clock update for ${delay}s..." "vomit"

	# Approximate waiting
	sleep $delay

	# 1/10 of a second precision
	while [[ $(date '+%S') != "00" ]]; do
		sleep 0.1
	done

	sketchybar --set $NAME icon="$(date '+%a %d. %b')" label="$(date '+%H:%M')"
	sendLog "Updated date" "vomit"
}

## Main logic
update
