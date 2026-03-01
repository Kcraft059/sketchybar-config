local mod = {}

-- Setup
function mod.setup(items,icons)
  mod.properties = {
    position = "right",
    padding_right = items.config.margin - 1,
    icon = {
      string        = icons.display.default,
      padding_right = 1
    },
    label = {
      drawing = false
    }
  }

  return mod
end

local function bd_update(item)
  return function (env)
    -- `betterdisplaycli get --identifiers --devicetype=DisplayGroup`
    for k,v in pairs(config.bd_display_groups) do
      sbar.exec("printf \"%s\" \"$(" .. execs.bd_cli .. " get --name=\"" .. k .. "\" --active)\"", function (result,exit_code) 
        if result == "on" then 
          item:set({ icon = { string = v.icon }})
        end
      end)
    end
  end
end

-- Load
function mod.load()
  mod.item = sbar.add("item",mod.properties)
  
  if execs.bd_cli then
    mod.item:subscribe("mouse.clicked", function (env) sbar.exec(execs.bd_cli .. " toggle --appmenu") end)
    mod.item:subscribe({"display_change","forced"}, bd_update(mod.item))
  else  
    mod.item:subscribe("mouse.clicked", function (env) sbar.exec(execs.menubar .. " -s " .. menu_items.display) end)
  end

  return mod
end

return mod