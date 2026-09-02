# Minimized Dots

This repo is **not** a fork of any upstream dots. It holds only the personal diff on
top of a stock install, deployed by a single `apply.sh`. The whole point is near-zero
upkeep: never vendor or copy upstream files wholesale, only track the override.

## Layout

- `hypr/<base>/` → copied to `~/.config/hypr/` (Linux), one subfolder per vendor base:
  - `hypr/dot4/` — [end-4/dots-hyprland](https://github.com/end-4/dots-hyprland)
    (illogical-impulse). **Active base.**
  - `hypr/jakoolit/` — [JaKooLit/Hyprland-Dots](https://github.com/JaKooLit/Hyprland-Dots).
    Kept for reference after the 2026-09 switch to dot4; not maintained. Don't add to
    it, and don't copy its patterns into `dot4/` — the two bases share nothing
    structurally.
- `aerospace/` → copied to `~/.config/aerospace/` (macOS, AeroSpace base)

Every file's path under a base folder is the exact relative path it lands at under
`~/.config/<os>/`. Adding a new override = add the file at the same relative path;
nothing else needs to know about it.

`og-hyprland-config/` (gitignored, local-only) is a full copy of the original vendor
`~/.config` tree, kept purely as a lookup reference. Check it — or the live
`~/.config/hypr/hyprland/` tree, which is vendor and untouched — before adding a new
override, to confirm the exact base file / keybind / path you're overriding still
exists under that name upstream.

## dot4 override mechanism

`~/.config/hypr/hyprland.lua` is the entrypoint. It `require`s the vendor
`hyprland/*.lua` defaults first, then each `custom/*.lua` **if the file exists**:
`custom/env.lua`, `custom/execs.lua`, `custom/general.lua`, `custom/rules.lua`,
`custom/keybinds.lua` (plus `custom/variables.lua`, pulled in by
`hyprland/keybinds.lua`). Those six files are the entire override surface — vendor
creates them as empty stubs and never overwrites them on update. **Never edit
anything under `~/.config/hypr/hyprland/`.**

The two override styles are not the same, and this is the thing to get right:

- **`hl.config` / `hl.monitor` / `hl.gesture` are last-value-wins.** Set the value in
  the matching `custom/` file and it overrides the default. No removal step.
- **`hl.bind` is ADDITIVE.** Binding a key that's already bound leaves *both* binds
  live and *both* fire — vendor relies on this deliberately for its "quickshell if
  alive, else fallback" pattern (see `SUPER + V` bound twice in
  `hyprland/keybinds.lua`). To *replace* a vendor bind you must
  `hl.unbind("SUPER + D")` first, then `hl.bind`. `hl.unbind` takes the same
  `"MOD + MOD + Key"` string form as `hl.bind` and clears every bind on that combo.

When a rebind displaces a vendor feature, rebind that feature somewhere free rather
than dropping it, and record both halves in the README table.

Useful when working on this:

- `/usr/share/hypr/stubs/hl.meta.lua` is the **complete, authoritative `hl` API**
  (LuaLS annotations: every dispatcher, every config key, every spec table). Grep it
  before guessing at a field name.
- `hyprctl eval '<lua>'` applies a snippet live — the right way to test a monitor or
  bind change before writing it to a file. **`hyprctl keyword` does not work** under
  the Lua config provider ("keyword can't work with non-legacy parsers"); `hyprctl
  reload` does.
- `hyprctl binds -j` to verify a bind landed (and that the old one is gone);
  `hyprctl monitors -j` / `hyprctl monitors all -j` (includes `availableModes`) for
  displays.
- There is no raw string dispatch — `hl.dispatch` only takes an `hl.dsp.*` object. For
  a dispatcher the Lua API doesn't expose with the argument shape you need (e.g.
  `movecurrentworkspacetomonitor` with a direction), shell out:
  `hl.dsp.exec_cmd("hyprctl dispatch ...")`.

### Quickshell (the bar/launcher/sidebars)

Separate config tree at `~/.config/quickshell/ii/`, driven by
`~/.config/illogical-impulse/config.json`. That JSON is the supported user surface —
check it first for anything shell-shaped. Two things it does *not* cover, and there is
no other override hook for them:

- QML behaviour (what a result row renders, how a widget works).
- User action scripts in `~/.config/illogical-impulse/actions/` look like an extension
  point but are `Quickshell.execDetached` — fire-and-forget, no output back to the UI.
  They cannot add or change a launcher result.

So changing shell behaviour means editing vendor QML, which updates overwrite. The one
place this repo does it (the launcher's math command) is handled as an **idempotent
`sed` in `apply.sh`**, not a vendored file copy: it greps for the already-patched
marker, bails with a warning if the upstream line no longer matches, and keeps a
`.bak`. Follow that shape if a second patch ever becomes necessary — and prefer not
needing one. Restart the shell to test: `killall qs quickshell; qs -c ii &`
(detached), or the vendor bind `Ctrl+Super+R`.

### Displays

Match monitors on `desc:<make> <model> <serial>`, not connector name, so settings
follow a display across ports and docks. Hyprland resolves an unavailable refresh rate
to the nearest available one rather than falling back to preferred, so asking for a
rate the current cable can't carry is safe and self-upgrading — `hypr/dot4/custom/general.lua`
relies on this for the AOC's 240Hz (144 over HDMI, 240 over DP, one config line).

Any monitor left on the vendor catch-all's `position = "auto"` will wander when
another monitor's rotation or resolution changes the logical width to its left. If you
pin one monitor's position, pin them all.

## apply.sh

Always clones the repo fresh from GitHub into a temp dir — deliberately no
local-vs-remote detection, so `sh <(curl -fsSL <raw-url>)` and a locally-cloned
`./apply.sh` behave identically (**local edits only take effect after they're
pushed**; to test before pushing, copy the files into `~/.config/hypr/` by hand and
`hyprctl reload`). It detects OS via `uname -s`; on Linux it copies `hypr/$HYPR_BASE`
(first positional arg, else `$HYPR_BASE`, else `dot4`), on macOS `aerospace/`,
backing up any existing target once as `<file>.bak`.

## General constraints

Keep it minimal. Don't touch a vendor file if a `custom/` override achieves the same
effect. Don't port a JaKooLit-era override that dot4 already binds natively — check
`hyprland/keybinds.lua` first. If a change needs a new mechanism (not covered above),
that's a signal to stop and confirm the approach rather than bolt something on.

## README upkeep

`README.md` documents **the diff only** — dot4 ships a live cheatsheet
(`Super + Shift + /`, vendor default `Super + /`) generated from the real binds, and
that is authoritative for the ~190 vendor binds. Don't mirror them into the README.

After any change to a keybind here (add, remove, rebind, or the vendor feature it
displaces), update the keybind table in the same pass — don't leave it to drift. Same
for the display layout: the ASCII diagram and the coordinates in
`hypr/dot4/custom/general.lua` must agree. If a change doesn't cleanly fit an existing
section or convention documented here, stop and flag it rather than forcing it in.
