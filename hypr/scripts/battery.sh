#!/usr/bin/env nu

def get_battery [] {
    let energy_now = (open /sys/class/power_supply/BAT0/energy_now | str trim | into int)
    let energy_full = (open /sys/class/power_supply/BAT0/energy_full | str trim | into int)
    let power_now = (open /sys/class/power_supply/BAT0/power_now | str trim | into int)
    let status = (open /sys/class/power_supply/BAT0/status | str trim)
    let capacity = (open /sys/class/power_supply/BAT0/capacity | str trim | into int)

    let batteryNerdFonts = ["󰂎", "󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"]
    let idx = ($capacity / 10 | math floor)
    let idx = (if $idx > 10 { 10 } else { $idx })
    mut icon = ($batteryNerdFonts | get $idx)

    mut time_left_msg = ""
    mut display_time = ""
    if $status == "Charging" {
        $icon = "󰂄"
        if $power_now > 0 {
            let hours = (($energy_full - $energy_now) / $power_now)
            let mins = (($hours - ($hours | math floor)) * 60 | math round)
            $time_left_msg = $"($hours | math floor)h ($mins)m until full"
            $display_time = $" [($hours | math floor)h ($mins)m]"
        }
    } else if $status == "Discharging" {
        if $power_now > 0 {
            let hours = ($energy_now / $power_now)
            let mins = (($hours - ($hours | math floor)) * 60 | math round)
            $time_left_msg = $"($hours | math floor)h ($mins)m left"
        }
    }

    let class = if $status == "Charging" {
        "battery-charging"
    } else if $capacity < 20 {
        "battery-low"
    } else {
        "battery-normal"
    }

    {
        capacity: $capacity,
        icon: $icon,
        status: $status,
        time_left: $time_left_msg,
        class: $class,
        display: $"($icon) ($capacity)%($display_time)"
    } | to json --raw
}

print (get_battery)
