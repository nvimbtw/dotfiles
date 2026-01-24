#!/usr/bin/env bash

file="$HOME/.tmp/volume.txt"

# Ensure the file exists
[ -f "$file" ] || echo 0 > "$file"

# Function to print the volume with an icon
print_volume() {
    vol=$(<"$file")       # read the number
    vol=${vol//[^0-9]/}  # sanitize just in case

    # check for bluetooth
    if bluetoothctl devices Connected | grep -q "Device"; then
        icon="󰋋" # Wireless earbuds/headset icon
    elif [ "$vol" -eq 0 ]; then
        icon=""   # muted
    elif [ "$vol" -le 30 ]; then
        icon=""   # low
    elif [ "$vol" -le 70 ]; then
        icon=""   # medium
    else
        icon=""   # high
    fi

    echo "$icon  $vol%"
}

# Print initial value
print_volume

# Watch for changes
inotifywait -m -e close_write "$file" | while read -r _; do
    print_volume
done
