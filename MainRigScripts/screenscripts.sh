#!/bin/bash

MONITOR="DP-1"
SECONDARY="HDMI-A-1"  # QD-OLED, right of primary
SPEAKER_SINK="alsa_output.pci-0000_13_00.6.analog-stereo"  # Ryzen HD Audio
DAC_SINK="alsa_output.usb-Burr-Brown_from_TI_USB_Audio_CODEC-00.analog-stereo-output"

speaker_plug_on() {
  source "$(dirname "$0")/.env"
  curl -s -X POST "https://homeassistant.ofhens.uk/api/services/switch/turn_on" \
    -H "Authorization: Bearer ${HA_TOKEN}" \
    -H "Content-Type: application/json" \
    -d '{"entity_id": "switch.smart_plug_socket_1"}' &
}

speaker_plug_off() {
  source "$(dirname "$0")/.env"
  curl -s -X POST "https://homeassistant.ofhens.uk/api/services/switch/turn_off" \
    -H "Authorization: Bearer ${HA_TOKEN}" \
    -H "Content-Type: application/json" \
    -d '{"entity_id": "switch.smart_plug_socket_1"}' &
}

case "$1" in
  --monitor)
    kscreen-doctor output.${MONITOR}.enable output.${SECONDARY}.disable
    ;;
  --tv)
    kscreen-doctor output.${SECONDARY}.enable output.${MONITOR}.disable
    ;;
  --gaming)
    source "$(dirname "$0")/.env"

    if pgrep -x steam >/dev/null; then
      # Already in gaming mode - toggle off and kill the smart plug
      pkill -x steam
      speaker_plug_off
      exit 0
    fi

    notify-send "Gaming mode on"

    # Save state to restore after Steam closes
    prev_brightness=$(kscreen-doctor -o | awk "/Output.*${MONITOR}/{f=1} f && /Brightness control/{print; f=0}" | grep -oP 'set to \K\d+')
    prev_sink=$(pactl get-default-sink)
    prev_volume=$(pactl get-sink-volume "$prev_sink" | grep -oP '\d+(?=%)' | head -1)

    # Turn on speaker smart plug
    speaker_plug_on

    # Switch to Ryzen HD Audio and set volume
    pactl set-default-sink "$SPEAKER_SINK"
    pactl set-sink-volume "$SPEAKER_SINK" 30%

    kscreen-doctor output.${MONITOR}.enable output.${SECONDARY}.disable
    kscreen-doctor output.${MONITOR}.brightness.80
    pkill -x steam 2>/dev/null && sleep 3

    # Hide mouse cursor on inactivity while in Big Picture
    qdbus-qt6 org.kde.KWin /Effects loadEffect "hidecursor" >/dev/null

    /usr/bin/steam steam://open/bigpicture &
    sleep 5
    while pgrep -x steam >/dev/null; do sleep 2; done

    # Stop hiding the cursor now that we're back on the desktop
    qdbus-qt6 org.kde.KWin /Effects unloadEffect "hidecursor" >/dev/null

    # Restore state
    pactl set-default-sink "$prev_sink"
    pactl set-sink-volume "$prev_sink" "${prev_volume:-50}%"
    [[ -n "$prev_brightness" ]] && kscreen-doctor output.${MONITOR}.brightness.${prev_brightness}

    notify-send "Gaming mode off"
    "$0" --both
    ;;
  --both)
    kscreen-doctor \
      output.${MONITOR}.enable \
      output.${SECONDARY}.enable \
      output.${MONITOR}.position.0,0 \
      output.${SECONDARY}.position.2560,0 \
      output.${MONITOR}.primary
    ;;
  --speakers)
    if [[ "$(pactl get-default-sink)" == "$SPEAKER_SINK" ]]; then
      pactl set-default-sink "$DAC_SINK"
      speaker_plug_off
      notify-send "Switched to DAC"
    else
      pactl set-default-sink "$SPEAKER_SINK"
      pactl set-sink-volume "$SPEAKER_SINK" 30%
      speaker_plug_on
      notify-send "Switched to speakers"
    fi
    ;;
  --brightness)
    kscreen-doctor output.${MONITOR}.brightness.$2
    ;;
  --brightness-up)
    current=$(kscreen-doctor -o | awk "/Output.*${MONITOR}/{f=1} f && /Brightness control/{print; f=0}" | grep -oP 'set to \K\d+')
    new=$(( current + 10 > 100 ? 100 : current + 10 ))
    kscreen-doctor output.${MONITOR}.brightness.${new}
    sleep 0.5 && notify-send "Brightness: ${new}%" &
    ;;
  --brightness-down)
    current=$(kscreen-doctor -o | awk "/Output.*${MONITOR}/{f=1} f && /Brightness control/{print; f=0}" | grep -oP 'set to \K\d+')
    new=$(( current - 10 < 0 ? 0 : current - 10 ))
    kscreen-doctor output.${MONITOR}.brightness.${new}
    sleep 0.5 && notify-send "Brightness: ${new}%" &
    ;;
  --hdr-on)
    kscreen-doctor output.${MONITOR}.hdr.enable output.${MONITOR}.wcg.enable
    sleep 0.5 && notify-send "HDR enabled" &
    ;;
  --hdr-off)
    kscreen-doctor output.${MONITOR}.hdr.disable output.${MONITOR}.wcg.disable
    sleep 0.5 && notify-send "HDR disabled" &
    ;;
  *)
    echo "Usage: $0 [--monitor | --tv | --both | --gaming | --speakers | --brightness <0-100> | --brightness-up | --brightness-down | --hdr-on | --hdr-off]"
    exit 1
    ;;
esac