local mod = {}

-- Setup 
function mod.setup(bar, zones, icons, palette)
  mod.config = {
    margin = 5,
    padding = {
      outer = 2,
      inner = 5
    }
  }

  mod.defaults = {
    updates       = "when_shown",
    update_freq   = 120,
    padding_right = mod.config.margin,
    padding_left  = mod.config.margin, 

    icon = {
      color         = palette.colors.blue,
      font          = config.font .. ":Regular:" .. 14.0,
      padding_left  = mod.config.padding.outer,
      padding_right = mod.config.padding.inner,
    },
    
    label = {
      color         = palette.text.primary,
      font          = config.font .. ":Semibold:" .. 10.0,
      padding_left  = 0,
      padding_right = mod.config.padding.outer + 1 
    },

    background = {
      corner_radius = zones.properties.background.corner_radius,
      --color = 0xFFFF0000
    }
  }

  sbar.default(mod.defaults)

  -- Left
  mod.logo    = require("items.logo")   .setup(bar, zones, mod, icons, palette)
  mod.menus   = require("items.menus")  .setup(icons, palette)
  mod.spaces  = require("items.spaces") .setup(bar, zones, palette)

  -- Right    
  mod.date    = require("items.date")   .setup(palette)
  mod.mic     = require("items.mic")    .setup(mod, icons, palette)
  mod.sound   = require("items.sound")  .setup(mod, icons, palette)
  mod.battery = require("items.battery").setup(icons, palette)
  mod.wifi    = require("items.wifi")   .setup(icons, palette)
  mod.display = require("items.display").setup(mod, icons)
  return mod
end 

-- Load 
function mod.load(zones,icons,palette)
--Module     Load Method                   Adjustements
  mod.logo   .load(mod.menus, mod.spaces)
  mod.menus  .load(zones)
  mod.spaces .load(zones)
  
  mod.date   .load()     
  mod.mic    .load(zones,icons,palette)    .item:set({ padding_left  = mod.config.margin - 4 })
  mod.sound  .load(mod,zones,icons,palette).item:set({ padding_right = 4 })
  mod.battery.load(zones,icons,palette)    .item:set({ padding_left  = 0 })
  mod.wifi   .load(mod,zones,icons,palette).item:set({ padding_left  = 0 })
  mod.display.load(zones)
end

return mod