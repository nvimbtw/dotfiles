#!/usr/bin/env bash

# Get brightness percentage
# Assumes brightnessctl is installed
BRIGHT=$(brightnessctl i | grep -oP '\(\K[^%]+')
echo "$BRIGHT"
