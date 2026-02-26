-- Helper functions
function mergeTables(t1, t2)
  for k,v in pairs(t2) do 
    t1[k] = v 
  end
  return t1
end

function toggle(bool)
  return not bool and true or false
end

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

local function macOSversion()
  local f = io.popen("sw_vers -productVersion")
  local result = f:read("*a")
  f:close()
  return tonumber(result:match("^(.-)\n?$"))
end

-- Global vars
os_version = macOSversion()