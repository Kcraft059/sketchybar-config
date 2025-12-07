#!/bin/bash
source ./log_handler.sh ## Sourcing needed because it can be called outside of sketchybarrc sourcing
OS_VERSION="$(sw_vers -productVersion)"

# Config sourcing
if [[ -n "$SKETCHYBAR_CONFIG" && -f "$SKETCHYBAR_CONFIG" ]]; then
	# External override path (useful for Nix)
	# shellcheck disable=SC1090
	source "$SKETCHYBAR_CONFIG"
elif [[ -f ./config.sh ]]; then
	# Local config file in repository
	# shellcheck disable=SC1091
	source ./config.sh
fi

# Defaults

export COLOR_SCHEME=${COLOR_SCHEME:-rosepine-moon}
export BAR_TRANSPARENCY=${BAR_TRANSPARENCY:-true}
: "${THEME_FILE_PATH:="./theme.sh"}"

case "$COLOR_SCHEME" in
# Rosé pine Moon theme
"rosepine-moon")
	if [[ $BAR_TRANSPARENCY == true ]]; then
		TFrate=160
	else
		TFrate=255
	fi

	TFp=$(echo "obase=16; $TFrate" | bc) # Set primary transparency factor
	[ $((TFrate + 20)) -lt 255 ] && TFrate=$(($TFrate + 20))
	TFs=$(echo "obase=16; $TFrate" | bc) # Set secondary transparency factor

	# Default Theme colors
	export BASE=0x${TFp}232136
	export SURFACE=0x${TFp}2a273f
	export OVERLAY=0x${TFp}393552
	export MUTED=0x${TFp}6e6a86
	export HIGH_LOW=0x${TFs}2a283e
	export HIGH_MED=0x${TFs}44415a
	export HIGH_HIGH=0x${TFs}56526e
	export SUBTLE=0xff908caa
	export TEXT=0xffe0def4
	export CRITICAL=0xffeb6f92
	export NOTICE=0xfff6c177
	export WARN=0xffea9a97
	export SELECT=0xff3e8fb0
	export GLOW=0xff9ccfd8
	export ACTIVE=0xffc4a7e7

	export BLACK=0xff181926
	export TRANSPARENT=0x00000000

	# General bar colors
	if [ $(echo $OS_VERSION | awk -F. '{print $1}') -gt 15 ]; then
		export BAR_COLOR=0x${TFp}232137
		export BORDER_COLOR=0x60808080
		#export BORDER_COLOR=0x${TFp}4D525B
	else
		export BAR_COLOR=0x${TFp}414354
		export BORDER_COLOR=0x${TFp}4D525B
	fi

	export ICON_COLOR=$TEXT  # Color of all icons
	export LABEL_COLOR=$TEXT # Color of all labels

	export POPUP_BACKGROUND_COLOR=0x${TFp}393552
	export POPUP_BORDER_COLOR=$HIGH_MED

	export SHADOW_COLOR=$TEXT
	;;

# Catpuccin Mocha theme
"catppuccin-mocha")
	# Default Theme colors
	export BASE=0xff1e1e2e
	export SURFACE=0xff6c7086
	export OVERLAY=0xff313244
	export MUTED=0xff6e6a86
	export SUBTLE=0xff908caa

	export TEXT=0xffcdd6f4
	export CRITICAL=0xfff38ba8
	export NOTICE=0xfff9e2af
	export WARN=0xffeba0ac
	export SELECT=0xff89b4fa
	export GLOW=0xff89dceb
	export ACTIVE=0xffcba6f7

	export HIGH_LOW=0xff1e1e2e
	export HIGH_MED=0xff45475a
	export HIGH_HIGH=0xff585b70

	export BLACK=0xff11111b
	export TRANSPARENT=0x00000000

	# General bar colors
	if [[ $BAR_TRANSPARENCY == true ]]; then
		export BAR_COLOR=0xB81f1f30
		export BORDER_COLOR=0xB845475a
	elif [[ $BAR_TRANSPARENCY == false ]]; then
		export BAR_COLOR=0xff1f1f30
		export BORDER_COLOR=0xff45475a
	fi
	export ICON_COLOR=$TEXT  # Color of all icons
	export LABEL_COLOR=$TEXT # Color of all labels

	export POPUP_BACKGROUND_COLOR=0xbe393552
	export POPUP_BORDER_COLOR=$HIGH_MED

	export SHADOW_COLOR=$TEXT
	;;
*)
	if [[ -n "$THEME_FILE_PATH" && -f "$THEME_FILE_PATH" ]]; then
		sendLog "Theme specified isn't a default theme ($COLOR_SCHEME), Loading custom theme file $THEME_FILE_PATH" "info"
		source "$THEME_FILE_PATH"
	else
		sendErr "Theme specified isn't a default theme ($COLOR_SCHEME) and no theme.sh was specified" "info"
		exit
	fi
	;;
esac
