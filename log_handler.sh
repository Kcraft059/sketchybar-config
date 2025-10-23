#!/bin/bash

##
# This script is responsible for error / log handling
# It include script-wide functions to print to stdout / stderr depending on $LOGLEVEL
# LOG_LEVEL=<"none"|"info"|"verbose"|"debug"|"vomit">
##

export RELPATH=$(dirname $0)
if [[ -n "$SKETCHYBAR_CONFIG" && -f "$SKETCHYBAR_CONFIG" ]]; then
	source "$SKETCHYBAR_CONFIG"
elif [[ -f "$RELPATH/config.sh" ]]; then
	source "$RELPATH/config.sh"
fi
: "${LOG_LEVEL:="none"}"

sendErr() { # $1 -> <errMsg>, $2 -> <logLevel>
	if [[ $LOG_LEVEL != "none" && $LOG_LEVEL == "$2" ]]; then ## Implement level hierarchy
		# Sends log + date to stdout
		>&2 echo "[Err] $(date '+[%H:%M:%S]') $1"
	fi
}

sendLog() { # $1 -> <logMsg>, $2 -> <logLevel>
	if [[ LOG_LEVEL != "none" && LOG_LEVEL == "$2" ]]; then
		# Sends log + date to stdout
		>&1 echo "[Log] $(date '+[%H:%M:%S]') $1"
	fi
}
