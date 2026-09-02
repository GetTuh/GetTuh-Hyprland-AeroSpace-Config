-- Lua port of UserConfigs/UserSettings.conf.
-- The exec-once = kwalletd6 line lives in hypr/UserConfigs/user_startup.lua
-- instead -- that's the vendor-designated Lua slot for startup commands
-- (loaded separately from user_settings.lua by lua/user_overrides.lua).

hl.config({
    input = {
        accel_profile = "flat", -- disable mouse acceleration
    },
})

hl.config({
    general = {
        layout = "scrolling", -- default to the scrolling layout (still swappable via Super+Alt+1-4)
    },
})

-- These unsets target gestures registered in system_settings.lua (3-finger
-- swipe-up cursor zoom, 3-finger horizontal workspace swipe). That file is
-- the real Lua port of configs/SystemSettings.conf's gestures block -- it
-- must load before this one for these unsets to find a match.
hl.gesture({ fingers = 3, direction = "up", action = "unset" }) -- disable three finger swipe-up zoom in
hl.gesture({ fingers = 3, direction = "horizontal", action = "unset" }) -- free up 3-finger horizontal (was workspace swipe)

-- switch workspaces with 4-finger swipe
hl.gesture({ fingers = 4, direction = "horizontal", action = "workspace" })
-- scroll through windows (scrolling layout) with 3-finger swipe
hl.gesture({ fingers = 3, direction = "horizontal", action = "scroll_move" })
