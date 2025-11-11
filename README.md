# Utility Bar
## Rosé Pine Moon (and more !)
<div align=center>
<img width="1470" height="40" alt="Screenshot 2025-08-21 at 12 39 13" src="https://github.com/user-attachments/assets/230c1063-cb96-4686-9745-270335e650e5" />
<img width="1470" height="40" alt="Screenshot 2025-08-21 at 12 39 39" src="https://github.com/user-attachments/assets/c34be030-27f3-4bf4-a7df-d1119208c824" />

</div>


This is a config I made which aggregate functionnality and aesthetics, made in mind to be Nix-Compliant.

See https://github.com/FelixKratz/SketchyBar/discussions/47#discussioncomment-14058252

> [!WARNING] 
> Some of the functionnalities of the bar are not working currently in MacOS Tahoe (26.0).
> Permissions issues and other not yet tested bugs might occur.
> 
> Since this was a personnal config not meant for release, the original code that remains is garbage... sry 😅

## A little demonstration of the functionalities :

<img width="2940" height="1912" alt="Screenshot 2025-08-09 at 18 49 42" src="https://github.com/user-attachments/assets/23066c77-1b31-4372-a737-8bf450af1d80" />
<img width="2940" height="1912" alt="Screenshot 2025-08-09 at 18 55 12" src="https://github.com/user-attachments/assets/0406413d-4468-4ba7-b55d-1c59e7e52cfb" />


https://github.com/user-attachments/assets/c9db52a4-d7fe-4daa-a904-cd201476556c

## Install :

With the installer :

```sh
bash -c "$(curl -fsSL https://raw.githubusercontent.com/Kcraft059/sketchybar-config/main/install.sh)"
```

<details>

<summary>Manual install:</summary>

Install sketchybar

```bash
brew tap FelixKratz/formulae
brew install sketchybar
brew services start sketchybar
```

Install this config with its dependencies

```bash
# brew install yabai # Recommended only if you already have a config
# brew install brew install waydabber/betterdisplay/betterdisplaycli # Recommended if using better display Configure [here](<plugins/display/script.sh>)
# (Also recommended for battery control - when clicking battery icon : https://github.com/mhaeuser/Battery-Toolkit)

brew install media-control macmon imagemagick
brew install --cask font-SF-Pro font-sketchybar-app-font

mkdir -p ~/.config
cd ~/.config/
git clone https://www.github.com/Kcraft059/sketchybar-config sketchybar

sketchybar --reload
```

For yabai users : `yabai -m config external_bar all:36:0`

</details>

For Nix-Darwin users see : [here](#nix--nix-darwin-integration)
or alternatively https://github.com/Kcraft059/Nix-Config/blob/master/home/darwin/sketchybar.nix

## Aerospace Integration

Aerospace window manager is now supported!

### Choosing a window manager

1. You can let the config auto detect your window-manger or force it in `config.sh`:
```bash
WINDOW_MANAGER="aerospace" # supported "yabai", "aerospace", and "rift"; defaults to "" which is auto-detect
```

1. For aerospace, add the following to your `~/.config/aerospace/aerospace.toml`:
```toml
# Add this anywhere in your aerospace.toml file
# IMPORTANT: Must be an array format, NOT using exec-and-forget
exec-on-workspace-change = [
  '/opt/homebrew/bin/bash',
  '-c',
  '/opt/homebrew/bin/sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE=$AEROSPACE_FOCUSED_WORKSPACE'
]
```

1. Reload both configurations:
```bash
aerospace reload-config
sketchybar --reload
```

**Note:** The setup script automatically detects the correct paths for bash and sketchybar.

### Aerospace vs Yabai Differences

- **Creating workspaces**: Right-clicking the separator won't create new workspaces (aerospace manages workspaces differently)
- **Destroying workspaces**: Right-clicking workspace items won't destroy them
- **Performance**: Uses efficient workspace-specific triggers instead of updating all workspaces
- **Workspace switching**: Click on workspace items to switch (supports both left and right click)

### Troubleshooting Aerospace Integration

- **Workspaces not updating**: Ensure `aerospace reload-config` and `sketchybar --reload` have been run after configuration changes
- **Click not working**: Verify aerospace is in your PATH by running `which aerospace`
- **Setup script fails**: Check that both aerospace and sketchybar are properly installed via Homebrew
- **Config file errors**: Run `aerospace validate-config` to check your aerospace.toml syntax
- **"Event not found" errors**: Check `/tmp/sketchybar.out.log` for missing events. Ensure `AEROSPACE_MODE=True` is set in config.sh
- **"Permission denied" errors**: Check `/tmp/sketchybar.err.log`. The aerospace-script.sh file may need execute permissions: `chmod +x ~/.config/sketchybar/plugins/spaces/aerospace-script.sh`
- **Runtime errors**: If you see `exec-and-forget` errors, ensure your aerospace.toml uses the array format: `["bash", "-c", "command"]` not `"exec-and-forget command"`

## Rift Integration

### Setting up Rift Integration

1. Ensure Rift is installed and running with `rift-cli` available in your PATH.

2. The config automatically detects Rift, but you can force it in `config.sh`:
```bash
WINDOW_MANAGER="rift"
```

3. Add the following to your `~/.config/rift/config.toml` to enable SketchyBar integration:
```toml
# Run commands on start
run_on_start = [
  "rift-cli subscribe cli --event workspace_changed --command /bin/bash --args -c --args 'sketchybar --trigger rift_workspace_changed'",
  "rift-cli subscribe cli --event windows_changed --command /bin/bash --args -c --args 'sketchybar --trigger rift_windows_changed'"
]
```

4. Reload configurations:
```bash
rift-cli service restart  # Restart Rift service if needed
sketchybar --reload
```

### Rift Features

- **Workspace switching**: Click on workspace numbers to switch between workspaces
- **Active workspace highlighting**: Current workspace is highlighted
- **Window icons**: Workspaces show icons of running applications
- **Dynamic workspace detection**: Automatically detects available workspaces from Rift
- **Event-driven updates**: Responds to Rift's workspace and window change events

### Rift vs Other Window Managers

- **Similar to Aerospace**: Uses event-driven updates and workspace-specific triggers
- **Workspace management**: Right-clicking the separator shows a message (Rift manages workspaces differently)
- **Performance**: Efficient updates only when workspaces or windows change
- **Integration**: Native support through Rift's CLI and event system

### Troubleshooting Rift Integration

- **Workspaces not showing**: Ensure `rift-cli` is in your PATH and Rift is running
- **Click not working**: Verify Rift is active and workspaces are available
- **Icons not updating**: Check that Rift's event subscriptions are working
- **Config errors**: Ensure your Rift config includes the event subscriptions (usually in `~/.config/rift/config.toml`)
- **Permission errors**: Make sure the Rift scripts have execute permissions

## Configuration

A lightweight `config.sh` (or an externally provided file via the `SKETCHYBAR_CONFIG` env var) now allows you to tweak common behaviors without patching the repo.

Defaults (only applied if a variable is unset):

```bash
BAR_TRANSPARENCY=true
BAR_LOOK="plain"        # Aspect of the bar 
NOTCH_WIDTH=180         # Reserved width for the display notch
MUSIC_INFO_WIDTH=80     # Width (px) for music title & subtitle labels
CPU_UPDATE_FREQ=2       # Seconds between CPU graph samples
MENUBAR_AUTOHIDE=True   # Whether to automatically hide the menu titles
GITHUB_TOKEN="~/.github_token" # Path to your GitHub Classic token (for notifications)
WIFI_UNREDACTOR="~/Applications/wifi-unredactor.app" # Wifi unredactor path
```

Usage order of precedence:
1. If `SKETCHYBAR_CONFIG` points to a readable file, it is sourced.
2. Else if `config.sh` exists in the repo directory, it is sourced (see all examples in ./config-examples/).
3. Fallback defaults are applied inside `sketchybarrc`.

You can remove or comment variables you don't want to override—defaults remain unaffected.

### Adding a custom theme 

In the config.sh, you can choose the theme used for the bar :

```bash
COLOR_SCHEME="rosepine-moon"
```

You can also set your own theme by adding a theme.sh file, or by specifying the path to the theme file :

```bash
COLOR_SCHEME="my-theme"
THEME_FILE_PATH="$HOME/.config/sketchybar-config/theme.sh"
```

The file must follow the format in the example (./config-examples)

### Adding native macOS menu items in the 'more' menu

You can add native macOS menu items to the bar by modifying `MENU_CONTROLS` in config.sh :

```bash
MENU_CONTROLS=(
	"Control__Center,FocusModes"
	"Control__Center,Bluetooth"
)
```

To get the name of the items present in the bar you can run `sketchybar --query default_menu_items`. 
To add an item with a space in the name you must replace " " with "__", for example :
"Control Center,FocusModes" -> "Control__Center,FocusModes"

### Adjusting for the Notch or Clipping Music
If album/title text appears clipped by the notch, increase either:
- `NOTCH_WIDTH` (reserves more center space), or
- `MUSIC_INFO_WIDTH` (shrinks / expands label region; smaller can prevent collision with other center items).

To reload after changing values: `sketchybar --reload` (tip: you can also ⇧+click on the cloverleaf logo to reload the config directly from the bar).

# Nix / Nix-Darwin Integration
<details>

There are multiple ways to integrate these settings through Nix flakes.

### 1. Flake Input 
```nix
{
  sketchybar-config = {
    url = "github:kcraft059/sketchybar-config";
    flake = false;
  };
}
```
Then deploy the repo content into `~/.config/sketchybar` (via home-manager or a derivation) and drop a `config.sh` alongside.

#### Example Home-Manager Module Snippet
An opinionated module integrating this repo as a flake input :
```nix
{ inputs, pkgs, ... }:
{
  home.packages = with pkgs; [
    sketchybar-app-font
  ];

  programs.sketchybar = {
    enable = true;
    service = rec {
      enable = true;
      errorLogFile = "/tmp/sketchybar.log"; # You can remove those, but they might be usefull when bug reporting
      outLogFile = errorLogFile;
    };
    configType = "bash";
    config = {
      source = "${inputs.sketchybar-config}"; # Use the flake input pointing to this repo
      recursive = true; # Copy entire config tree
    };
    extraPackages = with pkgs; [
      # menubar-cli # (needs to come from an overlay, check https://github.com/Kcraft059/Nix-Config/blob/master/overlays/menubar-cli.nix for implementation - bin by @FelixKratz)
      # wifi-unredactor # (needs to come from an overlay, check https://github.com/Kcraft059/Nix-Config/blob/master/overlays/wifi-unredactor.nix for implementation - app by @noperator)
      imagemagick
      macmon
    ];
  };

  # Example of providing dynamic icon map or other generated files
  xdg.configFile = {
    "sketchybar/dyn-icon_map.sh".source = "${pkgs.sketchybar-app-font}/bin/icon_map.sh"; # To get the latest icon map for sketchybar app font

    # Optional: inline user overrides without forking
    # "sketchybar/config.sh".text = ''
    #   NOTCH_WIDTH=200
    #   MUSIC_INFO_WIDTH=100
    # '';
  };
}
```
</details>

## Troubleshooting
- Menu Bar items like `volume`, `wifi`, `bluetooth`, etc are not clickable (not working on macOS 26) : Ensure the items are present in the macOS native Menu Bar so that the program can simulate a click on the item.
- CPU not showing: Ensure `cpu.sh` is sourced (it is by default) and run `sketchybar --query item graph.percent` to verify presence.
- Music overlapping notch: Bump `NOTCH_WIDTH` in small increments (e.g. +10) or reduce `MUSIC_INFO_WIDTH`.
- Config not applied: Echo inside your `config.sh` or run `grep NOTCH_WIDTH ~/.config/sketchybar/sketchybarrc` to confirm dynamic variable usage.
