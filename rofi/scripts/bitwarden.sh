#!/usr/bin/env bash

# Kanagawa Dragon colors
CYAN="#8ea4a2"
PURPLE="#c4b28a"
PINK="#b6927b"
BASE03="#625e5a"

CACHE_FILE="$HOME/.cache/bw_vault.json"

# Function to unlock and get session
unlock_vault() {
    local pass=$(rofi -dmenu -password -p "Unlock" -theme-str 'entry { placeholder: "MASTER PASSWORD"; }')
    if [ -z "$pass" ]; then exit 1; fi
    BW_SESSION=$(echo "$pass" | bw unlock --raw)
    if [ $? -ne 0 ]; then
        notify-send "Bitwarden" "Failed to unlock vault."
        exit 1
    fi
    export BW_SESSION
}

# 1. Ensure BW_SESSION exists if not unlocked
if ! bw status | grep -q '"status":"unlocked"'; then
    unlock_vault
fi

# 2. Check if cache exists, if not, create it
if [ ! -f "$CACHE_FILE" ]; then
    notify-send "Bitwarden" "Building initial cache (this may take a moment)..."
    bw sync --session "$BW_SESSION" > /dev/null
    bw list items --session "$BW_SESSION" > "$CACHE_FILE"
fi

# 3. Main Loop/UI
while true; do
    # Load items from cache
    items=$(cat "$CACHE_FILE")
    
    # Prepend a Sync option
    selected_item=$( (echo "󰑐 SYNC VAULT"; echo "$items" | jq -r '.[] | .name + " [" + (.login.username // "no user") + "]"') | sort | rofi -dmenu -i -p "PASS" -theme-str 'listview { lines: 10; }')

    if [ -z "$selected_item" ]; then exit 0; fi

    if [ "$selected_item" == "󰑐 SYNC VAULT" ]; then
        notify-send "Bitwarden" "Syncing vault..."
        bw sync --session "$BW_SESSION" > /dev/null
        bw list items --session "$BW_SESSION" > "$CACHE_FILE"
        notify-send "Bitwarden" "Sync complete."
        continue
    fi

    # Extract name and get item data
    item_name=$(echo "$selected_item" | sed 's/ \[.*//')
    item_data=$(echo "$items" | jq -r --arg name "$item_name" '.[] | select(.name == $name)')

    # Menu for specific item
    options=""
    has_pass=$(echo "$item_data" | jq -r '.login.password // empty')
    has_user=$(echo "$item_data" | jq -r '.login.username // empty')
    has_totp=$(echo "$item_data" | jq -r '.login.totp // empty')

    [ -n "$has_pass" ] && options+="Password\n"
    [ -n "$has_user" ] && options+="Username\n"
    [ -n "$has_totp" ] && options+="TOTP\n"
    options+="Back"

    choice=$(echo -e "$options" | rofi -dmenu -i -p "COPY")

    case $choice in
        "Password")
            echo -n "$has_pass" | wl-copy
            notify-send "Bitwarden" "Password copied."
            exit 0
            ;;
        "Username")
            echo -n "$has_user" | wl-copy
            notify-send "Bitwarden" "Username copied."
            exit 0
            ;;
        "TOTP")
            totp=$(bw get totp "$item_name" --session "$BW_SESSION")
            echo -n "$totp" | wl-copy
            notify-send "Bitwarden" "TOTP copied."
            exit 0
            ;;
        "Back")
            continue
            ;;
        *)
            exit 0
            ;;
    esac
done
