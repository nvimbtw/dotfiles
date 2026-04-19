#!/usr/bin/env bash

# Get task completion statistics
pending=$(task export status:pending 2>/dev/null | jq 'length // 0')
completed=$(task export status:completed 2>/dev/null | jq 'length // 0')

total=$((pending + completed))

if [ "$total" -eq 0 ]; then
    echo "0"
else
    percentage=$((completed * 100 / total))
    echo "$percentage"
fi