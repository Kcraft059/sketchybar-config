local mod = {}

-- Function
function mod.setup(bar, items, icons, palette)
  mod.properties = {
    space = {
      position = "left",

      padding_left   = items.config.padding.outer + items.config.margin + bar.config.padding,
      padding_right  = items.config.padding.outer + bar.config.padding,

      icon = {
        string        = icons.logo.cmd,
        color         = palette.text.primary,
        font          = config.font .. ":Semibold:" .. 14.0,
        padding_right = 2,
        padding_left  = 0,
        y_offset      = 0
      },

      label = {
        drawing = false
      },

      background = {
        drawing = false
      }
    },

    menus = mergeTables(zones.properties,{
      padding_left = items.config.padding.outer,
      padding_right = items.config.padding.outer,

      icon = {
        string        = icons.logo.apple,
        color         = palette.colors.blue,
        font          = config.font .. ":Black:" .. 17.0,
        padding_left  = 8,
        padding_right = 9,
        y_offset      = 1
      },

      label = {
        drawing = false
      },

      blur_radius = 0
    })
  }

  mod.state = {
    show_menus = false
  }

  return mod
end

-- Load
function mod.load(menus, spaces)
  -- Add item
  mod.item = sbar.add("item", "logo", mod.properties.space)

  -- Click event
  mod.item:subscribe("mouse.clicked", function (env) 
    if env.BUTTON == "right" then
      mod.state.show_menus = toggle(mod.state.show_menus)
      
      --sbar.animate("tanh", 15, function ()    -- animate transition
      menus.show(mod.state.show_menus)      -- display menus
      spaces.show(not mod.state.show_menus) -- display spaces

      mod.item:set(mod.state.show_menus and mod.properties.menus 
                   or mod.properties.space)
      --end)

    elseif mod.state.show_menus then
      sbar.exec(execs.menubar .. " -s 0")

    end
  end)
  
  -- Mouse hover event
  mod.item:subscribe("mouse.entered", function (env) 
    sbar.exec(execs.ft_haptic)
  end)

  -- App switch event
  mod.item:subscribe("front_app_switched", function (env)
    if mod.state.show_menus then
      menus.update()
    end
  end)
end

return mod