#!/usr/bin/env bash

clock_icons=("󱑋 " "󱑌 " "󱑍 " "󱑎 " "󱑏 " "󱑐 " "󱑑 " "󱑒 " "󱑓 " "󱑔 " "󱑕 " "󱑖 ")

while true; do
    hour=$(date +"%I")
    hour=$((10#$hour))

    minute=$(date +"%M")

    icon=${clock_icons[$((hour-1))]}

    printf "%s %02d:%02d\n" "$icon" "$hour" "$minute"

    sleep 60
done
