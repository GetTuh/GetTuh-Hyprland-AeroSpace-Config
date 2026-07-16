#!/usr/bin/env bash
# Single pick-list for everything that used to have its own dedicated keybind.
# Bound to Super+X in UserKeybinds.conf. Add/remove lines here, not new binds.

scriptsDir="$HOME/.config/hypr/scripts"
UserScripts="$HOME/.config/hypr/UserScripts"
rofi_theme="${XDG_CONFIG_HOME:-$HOME/.config}/rofi/config-edit.rasi"

options="Emoji Picker\nWallpaper Picker\nWallpaper Effects\nRandom Wallpaper\nOnline Music\nZsh Theme\nRainbow Border On\nRainbow Border Off\nAnimations Menu\nGhostty Theme\nRofi Theme (modified)\nWaybar Style\nWaybar Layout"

pidof rofi >/dev/null && pkill rofi

choice=$(printf "%b" "$options" | rofi -i -dmenu -config "$rofi_theme" -mesg " Choose an extra")

case "$choice" in
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
        # SIGTERM alone doesn't work here: the vendor script's exit trap never
        # calls `exit`, so it restores the border for an instant then loops
        # right back into overwriting it. Force-kill by name and reload the
        # config from disk to reapply the real border color.
        pkill -9 -f "RainbowBorders-low-cpu.sh"
        rm -f "/tmp/hypr-rainbowborders.lock"
        hyprctl reload >/dev/null 2>&1
        ;;
    "Animations Menu")       "$scriptsDir/Animations.sh" ;;
    "Ghostty Theme")         "$scriptsDir/Ghostty_themes.sh" ;;
    "Rofi Theme (modified)") "$scriptsDir/RofiThemeSelector-modified.sh" ;;
    "Waybar Style")          "$scriptsDir/WaybarStyles.sh" ;;
    "Waybar Layout")         "$scriptsDir/WaybarLayout.sh" ;;
    *) exit 0 ;;
esac
