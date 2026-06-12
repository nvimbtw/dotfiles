#!/usr/bin/env bash

# Check if battery exists
if [ ! -d "/sys/class/power_supply/BAT0" ]; then
    echo "NO BAT"
    exit 0
fi

CAPACITY=$(cat /sys/class/power_supply/BAT0/capacity)
STATUS=$(cat /sys/class/power_supply/BAT0/status)

# Same material glyph set as the eww bar (battery.sh)
ICONS=("󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹")
IDX=$((CAPACITY / 10))
[ "$IDX" -gt 10 ] && IDX=10
ICON="${ICONS[$IDX]}"

if [ "$STATUS" = "Charging" ]; then
    ICON="󰂄"
fi

echo "$ICON $CAPACITY%"
