local mod = {}

function mod.setup(bar,palette) 
  mod.brackets = {
    system = {},
    volume = {},
    more = {}
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
  for k,v in pairs(mod.brackets) do
    sbar.add("bracket",v,mod.properties)
  end
end

return mod