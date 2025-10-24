#!/bin/bash
export PATH=/opt/homebrew/bin/:$PATH
export RELPATH=$(dirname $0)/../..
source $RELPATH/log_handler.sh

# Toggle the menu of the BD app
betterdisplaycli toggle --appmenu >/dev/null 2>&1 || sendErr "No betterdisplay-cli" "debug"
