-- ==================================================
--  KoolDots (2026)
--  Project URL: https://github.com/LinuxBeginnings
--  License: GNU GPLv3
--  SPDX-License-Identifier: GPL-3.0-or-later
-- ==================================================

-- Real Lua port of configs/Laptops.conf, loaded via user_overrides.lua's
-- system_files legacy fallback. Vendor's lua/laptops.lua template is empty
-- ("no active laptop rules currently enabled") but Laptops.conf is sourced
-- unconditionally by hyprland.conf and does have active binds (brightness
-- keys, F6 screenshot binds, touchpad device) -- this machine has both
-- external monitors and an eDP-1 laptop panel, so these matter here.

local scriptsDir = "$HOME/.config/hypr/scripts"

local function chord(mods, key)
  if mods == nil or mods == "" then
    return key
  end
  return mods:gsub("%s+", " + ") .. " + " .. key
end

local function bind(mods, key, cmd, opts)
  local dsp = hl.dsp or hl
  local action
  if dsp and dsp.exec_cmd then
    action = dsp.exec_cmd(cmd)
  else
    action = function()
      hl.exec_cmd(cmd)
    end
  end
  if opts then
    hl.bind(chord(mods, key), action, opts)
  else
    hl.bind(chord(mods, key), action)
  end
end

-- binde = , xf86KbdBrightnessDown/Up, exec, ...
bind("", "XF86KbdBrightnessDown", scriptsDir .. "/BrightnessKbd.sh --dec", { description = "decrease keyboard brightness", ["repeat"] = true })
bind("", "XF86KbdBrightnessUp", scriptsDir .. "/BrightnessKbd.sh --inc", { description = "increase keyboard brightness", ["repeat"] = true })

-- ASUS-specific hardware buttons
bind("", "XF86Launch1", "rog-control-center", { description = "ASUS Armory crate button" })
bind("", "XF86Launch3", "asusctl led-mode -n", { description = "FN+F4 switch keyboard RGB profile" })
bind("", "XF86Launch4", "asusctl profile -n", { description = "FN+F5 change fan profile" })

-- binde = , xf86MonBrightnessDown/Up, exec, ...
bind("", "XF86MonBrightnessDown", scriptsDir .. "/Brightness.sh --dec", { description = "decrease monitor brightness", ["repeat"] = true })
bind("", "XF86MonBrightnessUp", scriptsDir .. "/Brightness.sh --inc", { description = "increase monitor brightness", ["repeat"] = true })

bind("", "XF86TouchpadToggle", scriptsDir .. "/TouchPad.sh", { description = "disable touchpad" })

-- Screenshot keybindings using F6 (no PrintScrn button)
bind("SUPER", "F6", scriptsDir .. "/ScreenShot.sh --now", { description = "screenshot" })
bind("SUPER SHIFT", "F6", scriptsDir .. "/ScreenShot.sh --area", { description = "screenshot (area)" })
bind("SUPER CTRL", "F6", scriptsDir .. "/ScreenShot.sh --in5", { description = "screenshot (5 secs delay)" })
bind("SUPER ALT", "F6", scriptsDir .. "/ScreenShot.sh --in10", { description = "screenshot (10 secs delay)" })
bind("ALT", "F6", scriptsDir .. "/ScreenShot.sh --active", { description = "screenshot (active window only)" })

if hl.device then
  hl.device({
    name = "asue1209:00-04f3:319f-touchpad",
    enabled = true,
  })
end
