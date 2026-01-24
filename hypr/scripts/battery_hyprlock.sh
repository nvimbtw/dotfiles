#!/usr/bin/env bash

# Check if battery exists
if [ ! -d "/sys/class/power_supply/BAT0" ]; then
    echo "NO BAT"
    exit 0
fi

CAPACITY=$(cat /sys/class/power_supply/BAT0/capacity)
STATUS=$(cat /sys/class/power_supply/BAT0/status)

# Icons
ICON=" "
if [ "$STATUS" = "Charging" ]; then
    ICON="⚡"
elif [ "$CAPACITY" -le 10 ]; then
    ICON=" "
elif [ "$CAPACITY" -le 30 ]; then
    ICON=" "
elif [ "$CAPACITY" -le 60 ]; then
    ICON=" "
elif [ "$CAPACITY" -le 90 ]; then
    ICON=" "
fi

echo "$ICON $CAPACITY%"
