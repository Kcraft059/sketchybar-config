local mod = { }

-- Setup
function mod.setup(palette)
  mod.properties = {
    position    = "right",
    update_freq = 60,

    icon = {
      --string        = "+%a %d. %b",
      color         = palette.text.primary,
      font          = { style = "Black", size = 12.0 },
      padding_right = 5,
    },
    
    label = {
      --string = "+%H:%M",
      font          = { style = "Semibold", size = 13.0 },
      width  = 50,
      align  = "center"
    }
  }
  return mod
end

local function parseDate(item, string)
  local date = strSplit(string,"|")
  item:set({
    icon  = { string = date[1] },
    label = { string = date[2] }
  })
end 

-- Load 
function mod.load()
  mod.item = sbar.add("item",mod.properties)
  mod.item:subscribe({"routine","forced"}, function(env) 
    if env.SENDER == "forced" then 
      sbar.exec("printf \"$(date '+%a %d. %b')|$(date '+%H:%M')\"", function (result,exit_code)
        parseDate(mod.item,result)
      end) 
    end

    sbar.exec([=[
      sleep $((59 - $(date '+%-S')))
      while [[ $(date '+%S') != "00" ]]; do
		    sleep 0.1
	    done
      printf "$(date '+%a %d. %b')|$(date '+%H:%M')"
    ]=],function (result,exit_code) 
      parseDate(mod.item,result)
    end)
  end)

  return mod
end

return mod