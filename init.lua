-- Imports
require("helpers")
local icons   = require("helpers/icons")

-- Globals
os_version = macOSversion()

menu_items = {
  sound          = { app = "com.apple.MenuBarAgent", id = "com.apple.menuextra.sound"},
  wifi           = { app = "com.apple.MenuBarAgent", id = "com.apple.menuextra.wifi" },
  battery        = { app = "com.apple.MenuBarAgent", id = "com.apple.menuextra.battery" },
  display        = { app = "com.apple.MenuBarAgent", id = "com.apple.menuextra.display" },
  user_switcher  = { app = "com.apple.MenuBarAgent", id = "com.apple.menuextra.user" },
  media_player   = { app = "com.apple.MenuBarAgent", id = "com.apple.menuextra.now-playing" },
	bluetooth      = { icon = icons.link, app = "com.apple.MenuBarAgent", id = "com.apple.menuextra.bluetooth" };
	control_center = { icon = icons.control_center, app = "com.apple.MenuBarAgent", id = "com.apple.menuextra.controlcenter" }
}

-- Fetch config with given defaults
config = fetchConfig(os.getenv("SKETCHYBAR_CONFIG") or "./config.lua", 
                     { -- Look & feel
                       theme        = "rose_pine",
                       transparency = true,
                       bar_look     = "default",
                       font         = "SF Pro",
                       animate      = true,

                       -- Behaviour
                       controls     = { menu_items.bluetooth },
                       theme_file   = "./themes.lua",
                       
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

-- Configure bar properties
local bar   = require("bar")   .setup(palette)
local zones = require("zones") .setup(bar, icons, palette)
local items = require("items") .setup(bar, zones, icons, palette)

bar  .load()
items.load(zones,icons,palette)
zones.load(icons)
