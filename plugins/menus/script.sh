#!/bin/bash
export RELPATH=$(dirname $0)/../..
shopt -s expand_aliases

command -v 'ft-haptic' 2>/dev/null 1>&2 || alias ft-haptic="$RELPATH/ft-haptic"
command -v 'menubar' 2>/dev/null 1>&2 || alias menubar="$RELPATH/menubar"

### Trigger menu bar item depending on menu index

case "$SENDER" in
"mouse.entered")
	ft-haptic -n 1
	;;
"mouse.clicked")
	menubar -s "$(echo "$NAME" | cut -d '.' -f 2)"
	;;
esac
