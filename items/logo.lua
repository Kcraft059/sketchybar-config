local mod = {}

-- Function
function mod.setup(bar, zones, items, icons, palette)
  mod.properties = {
    space = {
      static = {
        position = "left",

        icon = {
          string   = icons.logo.cmd,
          font     = { style = "Semibold", size = 14.0 },
          y_offset = 0
        },

        label = {
          drawing = false
        },

        background = {
          drawing  = false
        }
      },
      anim = {
        padding_left  = items.config.padding.outer + items.config.margin + bar.config.padding,
        padding_right = items.config.padding.outer + bar.config.padding,

        icon = {
          color         = palette.text.primary,
          padding_right = 2,
          padding_left  = 0
        }
      }
    },

    menus = {
      static = {
        padding_left = items.config.padding.outer + items.config.margin + bar.config.padding - 8,

        icon = {
          string        = icons.logo.apple,
          font          = { style = "Black", size = 17.0 },
          y_offset      = 1,
        },
      },
      anim = {
        icon = {
          color         = palette.colors.blue,
          padding_left  = 8,
          padding_right = 9
        },

        padding_left  = 5,
        padding_right = 5
      },
      static_after = mergeTables(zones.properties,{
        blur_radius = 0,
      })
    }
  }

  mod.state = {
    show_menus = false
  }

  return mod
end

local function mouseClick(menus, spaces)
  return function(env)
    if env.BUTTON == "right" then
      mod.state.show_menus = toggle(mod.state.show_menus)

      
      if mod.state.show_menus then
        sequencedAnimation(mod.item, "tanh", 15, mod.properties.menus.static, mod.properties.menus.anim, mod.properties.menus.static_after, true)
      else
        sequencedAnimation(mod.item, "tanh", 15, mod.properties.space.static, mod.properties.space.anim, nil, true)
      end
      
      spaces.show(not mod.state.show_menus) -- display spaces
      menus.show(mod.state.show_menus) -- display menus

    elseif mod.state.show_menus then
      sbar.exec(execs.menubar .. " -s 0")

    end
  end
end

-- Load
function mod.load(menus, spaces)
  -- Add item
  mod.item = sbar.add("item", "logo", mergeTables(mod.properties.space.static, mod.properties.space.anim))

  -- Click event
  mod.item:subscribe("mouse.clicked", mouseClick(menus, spaces))

  -- Mouse hover event
  mod.item:subscribe("mouse.entered", function(env)
    sbar.exec(execs.ft_haptic)
  end)

  -- App switch event
  mod.item:subscribe("front_app_switched", function(env)
    if mod.state.show_menus then
      menus.update(false)
    end
  end)

  return mod
end

return mod
