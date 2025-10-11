#!/bin/bash

### Get real name of current user

RealName=$(dscl . -read /Users/"$(whoami)" RealName | awk '/RealName: / {gsub("RealName: ",""); print}')

# If no RealName found, check for RealName at the next line (caused by spaces in the RealName)
if [ -z $RealName ]; then 
	RealName=$(dscl . -read /Users/"$(whoami)" RealName | awk 'NR>1 {sub(/^[[:space:]]*/, ""); print; exit}')
fi

sketchybar --set "$NAME" label="$RealName"
