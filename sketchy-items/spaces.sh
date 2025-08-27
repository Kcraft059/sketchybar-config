#!/bin/bash
SCRIPT_SPACES="export PATH=$PATH; $RELPATH/plugins/spaces/script.sh"

SCRIPT_SPACE_WINDOWS="export PATH=$PATH; $RELPATH/plugins/spaces/script-windows.sh"

SPACE_ICONS=("1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" "12" "13" "14" "15")

# Destroy space on right click, focus space on left click.
# New space by left clicking separator (>)

sid=0
spaces=()
for i in "${!SPACE_ICONS[@]}"; do
  sid=$(($i + 1))

  space=(
    associated_space=$sid
    icon=${SPACE_ICONS[i]}
    icon.padding_left=6
    icon.padding_right=7
    icon.color=$GOLD
    padding_left=8
    padding_right=2
    background.color=$HIGH_MED
    background.height=$(($BAR_HEIGHT - 12))
    background.corner_radius=7
    background.drawing=off
    icon.highlight_color=$LOVE
    label.padding_right=20
    label.font="sketchybar-app-font:Regular:16.0"
    label.background.height=$(($BAR_HEIGHT - 12))
    label.background.drawing=on
    label.background.color=$HIGH_HIGH
    label.background.corner_radius=7
    label.y_offset=-1
    label.drawing=off
    script="$SCRIPT_SPACES"
  )

  sketchybar --add space space.$sid left \
    --set space.$sid "${space[@]}" \
    --subscribe space.$sid mouse.clicked
done

separator=(
  icon=􀆊
  label.drawing=off
  icon.font="$FONT:Semibold:14.0"
  associated_display=active
  click_script="export PATH=$PATH; yabai -m space --create && sketchybar --trigger space_change"
  icon.color=$SUBTLE
  script="$SCRIPT_SPACE_WINDOWS"
)

sketchybar --add bracket spaces '/space\..*/' \
  --set spaces "${zones[@]}" \
  --add item separator left \
  --set separator "${separator[@]}" \
  --subscribe separator space_windows_change
