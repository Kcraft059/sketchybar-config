local mod = {}

-- Setup 
function mod.setup(bar, zones, icons, palette)
  mod.config = {
    margin = 5,
    padding = {
      outer = 5,
      inner = 2
    }
  }

  sbar.default({
    updates       = "when_shown",
    padding_right = mod.config.margin,
    --padding_left = mod.config.margin,

    icon = {
      color         = palette.colors.blue,
      font          = config.font .. ":Regular:" .. 14.0,
      padding_left  = mod.config.padding.outer,
      padding_right = 0
    },

    label = {
      color         = palette.text.primary,
      font          = config.font .. ":Semibold:" .. 13.0,
      padding_left  = mod.config.padding.inner,
      padding_right = mod.config.padding.outer
    },

    background = {
      corner_radius = zones.properties.background.corner_radius
    }
  }) 

  mod.logo  = require("items.logo") .setup(bar, mod, icons, palette)
  mod.menus = require("items.menus").setup(icons, palette)

  return mod
end 

-- Load 
function mod.load()
  mod.logo.load(mod.menus)
end


return mod