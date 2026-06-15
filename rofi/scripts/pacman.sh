#!/usr/bin/env bash
# Pacman package manager integration for rofi
# Choose action first, then package

action=$(echo -e "Search\nInstall\nRemove\nUpdate System\nUpdate Package List" | rofi -dmenu -p "Pacman Action")

case "$action" in
    "Search")
        # Search in both AUR and official repos
        query=$(rofi -dmenu -p "Search package")
        if [ -z "$query" ]; then exit 0; fi

        # Pacman search (official repos)
        result=$(pacman -Ss "$query" | grep -E "^[^ ]" | awk '{print $1}' | rofi -dmenu -p "Install" -display-columns 1)

        if [ -n "$result" ]; then
            # Show package info and confirm
            pacman -Si "$result" | rofi -dmenu -i -p "Install $result?" || true
            notify-send "Installing $result..." -t 2000
            pkexec pacman -S "$result"
            notify-send "Installed $result" -t 2000
        fi
        ;;
    "Install")
        # Direct package name input
        package=$(rofi -dmenu -p "Package to install")
        if [ -z "$package" ]; then exit 0; fi

        notify-send "Installing $package..." -t 2000
        pkexec pacman -S "$package"
        notify-send "Installed $package" -t 2000
        ;;
    "Remove")
        # List installed packages
        package=$(pacman -Q | awk '{print $1}' | rofi -dmenu -p "Remove package")
        if [ -z "$package" ]; then exit 0; fi

        confirm=$(echo -e "Yes\nNo" | rofi -dmenu -p "Remove $package?")
        if [ "$confirm" = "Yes" ]; then
            notify-send "Removing $package..." -t 2000
            pkexec pacman -R "$package"
            notify-send "Removed $package" -t 2000
        fi
        ;;
    "Update System")
        notify-send "Updating system..." -t 2000
        pkexec pacman -Syu
        notify-send "System updated" -t 3000
        ;;
    "Update Package List")
        notify-send "Syncing package database..." -t 2000
        pkexec pacman -Sy
        notify-send "Package list updated" -t 2000
        ;;
esac
