#!/bin/bash
# See : https://github.com/FelixKratz/dotfiles/blob/e6288b3f4220ca1ac64a68e60fced2d4c3e3e20b/.config/sketchybar/helper/cpu.h
GRAPH_MARGIN=$(($BAR_HEIGHT / 8))
GRAPH_WIDTH=140
PERCENT_WIDTH=24

GRAPH_SCRIPT="export PATH=$PATH; $RELPATH/plugins/graph/script.sh"

# Allow override of update frequency via CPU_UPDATE_FREQ from config
: "${CPU_UPDATE_FREQ:=2}"

graph=(
	graph.color=$SUBTLE
	drawing=off
	y_offset=$((-$BAR_HEIGHT / 2 + $GRAPH_MARGIN + 7))
	padding_left=0
	padding_right=0
	icon.drawing=off
	label.drawing=off
	background.padding_left=4
	background.padding_right=0
	background.drawing=on
	background.height=$(($BAR_HEIGHT - $GRAPH_MARGIN * 2 - 9))
	script="$GRAPH_SCRIPT"
	update_freq=$CPU_UPDATE_FREQ
)

graph_percent=(
	drawing=off
	padding_left=8
	padding_right=0
	y_offset=$((-$BAR_HEIGHT / 2 + $GRAPH_MARGIN + 8))
	label.padding_right=0
	label.padding_left=0
	icon.drawing=off
	label.drawing=on
	#background.color=$CRITICAL
	background.drawing=off
	label="37%"
	label.width=$PERCENT_WIDTH
	label.font="$FONT:Bold:10.0"
)

graph_label=(
	drawing=off
	padding_left=-$PERCENT_WIDTH
	padding_right=-$GRAPH_WIDTH
	label.width=$(($GRAPH_WIDTH + $PERCENT_WIDTH))
	y_offset=$(($BAR_HEIGHT / 2 - $GRAPH_MARGIN - 5))
	label.padding_right=0
	label.padding_left=0
	icon.drawing=off
	label.drawing=on
	#background.color=$CRITICAL
	background.drawing=off
	label="GLUOP ORPI EIOP - EOIYUEUI 33%"
	label.color=$SUBTLE
	label.font="$FONT:Regular:7.0"
)

sketchybar --add item graph.percent e \
	--set graph.percent "${graph_percent[@]}" \
	--add item graph.label e \
	--set graph.label "${graph_label[@]}" \
	--add graph graph e $GRAPH_WIDTH \
	--set graph "${graph[@]}"
