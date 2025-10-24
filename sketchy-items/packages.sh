#!/bin/bash

## Scripts
SCRIPT_PKGS="export PATH=$PATH; $RELPATH/plugins/packages/script.sh"

## Item properties
pkgs=(
  drawing=off
  script="$SCRIPT_PKGS"
  #click_script="$SCRIPT_CLICK_PKGS"
  icon=􀐛
  icon.color=$WARN
  icon.font="$FONT:Regular:14.0"
  icon.padding_left=0 #$(($OUTER_PADDINGS - 4))
  icon.padding_right=0
  label=""
  label.font="$FONT:Semibold:10.0"
  label.padding_left=$INNER_PADDINGS
  label.padding_right=6
  padding_left=$INNER_PADDINGS
  padding_right=$OUTER_PADDINGS
  update_freq=0
  updates=when_shown
)

## Item addition
sketchybar --add item moremenu.pkgs right \
  --set moremenu.pkgs "${pkgs[@]}" \
  --subscribe moremenu.pkgs more-menu-update

sendLog "Added package item" "vomit"