#!/bin/bash
export RELPATH=$(dirname $0)/../..
source $RELPATH/log_handler.sh

if command -v yabai >/dev/null; then
	yabai -m window --toggle float
	sendLog "Toggle window floating" "vomit"
else
	sendErr "No yabai" "debug"
fi
