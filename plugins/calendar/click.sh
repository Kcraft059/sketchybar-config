#!/bin/bash

# For 5s, show more precise time
for ((i = 0; i <= 5; ++i)); do
  sketchybar --set $NAME icon="$(date '+%a %d. %b')" label="$(date '+%H:%M:%S')" \
    label.width=65
  sleep 1
done

sketchybar --set $NAME icon="$(date '+%a %d. %b')" label="$(date '+%H:%M')" \
  label.width=50
