#!/usr/bin/env bash

# Primary connected interface (skip loopback)
IFACE=$(nmcli -t -f DEVICE,TYPE,STATE device | awk -F: '$2 != "loopback" && $3 == "connected" {print $1; exit}')
if [ -z "$IFACE" ]; then
    echo '{"iface": "N/A", "ip": "N/A", "conn": "Disconnected"}'
    exit 0
fi

IP=$(ip -4 addr show "$IFACE" | awk '/inet / {print $2}' | cut -d/ -f1 | head -n1)
# Connection name of THIS interface (the SSID for wifi)
CONN=$(nmcli -t -f GENERAL.CONNECTION device show "$IFACE" | cut -d: -f2-)

echo "{\"iface\": \"$IFACE\", \"ip\": \"${IP:-N/A}\", \"conn\": \"${CONN:-N/A}\"}"
