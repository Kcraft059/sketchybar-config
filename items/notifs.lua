local mod = {}

-- Setup
function mod.setup(icons, palette)
  mod.properties = {
    position = "right",

    update_freq = 1800,

    icon = { 
      color = palette.colors.blue,
      string = icons.notifications.empty
    },
    
    label = { string = "0" }
  }

  return mod
end

local function update(item,key_path,icons,palette)
  return function (env) 
    sbar.exec([[
      curl -m 15 -s \
        -H "Accept: application/vnd.github+json" \
        -H "Authorization: Bearer $(cat "]] .. key_path ..  [[")" \
        https://api.github.com/notifications
    ]], function (result,exit_code) 
      if exit_code ~= 0 or result.status == 401 then 
        log("notif","[error] code: " .. tostring(exit_code) .. ", result: " .. dump(result))
        return
      end

      local count = 0
      for _,_ in pairs(result) do count = count + 1 end
      
      item:set({ 
        label = { string = tostring(count) }, 
        icon = (count > 0) and { color = palette.colors.red , string = icons.notifications.notif } 
                            or { color = palette.colors.blue, string = icons.notifications.empty } 
      })
    end)
  end
end

-- Load
function mod.load(icons,palette)
  if config.git_key then 
    mod.item = sbar.add("item",mod.properties)
    mod.item:subscribe({"routine","forced"}, update(mod.item,config.git_key,icons,palette))
    mod.item:subscribe("mouse.clicked", function ()
      sbar.exec("open https://github.com/notifications")
    end)
  end

  return mod
end

return mod