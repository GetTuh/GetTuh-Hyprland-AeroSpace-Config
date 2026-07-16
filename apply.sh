#!/usr/bin/env bash
# Fetches (if needed) and applies this repo's config/ tree into ~/.config.
# Existing targets are backed up once as <file>.bak before being overwritten.
# Requires JaKooLit/Hyprland-Dots (or equivalent) already installed at ~/.config/hypr.
#
# Local usage:  ./apply.sh
# Remote usage: sh <(curl -L https://raw.githubusercontent.com/GetTuh/Minimized-Hyprland-Dots/main/apply.sh)
set -euo pipefail

REPO_URL="https://github.com/GetTuh/Minimized-Hyprland-Dots.git"

script_dir=""
if [[ -n "${BASH_SOURCE[0]:-}" ]]; then
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd)" || script_dir=""
fi

if [[ -n "$script_dir" && -d "$script_dir/config" ]]; then
    repo_dir="$script_dir"
else
    repo_dir="$(mktemp -d)"
    trap 'rm -rf "$repo_dir"' EXIT
    git clone --depth 1 --quiet "$REPO_URL" "$repo_dir"
fi

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
