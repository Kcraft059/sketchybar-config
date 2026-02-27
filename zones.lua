local mod = {}

function mod.setup(bar,palette) 
  mod.brackets = {
    system = {},
    volume = {},
    more   = {},
    menus  = {},
    spaces = {}
  }

  mod.properties = {
    background = {
      height = bar.config.height - 8,
      corner_radius = bar.config.radius - 5,
      border_width = 2,

      color = palette.zone.background,
      border_color = palette.zone.border
    },

    blur_radius=2
  }

  return mod
end 

function mod.load()
  -- Add all brackets and associated items
  for k,v in pairs(mod.brackets) do 
    sbar.add("bracket", k .. "_zone" ,v,mod.properties)
    --print("Adding zone: " .. k .. "_zone")
  end
end

return mod