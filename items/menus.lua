local mod = {}

-- Setup
function mod.setup(icons, palette)
  mod.items = {}
  mod.properties = {
    base = {
      position      = "left",
      padding_left  = 8,
      padding_right = 11,

      drawing = false,
      label   = { drawing = false },
      
      icon = {
        string          = "Menu",
        font            = {
          style = "Regular",
          size  = 14.0
        },
        width           = 0,
        color           = palette.text.primary,
        padding_right   = 0,
        padding_left    = 0,

      },

      background = { drawing = false }
    },
    title = {
      icon = {
        string          = "App",
        font            = { style = "Heavy" },
        color           = palette.colors.cyan,
      }
    }
  }
  mod.menu_count = 15
  return mod
end

function mod.load(zones)
  -- Items
  local i
  for i = 1, mod.menu_count do
    -- Add item
    local item = sbar.add("item",
      mergeTables(i == 1 and mergeTables(mod.properties.base, mod.properties.title) or mod.properties.base, {
        label = { string = i }
      }))

    -- Click event
    item:subscribe("mouse.clicked", function(env)
      sbar.exec(string.format(execs.menubar .. " -s %d", mod.items[i]:query().label.value))
    end)

    -- Mouse hover event 
    item:subscribe("mouse.entered", function(env)
      sbar.exec(execs.ft_haptic)
    end)

    -- Store
    mod.items[i] = item
    zones.brackets.menus[i] = item
  end

  return mod
end

-- Methods
function mod.show(bool)
  if bool then -- Update menus when showing 
    mod.update(true)

  else -- Set all to false otherwise
    perfbc() -- PERF: bundle instructions
    for _, item in pairs(mod.items) do
      sequencedAnimation(item, "linear", 15, nil, {
        icon = { width = 0 },
      }, {
        drawing = false,
        icon    = { string = "" }
      }, true)

    end
    perfec()
  end
end

function mod.update(anim)
  sbar.exec(execs.menubar .. " -l", function(result, exit_code)
    perfbc() -- PERF: bundle instructions

    -- Display all menus
    local i = 1
    for menu_str in string.gmatch(result, "([^\n]+)") do
      if i > mod.menu_count then
        return
      end

      sequencedAnimation(mod.items[i], "linear", 15, { -- Set icon as menu name
        drawing = true,
        icon    = { string = menu_str },
      },{
        icon = { width = "dynamic" },
      }, nil, anim)

      i = i + 1
    end

    -- Hide others
    local j
    for j = i, mod.menu_count do
      mod.items[j]:set({
        icon = {
          string = "",
        },
        drawing = false
      })
    end

    perfec()
  end)
end

return mod
