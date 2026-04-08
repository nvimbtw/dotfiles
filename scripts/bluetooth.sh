#!/usr/bin/env bash
exec >> /tmp/bluetooth_debug.log 2>&1

bluetooth_state=$(rfkill list bluetooth | grep -A2 "asus-bluetooth" | grep "Soft blocked" | cut -d' ' -f3)
echo "State was: $bluetooth_state"

if [ "$bluetooth_state" = "yes" ]; then
    rfkill unblock bluetooth
    notify-send "Bluetooth" "󰂯 Enabled"
else
    rfkill block bluetooth
    notify-send "Bluetooth" "󰂲 Disabled"
fi
