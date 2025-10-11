#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# Colors
spmt='\033[38;5;5;1m> \033[0m\033[48;5;0m'                   # >_
sqes='\033[48;5;0;38;5;8m[\033[38;5;4m?\033[38;5;8m]\033[0m' # [?]
scac='\033[48;5;0;38;5;8m[\033[38;5;1mx\033[38;5;8m]\033[0m' # [x]
sexc='\033[48;5;0;38;5;8m[\033[38;5;2mo\033[38;5;8m]\033[0m' # [o]
smak='\033[48;5;0;38;5;8m[\033[38;5;5m+\033[38;5;8m]\033[0m' # [+]
swrn='\033[48;5;0;38;5;8m[\033[38;5;3m!\033[38;5;8m]\033[0m' # [!]
syon='(\033[38;5;2;1my\033[38;5;0m/\033[38;5;1;1mn\033[0m)'  # (y/n)
RESET="\033[0m"

# Logging helpers
log() { echo -e "${sexc} $1${RESET}"; }
success() { echo -e "${smak} $1${RESET}"; }
warn() { echo -e "${swrn} $1${RESET}"; }
error() { echo -e "${scac} $1${RESET}" >&2; exit 1; }

### Ensure Homebrew
if ! command -v brew &>/dev/null; then
	log "Homebrew not found. Installing Homebrew..."
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || error "Failed to install Homebrew."
	eval "$(/opt/homebrew/bin/brew shellenv)" || eval "$(/usr/local/bin/brew shellenv)"
	success "Homebrew installed successfully."
else
	success "Homebrew is already installed."
fi

# Ensure dependencies
for cmd in git curl jq; do
	command -v "$cmd" >/dev/null 2>&1 || error "$cmd not found. Please install it first."
done

CONFIG_DIR="$HOME/.config/sketchybar"
ICON_MAP="$CONFIG_DIR/icon_map.sh"

### Clone config
log "Cloning SketchyBar configuration..."
if [[ -d "$CONFIG_DIR" ]]; then
	read -rp "$(echo -e "${sqes} Existing config found at $CONFIG_DIR. Reinstall? ${syon}: ${RESET}")" confirm
	if [[ "$confirm" =~ ^[Yy]$ ]]; then
		rm -rf "$CONFIG_DIR"
	else
		warn "Keeping existing config. Skipping clone."
	fi
fi

if [[ ! -d "$CONFIG_DIR" ]]; then
	git clone --depth 1 https://github.com/Kcraft059/sketchybar-config "$CONFIG_DIR" || error "Failed to clone repository."
	success "Cloned sketchybar-config repository."
fi

### Install dependencies
log "Installing SketchyBar dependencies..."
brew tap FelixKratz/formulae
brew install sketchybar media-control macmon imagemagick || warn "Some formulae may already be installed."
brew install --cask sf-symbols font-sketchybar-app-font font-sf-pro || warn "Some casks may already be installed."
success "Dependencies installed."

### Download latest icon map
get_icon_map() {
	log "Fetching latest icon map..."
	local latest_tag font_url
	latest_tag=$(curl -fsSL https://api.github.com/repos/kvndrsslr/sketchybar-app-font/releases/latest | jq -r .tag_name)
	font_url="https://github.com/kvndrsslr/sketchybar-app-font/releases/download/${latest_tag}/icon_map.sh"

	log "Latest release tag: $latest_tag"
	if [[ -f "$ICON_MAP" ]]; then
		warn "icon_map.sh already exists. Skipping download."
	else
		log "Downloading icon_map.sh from $font_url..."
		if curl -fsSL -o "$ICON_MAP" "$font_url"; then
			chmod +x "$ICON_MAP"
			success "icon_map.sh downloaded successfully."
		else
			error "Failed to download icon_map.sh."
		fi
	fi
}

get_icon_map

### Wifi-unredactor install
read -rp "$(echo -e "${sqes} Install 'wifi-unredactor' (for macOS 15.5+ WiFi name)? ${syon}: ${RESET}")" install_wifi_unredactor

if [[ "$install_wifi_unredactor" =~ ^[Yy]$ ]]; then
	TEMP_DIR=$(mktemp -d)
	PREVIOUS_DIR=$PWD
	log "Cloning noperator/wifi-unredactor..."
	git clone --depth 1 https://github.com/noperator/wifi-unredactor "$TEMP_DIR"
	cd "$TEMP_DIR"
	if ./build-and-install.sh; then
		success "Installed wifi-unredactor successfully."
	else
		error "Error compiling wifi-unredactor."
	fi
	cd "$PREVIOUS_DIR"
	rm -rf "$TEMP_DIR"
	success "Cleaned up temporary files."
else
	log "Skipped wifi-unredactor installation."
fi

### GitHub Notifications Setup
read -rp "$(echo -e "${sqes} Enable GitHub notifications in SketchyBar? ${syon}: ${RESET}")" enable_github

if [[ "$enable_github" =~ ^[Yy]$ ]]; then
	read -rsp "$(echo -e "${sqes} Enter your Classic GitHub Token: ${RESET}")" github_token
	echo
	if [[ -n "$github_token" ]]; then
		echo "$github_token" >"$HOME/.github_token"
		chmod 600 "$HOME/.github_token"
		success "GitHub token saved to ~/.github_token."
	else
		warn "No token entered. Skipping GitHub notifications."
	fi
else
	log "Skipped GitHub notifications setup."
fi

### Restart SketchyBar
log "Restarting SketchyBar..."
brew services restart sketchybar || warn "Failed to restart SketchyBar service."
sketchybar --reload || warn "Failed to reload SketchyBar."
success "SketchyBar setup complete 🎉"
