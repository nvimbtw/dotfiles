#!/usr/bin/env bash

# Check bluetooth power state
POWER=$(bluetoothctl show 2>/dev/null | grep -q "Powered: yes" && echo "On" || echo "Off")

# Full name of the first connected device (fields 3+ — field 2 is the MAC)
DEVICE=$(bluetoothctl devices Connected 2>/dev/null | head -n1 | cut -d' ' -f3-)
if [ -z "$DEVICE" ]; then
    DEVICE="None"
fi

echo "{\"power\": \"$POWER\", \"device\": \"$DEVICE\"}"
