local mod = {}

-- Setup
function mod.setup(items, icons, palette)
  mod.properties = {
    position = "right",
    icon = {
      string = icons.mic.high,
      align  = "left",
      width  = 16,
      color  = palette.colors.purple,
    },
    padding_right = items.config.margin + items.config.padding.outer,
    label = { drawing = false }
  }
  
  mod.state = {
    muted = false,
    volume = 50
  }

  return mod
end

local function micUpdate(item,icons,palette)
  return function (env)
    sbar.exec("osascript -e 'set ivol to input volume of (get volume settings)'", function (result,exit_code)
      local volume = tonumber(result)
      if not mod.state.muted then mod.state.volume = volume end

      local properties
      if volume == 0 then
        properties = { icon = { 
          string = icons.mic.muted,
          color  = palette.colors.red
        }}
      elseif volume < 50 then
        properties = { icon = { 
          string = icons.mic.low,
          color  = palette.colors.purple
        }}
      elseif volume >= 50 then
        properties = { icon = { 
          string = icons.mic.high,
          color  = palette.colors.purple
        }}
      end

      sequencedAnimation(item, "tanh", 15, nil, properties, nil, env.SENDER ~= "forced")
    end)
  end
end

local function micToggle(item,icons,palette)
  return function (env)
    
    micUpdate(item,icons,palette)({SENDER = "forced"})
    if env.INFO.button == "left" then
      if mod.state.muted then
        mod.state.muted = false
        sbar.exec(string.format("osascript -e 'set volume input volume %d'",mod.state.volume),micUpdate(item,icons,palette))
      else
        mod.state.muted = true
        sbar.exec("osascript -e 'set volume input volume 0'",micUpdate(item,icons,palette))
      end

    elseif env.INFO.button == "right" then
      sbar.exec(
        "osascript -e 'tell application \"System Events\"' -e 'key down option' -e 'end tell';"..
        execs.menubar .. " -s \"" .. menu_items.sound .. "\";" ..
        "osascript -e 'tell application \"System Events\"' -e 'key up option' -e 'end tell';", function (result,exit_code) 
          if exit_code ~= 0 then log("mic-click",result) end
        end)

    end
  end
end

-- Load
function mod.load(zones,icons,palette)
  mod.item = sbar.add("item", mod.properties)

  mod.item:subscribe({"routine","forced"},micUpdate(mod.item,icons,palette))
  mod.item:subscribe("mouse.clicked",     micToggle(mod.item,icons,palette))
   
  if not zones.brackets.right_brackets[1] then zones.brackets.right_brackets[1] = {} end
  table.insert(zones.brackets.right_brackets[1], mod.item.name) 

  return mod
end

return mod