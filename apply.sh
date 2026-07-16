#!/usr/bin/env bash
# Clones this repo fresh and applies the config for the current OS into ~/.config.
# Existing targets are backed up once as <file>.bak before being overwritten.
#
# Usage (same command on Linux and macOS):
#   sh <(curl -fsSL https://raw.githubusercontent.com/GetTuh/Minimized-Hyprland-Dots/main/apply.sh)
set -euo pipefail

REPO_URL="https://github.com/GetTuh/Minimized-Hyprland-Dots.git"

repo_dir="$(mktemp -d)"
trap 'rm -rf "$repo_dir"' EXIT
git clone --depth 1 --quiet "$REPO_URL" "$repo_dir"

case "$(uname -s)" in
    Linux)  os_dir="hypr";      dest_dir="$HOME/.config/hypr" ;;
    Darwin) os_dir="aerospace"; dest_dir="$HOME/.config/aerospace" ;;
    *) echo "Unsupported OS: $(uname -s)" >&2; exit 1 ;;
esac

src_dir="$repo_dir/$os_dir"
if [[ ! -d "$src_dir" ]]; then
    echo "No $os_dir/ config in this repo yet." >&2
    exit 1
fi

if [[ "$os_dir" == "hypr" && ! -d "$HOME/.config/hypr" ]]; then
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

if [[ "$os_dir" == "hypr" ]] && pidof Hyprland >/dev/null 2>&1 && command -v hyprctl >/dev/null 2>&1; then
    hyprctl reload >/dev/null 2>&1 || true
    echo "Hyprland config reloaded."
elif [[ "$os_dir" == "aerospace" ]] && pgrep -x AeroSpace >/dev/null 2>&1 && command -v aerospace >/dev/null 2>&1; then
    aerospace reload-config >/dev/null 2>&1 || true
    echo "AeroSpace config reloaded."
else
    echo "Changes apply on next login/restart."
fi
