mod = {}

-- Setup
function mod.setup(palette)
  mod.config = { -- global config, can be accessed by items
    radius = 15,
    margin = 5,
    height = 34,
    padding = 12
  }

  if os_version < 26.0 then -- for macos versions previous to Tahoe
    mod.config.radius = 13
  end

  if config.bar_look == "compact" then
    mod.config.radius = 0
    mod.config.margin = 0
    mod.config.height = 27
  end

  -- Defaults
  mod.properties = {
    height=mod.config.height,
  	y_offset=mod.config.margin,
  	margin=mod.config.margin,
  	position="top",

  	topmost="everything",
  	sticky=true,

  	padding_left=0,
  	padding_right=mod.config.padding,

  	notch_width=config.notch_width,
  	border_width=1,
  	corner_radius=15,
  
  	border_color=palette.bar.border,
    color=palette.bar.background,
  	blur_radius=14
  }

  return mod
end


function mod.load() 
  sbar.bar(mod.properties)
end

return mod