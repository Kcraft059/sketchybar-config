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
  if preserve == nil then preserve = true end
  if preserve then t1 = copyTable(t1) end
  for k,v in pairs(t2) do 
    if (type(t1[k]) == "table" and type(v) == "table") then 
      t1[k] = mergeTables(t1[k], v)
    else
      t1[k] = v
    end
  end
  return t1
end

function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

-- Os
function fetchConfig(cfg_path, default_cfg)
  local user_config = {} -- to keep it separate from the global env
  local config_file,err = loadfile(cfg_path, "t", user_config)

  if config_file then
     config_file() -- run the chunk

     default_cfg = mergeTables(default_cfg,user_config)
  else
     print("No user config loaded: " .. err)
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