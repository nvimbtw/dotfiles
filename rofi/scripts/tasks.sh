#!/usr/bin/env bash

# Kanagawa Dragon colors
CYAN="#8ea4a2"
PURPLE="#c4b28a"
PINK="#b6927b"
BASE03="#625e5a"

# 1. Main Loop
while true; do
    # Get Task list (format: ID - DESCRIPTION [DUE])
    # Filter out empty lines and "No matches"
    task_list=$(task rc.verbose=nothing rc.report.next.columns=id,description,due.relative rc.report.next.labels=ID,DESC,DUE next | sed 's/  */ /g')
    
    if [ -z "$task_list" ]; then
        display_list="󰑐  NEW TASK"
    else
        display_list="󰑐  NEW TASK\n$task_list"
    fi

    # 2. Show Rofi
    selected=$(echo -e "$display_list" | rofi -dmenu -i -p "TASK" -theme-str 'listview { lines: 10; }')

    if [ -z "$selected" ]; then exit 0; fi

    if [ "$selected" == "󰑐  NEW TASK" ]; then
        new_task=$(rofi -dmenu -p "ADD" -theme-str 'entry { placeholder: "TASK DESCRIPTION..."; }')
        if [ -n "$new_task" ]; then
            task add "$new_task"
            notify-send "Tasks" "Added: $new_task"
        fi
        continue
    fi

    # 3. Extract Task ID (first field)
    task_id=$(echo "$selected" | awk '{print $1}')
    task_desc=$(echo "$selected" | cut -d' ' -f2-)

    # 4. Action Menu for selected task
    action=$(echo -e "󰄬  DONE\n󰆴  DELETE\n󰑐  BACK" | rofi -dmenu -i -p "ACTION")

    case $action in
        "󰄬  DONE")
            task "$task_id" done
            notify-send "Tasks" "Completed: $task_desc"
            ;;
        "󰆴  DELETE")
            task "$task_id" delete rc.confirmation=off
            notify-send "Tasks" "Deleted: $task_desc"
            ;;
        "󰑐  BACK")
            continue
            ;;
    esac
done
