local mod = {}

-- Setup
function mod.setup(zones,icons,palette)
  mod.properties = mergeTables(zones.separator_properties,{
    position = "center",
    drawing  = "false",
    
    updates  = true, -- Instead of "always"

    icon     = icons.zones.expended
  })

  mod.event_name = "center_separator_udpate"

  mod.state = {
    refs = {},
    refc = 0
  }

  return mod
end

local function update(item)
  return function (env)
    item:set({ drawing = mod.state.refc > 0 })
  end
end

function mod.addRef(id)
  for _,v in pairs(mod.state.refs) do
    if v == id then return false end
  end

  table.insert(mod.state.refs, id)
  mod.state.refc = mod.state.refc + 1
  return true
end 

function mod.dropRef(id)
  for k,v in pairs(mod.state.refs) do
    if v == id then 
      table.remove(mod.state.refs, k)
      mod.state.refc = mod.state.refc - 1
      return true
    end
  end

  return false
end

-- Load 
function mod.load()
  mod.item = sbar.add("item",mod.properties)
  
  sbar.add("event",mod.event_name)
  mod.item:subscribe(mod.event_name, update(mod.item))

  return mod
end

return mod