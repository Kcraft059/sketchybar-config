#!/bin/bash
## Functions

# Adds a separator item
add_separator() {
	icon=${3:-"|"}
  separator=(
    icon=$icon
    icon.color=$SUBTLE
    icon.font="$FONT:Bold:16.0"
    icon.y_offset=2
    label.drawing=off
    icon.padding_left=0
    icon.padding_right=0
  )

  sketchybar --add item separator.$1 $2 \
    --set separator.$1 "${separator[@]}"

	sendLog "Added separator with icon \"$icon\", id $1 at $2" "debug"
}
