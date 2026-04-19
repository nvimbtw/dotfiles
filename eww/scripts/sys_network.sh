#!/usr/bin/env bash

# Get active network interface and IP
IFACE=$(nmcli -t -f DEVICE,STATE device | grep ":connected" | cut -d: -f1 | head -n1)
if [ -z "$IFACE" ]; then
    echo '{"iface": "N/A", "ip": "N/A", "conn": "Disconnected"}'
    exit 0
fi

IP=$(ip addr show "$IFACE" | grep "inet " | awk '{print $2}' | cut -d/ -f1)
CONN=$(nmcli -t -f NAME connection show --active | head -n1)

echo "{\"iface\": \"$IFACE\", \"ip\": \"$IP\", \"conn\": \"$CONN\"}"
