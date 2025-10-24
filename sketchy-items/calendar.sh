#!/bin/bash

## Scripts
SCRIPT_CALENDAR="export PATH=$PATH; $RELPATH/plugins/calendar/script.sh"
SCRIPT_CLICK_CALENDAR="export PATH=$PATH; $RELPATH/plugins/calendar/click.sh"

calendar=(
  icon="$(date '+%a %d. %b')"
  label="$(date '+%H:%M')"
  icon.font="$FONT:Black:12.0"
  icon.padding_right=0
  label.width=50
  label.align=center
  label.padding_right=0
  update_freq=60
  script="$SCRIPT_CALENDAR"
  click_script="$SCRIPT_CLICK_CALENDAR"
)

sketchybar --add item calendar right \
  --set calendar "${calendar[@]}"

add_separator "0" "right"

sendLog "Added calendar (date) item" "vomit"