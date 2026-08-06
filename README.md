# Minimized Dots

Personal config overrides, same install command on every machine. On Linux it layers keybind/idle overrides on top of [JaKooLit/Hyprland-Dots](https://github.com/LinuxBeginnings/Hyprland-Dots) (install that first); on macOS it's a standalone config for [AeroSpace](https://github.com/nikitabobko/AeroSpace) (install that first) -- AeroSpace has no vendor base to layer on top of, so `aerospace/aerospace.toml` is the entire config, not a diff.

## Setup

```sh
sh <(curl -fsSL https://raw.githubusercontent.com/GetTuh/Minimized-Hyprland-Dots/main/apply.sh)
```

Always clones the repo fresh (so it works with no local checkout) and copies `hypr/` (Linux) or `aerospace/` (macOS) into `~/.config`, preserving paths and backing up any existing file once as `<file>.bak`. Since it always pulls from GitHub, local edits only take effect after you push them.

## What this changes vs. upstream

- Removed dedicated keybinds for one-off gimmicks (RofiBeats, zsh theme switcher, rainbow border, animations menu, emoji picker, Ghostty theme selector, the duplicate "modified" rofi theme selector, Waybar style menu, Waybar layout menu).
- Wallpaper: no longer has a dedicated hotkey at all — picker, effects, and random are all in the extras menu now.
- Everything removed above is still reachable from one place: `Super+X` (Extras menu).
- Added: tap bare `Super` to open the app launcher.
- Added: `Ctrl+Alt+S` to sleep the monitors (screen off) without suspending the system.
- `Super+D` now opens Desktop overview (its old App-launcher duty moved to the bare `Super` tap); `Super+A` is unbound.

## Keybinds

### App Launchers
| Keys | Action |
|---|---|
| `Super` (tap) | App launcher (Rofi) |
| `Super + D` | Desktop overview |
| `Super + X` | Extras menu (everything unbound below, in one picker) |
| `Super + Return` | Terminal |
| `Super + E` | File manager |
| `Super + B` | Default browser |
| `Super + C` | SSH session manager |
| `Super + S` | Web search |
| `Super + Ctrl + S` | Window switcher |
| `Super + Alt + C` | Calculator |
| `Super + V` | Clipboard manager |

### Windows
| Keys | Action |
|---|---|
| `Super + Q` | Close active window |
| `Super + Shift + Q` | Terminate active process |
| `Super + Shift + F` | Fullscreen |
| `Super + F` | Maximize |
| `Super + Space` | Float current window |
| `Super + Alt + Space` | Float all windows |
| `Super + Shift + Return` | Drop-down terminal |
| `Super + Ctrl + O` | Toggle window opacity |
| `Super + Shift + H` | Mute/unmute active window audio |
| `Super + Alt + Mouse scroll` | Desktop zoom (magnifier) |
| `Super + ←/→/↑/↓` | Focus window (direction) |
| `Super + Ctrl + ←/→/↑/↓` | Move window (direction) |
| `Super + Alt + ←/→/↑/↓` | Swap window (direction) |
| `Super + Shift + ←/→/↑/↓` | Resize window (direction) |
| `Super + Mouse Left` | Move floating window |
| `Super + Mouse Right` | Resize floating window |
| `Alt + Tab` | Cycle next window |

### Groups
| Keys | Action |
|---|---|
| `Super + G` | Toggle group |
| `Super + Tab` / `Super + Shift + Tab` | Change group active (forward/back) |
| `Super + Ctrl + Tab` | Change active window in group |
| `Super + Ctrl + K / L` | Move window into group (left/right) |
| `Super + Ctrl + H` | Move window out of group |

### Layouts
| Keys | Action |
|---|---|
| `Super + Alt + L` | Toggle Dwindle/Master |
| `Super + Alt + 1/2/3/4` | Set layout: dwindle/master/scrolling/monocle |
| `Super + I` | Add master |
| `Super + Ctrl + D` | Remove master |
| `Super + Ctrl + Return` | Swap with master |
| `Super + j / k` | Cycle next/prev window (layout-aware) |
| `Super + /` | Toggle split (dwindle) |
| `Super + P` | Toggle pseudo (dwindle) |
| `Super + M` | Set split ratio 0.3 |
| `Super + R` | Cycle column width preset (scrolling) |
| `Super + Shift + . / ,` | Move column right/left (scrolling) |
| `Super + Alt + . / ,` | Swap column right/left (scrolling) |
| `Super + Alt + S` | Toggle scroll direction V/H |

### Workspaces
| Keys | Action |
|---|---|
| `Super + 0-9` | Go to workspace |
| `Super + Shift + 0-9` | Move window to workspace + follow |
| `Super + Ctrl + 0-9` | Move window to workspace (silent) |
| `Super + [ / ]` (Shift) | Move to previous/next workspace |
| `Super + . / ,` | Next/previous workspace |
| `Super + Tab / Shift+Tab` | Next/previous workspace |
| `Super + U` | Toggle special workspace |
| `Super + Shift + U` | Move to special workspace |
| `Super + Ctrl + F9-F12` | Move workspace to monitor (l/r/u/d) |

### Wallpaper / Bar
| Keys | Action |
|---|---|
| `Super + T` | Global theme switcher (Wallust) |
| `Super + N` | Toggle night light |
| `Super + Ctrl + Alt + B` | Toggle Waybar visibility |
| `Super + Alt + B` | Hide waybar |

### System
| Keys | Action |
|---|---|
| `Ctrl + Alt + Delete` | Exit Hyprland |
| `Ctrl + Alt + L` | Lock screen |
| `Ctrl + Alt + P` | Power menu |
| `Super + L` | Sleep monitors (screen off) |
| `Super + Shift + N` | Notification panel |
| `Super + Shift + E` | Quick settings menu |
| `Super + Alt + O` | Toggle blur |
| `Super + Shift + G` | Game mode (animations off) |
| `Super + Alt + R` | Refresh bar and menus |
| `Super + Shift + K` | Search keybinds (fuzzy) |
| `Alt Shift` | Switch keyboard layout (global) |
| `Shift Alt` | Switch keyboard layout (per window) |

### Screenshots
| Keys | Action |
|---|---|
| `Super + Print` | Screenshot now |
| `Super + Shift + Print` | Screenshot (area) |
| `Super + Shift + S` | Screenshot (swappy) |
| `Super + Ctrl + Print` | Screenshot in 5s |
| `Super + Ctrl + Shift + Print` | Screenshot in 10s |
| `Alt + Print` | Screenshot active window |
| `Alt + Shift + S` | Hyprshot region capture |

Multimedia, volume, mic-mute keys work out of the box.

### Extras menu (`Super + X`)
Everything that used to have its own hotkey and didn't earn a place above — picked from a single Rofi list instead:

Emoji picker, Wallpaper picker, Wallpaper effects, Random wallpaper, Online music, Zsh theme, Rainbow border (on/off), Animations menu, Ghostty theme, Rofi theme (modified), Waybar style, Waybar layout.

## Known quirks (inherited from upstream)

`Super + Ctrl + K` is bound twice in the base dots: Kitty theme selector and move-window-into-group-left. Both fire; harmless unless you're on Kitty and grouping windows at the same time.

## AeroSpace (macOS)

`aerospace/aerospace.toml` translates the Linux keybind/workspace setup above wherever AeroSpace has an equivalent concept. AeroSpace is tiling/workspaces only — no compositor, bar, wallpaper engine, idle daemon, or screenshot tool — so most of `hypr/UserConfigs/` (decorations, blur, animations, Waybar, wallust theming, hypridle) has nothing to translate to; those stay macOS-native or out of scope. See the bottom of this section for the full list of what's intentionally missing.

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
Same scheme as `hypr/workspaces.conf`: workspaces 1-3 on the main monitor, 4-6 on the second external, 7-9 on the built-in laptop panel — see `workspace-to-monitor-force-assignment` in `aerospace.toml` for the exact monitor patterns and a note on verifying monitor order with `aerospace list-monitors`.

### What doesn't carry over, and why
- **Decorations/blur/animations/rounding** (`UserDecorations.conf`) — AeroSpace doesn't touch window rendering at all; macOS's native window chrome is used as-is.
- **Waybar, wallust theme switching, night light** — no bar or theming engine in AeroSpace; use a separate bar tool (e.g. Sketchybar) if wanted, or macOS's own Night Shift.
- **Window opacity rule** (`WindowRules.conf`) — same reason as decorations; not part of AeroSpace's scope, and macOS has no system-wide equivalent either.
- **hypridle/hyprlock (idle warn, auto-lock, dpms off, suspend)** — AeroSpace doesn't manage idle or power state; use System Settings → Lock Screen / Battery instead.
- **Screenshots** — macOS's native shortcuts (`Cmd+Shift+3/4/5`) already cover this; nothing to configure.
- **Mouse accel-off, kwalletd6** (`UserSettings.conf`) — OS/input-driver level, not a WM setting; macOS has no native accel toggle (third-party tools like LinearMouse exist but aren't part of this repo), and Keychain replaces kwallet's job.
- **Force-quit, power menu, notification/quick-settings panels** — all macOS-native (`Cmd+Option+Esc`, Control Center, etc.), nothing for a WM to bind.
- **Hyprland's master/scrolling/monocle layout engines, column-width presets** — AeroSpace only has two layout kinds (tiles, accordion); there's no master-stack or scrolling-column concept to map those binds onto.

# MainRigScripts

Copy HA TOKEN as .env (HA_TOKEN=) to the MainRigScripts folder.