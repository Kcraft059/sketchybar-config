local mod = {}

function mod.setup(bar,palette) 
  mod.brackets = {
    right_brackets  = {},
    menus           = {},
    spaces          = {}
  }

  mod.properties = {
    background = {
      height = bar.config.height - 8,
      corner_radius = bar.config.radius - 5,
      border_width = 2,

      color = palette.zone.background,
      border_color = palette.zone.border,
      
      --[[ shadow = {
        color = palette.colors.black - 0xff000000 + 10 * 0x1000000,
        angle = 45,
      } ]]
    },

    blur_radius=2
  }

  mod.separator_properties = {
    position = "right",
    padding_right = 4,
    padding_left  = 3,

    icon = {
      string        = "|",
      y_offset      = 2,
      font          = config.font .. ":Bold:" .. 18.0,
      color         = palette.text.muted,
      padding_left  = -1,
      padding_right = 0,
    },

    label = {
      drawing = "false" 
    }
  }

  return mod
end 

local function handleDynamicBrackets(brackets)
  for key,items in pairs(brackets) do
    local separator = sbar.add("item",mod.separator_properties)
    sbar.add("bracket", key .. "_right_zone", items, mod.properties)

    sbar.exec(string.format("sketchybar --move %s before %s",separator.name,items[1]))
  end 
end

-- Load
function mod.load()
  -- Add all brackets and associated items
  for k,v in pairs(mod.brackets) do 
    if k == "right_brackets" then 
      handleDynamicBrackets(v)
    else 
      sbar.add("bracket", k .. "_zone" , v, mod.properties)
    end 
  end
end

return mod