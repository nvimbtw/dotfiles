#!/usr/bin/env nu

def get_workspaces [] {
    let workspaces = (hyprctl -j workspaces | from json | sort-by id)
    let active_workspace = (hyprctl -j activeworkspace | from json).id
    let ws = ($workspaces | each { |w| { id: $w.id, active: ($w.id == $active_workspace) } })
    print ($ws | to json --raw)
}

get_workspaces

socat -u $"UNIX-CONNECT:($env.XDG_RUNTIME_DIR)/hypr/($env.HYPRLAND_INSTANCE_SIGNATURE)/.socket2.sock" - 
| lines 
| each { |line|
    let prefixes = ["workspace>>", "createworkspace>>", "destroyworkspace>>"]
    if ($prefixes | any { |p| $line | str starts-with $p }) {
        get_workspaces
    }
}
