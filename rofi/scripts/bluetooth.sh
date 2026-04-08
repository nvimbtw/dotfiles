#!/usr/bin/env bash

# Oxocarbon colors
CYAN="#3ddbd9"
PURPLE="#be95ff"
PINK="#ff7eb6"
BASE03="#525252"

# 1. Get Power Status via rfkill (more reliable for battery saving)
# Check if bluetooth is soft blocked
blocked=$(rfkill list bluetooth | grep "Soft blocked: yes")

if [ -n "$blocked" ]; then
    power_status="off"
    toggle="󰂯  POWER ON"
else
    power_status="on"
    toggle="󰂲  POWER OFF"
fi

# 3. List Devices (only if powered on)
devices=""
if [ "$power_status" == "on" ]; then
    devices=$(bluetoothctl devices | while read -r line; do
        mac=$(echo "$line" | cut -d' ' -f2)
        name=$(echo "$line" | cut -d' ' -f3-)
        
        # Check if connected/paired
        info=$(bluetoothctl info "$mac")
        if echo "$info" | grep -q "Connected: yes"; then
            state="[CONNECTED]"
        elif echo "$info" | grep -q "Paired: yes"; then
            state="[PAIRED]"
        else
            state="[OFF]"
        fi
        echo "$name $state | $mac"
    done)
fi

# 4. Show Rofi
chosen=$( (echo -e "$toggle\n$devices") | rofi -dmenu -i -p "BT" -theme-str 'listview { lines: 10; }')

if [ -z "$chosen" ]; then exit 0; fi

# 5. Handle Selection
if [ "$chosen" == "󰂯  POWER ON" ]; then
    rfkill unblock bluetooth
    bluetoothctl power on
    notify-send "Bluetooth" "Powered ON"
elif [ "$chosen" == "󰂲  POWER OFF" ]; then
    bluetoothctl power off
    rfkill block bluetooth
    notify-send "Bluetooth" "Powered OFF (Hard Blocked)"
else
    # Extract MAC address (everything after the last '|')
    mac=$(echo "$chosen" | awk -F' | ' '{print $NF}')
    name=$(echo "$chosen" | sed 's/ \[.*//')

    # Toggle connection
    if echo "$chosen" | grep -q "CONNECTED"; then
        bluetoothctl disconnect "$mac"
        notify-send "Bluetooth" "Disconnected from $name"
    else
        notify-send "Bluetooth" "Connecting to $name..."
        bluetoothctl connect "$mac"
        if [ $? -eq 0 ]; then
            notify-send "Bluetooth" "Connected to $name"
        else
            notify-send "Bluetooth" "Failed to connect to $name"
        fi
    fi
fi
