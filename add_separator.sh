#!/bin/bash
add_separator() {
  separator=(
    icon="|"
    icon.color=$SUBTLE
    icon.font="$FONT:Bold:16.0"
    icon.y_offset=2
    label.drawing=off
    icon.padding_left=0
    icon.padding_right=0
  )

  if [[ -n "$3" ]]; then
    separator+=(
      icon="$3"
    )
  fi

  sketchybar --add item separator.$1 $2 \
    --set separator.$1 "${separator[@]}"
}
