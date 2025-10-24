#!/bin/bash
export RELPATH=$(dirname $0)/../..
source $RELPATH/log_handler.sh

## Main logic
RealName=$(dscl . -read /Users/"$(whoami)" RealName | awk '/RealName: / {gsub("RealName: ",""); print}')

# If no RealName found, check for RealName at the next line (caused by spaces in the RealName)
if [ -z $RealName ]; then
	sendWarn "No realName found for user $(whoami), trying an other method." "debug"
	RealName=$(dscl . -read /Users/"$(whoami)" RealName | awk 'NR>1 {sub(/^[[:space:]]*/, ""); print; exit}')
fi

[ -z $RealName ] && (sendErr "No realName found for user $(whoami) using both methods" "debug")

sketchybar --set "$NAME" label="$RealName"

sendLog "Updated user" "vomit"
