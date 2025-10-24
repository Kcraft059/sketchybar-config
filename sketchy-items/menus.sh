#!/bin/bash
SCRIPT_CLICK_MENUS="export PATH=$PATH; $RELPATH/plugins/menus/click.sh"

mid=0
spaces=()
for ((i = 1; i <= 14; ++i)); do
  mid=$i
  space=(
    icon=$i
    label.drawing=off
    click_script="$SCRIPT_CLICK_MENUS"
    drawing=off
  )
  if [ $mid = 1 ]; then
    space+=(
      icon.font="$FONT:Heavy:14:0"
      icon.color=$GLOW
    )
  fi

  sketchybar --add item menu.$mid left \
    --set menu.$mid "${space[@]}"
  #--subscribe menu.$mid mouse.clicked front_app_switched
done

sketchybar --add bracket menus '/menu\..*/' \
  --set menus "${zones[@]}"

sendLog "Added menus items" "vomit"
