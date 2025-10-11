#!/bin/bash

# Config sourcing
if [[ -n "$SKETCHYBAR_CONFIG" && -f "$SKETCHYBAR_CONFIG" ]]; then
	# External override path (useful for Nix)
	# shellcheck disable=SC1090
	source "$SKETCHYBAR_CONFIG"
elif [[ -f ./settings.sh ]]; then
	# Local config file in repository
	# shellcheck disable=SC1091
	source ./settings.sh
fi

# Defaults

export COLOR_SCHEME=${COLOR_SCHEME:-rosepine-moon}
export BAR_TRANSPARENCY=${BAR_TRANSPARENCY:-true}
: "${THEME_FILE_PATH:="./theme.sh"}"

if [[ -n "$THEME_FILE_PATH" && -f "$THEME_FILE_PATH" ]]; then
	source "$THEME_FILE_PATH"
fi

# Rosé pine Moon theme
if [[ "$COLOR_SCHEME" == "rosepine-moon" ]]; then
	# Default Theme colors
	export BASE=0xff232136
	export SURFACE=0xff2a273f
	export OVERLAY=0xff393552
	export MUTED=0xff6e6a86
	export SUBTLE=0xff908caa
	export TEXT=0xffe0def4
	export CRITICAL=0xffeb6f92
	export NOTICE=0xfff6c177
	export WARN=0xffea9a97
	export SELECT=0xff3e8fb0
	export GLOW=0xff9ccfd8
	export ACTIVE=0xffc4a7e7
	export HIGH_LOW=0xff2a283e
	export HIGH_MED=0xff44415a
	export HIGH_HIGH=0xff56526e

	export BLACK=0xff181926
	export TRANSPARENT=0x00000000

	# General bar colors
	if [[ $BAR_TRANSPARENCY == true ]]; then
		export BAR_COLOR=0x80414354 
		export BORDER_COLOR=0x804D525B
	elif [[ $BAR_TRANSPARENCY == false ]]; then
		export BAR_COLOR=0xff414354 
		export BORDER_COLOR=0xff4D525B
	fi
	export ICON_COLOR=$TEXT  # Color of all icons
	export LABEL_COLOR=$TEXT # Color of all labels

	export POPUP_BACKGROUND_COLOR=0xbe393552
	export POPUP_BORDER_COLOR=$HIGH_MED

	export SHADOW_COLOR=$TEXT
fi

# Catpuccin Mocha theme
if [[ "$COLOR_SCHEME" == "catppuccin-mocha" ]]; then
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
fi
