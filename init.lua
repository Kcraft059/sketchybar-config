-- Imports
require("helpers")

-- Fetch config with given defaults
config = fetchConfig(os.getenv("SKETCHYBAR_CONFIG") and os.getenv("SKETCHYBAR_CONFIG")
                      or "./config.lua", 
{ -- Look & feel
  theme = "rose-pine",
  transparency = true,
  bar_look = "default",
  font = "SF Pro",

  -- Technical
  notch_width = 180
}) 

local palette = require("helpers/colors").getColorPalette(config.theme, config.transparency and 180 or 1000) -- Put a huge alpha value to prevent adjusts
local icons   = require("helpers/icons")

-- Configure bar properties
bar   = require("bar")   .setup(palette)
zones = require("zones") .setup(bar, palette)
items = require("items") .setup(bar, zones, icons, palette)

bar.load()
items.load()
