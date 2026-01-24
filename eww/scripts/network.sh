#!/usr/bin/env bash

INTERVAL=5

while true; do
    
    ssid=$(nmcli -t -f ACTIVE,SSID dev wifi | grep '^yes' | cut -d: -f2)
    signal=$(nmcli -t -f ACTIVE,SIGNAL dev wifi | grep '^yes' | cut -d: -f2)
    eth=$(nmcli -t -f TYPE,STATE dev status | grep '^ethernet:connected' | cut -d: -f2)

    if [ -n "$eth" ]; then
        icon="󱎔 "
        name="Ethernet"
    elif [ -n "$ssid" ]; then
        if [ "$signal" -ge 75 ]; then
            icon="󰤨 "
        elif [ "$signal" -ge 50 ]; then
            icon="󰤥 "
        elif [ "$signal" -ge 25 ]; then
            icon="󰤢 "
        else
            icon="󰤟 "
        fi
        name="$ssid"
    else
        icon="󰤮 "
        name="Disconnected"
    fi

    printf "%s %s\n" "$icon" "$name"
    sleep $INTERVAL
done