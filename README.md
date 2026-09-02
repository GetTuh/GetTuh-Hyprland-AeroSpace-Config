# Minimized Dots

Personal config overrides, same install command on every machine. On Linux it layers keybind and display overrides on top of [end-4/dots-hyprland](https://github.com/end-4/dots-hyprland) (install that first); on macOS it's a standalone config for [AeroSpace](https://github.com/nikitabobko/AeroSpace) (install that first) -- AeroSpace has no vendor base to layer on top of, so `aerospace/aerospace.toml` is the entire config, not a diff.

## Setup

```sh
sh <(curl -fsSL https://raw.githubusercontent.com/GetTuh/Minimized-Hyprland-Dots/main/apply.sh)
```

Always clones the repo fresh (so it works with no local checkout) and copies `hypr/<base>/` (Linux, default base `dot4`) or `aerospace/` (macOS) into `~/.config`, preserving paths and backing up any existing file once as `<file>.bak`. Since it always pulls from GitHub, local edits only take effect after you push them.

## What this changes vs. upstream

Only the diff, nothing vendored. dot4 already binds natively almost everything the
old JaKooLit override tree had to add by hand (bare-`Super` launcher, `Super+V`
clipboard, wallpaper picker, emoji picker, light/dark toggle), so what's left is a
handful of keybind preferences, the display layout, pointer accel, and the
launcher's currency math.

### Keybinds

`hypr/dot4/custom/keybinds.lua`. Where a rebind displaces a vendor feature, that
feature is rebound rather than dropped — both halves are in the table.

| Keys | Action | Was, in stock dot4 |
|---|---|---|
| `Super + D` | Desktop overview | Maximize |
| `Super + Shift + D` | Maximize | *(unbound)* |
| `Super + /` | Toggle split (dwindle) | Cheatsheet |
| `Super + H` | Cheatsheet (the keybind list) | *(unbound)* |
| `Super + L` | Sleep monitors (screen off, system stays up) | Lock |
| `Ctrl + Alt + L` | Lock | *(unbound)* |
| `Super + B` | Browser | Left sidebar |
| `Print` | Screen snip | Whole screen >> clipboard |
| `Shift + Print` | Whole screen >> clipboard | *(unbound)* |
| `Super + Shift + S` | *(unbound)* | Screen snip |
| `Alt + Tab` | Cycle windows, fullscreen-aware | *(unbound — new)* |
| `Super + Ctrl + F9 / F10 / F11 / F12` | Move workspace to monitor (l/r/u/d) | *(unbound — new)* |

Notes on the less obvious ones:

- **`Super + B`** costs nothing: vendor had it as the *third* key for the left
  sidebar, and `Super + A` / `Super + O` both still open it. `Super + W` also still
  launches the browser.
- **`Alt + Tab`** re-applies the outgoing window's fullscreen mode to the one it
  lands on, so tabbing between two fullscreen windows works instead of leaving the
  first one covering the screen. Only forward cycling is bound; `Alt + Shift + Tab`
  for the reverse is one line away if you want it.
- **`Super + Tab`** (overview) and **`Super + Shift + L`** (suspend) are vendor binds
  and still work — the `Super + D` and `Super + L` rebinds above are muscle memory,
  not replacements for them.
- **`Ctrl + Print`** (whole screen >> file *and* clipboard) is vendor, untouched.

Everything else is stock. dot4 ships a live, self-generating cheatsheet on
`Super + H` — that's the authoritative list of the other ~190 binds, so this README
documents the diff only and doesn't try to mirror it.

### Input

`hypr/dot4/custom/general.lua` sets `input.accel_profile = "flat"` — no mouse
acceleration. Vendor leaves it unset, which means libinput's adaptive curve.
`hl.config` merges by key, so vendor's other input and touchpad settings survive.

### Displays

`hypr/dot4/custom/general.lua`. Monitors are matched on `desc:` (make + model +
serial), not connector name, so settings follow a display across ports and docks.

```
  x=0        2560   4000
y=0 +----------+------+
    |   AOC    | Dell |    AOC    2560x1440 @240  at 0,0
    | 2560x1440|      |    Dell   1440x2560 @60   at 2560,0  (transform 1)
 1440 +--+-----+ 1440 |    eDP-1  1920x1080 @60   at 640,1440
       |eDP-1  |x2560 |
 2520  +-------+      |
               +------+ y=2560
```

- **AOC Q27G41ZDF** — asks for `2560x1440@240`. 240Hz exists only over
  DisplayPort; on HDMI the panel's EDID tops out at 144Hz and Hyprland resolves
  an unavailable refresh rate to the nearest one it has. So this one line is
  144Hz on HDMI and 240Hz the moment the cable moves to DP, with no config
  change. Check with `hyprctl monitors -j | jq -r '.[]|"\(.name) \(.refreshRate)"'`.
- **Dell P2423DE** — portrait, `transform = 1` (image rotated 90° clockwise,
  which is what compensates for this stand's pivot; `transform = 3` renders it
  upside down).
- **eDP-1** — pinned explicitly rather than left on the vendor catch-all's
  `position = "auto"`, which otherwise shoves it to the far right whenever the
  Dell's rotation changes the logical width to its left. Its x is `2560-1920 =
  640` so its right edge meets the Dell's left edge exactly — no dead gap for
  the cursor to cross.

### Launcher math: currency

`hypr/dot4/custom/scripts/qalc-multi.sh`. The launcher's math row runs `qalc -t` and
shows the one line it prints. qalc already converts a *foreign* amount into the local
currency by itself (`local_currency_conversion=1` in `~/.config/qalculate/qalc.cfg`),
but it won't go the other way and only ever prints one conversion. The wrapper adds
both, on one line, and passes everything non-currency straight through:

| Typed | Shown |
|---|---|
| `10` | `10 zł = 2,3319 € • 10 € = 42,883 zł` |
| `10pln` | `10 zł = 2,3319 € = 2,6633 $` |
| `10 eur` | `42,883 zł = 11,415 $` |
| `2+2` | `4` |
| `5 km to mi` | `3 mi + 188 yd + 2,393700787 in` |

The local currency comes from `LC_MONETARY`, not a hardcoded `PLN`. Targets are
overridable with `QALC_MULTI_TARGETS` / `QALC_MULTI_PAIR` / `QALC_MULTI_LOCAL`. Every
qalc call is wrapped in `timeout 3` so a stale exchange-rate fetch can't hang the
launcher, and a currency you already typed isn't echoed back at you.

**This one needs a vendor patch.** The command is hardcoded in
`~/.config/quickshell/ii/services/LauncherSearch.qml` and the shell exposes no
override for it — `config.json` has no such option, and user action scripts
(`~/.config/illogical-impulse/actions/`) are exec-detached, so they can't render a
result row. `apply.sh` therefore re-applies a one-line, idempotent `sed` to that file
on every run, keeping a `.bak.qalc` copy. It no-ops if already patched, and bails
with a warning (rather than mangling anything) if upstream changes that line. A
dots-hyprland update will revert it; re-run `apply.sh`.

## Repo layout

`hypr/` holds one subfolder per vendor base:

| Folder | Base | Status |
|---|---|---|
| `hypr/dot4/` | [end-4/dots-hyprland](https://github.com/end-4/dots-hyprland) (illogical-impulse) | active |
| `hypr/jakoolit/` | [JaKooLit/Hyprland-Dots](https://github.com/JaKooLit/Hyprland-Dots) | kept for reference |

Inside each, a file's path is the exact relative path it lands at under
`~/.config/hypr/`. `apply.sh` copies one base, defaulting to `dot4`:

```sh
./apply.sh              # dot4
./apply.sh jakoolit     # or HYPR_BASE=jakoolit ./apply.sh
```

## Not migrated from the JaKooLit config

Deliberately dropped, because dot4 covers it natively or the thing it drove no
longer exists:

| Old override | Why it's gone |
|---|---|
| `Super` (tap) → Rofi launcher | Vendor binds `SUPER_L`/`SUPER_R` to the shell search / fuzzel |
| `Super + V` → clipboard manager | Vendor binds it to the clipboard overview |
| `Super + X` → extras menu | Every entry was a JaKooLit script. The survivors are native binds now: wallpaper `Ctrl+Super+T`, random wallpaper `Ctrl+Super+Alt+T`, emoji `Super+.`, light/dark `Ctrl+Super+Shift+D`. `Super + X` stays the vendor text-editor bind |
| `Super + Alt + B` → hide waybar | No waybar in dot4; the bar toggle is `Super + J` |
| `Super + H` → KeyHints (`yad` list) | dot4's cheatsheet is generated from the real binds, so it can't drift. Same key, live data |
| `MoveWorkspaceToMonitor.sh` | Only existed to fight `workspaces.conf`'s static `monitor:` pinning. dot4 ships no workspace pinning, so `Super+Ctrl+F9-F12` calls the dispatcher directly |
| Decorations / animations / window + layer rules / startup / `system_*.lua` ports | All JaKooLit-shaped. dot4's own `hyprland/` tree is complete — there's no `system_*.lua` gap to fill |


## AeroSpace (macOS)

`aerospace/aerospace.toml` translates the Linux keybind/workspace setup above wherever AeroSpace has an equivalent concept. AeroSpace is tiling/workspaces only — no compositor, bar, wallpaper engine, idle daemon, or screenshot tool — so most of what a Hyprland base ships (decorations, blur, animations, bar, theming, idle daemon) has nothing to translate to; those stay macOS-native or out of scope. See the bottom of this section for the full list of what's intentionally missing.

`alt` is the AeroSpace mod key everywhere below, standing in for Hyprland's `Super`. `cmd` is deliberately left alone as a modifier — it's claimed by macOS itself and nearly every app, unlike Linux's mostly-free Super key. `ctrl`/`shift`/`cmd` then layer on top of `alt` the same way `ctrl`/`alt`/`shift` layered on top of `Super` on Linux.

### Windows
| Keys | Action |
|---|---|
| `Alt + Q` | Close active window |
| `Alt + Shift + F` | Fullscreen (AeroSpace has one fullscreen concept — no separate maximize) |
| `Alt + Space` | Toggle floating |
| `Alt + ←/→/↑/↓` | Focus window (direction) |
| `Alt + Ctrl + ←/→/↑/↓` | Move window (direction) |
| `Alt + Cmd + ←/→/↑/↓` | Swap window (direction) |
| `Alt + Shift + ←/→/↑/↓` | Resize window |
| `Alt + `` ` `` | Cycle next window (substitute for bare `Alt+Tab`, which alt-as-mod takes for workspace-back-and-forth below) |
| `Alt + Shift + `` ` `` | Cycle previous window |

### Layouts
| Keys | Action |
|---|---|
| `Alt + /` | Toggle tiles orientation (h/v) |
| `Alt + Shift + /` | Toggle accordion (closest analog to Hyprland's window "groups") |

### Workspaces
| Keys | Action |
|---|---|
| `Alt + 0-9` | Go to workspace |
| `Alt + Shift + 0-9` | Move window to workspace + follow |
| `Alt + Ctrl + 0-9` | Move window to workspace (silent) |
| `Alt + . / ,` | Next/previous workspace |
| `Alt + Tab` | Workspace back-and-forth (last two) |
| `Alt + Shift + Tab` | Move workspace to next monitor |
| `Alt + Ctrl + F9-F12` | Move workspace to monitor (l/r/u/d) — no-op for workspaces 1-9 (see config comment: they're force-assigned to a monitor) |

### App launchers
| Keys | Action |
|---|---|
| `Alt + Return` | Terminal |
| `Alt + E` | File manager |
| `Alt + B` | Default browser |

### Service mode (`Alt + Shift + ;`, then...)
| Keys | Action |
|---|---|
| `Esc` | Reload config |
| `R` | Reset layout |
| `Backspace` | Close all windows but current |
| `Alt + Shift + H/J/K/L` | Join window into neighbor (the other half of the "groups" analogy) |

### 3 workspaces per monitor
Same 3-per-monitor scheme the Linux side used to pin in `workspaces.lua`: workspaces 1-3 on the main monitor, 4-6 on the second external, 7-9 on the built-in laptop panel — see `workspace-to-monitor-force-assignment` in `aerospace.toml` for the exact monitor patterns and a note on verifying monitor order with `aerospace list-monitors`.

### What doesn't carry over, and why
- **Decorations/blur/animations/rounding** — AeroSpace doesn't touch window rendering at all; macOS's native window chrome is used as-is.
- **Waybar, wallust theme switching, night light** — no bar or theming engine in AeroSpace; use a separate bar tool (e.g. Sketchybar) if wanted, or macOS's own Night Shift.
- **Window opacity rule** (`system_window_rules.lua`) — same reason as decorations; not part of AeroSpace's scope, and macOS has no system-wide equivalent either.
- **hypridle/hyprlock (idle warn, auto-lock, dpms off, suspend)** — AeroSpace doesn't manage idle or power state; use System Settings → Lock Screen / Battery instead.
- **Screenshots** — macOS's native shortcuts (`Cmd+Shift+3/4/5`) already cover this; nothing to configure.
- **Mouse accel-off, kwalletd6** (`user_settings.lua`) — OS/input-driver level, not a WM setting; macOS has no native accel toggle (third-party tools like LinearMouse exist but aren't part of this repo), and Keychain replaces kwallet's job.
- **Force-quit, power menu, notification/quick-settings panels** — all macOS-native (`Cmd+Option+Esc`, Control Center, etc.), nothing for a WM to bind.
- **Hyprland's master/scrolling/monocle layout engines, column-width presets** — AeroSpace only has two layout kinds (tiles, accordion); there's no master-stack or scrolling-column concept to map those binds onto.

# MainRigScripts

Copy HA TOKEN as .env (HA_TOKEN=) to the MainRigScripts folder.