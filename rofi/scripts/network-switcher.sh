#!/usr/bin/env bash

# Oxocarbon colors
CYAN="#3ddbd9"
PURPLE="#be95ff"
PINK="#ff7eb6"
BASE03="#525252"

# 1. Scanning
notify-send "Network" "Scanning for networks..."
networks=$(nmcli -t -f SSID,SIGNAL,SECURITY dev wifi list | sed 's/\\:/|/g' | while IFS=: read -r ssid signal security; do
    if [ -n "$ssid" ]; then
        # Check if currently connected
        connected=$(nmcli -t -f ACTIVE,SSID dev wifi | grep '^yes' | cut -d: -f2)
        if [ "$ssid" == "$connected" ]; then
            state="[CONNECTED]"
        else
            state="[$signal%]"
        fi
        echo "$ssid $state | $security"
    fi
done | sort -t' ' -k1,1 -u)

# 2. Show Rofi
chosen=$(echo -e "󰑐 RE-SCAN\n$networks" | rofi -dmenu -i -p "WIFI" -theme-str 'listview { lines: 10; }')

if [ -z "$chosen" ]; then exit 0; fi

if [ "$chosen" == "󰑐 RE-SCAN" ]; then
    exec "$0"
fi

# 3. Handle Selection
ssid=$(echo "$chosen" | sed 's/ \[.*//')
security=$(echo "$chosen" | awk -F' | ' '{print $NF}')

if echo "$chosen" | grep -q "CONNECTED"; then
    nmcli dev disconnect wlan0 # Using standard interface name
    notify-send "Network" "Disconnected from $ssid"
else
    if [ "$security" != "--" ] && [ -n "$security" ]; then
        # Need password
        password=$(rofi -dmenu -password -p "Password" -theme-str 'entry { placeholder: "PASSWORD"; }')
        if [ -z "$password" ]; then exit 1; fi
        notify-send "Network" "Connecting to $ssid..."
        nmcli dev wifi connect "$ssid" password "$password"
    else
        notify-send "Network" "Connecting to $ssid..."
        nmcli dev wifi connect "$ssid"
    fi

    if [ $? -eq 0 ]; then
        notify-send "Network" "Connected to $ssid"
    else
        notify-send "Network" "Failed to connect to $ssid"
    fi
fi
