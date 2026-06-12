#!/usr/bin/env bash

# Machine-readable output: device,class,current,percent,max
BRIGHT=$(brightnessctl -m 2>/dev/null | cut -d, -f4 | tr -d '%')
echo "${BRIGHT:-0}"
