local mod = {}

-- Setup 
function mod.setup(icons,palette)
  mod.properties = {
    position    = "right",
    update_freq = 1800,

    icon = {
      string = icons.pkg,
      color  = palette.colors.orange
    },

    label = {
      string = "1234",
      y_offset = 0
    }
  }

  return mod
end

local function update(item)
  return function (env)
    sbar.exec([=[
    list_nix_packages() {
      for x in $(nix-store --query --requisites "$1" 2>/dev/null); do
        if [ -d "$x" ]; then
          echo "$x"
        fi
      done | cut -d- -f2- |
        grep -E '([0-9]+\.)+[0-9]+' |
        grep -Ev '(-doc$|-man$|-info$|-dev$|-bin$|^nixos-system-nixos-)' |
        uniq |
        wc -l
    }
        
    ### Sum of all packages
        
    packages_total=$(($(list_nix_packages "/nix/var/nix/profiles/default") + \
    $(list_nix_packages "/run/current-system") + \
    $(list_nix_packages "$HOME/.nix-profile") + \
    $(ls /opt/homebrew/Caskroom 2>/dev/null | wc -l) + \
    $(ls /opt/homebrew/Cellar 2>/dev/null | wc -l) + \
    $(ls $HOME/local/Caskroom 2>/dev/null | wc -l) + \
    $(ls $HOME/local/Cellar 2>/dev/null | wc -l))) # Nix default + Nix system + Nix user

    printf "%s" $packages_total
    ]=], function (result)
      item:set({ label = { string = result }})
    end)
  end
end
-- Load
function mod.load()
  mod.item = sbar.add("item",mod.properties)

  mod.item:subscribe({"routine","forced"},update(mod.item))

  return mod
end

return mod