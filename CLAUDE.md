# Minimized Dots

This repo is **not** a fork of [JaKooLit/Hyprland-Dots](https://github.com/LinuxBeginnings/Hyprland-Dots). It holds only the personal diff on top of a stock install, deployed by a single `apply.sh`. The whole point is near-zero upkeep: never vendor or copy upstream files wholesale, only track the override.

## Layout

One top-level folder per OS, mirroring the real config path 1:1:

- `hypr/` → copied to `~/.config/hypr/` (Linux, JaKooLit/Hyprland-Dots base)
- `aerospace/` → copied to `~/.config/aerospace/` (macOS, AeroSpace base)

Every file's path under `hypr/` or `aerospace/` is the exact relative path it lands at under `~/.config/<os>/`. Adding a new override = add the file at the same relative path; nothing else needs to know about it.

`og-hyprland-config/` (gitignored, local-only) is a full copy of the original vendor `~/.config` tree, kept purely as a lookup reference. Check it before adding a new override, to confirm the exact base file / keybind / path you're overriding still exists under that name upstream.

## Hyprland override mechanism

- **Keybinds**: never edit vendor `configs/Keybinds.conf`. `hypr/UserConfigs/UserKeybinds.conf` is sourced last by the base config — remove a base keybind with `unbind = MOD, KEY` there, add new ones with `bindd`.
- **Everything else** (gaps, animations, decorations, window/layer rules): the vendor config already sources `UserConfigs/User*.conf` after the defaults, and Hyprland does last-value-wins, so setting a value there overrides the default with no `unbind` needed.
- **Startup daemons** (`exec-once` in `Startup_Apps.conf`) have no override mechanism in Hyprland — there's no `unexec`. That one vendor file is the sole accepted exception if a daemon must be disabled.

## Extras menu pattern

Don't give every rarely-used feature its own dedicated hotkey. If something is a one-off (theme switchers, emoji picker, wallpaper effects, etc.), `unbind` its dedicated key in `UserKeybinds.conf` and add it as an entry in `hypr/UserScripts/ExtrasMenu.sh` instead — a single Rofi picker bound to one key (`Super+X`). Prefer extending that menu over adding a new standalone bind.

## apply.sh

Always clones the repo fresh from GitHub into a temp dir — deliberately no local-vs-remote detection, so `sh <(curl -fsSL <raw-url>)` and a locally-cloned `./apply.sh` behave identically (local edits only take effect after they're pushed). It detects OS via `uname -s` and copies the matching top-level folder into `~/.config`, backing up any existing target once as `<file>.bak`. Adding macOS support was just: create `aerospace/` following the same relative-path convention — no apply.sh changes were needed.

## General constraints

Keep it minimal. Don't reintroduce a hotkey for something that fits the extras menu. Don't touch a vendor file if a `User*` override achieves the same effect. If a change needs a new mechanism (not covered above), that's a signal to stop and confirm the approach rather than bolt something on.

## README upkeep

`README.md`'s keybind tables must reflect reality. After any change to a keybind (add, remove, rebind, move to/from the extras menu), update the matching table and the extras-menu list in the same pass — don't leave it to drift. If a change doesn't cleanly fit an existing section or convention documented here, stop and flag it rather than forcing it in.
