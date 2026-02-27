local mod = {}

-- Setup
function mod.setup(icons, palette) 
  mod.items = {}
  mod.properties = {
    base = {
      --position     = "left",
      padding_left  = 8,
      padding_right = 11,

      drawing      = false,
      label        = { drawing = false },

      icon = {
        string        = "Menu",
        font          = { style = "Regular", size = 14.0 },
        color         = palette.text.primary,
        padding_right = 0,
        padding_left  = 0
      },
      
      background = {
        drawing = false
      }
    },
    title = {
      icon = {
        string = "App",
        font = { style = "Heavy" },
        color = palette.colors.cyan
      }
    }
  }
  mod.menu_count = 15
  return mod
end 

function mod.load(zones)
  -- Items
  local i
  for i = 1,mod.menu_count do
    -- Add item
    local item = sbar.add("item",
      mergeTables(i == 1 and mergeTables(mod.properties.base, mod.properties.title) or mod.properties.base,{
        label = { string = i }
    }))

    -- Click event
    item:subscribe("mouse.clicked", function (env) 
      sbar.exec(execs.menubar .. " -s " .. mod.items[i]:query().label.value)
    end)

    -- Mouse hover event 
    item:subscribe("mouse.entered", function (env) 
      sbar.exec(execs.ft_haptic)
    end)

    -- Store
    mod.items[i] = item
    zones.brackets.menus[i] = item.name
  end  
end

-- Methods
function mod.show(bool)
  if bool then -- Update menus when showing 
    mod.update()

  else -- Set all to false otherwise
    for _,v in pairs(mod.items) do
      v:set({ drawing = false })
    end
  end 
end

function mod.update()
  sbar.exec(execs.menubar .. " -l", function (result, exit_code) 
    -- Display all menus
    local i = 1
    for menu_str in string.gmatch(result, "([^\n]+)") do 
      if i > mod.menu_count then return end
      
      mod.items[i]:set({ -- Set icon as menu name
        drawing = true,
        icon = { string = menu_str }
      })

      i = i + 1
    end

    -- Hide others
    local j
    for j = i,mod.menu_count do
      mod.items[j]:set({ drawing = false })
    end
  end)
end 

return mod