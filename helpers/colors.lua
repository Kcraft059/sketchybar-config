-- color.lua
local mod = {}  -- module table

-- Helpers
local tpf_mask = 0x1000000

local function colorTp(base_color, tpf)
  if tpf < 0 then
    tpf = 0
  elseif tpf > 255 then
    tpf = 255
  end 

  return base_color + tpf * tpf_mask
end

local function resolvePalette(p,tpf)
  local t = {}

  for k,v in pairs(p) do
    if type(v) == "table" then
      t[k] = resolvePalette(v,tpf)
    elseif type(v) == "function" then
      t[k] = v(tpf)
    else
      t[k] = v
    end
  end

  return t
end

-- Palette
local palettes = {
  ["rose-pine"] = {
    bar = {
      background = function (tpf) return colorTp(0x232137, tpf) end,
      border     = function (tpf) return colorTp(0x808080, tpf - 20) end
    },
    text = {
      primary   = 0xffe0def4,
      subtle    = 0xff908caa,
      muted     = 0xff6e6a86
    },
    zone = {
      background = function (tpf) return colorTp(0x393552, tpf - 50) end,
      border     = function (tpf) return colorTp(0x44415a, tpf - 20) end,
      overlay    = 0xff56526e
    },
    colors = {
      red        = 0xffeb6f92,
      orange     = 0xffea9a97,
      yellow     = 0xfff6c177,
      blue       = 0xff3e8fb0,
      cyan       = 0xff9ccfd8,
      purple     = 0xffc4a7e7
    }
  }
}

-- Public API
function mod.getColorPalette(name,base_tpf)
  local palette = palettes[name]

  if not palette then
    error("Unknown palette: " .. tostring(name))
  end

  return resolvePalette(palette,base_tpf)
end

return mod