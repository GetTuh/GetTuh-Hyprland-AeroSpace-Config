# Minimized Dots

This repo is **not** a fork of [JaKooLit/Hyprland-Dots](https://github.com/LinuxBeginnings/Hyprland-Dots). It holds only the personal diff on top of a stock install, deployed by a single `apply.sh`. The whole point is near-zero upkeep: never vendor or copy upstream files wholesale, only track the override.

## Layout

One top-level folder per OS, mirroring the real config path 1:1:

- `hypr/` → copied to `~/.config/hypr/` (Linux, JaKooLit/Hyprland-Dots base)
- `aerospace/` → copied to `~/.config/aerospace/` (macOS, AeroSpace base)

Every file's path under `hypr/` or `aerospace/` is the exact relative path it lands at under `~/.config/<os>/`. Adding a new override = add the file at the same relative path; nothing else needs to know about it.

`og-hyprland-config/` (gitignored, local-only) is a full copy of the original vendor `~/.config` tree, kept purely as a lookup reference. Check it before adding a new override, to confirm the exact base file / keybind / path you're overriding still exists under that name upstream.

## Hyprland override mechanism (Lua-only)

This repo dropped the `hyprlang` `.conf` override tree entirely (2026-08) in favor of `hyprland.lua`, since hyprlang is being phased out upstream. `~/.config/hypr/hyprland.conf` may still exist as a vendor file (harmless, untouched, never sourced) — whichever of `hyprland.conf` / `hyprland.lua` is present is what Hyprland loads (`hyprctl systeminfo` shows `configProvider`), and provider selection only re-evaluates on an actual Hyprland restart, not `hyprctl reload`.

- **Keybinds**: never edit vendor `configs/system_keybinds.lua`. `hypr/UserConfigs/user_keybinds.lua` is loaded last — remove a base keybind with `unbind(mods, key)`, add new ones with `bind(mods, key, fn, opts)`.
- **Everything else** (gaps, animations, decorations, window/layer rules, gestures): `~/.config/hypr/lua/user_overrides.lua` loads `UserConfigs/user_*.lua` after the system defaults, and `hl.config()` does last-value-wins, so setting a value there overrides the default with no unbind needed. Use `hl.gesture({..., action = "unset"})` to remove a specific gesture (must match fingers/direction/mods/scale exactly).
- **Startup daemons** (`exec-once` equivalents) have no override/`unexec` mechanism — same as the old `.conf` world.

### The `system_*.lua` gap this repo fills

Vendor's Lua migration is incomplete as of Hyprland 0.56: `user_overrides.lua` looks for defaults at `configs/system_{env,startup,window_rules,layer_rules,keybinds,settings,laptops}.lua`, falling back to the **same filename under `UserConfigs/`** if the `configs/` one doesn't exist. Only `configs/system_keybinds.lua` ships upstream — the rest (`lua/settings.lua`, `lua/window_rules.lua`, `lua/layer_rules.lua`, `lua/startup.lua`, `lua/env.lua`, `lua/laptops.lua`, `lua/decorations.lua`, `lua/animations.lua`) are vendor "template" files explicitly marked as never `dofile`'d by `hyprland.lua`. Without a `UserConfigs/system_*.lua` fallback for each, gaps/rounding/blur/animations/window rules/layer rules/**startup apps** (waybar, hypridle, swaync, clipboard, etc.) silently fall back to Hyprland's bare engine defaults — not a cosmetic gap, a broken session.

This repo supplies `hypr/UserConfigs/system_env.lua`, `system_startup.lua`, `system_window_rules.lua`, `system_layer_rules.lua`, `system_settings.lua`, and `system_laptops.lua` as the real ports (most started from the vendor template content, verified/completed against the original `.conf` — e.g. `system_settings.lua` fills in gesture actions the template left commented as "pending Lua API parity", `system_laptops.lua` ports Laptops.conf's actual binds since the vendor template is an empty stub). **When vendor ships a real `configs/system_*.lua`, the primary path wins automatically and the matching `UserConfigs/system_*.lua` here becomes dead weight — delete it, don't leave it shadowing nothing.** Conversely, if a new `lua/*.lua` template gap turns up (like `user_animations.lua` was, previously an empty example despite `UserAnimations.conf` holding a real personal preset), port it the same way rather than leaving it silently blank.

One known gap: `UserDecorations.conf`'s color values used to come from `wallust/wallust-hyprland.conf` on every wallpaper change; there's no Lua equivalent for sourcing a generated hyprlang variable file yet, so `user_decorations.lua` hardcodes a color snapshot instead and will go stale on the next wallpaper change until vendor Lua/wallust parity lands.

## Extras menu pattern

Don't give every rarely-used feature its own dedicated hotkey. If something is a one-off (theme switchers, emoji picker, wallpaper effects, etc.), `unbind` its dedicated key in `user_keybinds.lua` and add it as an entry in `hypr/UserScripts/ExtrasMenu.sh` instead — a single Rofi picker bound to one key (`Super+X`). Prefer extending that menu over adding a new standalone bind.

## apply.sh

Always clones the repo fresh from GitHub into a temp dir — deliberately no local-vs-remote detection, so `sh <(curl -fsSL <raw-url>)` and a locally-cloned `./apply.sh` behave identically (local edits only take effect after they're pushed). It detects OS via `uname -s` and copies the matching top-level folder into `~/.config`, backing up any existing target once as `<file>.bak`. Adding macOS support was just: create `aerospace/` following the same relative-path convention — no apply.sh changes were needed.

## General constraints

Keep it minimal. Don't reintroduce a hotkey for something that fits the extras menu. Don't touch a vendor file if a `User*` override achieves the same effect. If a change needs a new mechanism (not covered above), that's a signal to stop and confirm the approach rather than bolt something on.

## README upkeep

`README.md`'s keybind tables must reflect reality. After any change to a keybind (add, remove, rebind, move to/from the extras menu), update the matching table and the extras-menu list in the same pass — don't leave it to drift. If a change doesn't cleanly fit an existing section or convention documented here, stop and flag it rather than forcing it in.

At the start of any session touching keybinds or README, also cross-check against the `Super+H` helper (vendor `scripts/KeyHints.sh`, hardcoded `yad` list — not generated from config, so it drifts independently of both the real binds and the README). Diff its entries against the actual keybinds (`configs/system_keybinds.lua` + `UserConfigs/user_keybinds.lua`) and flag anything it lists that's stale (unbound, moved to the extras menu) or missing from README. README stays authoritative and gets fixed to match the real config; KeyHints.sh is vendor and only gets a mention/flag, not an edit, unless the user asks for that exception.
