#!/bin/bash

selection=$(mpc listall --format '%artist% - %title%' | rofi -dmenu -i -p "Select Song")

if [ -n "$song" ]; then
    mpc clear
    mpc add "$song"
    mpc play
fi
