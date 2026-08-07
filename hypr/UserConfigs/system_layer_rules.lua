-- ==================================================
--  KoolDots (2026)
--  Project URL: https://github.com/LinuxBeginnings
--  License: GNU GPLv3
--  SPDX-License-Identifier: GPL-3.0-or-later
-- ==================================================

-- Real Lua port of configs/LayerRules.conf, loaded via user_overrides.lua's
-- system_files legacy fallback. Content copied from vendor's lua/layer_rules.lua
-- template, which is never dofile'd by hyprland.lua on its own.

local function apply_layer_rule(rule)
  if hl.layer_rule then
    hl.layer_rule(rule)
  end
end

apply_layer_rule({
  name = "layerrule-001",
  match = {
    namespace = "rofi",
  },
  blur = true,
  ignore_alpha = 0,
  animation = "slide",
})

apply_layer_rule({
  name = "layerrule-002",
  match = {
    namespace = "notifications",
  },
  blur = true,
  ignore_alpha = 0,
  animation = "slide",
})

apply_layer_rule({
  name = "layerrule-003",
  match = {
    namespace = "quickshell:overview",
  },
  blur = true,
  ignore_alpha = 0.5,
})

apply_layer_rule({
  name = "layerrule-004",
  match = {
    namespace = "wallpaper",
  },
  blur = true,
  ignore_alpha = 0,
})

apply_layer_rule({
  name = "layerrule-005",
  match = {
    namespace = "swaync-control-center",
  },
  blur = true,
  ignore_alpha = 0,
})

apply_layer_rule({
  name = "layerrule-006",
  match = {
    namespace = "swaync-notification-window",
  },
  blur = true,
  ignore_alpha = 0,
})

apply_layer_rule({
  name = "layerrule-007",
  match = {
    namespace = "com.aurora.keybinds_help",
  },
  blur = true,
  ignore_alpha = 0,
})

apply_layer_rule({
  name = "layerrule-008",
  match = {
    namespace = "logout_dialog",
  },
  blur = true,
  ignore_alpha = 0,
})
