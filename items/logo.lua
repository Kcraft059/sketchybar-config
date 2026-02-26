local mod = {}

-- Function
function mod.setup(bar, items, icons, palette)
  mod.properties = {
    space = {
      padding_left  = items.config.padding.outer + items.config.margin + bar.config.padding,

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

    menubar = mergeTables(zones.properties,{
      padding_left = items.config.padding.outer,
      padding_right = 10,

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
  -- Add and store item
  mod.item = sbar.add("item", "logo", mod.properties.space)

  -- Subscribe item
  mod.item:subscribe("mouse.clicked", function (env) 
    mod.state.show_menus = toggle(mod.state.show_menus)

    sbar.animate("tanh", 15, function ()        -- animate transition
      menus.show(mod.state.show_menus)      -- display menus
      --spaces.show(not mod.state.show_menus) -- display spaces

      mod.item:set(mod.state.show_menus and mod.properties.menubar 
                        or mod.properties.space)
    end)
  end)

end

return mod