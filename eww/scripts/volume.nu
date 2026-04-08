#!/usr/bin/env bash

# Function to get volume and print with icon
print_volume() {
    # Get volume from PipeWire
    vol_output=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null)

    # Extract the volume number (e.g., "Volume: 0.30" -> 30)
    vol=$(echo "$vol_output" | awk '{printf "%.0f", $2 * 100}')

    # Check if muted
    muted=$(echo "$vol_output" | grep "MUTED" && echo "yes" || echo "no")

    # check for muting and volume levels
    if [ "$muted" = "yes" ] || [ "$vol" -eq 0 ]; then
        icon="󰝟"   # muted
    elif [ "$vol" -le 30 ]; then
        icon="󰕿"   # low
    elif [ "$vol" -le 70 ]; then
        icon="󰖀"   # medium
    else
        icon="󰕾"   # high
    fi

    echo "{\"icon\": \"$icon\", \"vol\": \"$vol%\"}"
}

# Print initial value
print_volume

# Watch for sink changes using pactl subscribe
pactl subscribe 2>/dev/null | grep --line-buffered "sink" | while read -r _; do
    print_volume
done
