#!/usr/bin/env bash

# Kanagawa Dragon colors
CYAN="#8ea4a2"
PURPLE="#c4b28a"
PINK="#b6927b"
BASE03="#625e5a"

# 1. Get input
# We loop so the user can do multiple calculations without closing
while true; do
    input=$(rofi -dmenu -p "CALC" -theme-str 'entry { placeholder: "ENTER EXPRESSION (e.g. 256/4)"; }')

    if [ -z "$input" ]; then
        exit 0
    fi

    # 2. Calculate using bc -l
    # -l for math lib (floating point)
    # scale=2 for 2 decimal places by default
    result=$(echo "scale=2; $input" | bc -l | sed 's/\.00$//')

    if [ $? -ne 0 ]; then
        notify-send "Calculator" "Invalid expression"
        continue
    fi

    # 3. Show result and offer to copy
    # If they press enter on the result, it copies and exits
    # If they press escape, it goes back to input
    copy=$(echo -e "󰆏  COPY RESULT\n󰑐  NEW CALC" | rofi -dmenu -i -p "=$result")

    if [ "$copy" == "󰆏  COPY RESULT" ]; then
        echo -n "$result" | wl-copy
        notify-send "Calculator" "Result $result copied to clipboard"
        exit 0
    elif [ "$copy" == "󰑐  NEW CALC" ]; then
        continue
    else
        exit 0
    fi
done
