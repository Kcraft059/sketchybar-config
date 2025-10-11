# User configurable overrides for sketchybar-config
# Copy / edit this file or point SKETCHYBAR_CONFIG to an alternate path.
# All variables are optional; defaults are applied in sketchybarrc if unset.

# Width (in px) of the display notch reserved space
# Increase if music or other items are clipped near the notch
NOTCH_WIDTH=180

# Music title/subtitle info width (px)
MUSIC_INFO_WIDTH=80

# CPU graph update frequency (seconds)
CPU_UPDATE_FREQ=2

# Hide automatically menubar items (left click on logo)
MENUBAR_AUTOHIDE=False

# Included native menubar items 
# Replace " " by "__" and query with `sketchybar --query default_menu_items` 
MENU_CONTROLS=(
	"Control__Center,FocusModes"
	"Control__Center,Bluetooth"
)

# GITHUB Token path for notifications 
GITHUB_TOKEN="~/.github_token"

# Wifi unredactor path
WIFI_UNREDACTOR="~/Applications/wifi-unredactor.app"

# Color theme chosing and import
COLOR_SCHEME="rosepine-moon"
BAR_TRANSPARENCY=false
BAR_LOOK="compact" 
THEME_FILE_PATH="$HOME/.config/sketchybar-config/theme.sh"
