#!/bin/bash

options="Suspend\nReboot\nShutdown"

chosen=$(echo -e "$options" | rofi -dmenu -p "System:")

case $chosen in
    "Suspend")
        systemctl suspend
        ;;
    "Reboot")
        systemctl reboot
        ;;
    "Shutdown")
        systemctl poweroff
        ;;
esac
