#!/usr/bin/env bash
# Moves the active workspace to the monitor in the given direction (l/r/u/d),
# then re-pins it there at runtime. Without this, the persistent `monitor:`
# assignment in workspaces.conf fights the move -- Hyprland re-enforces the
# static pin (e.g. on the next `hyprctl reload` or monitor hotplug) and snaps
# the workspace back to where the config says it belongs.
#
# Note: the re-pin is runtime-only (hyprctl keyword), not written back to
# workspaces.conf, so a reload/redeploy still resets everything to the file's
# original layout.
set -euo pipefail

dir="$1"
ws_id=$(hyprctl activeworkspace -j | jq -r '.id')

hyprctl dispatch movecurrentworkspacetomonitor "$dir"
sleep 0.1

mon=$(hyprctl workspaces -j | jq -r --arg id "$ws_id" '.[] | select(.id == ($id | tonumber)) | .monitor')

if [[ -n "$mon" ]]; then
    hyprctl keyword workspace "$ws_id, monitor:$mon"
fi
