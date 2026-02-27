-- Helper functions
function toggle(bool)
  return not bool and true or false
end

function copyTable(t)
  local new = {}
  for k, v in pairs(t) do
    new[k] = v
  end
  return new
end

function mergeTables(t1, t2, preserve)
  if preserve == nil then
    preserve = true
  end
  if preserve then
    t1 = copyTable(t1)
  end
  for k, v in pairs(t2) do
    if (type(t1[k]) == "table" and type(v) == "table") then
      t1[k] = mergeTables(t1[k], v)
    else
      t1[k] = v
    end
  end
  return t1
end

function strSplit(inputstr, sep)
   -- if sep is null, set it as space
   if sep == nil then
      sep = '%s'
   end
   -- define an array
   local t={}
   -- split string based on sep   
   for str in string.gmatch(inputstr, '([^'..sep..']+)') 
   do
      -- insert the substring in table
      table.insert(t, str)
   end
   -- return the array
   return t
end

-- Debug
function log(sender,message)
  print("[" .. sender .. "] " .. message)
end

function dump(o)
  if type(o) == 'table' then
    local s = '{ '
    for k, v in pairs(o) do
      if type(k) ~= 'number' then
        k = '"' .. k .. '"'
      end
      s = s .. '[' .. k .. '] = ' .. dump(v) .. ','
    end
    return s .. '} '
  else
    return tostring(o)
  end
end

-- Os
function fetchConfig(cfg_path, default_cfg)
  local user_config = {} -- to keep it separate from the global env
  local config_file, err = loadfile(cfg_path, "t", user_config)

  if config_file then
    config_file() -- run the chunk

    default_cfg = mergeTables(default_cfg, user_config)
  else
    log("lua-main","No user config loaded: " .. err)
  end

  return default_cfg
end

function shellEval(cmd)
  local f = io.popen(cmd)
  local result = f:read("*a")
  f:close()
  return result:match("^(.-)%s*$")
end

function macOSversion()
  return tonumber(shellEval("sw_vers -productVersion"))
end

function cmdPath(cmd)
  return shellEval("command -v " .. cmd .. " 2>/dev/null")
end

-- Sketchybar
function sequencedAnimation(item, curve, duration, anim_before, anim, anim_after, animate)
  if animate and config.animate then
    if anim_before then
      item:set(anim_before)
    end
    if anim then
      sbar.animate(curve, duration, function()
        item:set(anim)
      end)
    end
    if anim_after then
      sbar.exec("sleep " .. (0.0 + duration) / 60, function(result, exit_code)
        item:set(anim_after)
      end)
    end

  else
    local properties = anim_before or anim or anim_after

    if anim then
      mergeTables(properties, anim, false)
    end
    if anim_after then
      mergeTables(properties, anim_after, false)
    end

    item:set(properties)
  end
end
