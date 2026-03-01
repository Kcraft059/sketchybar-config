local mod = {}

-- Setup
function mod.setup(icons,palette)
  mod.properties = {
    position = "right",
    icon = {
      string = icons.battery.p100,
      font = config.font .. ":Regular:" .. 16.0,
    }
  }
  return mod
end

local function update(item,icons,palette)
  return function (env) 
    sbar.exec("pmset -g batt | grep 'not charging'", function (result_charging,exit_code_charging) 
      sbar.exec("pmset -g batt | grep 'AC Power'", function (result_ac,exit_code_ac) 
        sbar.exec("pmset -g batt | grep -Eo \"[0-9]+%\" | cut -d% -f1", function (result, exit_code)
        local percentage = tonumber(result)

        local properties = { icon = {}, label = { string = percentage .. " %"}}

          -- Icon 
        if exit_code_ac == 0 then
          properties.icon.string = icons.battery.ac
        elseif percentage < 10 then
          properties.icon.string = icons.battery.p0
        elseif percentage < 30 then
          properties.icon.string = icons.battery.p25
        elseif percentage < 60 then
          properties.icon.string = icons.battery.p50
        elseif percentage < 90 then
          properties.icon.string = icons.battery.p75
        else
          properties.icon.string = icons.battery.p100
        end

          -- Color
        if exit_code_charging == 1 then -- exit_code = 0 -> not charging 1 -> charging
          if exit_code_ac == 0 then
            properties.icon.color = palette.colors.purple
          elseif percentage < 10 then
            properties.icon.color = palette.colors.red
          elseif percentage < 30 then
            properties.icon.color = palette.colors.orange
          elseif percentage < 60 then
            properties.icon.color = palette.colors.yellow
          elseif percentage < 90 then
            properties.icon.color = palette.colors.cyan
          else
            properties.icon.color = palette.colors.blue
          end
        else
          properties.icon.color = palette.text.subtle
        end
          
        item:set(properties)
        end)
      end)
    end)
  end
end

-- Load
function mod.load(icons,palette)
  -- Check for battery presence
  local percentage = tonumber(shellEval("pmset -g batt | grep -Eo \"[0-9]+%\" | cut -d% -f1"))
  if percentage then 
    mod.item = sbar.add("item",mergeTables(mod.properties, { label = { string = percentage .. " %" }},false))
    mod.item:subscribe({"power_source_change","routine"}, update(mod.item,icons,palette))
    mod.item:subscribe("mouse.clicked", function (env)
      sbar.exec(execs.menubar .. " -s \"" .. menu_items.battery .. "\"")
    end)
  else 
    log("battery","No battery detected.")
  end

  return mod
end

return mod