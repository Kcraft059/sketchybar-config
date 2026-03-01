local mod = {}

-- Setup
function mod.setup(icons,palette)
  mod.properties = {
    alias = {
      position      = "right",
      padding_left  = -4,
      padding_right = -4,

      icon          = { drawing = false },
      label         = { drawing = false },
    },
    control_center = {
      position = "right",

      icon = {
        string = icons.control_center,
        color  = palette.colors.blue
      },

      label = {
        drawing = false
      }
    }
  }



  mod.items = {}
  return mod
end

-- Load
function mod.load()
  local item = sbar.add("item", mod.properties.control_center)
  item:subscribe("mouse.clicked", function (env)
    sbar.exec(execs.menubar .. " -s \"" .. menu_items.control_center  .. "\"")
  end)

  mod.control_center = item
  return mod
end

function mod.alias(alias_name)
  local item = sbar.add("alias", alias_name, mod.properties.alias)
  item:subscribe("mouse.clicked", function (env) 
    sbar.exec(execs.menubar .. " -s \"" .. alias_name .. "\"")
  end)

  mod.items[alias_name] = item
  return mod
end

return mod