-- Personal keybind overrides on top of end-4/dots-hyprland (illogical-impulse).
--
-- Loaded by ~/.config/hypr/hyprland.lua AFTER hyprland/keybinds.lua, but
-- hl.bind is ADDITIVE here (vendor deliberately stacks two binds on one key
-- for its "quickshell if alive, else fallback" pattern) -- so replacing a
-- vendor bind means hl.unbind(key) first, then hl.bind.
--
-- Ported from the JaKooLit user_keybinds.lua this repo used to carry. Only the
-- personal preferences survived; everything that existed there purely to work
-- around JaKooLit's layout is gone because dot4 already binds it natively:
--   Super (tap) -> launcher      : vendor SUPER_L/SUPER_R search toggle
--   Super+V     -> clipboard     : vendor quickshell:overviewClipboardToggle
--   Extras menu (Super+X)        : dropped -- every entry was a JaKooLit
--                                  script. dot4 binds the survivors natively
--                                  (wallpaper Ctrl+Super+T, random wallpaper
--                                  Ctrl+Super+Alt+T, emoji Super+Period,
--                                  light/dark Ctrl+Super+Shift+D).
--   Super+Alt+B -> hide waybar   : no waybar in dot4; bar toggle is Super+J.

-- Vendor's own custom/keybinds.lua one-liner, kept.
hl.bind("CTRL + SUPER + ALT + Slash", hl.dsp.exec_cmd("xdg-open ~/.config/hypr/custom/keybinds.lua"),
    { description = "Edit user keybinds" })

--------------
--  Rebinds  --
--------------

-- Super+D = desktop overview (muscle memory from the JaKooLit config).
-- Vendor puts overview on Super+Tab and maximize on Super+D; maximize moves to
-- Super+Shift+D rather than being dropped.
hl.unbind("SUPER + D")
hl.bind("SUPER + D", hl.dsp.global("quickshell:overviewWorkspacesToggle"), { description = "Shell: Toggle overview" })
hl.bind("SUPER + SHIFT + D", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }),
    { description = "Window: Maximize" })

-- Super+/ = toggle split (dwindle). Vendor's cheatsheet moves to Super+H --
-- free in dot4, and where the old JaKooLit config kept its key hints.
hl.unbind("SUPER + Slash")
hl.bind("SUPER + Slash", hl.dsp.layout("togglesplit"), { description = "Layout: Toggle split (dwindle)" })
hl.bind("SUPER + H", hl.dsp.global("quickshell:cheatsheetToggle"),
    { description = "Shell: Toggle cheatsheet (keybind list)" })

-- Super+L = sleep the monitors only (screen off, system stays up).
-- Locking moves to Ctrl+Alt+L, same as the old JaKooLit layout.
-- Super+Shift+L (suspend) is vendor and left alone.
hl.unbind("SUPER + L")
hl.bind("SUPER + L", hl.dsp.dpms("off"), { description = "Session: Sleep monitors" })
hl.bind("CTRL + ALT + L", hl.dsp.exec_cmd("loginctl lock-session"), { description = "Session: Lock" })

------------------
--  Additions   --
------------------

-- Move the active workspace to the monitor in a direction. No vendor
-- equivalent, and no Lua dispatcher takes a direction here (hl.dsp.workspace.move
-- wants a concrete monitor name), so shell out to the dispatcher directly.
for _, m in ipairs({
    { key = "F9",  dir = "l", desc = "left" },
    { key = "F10", dir = "r", desc = "right" },
    { key = "F11", dir = "u", desc = "up" },
    { key = "F12", dir = "d", desc = "down" },
}) do
    hl.bind("CTRL + SUPER + " .. m.key,
        hl.dsp.exec_cmd("hyprctl dispatch movecurrentworkspacetomonitor " .. m.dir),
        { description = "Workspace: Move to " .. m.desc .. " monitor" })
end

-- Print = region snip. Vendor put the snip on Super+Shift+S and a whole-screen
-- grab on Print; swap them round. The whole-screen grab isn't lost, it moves to
-- Shift+Print. Ctrl+Print (whole screen -> file *and* clipboard) is vendor and
-- left alone.
--
-- Each of these keeps vendor's two-bind shape: the quickshell global first, then
-- an exec_cmd that no-ops while the shell is alive and takes over when it isn't.
local qsIsAlive = "qs -c $qsConfig ipc call TEST_ALIVE"
local grimhyprctl = "grim -o \"$(hyprctl activeworkspace -j | jq -r '.monitor')\""

hl.unbind("SUPER + SHIFT + S")
hl.unbind("Print")
hl.bind("Print", hl.dsp.global("quickshell:regionScreenshot"), { description = "Utilities: Screen snip" })
hl.bind("Print",
    hl.dsp.exec_cmd(qsIsAlive .. " || pidof slurp || hyprshot --freeze --clipboard-only --mode region --silent"))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd(grimhyprctl .. " - | wl-copy"),
    { locked = true, description = "Utilities: Screenshot >> clipboard" })

-- Super+B = browser. Vendor binds B to the left sidebar, but that's the third
-- key for it (Super+A and Super+O both still do it), so nothing is lost.
-- Super+W stays bound to the browser too.
hl.unbind("SUPER + B")
hl.bind("SUPER + B", hl.dsp.exec_cmd(browser), { description = "App: Browser" })

-- Alt+Tab cycles windows on the current workspace, and keeps working when they
-- are fullscreen. Plain cyclenext moves focus but leaves the window that was
-- fullscreen covering the screen, so re-apply the same fullscreen mode to
-- whatever we landed on. Both windows stay fullscreen, which is what makes
-- tabbing back and forth between them behave.
--   window.fullscreen (the property) is 0 none / 1 maximized / 2 fullscreen;
--   the dispatcher's action is toggle/set/unset, not on/off.
hl.bind("ALT + Tab", function()
    local active = hl.get_active_window()
    local mode = (active and active.fullscreen) or 0
    hl.dispatch(hl.dsp.window.cycle_next())
    hl.dispatch(hl.dsp.window.bring_to_top())
    if mode > 0 then
        hl.dispatch(hl.dsp.window.fullscreen({
            mode = (mode == 2) and "fullscreen" or "maximized",
            action = "set",
        }))
    end
end, { description = "Window: Cycle windows" })
