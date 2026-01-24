#!/usr/bin/env nu

pamixer --decrease 5
let vol = (pamixer --get-volume)
echo $vol | save --force ~/.tmp/volume.txt
