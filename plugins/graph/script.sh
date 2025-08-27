#!/bin/bash
export RELPATH=$(dirname $0)/../..
source $RELPATH/colors.sh

### Fetch system related data

systempower="$(macmon pipe -s 1 -i 1 | jq -r .sys_power)"
probe="$(/bin/ps -Aceo pid,pcpu,comm -r | awk 'NR==2')"

topprog_percent=$(echo "$probe" | awk '{print $2}')
topprog=$(echo "$probe" | awk '{print $3}')
topprog_pid=$(echo "$probe" | awk '{print $1}')

### Modify top consumming program name color to red if depassing more than 100% cpu

if [[ $(printf "%.0f" $topprog_percent) -gt 100 ]]; then
  LABEL_COLOR=$LOVE
else
  LABEL_COLOR=$SUBTLE
fi

graphlabel="${topprog_percent}% - $topprog [$topprog_pid]"

#graphpercent=$(awk -v min=0 -v max=100 'BEGIN{srand(); print int(min+rand()*(max-min+1))}')
graphpercent=$(top -l1 -n1 | grep "^CPU usage:" | awk '{gsub(/%/,"",$3); print $3}')
graphpoint=$(bc <<<"scale=1; $graphpercent / 100 ")

### Update graph color depending on cpu load

case $(printf "%.0f" $graphpercent) in
[8-9][0-9] | 7[5-9] | 100)
  COLOR=$LOVE
  ;;
[5-6][0-9] | 7[0-4])
  COLOR=$ROSE
  ;;
[3-5][0-9] | 2[5-9])
  COLOR=$GOLD
  ;;
[5-9] | 1[0-9] | 2[0-4])
  COLOR=$PINE
  ;;
*) COLOR=$SUBTLE ;;
esac

sketchybar --push $NAME $graphpoint \
  --set $NAME.percent label="$(printf "%.0f" $graphpercent)%" \
  --set $NAME graph.color=$COLOR

graphlabel="${topprog_percent}% - $topprog [$topprog_pid] | $(printf '%.2f' $systempower)W"

sketchybar --set $NAME.label label="$graphlabel" label.color="$LABEL_COLOR"
