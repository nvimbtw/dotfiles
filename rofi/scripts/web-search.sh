#!/usr/bin/env bash

# Oxocarbon colors
CYAN="#3ddbd9"
PURPLE="#be95ff"
PINK="#ff7eb6"
BASE03="#525252"

# 1. Get Search Query
query=$(rofi -dmenu -p "SEARCH" -theme-str 'entry { placeholder: "URL OR SEARCH..."; }')

if [ -z "$query" ]; then
    exit 0
fi

# 2. Check if it's a URL or a search query
# Regex: starts with http/https OR contains a dot and no spaces (e.g. github.com)
if [[ "$query" =~ ^https?:// ]] || [[ "$query" =~ ^[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}(/.*)?$ ]] || [[ "$query" == "localhost"* ]]; then
    # It looks like a URL
    url="$query"
    # Prepend https:// if no protocol is specified
    if [[ ! "$url" =~ ^https?:// ]]; then
        url="https://$url"
    fi
    chromium "$url" &
else
    # It's a search query
    encoded_query=$(echo "$query" | sed 's/ /+/g')
    chromium "https://www.google.com/search?q=$encoded_query" &
fi

disown
exit 0
