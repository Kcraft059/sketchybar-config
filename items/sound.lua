local mod = {}

-- Setup
function mod.setup(items, icons, palette)
  mod.properties = {
    item = {
      position = "right",
      icon = {
        string        = icons.speaker.loud,
        color         = palette.text.subtle - 0xff000000 + 100 * 0x1000000,
        --padding_right = items.config.padding.outer,
        width         = 21 + items.config.padding.outer
      },
      label = { 
        width        = 0,--(21 + items.config.padding.outer),
        padding_left = -(19 + items.config.padding.outer),
        string       = icons.speaker.mid,
        color        = palette.colors.purple,
        font         = items.defaults.icon.font
      }
    },
    slider = {
      position      = "right",

      padding_left  = 0,
      padding_right = 0,
      icon          = { drawing = false },
      label         = { drawing = false },
      
      slider        = {
        width           = 0,
        highlight_color = palette.colors.blue,

        background      = {
          color         = palette.zone.border,
          height        = 5,
          corner_radius = 3
        },

        knob = {
          drawing = false,
          string  = "􀀁",
          color   = palette.text.primary,
          --font = { size = 14 },
        }
      }
    }
  }

  mod.state = {
    slider = false,
    anim_refc = 0,
  }

  return mod
end

local function toggleSlider(slider)
  return function (env)
    if env.INFO.button == "left" then
      mod.state.slider = toggle(mod.state.slider)

      sequencedAnimation(slider, "tanh", 25, nil, {
        slider = { width = mod.state.slider and 100 or 0 }
      }, nil, true)
      
    elseif env.INFO.button == "right" then
      sbar.exec(execs.menubar .. string.format(" -s \"%s\"",menu_items.sound))
    end
  end
end

local function update(items,item,slider,icons,palette)
  return function (env)
    -- Slider opening animation
    if not mod.state.slider and env.SENDER ~= "forced" then 
      if mod.state.anim_refc == 0 then
        sequencedAnimation(slider, "tanh", 50, nil, {
          slider = { width = 100 }
        }, nil, true)
      end

      mod.state.anim_refc = mod.state.anim_refc + 1

      sbar.delay(50.0/60 + 1, function () 
        mod.state.anim_refc = mod.state.anim_refc - 1

        if mod.state.anim_refc == 0 then
          sequencedAnimation(slider, "tanh", 50, nil, {
            slider = { width = 0 }
          }, nil, true)
        end
      end)
    end

    -- Slider color + item icon
    local volume = tonumber(env.INFO)

    local slider_properties = { slider = { percentage = volume } }
    local item_properties = { label = { string = "􀊡" }, icon = { string = volume ~= 0 and icons.speaker.loud or "" } }
    
    if volume == 0 then 
      item_properties.icon.width         = mod.properties.item.icon.width - 5
      item_properties.label.padding_left = mod.properties.item.label.padding_left + 5
    else
      item_properties.icon.width         = mod.properties.item.icon.width
      item_properties.label.padding_left = mod.properties.item.label.padding_left
    end

    if volume == 0 then 
      slider_properties.slider.highlight_color = palette.text.muted
      item_properties.label.string = icons.speaker.muted
    elseif volume < 25 then
      slider_properties.slider.highlight_color = palette.colors.blue
      item_properties.label.string = icons.speaker.quiet
    elseif volume < 50 then
      slider_properties.slider.highlight_color = palette.colors.cyan
      item_properties.label.string = icons.speaker.mid
    elseif volume < 75 then 
      slider_properties.slider.highlight_color = palette.colors.yellow
      item_properties.label.string = icons.speaker.normal
    else 
      slider_properties.slider.highlight_color = palette.colors.red
      item_properties.label.string = icons.speaker.loud
    end

    item:set(item_properties)
    sequencedAnimation(slider, "sin", 15, nil, slider_properties , nil, true)
  end
end

-- Load
function mod.load(items, zones, icons, palette)
  mod.slider = sbar.add("slider", 100, mod.properties.slider)
  mod.item   = sbar.add("item", mod.properties.item)
  
  mod.item:subscribe("volume_change",update(items,mod.item,mod.slider,icons,palette))
  mod.item:subscribe("mouse.clicked",toggleSlider(mod.slider))

  mod.slider:subscribe("mouse.clicked",function (env) 
    sbar.exec(string.format("osascript -e 'set volume output volume %s'",env.PERCENTAGE))
  end)
  mod.slider:subscribe({"mouse.entered","mouse.exited"},function (env)
    mod.slider:set({slider = { knob = { drawing = env.SENDER == "mouse.entered"}}})
  end)

  if not zones.brackets.dynamic_brackets[1] then zones.brackets.dynamic_brackets[1] = {} end

  table.insert(zones.brackets.dynamic_brackets[1], mod.item) 
  table.insert(zones.brackets.dynamic_brackets[1], mod.slider) 

  return mod
end

return mod