#!/bin/bash

## Scripts
SCRIPT_MIC="export PATH=$PATH; $RELPATH/plugins/mic/script.sh"

## Item properties
mic=(
  icon=􀊱
  icon.color=$ACTIVE
  label.font="$FONT:Regular:14.0"
  padding_left=0
  #update_freq=10
  label.drawing=off
  script="$SCRIPT_MIC"
)

## Item addition
sketchybar --add item mic right \
  --set mic "${mic[@]}" \
  --subscribe mic mouse.clicked

sendLog "Added mic item" "vomit"