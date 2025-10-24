#!/bin/bash
SCRIPT_VOLUME_CLICK="export PATH=$PATH; $RELPATH/plugins/volume/click.sh"
SCRIPT_VOLUME="export PATH=$PATH; $RELPATH/plugins/volume/script.sh"

volume_slider=(
  script="$SCRIPT_VOLUME"
  updates=on
  padding_left=0
  padding_right=0
  label.drawing=off
  icon.drawing=off
  slider.highlight_color=$SELECT
  slider.background.height=5
  slider.background.corner_radius=3
  slider.background.color=$MUTED
  slider.knob=􀀁
  slider.knob.drawing=off
)

volume_icon=(
  click_script="$SCRIPT_VOLUME_CLICK"
  icon.align=left
  icon.padding_left=$(($OUTER_PADDINGS - 3))
  icon.padding_right=$OUTER_PADDINGS

  icon.color=$ACTIVE
  #label.width=32
  label.padding_left=0
  label.padding_right=0
  label.align=left
  label.font="$FONT:Regular:14.0"
)

sketchybar --add slider volume right \
  --set volume "${volume_slider[@]}" \
  --subscribe volume volume_change \
  mouse.clicked \
  mouse.entered \
  mouse.exited \
  \
  --add item volume_icon right \
  --set volume_icon "${volume_icon[@]}"

add_separator "1" "right"

sendLog "Added volume item" "vomit"