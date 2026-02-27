local mod = {}

-- Setup
function mod.setup(bar, zones, palette)
  mod.properties = {
    space = {
      padding_left  = 3,
  	  padding_right = 3,

      icon =  {
        padding_left    = 6,
        padding_right   = 7,
        color           = palette.colors.yellow,
        highlight_color = palette.colors.red
      },

      background = {
        height        = bar.config.height - 12,
        corner_radius = zones.properties.background.corner_radius,
        color         = palette.zone.border,
        drawing       = false,
      },

      label = {
        drawing       = true,
        padding_right = 13,
        padding_left  = 13,
        y_offset      = -1,
        width         = 0,
        font          = "sketchybar-app-font:Regular:16.0",
        background    = {
          drawing       = true,
          height        = bar.config.height - 12,
          color         = palette.zone.overlay,
          corner_radius = zones.properties.background.corner_radius - 2
        },
      }
    },
    separator = {
      icon               = { string  = "􀆊" },
      label              = { drawing = false },
      icon               = { 
        font  = config.font .. ":Semibold:14.0",
        color = palette.text.subtle 
      },
      associated_display = "active"
    }
  }

  mod.space_count = 15
  mod.loaded_spaces = 0
  mod.items = {}
  return mod
end

-- Load
function mod.show(bool)
  local i
  for i = 1,mod.space_count do
    mod.items[i]:set({ drawing = bool }) 
  end 
end

local function spaceLabelUpdate(item,properties,show)
  item:set(properties)
  sbar.animate("tanh" ,20 , function ()
    item:set({label = { width = show and "dynamic" or 0 }})
  end)
end

local function yabaiWindowChange(item, space_index)
  return function (env)
    if not (env.INFO.space == space_index) then return end

    local cmd_str = "source " .. execs.icon_map .. ";"
    local c = 0

    for k,v in pairs(env.INFO.apps) do
      cmd_str = cmd_str .. "__icon_map \"" .. k .. "\"; printf \"$icon_result \";" 
      c = c + 1
    end 
      
    mergeTables(item.state,{
      apps = copyTable(env.INFO.apps),
      appc = c
    },false)

    if c > 0 then 
      sbar.exec(cmd_str, function (result, exit_code) 
        if not item.state.selected then spaceLabelUpdate(item,{label = { string  = result }}, true) end
        if mod.loaded_spaces < mod.space_count then
          sbar.trigger("space_change")
          mod.loaded_spaces = mod.loaded_spaces  + 1
        end
      end)
    else 
      spaceLabelUpdate(item,{label = { string  = "" }}, false)
      if mod.loaded_spaces < mod.space_count then
        sbar.trigger("space_change")
        mod.loaded_spaces = mod.loaded_spaces  + 1
      end
    end
  end
end

local function yabaiSpaceChange(item)
  return function (env)
    item.state.selected = (env.SELECTED ~= "false")

    local show
    local properties = {icon = {highlight = env.SELECTED}}
    if not item.state.selected and item.state.appc >= 1 then 
      mergeTables(properties,{background = {drawing = true}}, false) 
      show = true
    else 
      mergeTables(properties,{background = {drawing = false}}, false)
      show = false
    end
    
    spaceLabelUpdate(item, properties, show)
  end
end

local function yabaiClick()
  return function (env)
    sbar.exec("yabai -m space --focus " .. env.SID)
  end
end 

local function yabaiMouseHover(item)
  return function (env)
    if item.state.appc > 0 and item.state.selected == false then
      sbar.exec(execs.ft_haptic .. " -n " .. item.state.appc .. " -t 0.1" )
    end
  end
end

local function loadYabaiSpaces(zones)
  local i
  for i = 1,mod.space_count do
    local item = sbar.add("space",mergeTables(mod.properties.space,{
      associated_space = i,
      icon =  { string = i }
    }))

    item.state = {
      apps     = {}, 
      appc     = 0, 
      selected = false
    }

    mod.items[i] = item
    zones.brackets.spaces[i] = item.name

    item:subscribe("space_change", yabaiSpaceChange(item))
    item:subscribe("space_windows_change",yabaiWindowChange(item,i))
    item:subscribe("mouse.clicked",yabaiClick())
    item:subscribe("mouse.entered",yabaiMouseHover(item))
  end
    
  --mod.items["separator"] = sbar:add("item",mod.properties.separator)
end

function mod.load(zones)
  if config.window_manager == "yabai" then
    loadYabaiSpaces(zones)
  end 
end 

return mod