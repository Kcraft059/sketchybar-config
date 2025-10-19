#!/bin/bash

dummy_space=(
	#associated_space=$sid
	#icon=${i}
	icon.padding_left=6
	icon.padding_right=7
	icon.color=$NOTICE
	padding_left=3
	padding_right=3
	background.color=$HIGH_MED
	background.height=$(($BAR_HEIGHT - 12))
	background.corner_radius=7
	background.drawing=off
	icon.highlight_color=$CRITICAL
	label.padding_right=20
	label.font="sketchybar-app-font:Regular:16.0"
	label.background.height=$(($BAR_HEIGHT - 12))
	label.background.drawing=off
	label.background.color=$HIGH_HIGH
	label.background.corner_radius=7
	label.y_offset=-1
	label.drawing=off
	#script="$SCRIPT_SPACES"
)

separator=(
	icon=􀆊
	label.drawing=off
	icon.font="$FONT:Semibold:14.0"
	associated_display=active
	#click_script="echo 'Aerospace does not support creating new workspaces via sketchybar'"
	icon.color=$SUBTLE
	#script="$SCRIPT_SPACE_WINDOWS"
)

addYabaiSpaces() {
	for sid in "${SPACES[@]}"; do # For each existing space add corresponding item
		#echo $sid
		space=(${dummy_space[@]})
		space+=(
			associated_space=$sid
			icon="$sid"
			script="$SCRIPT_SPACES"
		)
		#echo "${space[@]}"
		sketchybar --add space space.$sid left \
			--set space.$sid "${space[@]}" \
			--subscribe space.$sid mouse.clicked #space_windows_change

	done

	separator+=(
		click_script="export PATH=$PATH; yabai -m space --create && sketchybar --trigger space_change"
		script="$SCRIPT_SPACE_WINDOWS"
	)

	sketchybar --add item separator left \
		--set separator "${separator[@]}" \
		--subscribe separator space_windows_change
}

addAerospaceSpaces() {
	# Add the aerospace worksapce change event
	sketchybar --add event aerospace_workspace_change

	for sid in "${SPACES[@]}"; do # For each existing space add corresponding item
		#echo $sid
		space=(${dummy_space[@]})
		space+=(
			icon="$sid"
			#click_script="aerospace workspace $sid"
			script="$SCRIPT_SPACES $sid"
			drawing=on
		)
		#echo "${space[@]}"
		sketchybar --add item space.$sid left \
			--set space.$sid "${space[@]}" \
			--subscribe space.$sid aerospace_workspace_change mouse.clicked
		#--subscribe space.$sid mouse.clicked
	done

	separator+=(
		click_script="echo 'Aerospace does not support creating new workspaces via sketchybar'"
	)

	sketchybar --add item separator left \
		--set separator "${separator[@]}"
}

addRiftSpaces() {
	# Add the rift workspace change event
	sketchybar --add event rift_workspace_changed 
	#sketchybar --add event rift_windows_changed

	for sid in "${SPACES[@]}"; do # For each existing space add corresponding item
		space=(${dummy_space[@]})
		space+=(
			icon="$sid"
			#click_script="aerospace workspace $sid"
			script="$SCRIPT_SPACES $workspace"
			drawing=on
		)

		sid=$(echo "$sid" | sed 's/ /__/g') # Format name for sketchybar

		sketchybar --add item space.$sid left \
			--set space.$sid "${space[@]}" \
			--subscribe space.$sid rift_workspace_changed mouse.clicked #rift_windows_changed 
	done

	separator+=(
		click_script="echo 'Rift does not support creating new workspaces via sketchybar'"
	)

	sketchybar --add item separator left \
		--set separator "${separator[@]}"
}

# Choose script based on AEROSPACE_MODE

case $WINDOW_MANAGER in
"yabai")
	SCRIPT_SPACES="export PATH=$PATH; $RELPATH/plugins/spaces/yabai/script-space.sh"
	SCRIPT_SPACE_WINDOWS="export PATH=$PATH; $RELPATH/plugins/spaces/yabai/script-windows.sh"
	SPACES=("1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" "12" "13" "14" "15")
	addYabaiSpaces
	;;
"aerospace")
	SCRIPT_SPACES="export PATH=$PATH; $RELPATH/plugins/spaces/aerospace/script-space.sh"
	SCRIPT_SPACE_WINDOWS="export PATH=$PATH; $RELPATH/plugins/spaces/aerospace/script-windows.sh"
	SPACES=($(aerospace list-workspaces --all 2>/dev/null))
	addAerospaceSpaces
	;;
"rift")
	SCRIPT_SPACES="export PATH=$PATH; $RELPATH/plugins/spaces/rift/script-space.sh"
	SCRIPT_SPACE_WINDOWS="export PATH=$PATH; $RELPATH/plugins/spaces/rift/script-windows.sh"
	while IFS= read -r line; do
		SPACES+=("$line")
	done < <(rift-cli query workspaces 2>/dev/null | jq -r '.[] | .name')
	addRiftSpaces
	;;
esac

sketchybar --add bracket spaces '/space\..*/' \
	--set spaces "${zones[@]}"
