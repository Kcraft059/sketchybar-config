local mod = {}

-- Setup
function mod.setup(icons, palette)
  mod.properties = {
    position = "right",
    
    icon = {
      string        = icons.user,
      font          = { size = 13.0, style = "Medium" },
      color         = palette.colors.purple,
      padding_right = 3,
    },
    
    label = {
      string   = "Loading…",
      font     = { size = 12.0, style = "Medium" },
    }
  }

  return mod
end

local function update(item)
  return function (env)
    sbar.exec("printf \"%s\" \"$(dscl . -read \"$HOME\" RealName | awk '/RealName: / {gsub(\"RealName: \",\"\"); print}')\"", function (result)
      item:set({label = { string = result }})
    end)
  end
end

-- Load
function mod.load()
  mod.item = sbar.add("item",mod.properties)

  mod.item:subscribe("forced",update(mod.item))
  mod.item:subscribe("mouse.clicked",function ()
    sbar.exec(execs.menubar .. " item select " .. menu_items.user_switcher.app .. " " .. menu_items.user_switcher.id)
  end)

  return mod
end

return mod
