-- Monitor layout. Loaded after hyprland/general.lua, whose catch-all
--   hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })
-- still handles anything not named below.
--
-- Matched on `desc:` (make + model + serial) rather than the connector name,
-- so a monitor keeps its settings when it moves between ports/docks -- which
-- matters here, see the AOC note.
--
-- Layout -- AOC anchored at the origin, laptop panel directly below it, Dell
-- rotated to portrait on the right:
--
--     x=0        2560   4000
--   y=0 +----------+------+
--       |   AOC    | Dell |   AOC  2560x1440 at 0,0
--       | 2560x1440|      |   Dell 1440x2560 at 2560,0 (rotated)
--    1440 +--+-----+ 1440 |
--          |eDP-1  |x2560 |   eDP-1 1920x1080 at 640,1440
--    2520  +-------+      |
--                  +------+ y=2560
--
-- eDP-1's x is 2560-1920=640, so its right edge lands exactly on the Dell's
-- left edge -- the cursor crosses straight from the laptop panel into the
-- bottom half of the vertical display with no dead gap.

-- Laptop panel. Pinned explicitly: leaving it on the catch-all's position="auto"
-- lets it get shoved to the far right when the Dell's rotation changes the
-- logical width of everything to its left.
hl.monitor({
    output = "eDP-1",
    mode = "preferred",
    position = "640x1440",
    scale = 1,
})

-- AOC Q27G41ZDF -- 1440p 240Hz OLED.
--
-- 240Hz only exists over DisplayPort. On HDMI the panel's EDID tops out at
-- 2560x1440@144, and Hyprland resolves an unavailable refresh rate to the
-- closest one it does have, so this line means "144 on HDMI, 240 the moment
-- it's on DP" -- no config change needed when the cable moves. Verify with
--   hyprctl monitors -j | jq -r '.[]|"\(.name) \(.refreshRate)"'
hl.monitor({
    output = "desc:AOC Q27G41ZDF RK2RAJA000990",
    mode = "2560x1440@240",
    position = "0x0",
    scale = 1,
})

-- Dell P2423DE -- rotated to portrait.
-- transform = 1 is a 90 degrees clockwise rotation of the image, which is what
-- compensates for this panel's physical pivot. (transform = 3 renders it
-- upside down on this stand.)
hl.monitor({
    output = "desc:Dell Inc. DELL P2423DE 5HB4614",
    mode = "2560x1440@60",
    position = "2560x0",
    scale = 1,
    transform = 1,
})

-- Flat pointer accel = no mouse acceleration. Vendor leaves accel_profile
-- unset, which means libinput's adaptive curve. hl.config merges by key, so
-- naming just this one leaf keeps vendor's other input/touchpad settings.
hl.config({
    input = {
        accel_profile = "flat",
    },
})
