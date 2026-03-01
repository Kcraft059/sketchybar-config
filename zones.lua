local mod = {}

function mod.setup(bar,icons,palette) 
  mod.brackets = {
    dynamic_brackets  = {},
    menus           = {},
    spaces          = {}
  }


  mod.properties = {
    background = {
      height = bar.config.height - 8,
      corner_radius = (bar.config.radius - 5) > 7 and (bar.config.radius - 5) or 7,
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
    padding_right = 0,
    padding_left  = 0,

    icon = {
    --  string        = icons.zones.expended,
    --  y_offset      = 1,
      font          = { family = config.font },
      color         = palette.text.muted,
      padding_left  = 3,
      padding_right = 3,
    },

    label = {
      drawing = "false" 
    }
  }

  return mod
end 

local function fetchNames(items)
  local names = {}

  for index,item in pairs(items) do
    names[index] = item.name
  end

  return names
end

local function bracketToggle(items,icons,show)
  local sep_icon = show and icons.zones.expended or icons.zones.collapsed

  if type(sep_icon) == "table" then items.separator:set({ icon = sep_icon }) 
  else items.separator:set({ icon = { string = sep_icon }}) end
  
  for index,item in pairs(items) do
    if tonumber(index) then item:set({ drawing = show }) end
  end
end

local function handleDynamicBrackets(brackets,icons)
  for key,items in pairs(brackets) do
    local bracket   = sbar.add("bracket", fetchNames(items), mod.properties)
    items.separator = sbar.add("item",mod.separator_properties)

    if not items.bracket then items.bracket = { show = true } end
    mergeTables(items.bracket,bracket,false)

    bracketToggle(items,icons,items.bracket.show)

    items.separator:subscribe("mouse.clicked", function (env) 
      items.bracket.show = toggle(items.bracket.show)
      perfbc()
      bracketToggle(items,icons,items.bracket.show)
      perfec()
    end)
    
    sbar.exec(string.format("sketchybar --move %s before %s",items.separator.name,items[1].name))
  end 
end

-- Load
function mod.load(icons)
  -- Add all brackets and associated items
  for key,items in pairs(mod.brackets) do 
    if key == "dynamic_brackets" then 
      handleDynamicBrackets(items,icons)

    else 
      items.bracket = sbar.add("bracket", fetchNames(items), mod.properties)

    end 
  end
end

return mod