#!/usr/bin/env nu

def get_layout [] {
    let devices = (hyprctl -j devices | from json)
    let main_kb = ($devices.keyboards | where main == true | first)
    let layout = ($main_kb.active_keymap)
    let short_layout = (match $layout {
        "English (US)" => "Eng",
        "Slovenian" => "Slo",
        _ => $layout
    })
    print ({"icon": "󰌌", "layout": $short_layout} | to json --raw)
}

get_layout

socat -u $"UNIX-CONNECT:($env.XDG_RUNTIME_DIR)/hypr/($env.HYPRLAND_INSTANCE_SIGNATURE)/.socket2.sock" - 
| lines 
| each { |line|
    if ($line | str starts-with "activelayout>>") {
        get_layout
    }
}
