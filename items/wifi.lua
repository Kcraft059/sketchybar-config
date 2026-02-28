local mod = {}

-- Setup
function mod.setup(icons, palette)
  mod.properties = {
    position = "right",

    icon = {
      string = "􀙇"
    },

    label = {
      string = "FTN-0b28",
      max_chars = 10,
      scroll_duration = 80,
      --padding_right = 0,
    }
  }

  return mod
end

local function update(items,item,icons,palette)
  return function (env)
    sbar.exec([=[
      interface=$(scutil --nwi | egrep -om1 'en[0-9]')

      if [[ $interface ]]; then 
        wifi_active=true
        wifi_ip=$(scutil --nwi | grep address | sed 's/.*://' | tr -d ' ' | head -1)
        wifi_ssid=$(networksetup -listpreferredwirelessnetworks $interface | sed -n '2p' | xargs) # Working as of macOS 26.3
        sname=$(ipconfig getsummary $interface | grep sname | awk '{print $3}')
      else
        wifi_active=false
      fi

      #      Connected,Interface,Adress,SSID,Hotspot
      printf "%s\n%s\n%s\n%s\n%s" $wifi_active ${interface:--} ${wifi_ip:--} ${wifi_ssid:--} ${sname:--}
    ]=], function (result,exit_code)
      local wifi_infos = strSplit(result,"\n")
      
      local properties = { icon = {}, label = { } }
      wifi_infos[1] = wifi_infos[1] ~= "false"

      if wifi_infos[1] then -- Wifi avail
        if wifi_infos[5] == "-" then -- Sname
          properties.icon.string = icons.wifi.connected
          properties.icon.color  = palette.colors.blue
        else 
          properties.icon.string = icons.wifi.hotspot
          properties.icon.color  = palette.colors.cyan
        end

        if wifi_infos[4] == "-" then -- SSID
          properties.icon.padding_right = 0
          properties.label.drawing = false
        else 
          properties.icon.padding_right = items.config.padding.inner
          properties.label = { string  = wifi_infos[4],
                               drawing = true }
        end
        
        if wifi_infos[3] == "-" then -- Local IP
          properties.icon.string = icons.wifi.error
          properties.icon.color  = palette.colors.yellow
        end
      else
        properties.icon.color         = palette.colors.red
        properties.icon.string        = icons.wifi.disconnected
        properties.icon.padding_right = 0
        properties.label.drawing      = false
      end

      item:set(properties)
    end)
  end
end

-- Load
function mod.load(items, zones, icons, palette)
  mod.item = sbar.add("item", mod.properties)

  mod.item:subscribe("wifi_change",update(items, mod.item,icons,palette))
  mod.item:subscribe("mouse.clicked",function (env) 
    sbar.exec(execs.menubar .. " -s \"" .. menu_items.wifi .. "\"")
  end)
  mod.item:subscribe({"mouse.entered","mouse.exited"},function (env)
    mod.item:set({ scroll_texts = env.SENDER == "mouse.entered" })
  end)

  if not zones.brackets.right_brackets[2] then zones.brackets.right_brackets[2] = {} end
  table.insert(zones.brackets.right_brackets[2], mod.item.name) 

  return mod
end

return mod