#!/usr/bin/env bash

# Check bluetooth power state
POWER=$(bluetoothctl show | grep "Powered: yes" > /dev/null && echo "On" || echo "Off")

# Get connected device
DEVICE=$(bluetoothctl devices Connected | awk '{print $2 " " $3}' | head -n1)
if [ -z "$DEVICE" ]; then
    DEVICE="None"
fi

echo "{\"power\": \"$POWER\", \"device\": \"$DEVICE\"}"
