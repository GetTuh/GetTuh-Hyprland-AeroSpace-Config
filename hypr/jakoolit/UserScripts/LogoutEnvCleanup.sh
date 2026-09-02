#!/usr/bin/env bash
# `env =` vars in ENVariables.conf get pushed into the systemd --user and
# D-Bus activation environment, not just Hyprland's own process tree, so they
# outlive Hyprland and leak into a Plasma session started afterward without a
# reboot. These three force Qt/QML widget theming and break Plasma's own
# Breeze look (icons, widget style, text rendering) if left set.
set -euo pipefail

systemctl --user unset-environment \
    QT_QPA_PLATFORMTHEME \
    QT_STYLE_OVERRIDE \
    QT_QUICK_CONTROLS_STYLE \
    2>/dev/null || true

exec "$HOME/.config/hypr/scripts/Logout.sh" "$@"
