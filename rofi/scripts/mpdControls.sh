#!/bin/bash

options="Play/Pause\nNext\nPrevious\nStop\nRandom Toggle\nRepeat Toggle\nClear Queue\nUpdate Library"

chosen=$(echo -e "$options" | rofi -dmenu -p "MPD Controls")

case $chosen in
    "Play/Pause")
        mpc toggle
        ;;
    "Next")
        mpc next
        ;;
    "Previous")
        mpc prev
        ;;
    "Stop")
        mpc stop
        ;;
    "Random Toggle")
        mpc random
        ;;
    "Repeat Toggle")
        mpc repeat
        ;;
    "Clear Queue")
        mpc clear
        ;;
    "Update Library")
        mpc update
        ;;
esac
