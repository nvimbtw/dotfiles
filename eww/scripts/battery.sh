#!/usr/bin/env nu

def get_battery [prev_energy: int] {
    let energy_now = (open /sys/class/power_supply/BAT0/energy_now | str trim | into int)
    let energy_full = (open /sys/class/power_supply/BAT0/energy_full | str trim | into int)
    let power_now = (open /sys/class/power_supply/BAT0/power_now | str trim | into int)
    let status = (open /sys/class/power_supply/BAT0/status | str trim)
    let capacity = (open /sys/class/power_supply/BAT0/capacity | str trim | into int)

    let batteryNerdFonts = ["󰂎", "󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"]
    let idx = ($capacity / 10 | math floor)
    let idx = (if $idx > 10 { 10 } else { $idx })
    mut icon = ($batteryNerdFonts | get $idx)

    # Determine actual charging/discharging trend based on energy flow
    let up_arrow = "↑"
    let down_arrow = "↓"
    mut trend_arrow = ""
    if $prev_energy != -1 {
        if $energy_now > $prev_energy {
            $trend_arrow = $up_arrow  # Actually charging
        } else if $energy_now < $prev_energy {
            $trend_arrow = $down_arrow  # Actually discharging
        } else {
            # If energy hasn't changed, use status as fallback
            $trend_arrow = if $status == "Charging" { $up_arrow } else { $down_arrow }
        }
    } else {
        # First run, use status to determine arrow
        $trend_arrow = if $status == "Charging" { $up_arrow } else { $down_arrow }
    }

    mut time_left_msg = ""
    mut display_time = ""

    # Calculate time remaining based on actual energy flow
    if $power_now > 0 {
        if $trend_arrow == $up_arrow {
            # Charging - time until full
            let hours = (($energy_full - $energy_now) / $power_now)
            let mins = (($hours - ($hours | math floor)) * 60 | math round)
            $time_left_msg = $"($hours | math floor)h ($mins)m until full"
            $display_time = $" [($hours | math floor)h ($mins)m ($trend_arrow)]"
            $icon = "󰂄"
        } else {
            # Discharging - time until empty
            let hours = ($energy_now / $power_now)
            let mins = (($hours - ($hours | math floor)) * 60 | math round)
            $time_left_msg = $"($hours | math floor)h ($mins)m left"
            $display_time = $" [($hours | math floor)h ($mins)m ($trend_arrow)]"
        }
    } else {
        # Power now is 0, just show arrow without time
        $display_time = $" [($trend_arrow)]"
    }

    let class = if $trend_arrow == $up_arrow {
        "battery-charging"
    } else if $capacity < 20 {
        "battery-low"
    } else {
        "battery-normal"
    }

    let json_output = ({
        capacity: $capacity,
        icon: $icon,
        status: $status,
        time_left: $time_left_msg,
        class: $class,
        display: $"($icon) ($capacity)%($display_time)"
    } | to json --raw)

    print $json_output

    # Return current energy for next iteration
    $energy_now
}

# Output initial battery state
mut prev_energy = (get_battery -1)

# Update every 10 seconds
loop {
    sleep 10sec
    $prev_energy = (get_battery $prev_energy)
}
