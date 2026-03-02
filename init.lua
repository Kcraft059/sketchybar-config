-- Imports
require("helpers")

-- Globals
os_version = macOSversion()

menu_items = {
  control_center = "Control Center,BentoBox-0",
  sound          = "Control Center,Sound",
  wifi           = "Control Center,WiFi",
  battery        = "Control Center,Battery",
  display        = "Control Center,Display",
  user_switcher  = "Control Center,UserSwitcher",
  bluetooth      = "Control Center,Bluetooth",
  media_player   = "Control Center,NowPlaying",
}

-- Fetch config with given defaults
config = fetchConfig(os.getenv("SKETCHYBAR_CONFIG") or "./config.lua", 
                     { -- Look & feel
                       theme        = "rose-pine",
                       transparency = true,
                       bar_look     = "default",
                       font         = "SF Pro",
                       animate      = true,

                       -- Behaviour
                       controls     = { menu_items.bluetooth },
                       
                       -- Technical
                       window_manager = "yabai",
                       notch_width    = 180,
                       perfbc         = true, -- Allow command bundling for improved performance
                       git_key        = nil,
                       display_groups = {},
                       execs          = {} -- Overrides for executables
                     }) 

execs = mergeTables({
  menubar       = cmdPath("menubar") or "./helper/menubar",
  ft_haptic     = cmdPath("ft-haptic") or "./helper/ft-haptics",
  media_control = cmdPath("media-control") or log("lua-main","No media-control in path"),
  icon_map      = cmdPath("icon_map.sh") or "./helper/icon_map.sh",
  bd_cli        = cmdPath("betterdisplaycli") or log("lua-main","No betterdisplaycli in path"),
  identify      = cmdPath("identify") or log("lua-main","No imagemagick in path"),
  magick        = cmdPath("magick") or cmdPath("convert") or log("lua-main","No imagemagick in path"),
  yabai         = cmdPath("yabai") or log("lua-main","No yabai in path")
},config.execs)

local palette = require("helpers/colors").getColorPalette(config.theme, config.transparency and 180 or 1000) -- Put a huge alpha value to prevent adjusts
local icons   = require("helpers/icons")

-- Configure bar properties
local bar   = require("bar")   .setup(palette)
local zones = require("zones") .setup(bar, icons, palette)
local items = require("items") .setup(bar, zones, icons, palette)

bar  .load()
items.load(zones,icons,palette)
zones.load(icons)


--[[ 
❯ sketchybar --query default_menu_items                                                                                      01:14:22  ─╯
[
        "Control Center,Clock",
        "Control Center,BentoBox-0",
        "Control Center,Sound",
        "Control Center,Item-0",
        "LinkedNotesUIService,Window",
        "Control Center,Battery",
        "Control Center,Item-0",
        "Control Center,Item-0",
        "Control Center,WiFi",
        "Control Center,UserSwitcher",
        "Control Center,FocusModes",
        "Control Center,Bluetooth",
        "Control Center,Display",
        "Control Center,NowPlaying",
        "Control Center,Item-0",
        "Control Center,Item-0",
        "Control Center,DragPlaceholder",
        "Control Center,DragPlaceholder",
        "Control Center,DragPlaceholder",
        "Control Center,me.mhaeuser.BatteryToolkit",
        "Control Center,com.apple.TextInputMenuAgent",
        "Control Center,pro.betterdisplay.BetterDisplay",
        "Control Center,com.objective-see.lulu.app",
        "Control Center,17818"
] ]]