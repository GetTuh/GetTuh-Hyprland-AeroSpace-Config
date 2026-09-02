-- Lua port of workspaces.conf. Loaded directly by hyprland.lua's
-- load_module("workspaces") -- no default/user split for this file, same as
-- the .conf world where workspaces.conf is sourced directly and replaced
-- wholesale rather than layered through UserConfigs.
--
-- NOTE: This will be overwritten by NWG-Displays once you use and click apply.

-- 3 workspaces per monitor:
-- DP-1     = AOC Q27G41ZDF, 1440p 240Hz OLED (primary)
-- HDMI-A-1 = Dell P2423DE, 1440p 60Hz, rotated vertical
-- eDP-1    = laptop panel, when docked/undocked (no-op if not present)
hl.workspace_rule({ workspace = "1", monitor = "DP-1", default = true })
hl.workspace_rule({ workspace = "2", monitor = "DP-1" })
hl.workspace_rule({ workspace = "3", monitor = "DP-1" })
hl.workspace_rule({ workspace = "4", monitor = "HDMI-A-1", default = true })
hl.workspace_rule({ workspace = "5", monitor = "HDMI-A-1" })
hl.workspace_rule({ workspace = "6", monitor = "HDMI-A-1" })
hl.workspace_rule({ workspace = "7", monitor = "eDP-1", default = true })
hl.workspace_rule({ workspace = "8", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "9", monitor = "eDP-1" })
