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

-- disable three finger swipe-up zoom in
hl.gesture({ fingers = 3, direction = "up", action = "unset" })
-- free up 3-finger horizontal (was workspace swipe)
hl.gesture({ fingers = 3, direction = "horizontal", action = "unset" })
-- switch workspaces with 4-finger swipe
hl.gesture({ fingers = 4, direction = "horizontal", action = "workspace" })
-- scroll through windows (scrolling layout) with 3-finger swipe
hl.gesture({ fingers = 3, direction = "horizontal", action = "scroll_move" })
