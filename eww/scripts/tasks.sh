#!/usr/bin/env bash

# Output the 'next' task list as JSON for eww.
# Keep only the fields the widget uses and format 'due' (taskwarrior stores
# UTC like 20260615T000000Z) as a readable local time.
out=$(task export next 2>/dev/null | jq -c 'map({
    id,
    description,
    due: (if .due then (.due | strptime("%Y%m%dT%H%M%SZ") | mktime | localtime | strftime("%d %b %H:%M")) else "" end)
})' 2>/dev/null)

echo "${out:-[]}"
