# Minimized Hyprland Dots

Personal keybind overrides on top of [JaKooLit/Hyprland-Dots](https://github.com/LinuxBeginnings/Hyprland-Dots). This repo does not contain the base dots — install those first, then run `apply.sh` here to layer these files on top.

## Setup

```sh
./apply.sh
```

Copies everything under `config/` into `~/.config`, preserving paths, backing up any existing file once as `<file>.bak`, and reloading Hyprland if it's running.

## What this changes vs. upstream

- Removed dedicated keybinds for one-off gimmicks (RofiBeats, zsh theme switcher, rainbow border, animations menu, emoji picker, Ghostty theme selector, the duplicate "modified" rofi theme selector, the static help/cheat-sheet file).
- Wallpaper: kept only `Super+W` (picker). Effects and Random are no longer separate hotkeys.
- Everything removed above is still reachable from one place: `Super+X` (Extras menu).
- Added: tap bare `Super` to open the app launcher.

## Keybinds

### App Launchers
| Keys | Action |
|---|---|
| `Super` (tap) | App launcher (Rofi) |
| `Super + D` | App launcher (Rofi) |
| `Super + X` | Extras menu (everything unbound below, in one picker) |
| `Super + Return` | Terminal |
| `Super + E` | File manager |
| `Super + B` | Default browser |
| `Super + C` | SSH session manager |
| `Super + S` | Web search |
| `Super + Ctrl + S` | Window switcher |
| `Super + A` | Desktop overview |
| `Super + Alt + C` | Calculator |
| `Super + Alt + V` | Clipboard manager |

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
| `Super + Shift + I` | Toggle split (dwindle) |
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
| `Super + W` | Wallpaper picker |
| `Super + T` | Global theme switcher (Wallust) |
| `Super + N` | Toggle night light |
| `Super + Ctrl + Alt + B` | Toggle Waybar visibility |
| `Super + Ctrl + B` | Waybar style menu |
| `Super + Alt + B` | Waybar layout menu |

### System
| Keys | Action |
|---|---|
| `Ctrl + Alt + Delete` | Exit Hyprland |
| `Ctrl + Alt + L` | Lock screen |
| `Ctrl + Alt + P` | Power menu |
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

Multimedia, volume, mic-mute and brightness keys work out of the box.

### Extras menu (`Super + X`)
Everything that used to have its own hotkey and didn't earn a place above — picked from a single Rofi list instead:

Calculator, Emoji picker, Wallpaper effects, Random wallpaper, Online music, Zsh theme, Rainbow border, Animations menu, Ghostty theme, Rofi theme (modified), Help/cheat sheet.

## Known quirks (inherited from upstream)

`Super + Alt + V` is bound twice in the base dots: clipboard manager and vertical-scroll-direction. Both fire; harmless unless you're on the scrolling layout and hit it by accident.
