#!/usr/bin/env bash
# Copies everything under ./config into ~/.config, preserving paths.
# Existing targets are backed up once as <file>.bak before being overwritten.
# Requires JaKooLit/Hyprland-Dots (or equivalent) already installed at ~/.config/hypr.
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
src_dir="$repo_dir/config"
dest_dir="$HOME/.config"

if [[ ! -d "$HOME/.config/hypr" ]]; then
    echo "Warning: ~/.config/hypr not found. Install the base Hyprland dots first." >&2
fi

while IFS= read -r -d '' file; do
    rel="${file#"$src_dir"/}"
    target="$dest_dir/$rel"
    mkdir -p "$(dirname "$target")"
    if [[ -f "$target" && ! -f "$target.bak" ]]; then
        cp "$target" "$target.bak"
    fi
    cp "$file" "$target"
    [[ "$file" == *.sh ]] && chmod +x "$target"
    echo "applied: $rel"
done < <(find "$src_dir" -type f -print0)

if pidof Hyprland >/dev/null 2>&1 && command -v hyprctl >/dev/null 2>&1; then
    hyprctl reload >/dev/null 2>&1 || true
    echo "Hyprland config reloaded."
else
    echo "Hyprland not running -- changes apply on next login."
fi
