-- Lua port of UserConfigs/UserDecorations.conf.
-- NOTE: the .conf version sources wallust/wallust-hyprland.conf so border/shadow
-- colors update live on every wallpaper change (WallustConfig.sh/WallustSwww.sh
-- rewrite that file). Vendor's own lua/decorations.lua template notes Lua parity
-- for importing a sourced hyprlang file is "still evolving" -- there is no
-- require()-equivalent for a live-generated variable file yet. These are a
-- snapshot of wallust/wallust-hyprland.conf's current $color12/$color10/$color15/
-- $color0 values as static fallbacks; they will go stale on the next wallpaper
-- change until vendor lands real Lua wallust integration.

hl.config({
    general = {
        border_size = 1,
        gaps_in = 0,
        gaps_out = 0,
        col = {
            active_border = "rgb(5B768B)", -- $color12
            inactive_border = "rgb(28313A)", -- $color10
        },
    },
})

hl.config({
    decoration = {
        rounding = 10,
        active_opacity = 1.0,
        inactive_opacity = 1.0,
        fullscreen_opacity = 1.0,
        dim_inactive = true,
        dim_strength = 0.1,
        dim_special = 0.8,
        shadow = {
            enabled = true,
            range = 1,
            render_power = 1,
            color = "rgb(5B768B)", -- $color12
            color_inactive = "rgb(28313A)", -- $color10
        },
        blur = {
            enabled = true,
            size = 6,
            passes = 3,
            new_optimizations = true,
            xray = true,
            ignore_opacity = true,
            special = true,
            popups = true,
        },
    },
})

hl.config({
    group = {
        col = {
            border_active = "rgb(D2DDE6)", -- $color15
        },
        groupbar = {
            col = {
                active = "rgb(434548)", -- $color0
            },
        },
    },
})
