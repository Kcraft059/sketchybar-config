#!/bin/bash
export RELPATH=$(dirname $0)/../..
source $RELPATH/colors.sh

PERCENTAGE="$(pmset -g batt | grep -Eo "[0-9]+%" | cut -d% -f1)"
ACCONNECTED="$(pmset -g batt | grep 'AC Power')"
NOTCHARGING="$(pmset -g batt | grep 'not charging')"

if [[ -z "$PERCENTAGE" ]]; then exit 0; fi

DRAWING=on
COLOR=$TEXT

### Configure icon + color depending on charge level

case ${PERCENTAGE} in
9[0-9] | 100)
  ICON=􀛨
  COLOR=$PINE
  ;;
[6-8][0-9])
  ICON=􀺸
  COLOR=$FOAM
  ;;
[3-5][0-9])
  ICON=􀺶
  COLOR=$GOLD
  ;;
[1-2][0-9])
  ICON=􀛩
  COLOR=$ROSE
  ;;
*)
  ICON=􀛪
  COLOR=$LOVE
  ;;
esac

if [[ $ACCONNECTED != "" ]]; then
  ICON=􀢋
  if [[ $NOTCHARGING != "" ]]; then
    COLOR=$SUBTLE
  else
    COLOR=$IRIS
  fi
fi

sketchybar --set $NAME icon="$ICON" \
  icon.color=$COLOR \
  label="$PERCENTAGE %" \
  drawing=$DRAWING
