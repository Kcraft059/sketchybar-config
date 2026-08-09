local mod = {}

-- Setup
function mod.setup(icons,palette)
  mod.properties = {
    alias = {
      position      = "right",
      padding_left  = 3,
      padding_right = 4,

      icon          = { color = palette.colors.cyan },
      label         = { drawing = false },
    },
    control_center = {
      padding_left  = 5,
      padding_right = 5,
    }
  }



  mod.items = {}
  return mod
end

-- Load
function mod.load()
	mod.alias(menu_items.control_center):set(mod.properties.control_center);
  return mod
end

function mod.alias(menu_item)
	local item = sbar.add("item", mergeTables(mod.properties.alias, { icon = { string = menu_item.icon } },true))
	item:subscribe("mouse.clicked", function (env) 
    sbar.exec(execs.menubar .. " item select ".. menu_item.app .. " " .. menu_item.id);
	end)

	mod.items[menu_item.app .. "_" .. menu_item.id] = item 
  return item
end

return mod
