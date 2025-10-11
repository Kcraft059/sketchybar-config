#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# Colors
spmt='\033[38;5;5;1m> \033[0m\033[48;5;0m'
sqes='\033[48;5;0;38;5;8m[\033[38;5;4m?\033[38;5;8m]\033[0m'
scac='\033[48;5;0;38;5;8m[\033[38;5;1mx\033[38;5;8m]\033[0m'
sexc='\033[48;5;0;38;5;8m[\033[38;5;2mo\033[38;5;8m]\033[0m'
smak='\033[48;5;0;38;5;8m[\033[38;5;5m+\033[38;5;8m]\033[0m'
swrn='\033[48;5;0;38;5;8m[\033[38;5;3m!\033[38;5;8m]\033[0m'
syon='(\033[38;5;2;1my\033[38;5;0m/\033[38;5;1;1mn\033[0m)'
RESET="\033[0m"

# Logging helpers
log() { echo -e "${sexc} $1${RESET}"; }
success() { echo -e "${smak} $1${RESET}"; }
error() { echo -e "${scac} $1${RESET}" >&2; exit 1; }

# Ensure dependencies
for cmd in git brew curl jq; do
  command -v "$cmd" >/dev/null 2>&1 || error "$cmd not found. Please install it first."
done

CONFIG_DIR="$HOME/.config/sketchybar"

# --- Define get_icon_map function ---
get_icon_map() {
  mkdir -p "$CONFIG_DIR"
  local output_path="$CONFIG_DIR/icon_map.sh"

  if [[ -f "$output_path" ]]; then
    success "icon_map.sh already exists → skipping download."
    return 0
  fi

  log "Fetching latest icon map..."
  local latest_tag
  latest_tag=$(curl -fsSL https://api.github.com/repos/kvndrsslr/sketchybar-app-font/releases/latest | jq -r .tag_name)
  log "Latest release tag: $latest_tag"

  local font_url="https://github.com/kvndrsslr/sketchybar-app-font/releases/download/${latest_tag}/icon_map.sh"

  log "Downloading icon map from $font_url..."
  if curl -fsSL -o "$output_path" "$font_url"; then
    chmod +x "$output_path"
    success "Downloaded icon_map.sh → $output_path"
  else
    error "Failed to download icon_map.sh."
  fi
}

# --- Start install process ---
log "Cloning sketchybar-config repository..."
rm -rf "$CONFIG_DIR"
git clone --depth 1 https://github.com/Kcraft059/sketchybar-config "$CONFIG_DIR"
success "Cloned sketchybar-config repository."

log "Installing SketchyBar dependencies..."
brew tap FelixKratz/formulae
brew install sketchybar media-control macmon imagemagick || error "Failed to install formulae."
brew install --cask sf-symbols font-sketchybar-app-font font-sf-pro || error "Failed to install casks."
success "Installed dependencies."

# --- Get icon map (skip if exists) ---
get_icon_map

# --- Wifi-unredactor setup ---
read -rp "$(echo -e "${sqes} Install 'wifi-unredactor' for macOS 15.5+ Wi-Fi name fix? ${syon}: ${RESET}")" install_wifi_unredactor
PREVIOUS_DIR=$PWD
TEMP_DIR=$(mktemp -d)
if [[ "$install_wifi_unredactor" =~ ^[Yy]$ ]]; then
  log "Cloning noperator/wifi-unredactor..."
  git clone --depth 1 https://github.com/noperator/wifi-unredactor "$TEMP_DIR"
  cd "$TEMP_DIR"
  ./build-and-install.sh && success "Installed wifi-unredactor in ~/Applications." || error "Error compiling wifi-unredactor."
  cd "$PREVIOUS_DIR"
  rm -rf "$TEMP_DIR"
else
  log "Skipped wifi-unredactor setup."
fi

# --- GitHub notifications setup ---
read -rp "$(echo -e "${sqes} Enable GitHub notifications in SketchyBar? ${syon}: ${RESET}")" enable_github
if [[ "$enable_github" =~ ^[Yy]$ ]]; then
  read -rsp "$(echo -e "${sqes} Enter your Classic GitHub Token: ${RESET}")" github_token
  echo
  if [[ -n "$github_token" ]]; then
    echo "$github_token" >"$HOME/.github_token"
    chmod 600 "$HOME/.github_token"
    success "GitHub token saved to ~/.github_token."
  else
    error "No token entered. Skipping GitHub notifications setup."
  fi
else
  log "Skipped GitHub notifications setup."
fi

# --- Restart SketchyBar ---
log "Restarting SketchyBar..."
brew services restart sketchybar
sketchybar --reload
success "SketchyBar installation and setup complete."
