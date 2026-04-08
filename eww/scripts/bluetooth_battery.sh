#!/usr/bin/env bash

get_battery_icon() {
    local capacity=$1
    local icons=("󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹")
    local idx=$((capacity / 10))
    (( idx > 10 )) && idx=10
    echo "${icons[$idx]}"
}

emit() {
    local connected=$1 capacity=$2 name=$3
    local icon class
    icon=$(get_battery_icon "$capacity")
    if (( capacity < 20 )); then class="battery-low"; else class="battery-normal"; fi
    printf '{"connected":%s,"capacity":%d,"icon":"󱡏 %s","class":"%s","name":"%s"}\n' \
        "$connected" "$capacity" "$icon" "$class" "$name"
}

emit_disconnected() {
    echo '{"connected":false,"capacity":0,"icon":"","class":"battery-normal","name":""}'
}

declare -A bt_connected
declare -A bt_battery
declare -A bt_name

# Seed initial state
seeded=false
while IFS= read -r dev; do
    mac=$(echo "$dev" | awk '{print $2}')
    name=$(echo "$dev" | cut -d' ' -f3-)
    info=$(bluetoothctl info "$mac" 2>/dev/null)

    echo "$info" | grep -q "Connected: yes" || continue

    bt_connected[$mac]=1
    bt_name[$mac]=$name
    capacity=$(echo "$info" | grep "Battery Percentage" | grep -oP '\(\K\d+(?=\))')
    bt_battery[$mac]=${capacity:-0}
    emit "true" "${bt_battery[$mac]}" "$name"
    seeded=true
done < <(bluetoothctl devices | grep "Device")

$seeded || emit_disconnected

current_mac=""

dbus-monitor --system \
    "type='signal',interface='org.freedesktop.DBus.Properties',member='PropertiesChanged',path_namespace='/org/bluez'" \
    2>/dev/null | while IFS= read -r line; do

    # Update current device path
    if [[ "$line" == *"path="* ]]; then
        new_mac=$(echo "$line" | grep -oP 'dev_\K[A-F0-9_]+' | tr '_' ':')
        [[ -n "$new_mac" ]] && current_mac=$new_mac
    fi

    # Guard against empty mac for all handlers below
    [[ -z "$current_mac" ]] && continue

    if [[ "$line" == *'"Connected"'* ]]; then
        read -r next
        if [[ "$next" == *"true"* ]]; then
            bt_connected[$current_mac]=1
            # Seed name if we don't have it
            if [[ -z "${bt_name[$current_mac]}" ]]; then
                bt_name[$current_mac]=$(bluetoothctl info "$current_mac" 2>/dev/null \
                    | grep "Name:" | sed 's/.*Name: //')
            fi
            sleep 2
            capacity=$(bluetoothctl info "$current_mac" 2>/dev/null \
                | grep "Battery Percentage" | grep -oP '\(\K\d+(?=\))')
            bt_battery[$current_mac]=${capacity:-0}
            emit "true" "${bt_battery[$current_mac]}" "${bt_name[$current_mac]:-$current_mac}"
        else
            unset "bt_connected[$current_mac]"
            emit_disconnected
        fi
    fi

    if [[ "$line" == *'"Percentage"'* ]] || [[ "$line" == *'"BatteryPercentage"'* ]]; then
        read -r next
        capacity=$(echo "$next" | grep -oP '\d+')
        if [[ -n "$capacity" && -n "${bt_connected[$current_mac]}" ]]; then
            bt_battery[$current_mac]=$capacity
            emit "true" "$capacity" "${bt_name[$current_mac]:-$current_mac}"
        fi
    fi
done
