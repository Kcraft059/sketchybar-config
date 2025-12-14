#!/bin/bash
export RELPATH=$(dirname $0)/../..;
shopt -s expand_aliases

command -v 'menubar' 2>/dev/null 1>&2 || alias menubar="$RELPATH/menubar"

### Trigger menu bar item depending on menu index

menubar -s "$(echo "$NAME" | cut -d '.' -f 2)"