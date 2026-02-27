-- Imports
require("helpers")

-- Globals
os_version = macOSversion()
execs = {
  menubar       = cmdPath("menubar") or "./helper/menubar",
  ft_haptic     = cmdPath("ft-haptic") or "./helper/ft-haptics",
  media_control = cmdPath("media-control") or error("No media-control in path"),
  icon_map      = cmdPath("icon_map.sh") or "./helper/icon_map.sh"
}

-- Fetch config with given defaults
config = fetchConfig(os.getenv("SKETCHYBAR_CONFIG") or "./config.lua", 
                     { -- Look & feel
                       theme        = "rose-pine",
                       transparency = true,
                       bar_look     = "default",
                       font         = "SF Pro",
                       animate      = true,
                     
                       -- Technical
                       window_manager = "yabai",
                       notch_width    = 180,
                       perfbc         = true -- Allow command bundling for improved performance
                     }) 

local palette = require("helpers/colors").getColorPalette(config.theme, config.transparency and 180 or 1000) -- Put a huge alpha value to prevent adjusts
local icons   = require("helpers/icons")

-- Configure bar properties
local bar   = require("bar")   .setup(palette)
local zones = require("zones") .setup(bar, palette)
local items = require("items") .setup(bar, zones, icons, palette)

bar  .load()
items.load(zones)
zones.load()