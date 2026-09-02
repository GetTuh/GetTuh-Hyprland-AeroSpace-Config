#!/usr/bin/env bash
# Clones this repo fresh and applies the config for the current OS into ~/.config.
# Existing targets are backed up once as <file>.bak before being overwritten.
#
# Usage (same command on Linux and macOS):
#   sh <(curl -fsSL https://raw.githubusercontent.com/GetTuh/Minimized-Hyprland-Dots/main/apply.sh)
#
# On Linux, hypr/ holds one subfolder per vendor base -- pick which one to
# apply with an argument or HYPR_BASE (default: dot4):
#   ... apply.sh) jakoolit        HYPR_BASE=jakoolit ./apply.sh
set -euo pipefail

HYPR_BASE="${1:-${HYPR_BASE:-dot4}}"

REPO_URL="https://github.com/GetTuh/Minimized-Hyprland-Dots.git"

repo_dir="$(mktemp -d)"
trap 'rm -rf "$repo_dir"' EXIT
git clone --depth 1 --quiet "$REPO_URL" "$repo_dir"

case "$(uname -s)" in
    Linux)  os_dir="hypr/$HYPR_BASE"; dest_dir="$HOME/.config/hypr" ;;
    Darwin) os_dir="aerospace";       dest_dir="$HOME/.config/aerospace" ;;
    *) echo "Unsupported OS: $(uname -s)" >&2; exit 1 ;;
esac

src_dir="$repo_dir/$os_dir"
if [[ ! -d "$src_dir" ]]; then
    echo "No $os_dir/ config in this repo yet." >&2
    [[ "$(uname -s)" == Linux ]] && \
        echo "Available bases: $(ls "$repo_dir/hypr" 2>/dev/null | tr '\n' ' ')" >&2
    exit 1
fi
echo "Applying $os_dir -> $dest_dir"

if [[ "$(uname -s)" == Linux && ! -d "$HOME/.config/hypr" ]]; then
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

# The launcher's math row is hardcoded to `qalc -t` in a quickshell vendor file,
# and there's no user-override surface for it (config.json has no such option,
# and user action scripts are exec-detached so they can't render a result row).
# So: one idempotent sed, re-applied here because a dots-hyprland update
# overwrites the file. No-op if already patched, or if the file isn't there.
patch_quickshell_math() {
    local qml="$HOME/.config/quickshell/ii/services/LauncherSearch.qml"
    local script="$HOME/.config/hypr/custom/scripts/qalc-multi.sh"
    [[ -f "$qml" && -x "$script" ]] || return 0
    if grep -q "qalc-multi.sh" "$qml"; then
        echo "quickshell math hook: already patched"
        return 0
    fi
    if ! grep -q 'baseCommand: \["qalc", "-t"\]' "$qml"; then
        echo "quickshell math hook: upstream line changed, patch skipped -- reapply by hand" >&2
        return 0
    fi
    cp "$qml" "$qml.bak.qalc"
    sed -i "s|baseCommand: \[\"qalc\", \"-t\"\]|baseCommand: [\"$script\"]|" "$qml"
    echo "quickshell math hook: patched"
}

if [[ "$(uname -s)" == Linux ]]; then
    patch_quickshell_math
fi

if [[ "$(uname -s)" == Linux ]] && pidof Hyprland >/dev/null 2>&1 && command -v hyprctl >/dev/null 2>&1; then
    hyprctl reload >/dev/null 2>&1 || true
    echo "Hyprland config reloaded."
elif [[ "$(uname -s)" == Darwin ]] && pgrep -x AeroSpace >/dev/null 2>&1 && command -v aerospace >/dev/null 2>&1; then
    aerospace reload-config >/dev/null 2>&1 || true
    echo "AeroSpace config reloaded."
else
    echo "Changes apply on next login/restart."
fi
