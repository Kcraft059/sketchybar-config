local mod = {}

-- Setup
function mod.setup(zones,icons,palette)
  mod.properties = mergeTables(zones.separator_properties,{
    position = "center",
    drawing  = "false",
    
    updates  = true,

    icon     = icons.zones.expended
  })

  mod.state = {
    refs = {},
    refc = 0
  }

  return mod
end

local function update(item)
  item:set({ drawing = mod.state.refc > 0 })
end

function mod.addRef(id)
  for _,v in pairs(mod.state.refs) do
    if v == id then return false end
  end

  table.insert(mod.state.refs, id)
  mod.state.refc = mod.state.refc + 1
  update(mod.item)
  return true
end 

function mod.dropRef(id)
  for k,v in pairs(mod.state.refs) do
    if v == id then 
      table.remove(mod.state.refs, k)
      mod.state.refc = mod.state.refc - 1
      update(mod.item)
      return true
    end
  end

  return false
end

-- Load 
function mod.load()
  mod.item = sbar.add("item",mod.properties)

  return mod
end

return mod