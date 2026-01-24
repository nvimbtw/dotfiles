#!/usr/bin/env nu

def get_active_window [] {
    let win = (hyprctl -j activewindow | from json)

    if not ("initialTitle" in ($win | columns)) {
        print "  Desktop"
    } else {
        print $"  ($win.initialTitle)"
    }
}

get_active_window

socat -u $"UNIX-CONNECT:($env.XDG_RUNTIME_DIR)/hypr/($env.HYPRLAND_INSTANCE_SIGNATURE)/.socket2.sock" - | lines | each { |line|
    if ($line | str starts-with "activewindow>>") {
        get_active_window 
    }
}
