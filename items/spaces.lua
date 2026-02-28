local mod = {}

-- Setup
function mod.setup(bar, zones, palette)
  mod.properties = {
    space = {
      padding_left  = 3,
      padding_right = 3,

      icon = {
        padding_left    = 6,
        padding_right   = 7,
        color           = palette.colors.yellow,
        highlight_color = palette.colors.red
      },

      background = {
        height        = bar.config.height - 12,
        corner_radius = zones.properties.background.corner_radius,
        color         = palette.zone.border,
        drawing       = false
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
        }
      }
    },
    separator = {
      padding_left       = bar.config.padding - 2,
      padding_right      = bar.config.padding - 2,
      associated_display = "active",

      icon = {
        string        = "􀆊",
        font          = config.font .. ":Semibold:14.0",
        color         = palette.text.subtle,
        padding_left  = 0,
        padding_right = 4
      },
      
      label = { drawing = false },
    },
    front_app = {
      padding_left       = 0,
      padding_right      = 0,
      associated_display = "active",

      background = {
        color         = palette.zone.border,
        height        = bar.config.height - 13,
        corner_radius = 7
      },
        
      icon = {
        string        = ":gear:",
        padding_right = 5,
        padding_left  = 5,
        font          = "sketchybar-app-font:Regular:15.0",
        color         = palette.colors.blue
      },
      
      label = {
        string        = "Gloup",
        padding_left  = 0,
        padding_right = 5,
        color         = palette.text.primary,
        font          = config.font .. ":Black:12.0"
      }
    }
  }

  mod.space_count   = 15
  mod.loaded_spaces = 0
  mod.items         = {}
  return mod
end

-- Load
function mod.show(bool)
  perfbc() -- PERF: bundle instructions
  mod.items["separator"]:set({ drawing = bool })
  mod.items["front_app"]:set({ drawing = bool })
  
  local i
  for i = 1, mod.space_count do
    sequencedAnimation(mod.items[i],"tanh",30,nil,{
      width = bool and "dynamic" or 0,
      label = { width = (bool and mod.items[i].state.appc > 0 and not mod.items[i].state.selected) and "dynamic" or 0 }
    }, {
      drawing = bool
    },true)
  end
  perfec()
end

local function yabaiWindowChange(item, space_index)
  return function(env)
    if not (env.INFO.space == space_index) then
      return
    end

    local cmd_str = "source " .. execs.icon_map .. ";"
    local c = 0

    -- Create command string
    for k, v in pairs(env.INFO.apps) do
      cmd_str = cmd_str .. string.format("__icon_map \"%s\"; printf \"$icon_result \";",k)
      c = c + 1
    end

    -- Update state
    mergeTables(item.state, {
      apps = copyTable(env.INFO.apps),
      appc = c
    }, false)

    -- Create app string
    if c > 0 then
      -- Fetch icons
      sbar.exec(cmd_str, function(result, exit_code)
        if not item.state.selected then
          -- Show space
          sequencedAnimation(item,"tanh",15, {
            label = { string = result }
          }, {
            label = { width = "dynamic" }
          }, nil, true)
        end

        if mod.loaded_spaces < mod.space_count then
          sbar.trigger("space_change")
          mod.loaded_spaces = mod.loaded_spaces + 1
        end
      end)
    else
      -- Hide sapce
      sequencedAnimation(item,"tanh",15, {
        label = { string = "" }
      }, {
        label = { width = 0 }
      }, nil, true)

      if mod.loaded_spaces < mod.space_count then
        sbar.trigger("space_change")
        mod.loaded_spaces = mod.loaded_spaces + 1
      end
    end
  end
end

local function yabaiSpaceChange(item)
  return function(env)
    item.state.selected = (env.SELECTED ~= "false")

    local show
    local properties = {
      icon       = { highlight = env.SELECTED },
      background = { }
    }

    if not item.state.selected and item.state.appc >= 1 then
      properties.background.drawing = true
      show = true
    else
      properties.background.drawing = false
      show = false
    end

    -- Toggle space
    sequencedAnimation(item,"tanh",15,properties, {
      label = { width = show and "dynamic" or 0 }
    }, nil, true)
  end
end

local function yabaiClick()
  return function(env)
    sbar.exec("yabai -m space --focus " .. env.SID)
  end
end

local function yabaiMouseHover(item)
  return function(env)
    if item.state.appc > 0 and item.state.selected == false then
      sbar.exec(execs.ft_haptic --[[ .. " -n " .. item.state.appc .. " -t 0.1" ]])
    end
  end
end

local function loadYabaiSpaces(zones)
  local i
  for i = 1, mod.space_count do
    local item = sbar.add("space", mergeTables(mod.properties.space, {
      associated_space = i,
      icon             = {
        string = i
      }
    }))

    item.state = {
      apps     = {},
      appc     = 0,
      selected = false
    }

    mod.items[i]             = item
    zones.brackets.spaces[i] = item.name

    item:subscribe("space_change"        , yabaiSpaceChange(item))
    item:subscribe("space_windows_change", yabaiWindowChange(item, i))
    item:subscribe("mouse.clicked"       , yabaiClick())
    item:subscribe("mouse.entered"       , yabaiMouseHover(item))
  end

  mod.items["separator"] = sbar.add("item",mod.properties.separator)
  mod.items["front_app"] = sbar.add("item",mod.properties.front_app)

  mod.items["front_app"]:subscribe("front_app_switched",function (env)
    -- Update window icon depending on active app
    sbar.exec(string.format(
      "source %s; __icon_map \"%s\"; printf $icon_result",execs.icon_map,env.INFO
    ), function (result,exit_code)
      mod.items["front_app"]:set({
        icon  = {string = result},
        label = {string = env.INFO}
      })
    end)
  end)
end

function mod.load(zones)
  if config.window_manager == "yabai" then
    loadYabaiSpaces(zones)
  end

  return mod
end

return mod
