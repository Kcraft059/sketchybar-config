#!/bin/bash

##
# This script is responsible for error / log handling
# It include script-wide functions to print to stdout / stderr depending on $LOGLEVEL
# LOG_LEVEL=<"none"|"info"|"debug"|"vomit">
##

## Exports

if [[ -n "$SKETCHYBAR_CONFIG" && -f "$SKETCHYBAR_CONFIG" ]]; then
	source "$SKETCHYBAR_CONFIG"
elif [[ -f "./config.sh" ]]; then
	source "./config.sh"
fi

: "${LOG_LEVEL:="info"}"
: "${COLOR_LOG:=false}"

## Helpers & ressources
scac='\033[48;5;0;38;5;8m[\033[38;5;1mx\033[38;5;8m]\033[0m' # [x]
sexc='\033[48;5;0;38;5;8m[\033[38;5;2mo\033[38;5;8m]\033[0m' # [o]
smak='\033[48;5;0;38;5;8m[\033[38;5;5m+\033[38;5;8m]\033[0m' # [+]
swrn='\033[48;5;0;38;5;8m[\033[38;5;3m!\033[38;5;8m]\033[0m' # [!]

errString="$(if $COLOR_LOG; then echo "$scac"; else echo "[Error]"; fi)"
warnString="$(if $COLOR_LOG; then echo "$swrn"; else echo "[Warn]"; fi)"
logString="$(if $COLOR_LOG; then echo "$sexc"; else echo "[Info]"; fi)"

__getKeywordLevel() {
	case "$1" in
	"none")
		echo 0
		;;
	"info")
		echo 1
		;;
	"debug")
		echo 2
		;;
	"vomit")
		echo 3
		;;
	*)
		echo 0
		return 1
		;;
	esac
}

LOG_LEVEL_INDEX=$(__getKeywordLevel $LOG_LEVEL)

## Available functions
sendErr() {
	# $1 -> <errMsg>, $2 -> <logLevel>
	if [ -z $2 ]; then
		sendErr "No errLevel set for \"$1\"" "none"
		return 1
	fi

	if [ $LOG_LEVEL_INDEX -ge $(__getKeywordLevel "$2") ]; then # If current log level is higher or equal to function's log level, display message
		# Sends log + date to stderr
		>&2 echo -e "$errString $(date '+[%H:%M:%S]') $1"
	fi
}

sendWarn() {
	# $1 -> <logMsg>, $2 -> <logLevel>
	if [ -z $2 ]; then
		sendErr "No errLevel set for \"$1\"" "none"
		return 1
	fi

	if [ $LOG_LEVEL_INDEX -ge $(__getKeywordLevel "$2") ]; then # If current log level is higher or equal to function's log level, display message
		# Sends log + date to stdout
		>&1 echo -e "$warnString $(date '+[%H:%M:%S]') $1"
	fi
}

sendLog() {
	# $1 -> <logMsg>, $2 -> <logLevel>
	if [ -z $2 ]; then
		sendErr "No errLevel set for \"$1\"" "none"
		return 1
	fi

	if [ $LOG_LEVEL_INDEX -ge $(__getKeywordLevel "$2") ]; then # If current log level is higher or equal to function's log level, display message
		# Sends log + date to stdout
		>&1 echo -e "$logString $(date '+[%H:%M:%S]') $1"
	fi
}
