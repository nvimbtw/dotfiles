#!/usr/bin/env bash

clock_icons=("󱑋" "󱑌" "󱑍" "󱑎" "󱑏" "󱑐" "󱑑" "󱑒" "󱑓" "󱑔" "󱑕" "󱑖")

while true; do
    hour=$(date +"%I")
    hour=$((10#$hour))
    minute=$(date +"%M")

    icon=${clock_icons[$((hour-1))]}
    time=$(date +"%I:%M")

    echo "{\"icon\": \"$icon\", \"time\": \"$time\"}"

    sleep 60
done
