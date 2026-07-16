#!/usr/bin/env bash
# Single pick-list for everything that used to have its own dedicated keybind.
# Bound to Super+X in UserKeybinds.conf. Add/remove lines here, not new binds.

scriptsDir="$HOME/.config/hypr/scripts"
UserScripts="$HOME/.config/hypr/UserScripts"
rofi_theme="${XDG_CONFIG_HOME:-$HOME/.config}/rofi/config-edit.rasi"

options="Calculator\nEmoji Picker\nWallpaper Picker\nWallpaper Effects\nRandom Wallpaper\nOnline Music\nZsh Theme\nRainbow Border On\nRainbow Border Off\nAnimations Menu\nGhostty Theme\nRofi Theme (modified)\nHelp / Cheat Sheet"

pidof rofi >/dev/null && pkill rofi

choice=$(printf "%b" "$options" | rofi -i -dmenu -config "$rofi_theme" -mesg " Choose an extra")

case "$choice" in
    "Calculator")            "$UserScripts/RofiCalc.sh" ;;
    "Emoji Picker")          "$scriptsDir/RofiEmoji.sh" ;;
    "Wallpaper Picker")      "$scriptsDir/WallpaperSelect.sh" ;;
    "Wallpaper Effects")     "$scriptsDir/WallpaperEffects.sh" ;;
    "Random Wallpaper")      "$scriptsDir/WallpaperRandom.sh" ;;
    "Online Music")          "$UserScripts/RofiBeats.sh" ;;
    "Zsh Theme")             "$scriptsDir/ZshChangeTheme.sh" ;;
    "Rainbow Border On")
        "$UserScripts/RainbowBorders-low-cpu.sh" &
        disown
        ;;
    "Rainbow Border Off")
        rb_lock="/tmp/hypr-rainbowborders.lock"
        [[ -f "$rb_lock" ]] && kill "$(cat "$rb_lock" 2>/dev/null)" 2>/dev/null # restores the previous border color
        ;;
    "Animations Menu")       "$scriptsDir/Animations.sh" ;;
    "Ghostty Theme")         "$scriptsDir/Ghostty_themes.sh" ;;
    "Rofi Theme (modified)") "$scriptsDir/RofiThemeSelector-modified.sh" ;;
    "Help / Cheat Sheet")    "$scriptsDir/KeyHints.sh" ;;
    *) exit 0 ;;
esac
