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
        let total_hours = if $trend_arrow == $up_arrow {
            (($energy_full - $energy_now) / $power_now)
        } else {
            ($energy_now / $power_now)
        }
        
        # Round to nearest minute to avoid "60m" display
        let total_mins = ($total_hours * 60 | math round)
        let hours = ($total_mins / 60 | math floor)
        let mins = ($total_mins mod 60)
        
        $time_left_msg = $"($hours)h ($mins)m ($trend_arrow)"
        $display_time = $" [($hours)h ($mins)m ($trend_arrow)]"
        
        if $trend_arrow == $up_arrow {
            $icon = "󰂄"
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
        display: $"($icon) ($capacity)%",
        power: $power_now,
        power_input: (if $status == "Charging" or $trend_arrow == $up_arrow { $power_now } else { 0 }),
        energy: $energy_now
    })

    print ($json_output | to json --raw)

    # Return current stats for next iteration and logging
    $json_output
}

let log_file = $"($env.HOME)/.cache/eww_battery.csv"

def log_battery [stats] {
    let now = (date now | into int)
    let row = {
        timestamp: $now, 
        capacity: $stats.capacity, 
        power: $stats.power, 
        status: $stats.status
    }
    
    if not ($log_file | path exists) {
        [$row] | save $log_file
    } else {
        # Append and prune older than 24h
        let day_ago = ((date now) - 24hr | into int)
        let data = (open $log_file | append $row | where timestamp > $day_ago)
        $data | save $log_file --force
    }
}

# Output initial battery state
mut stats = (get_battery -1)
log_battery $stats
mut prev_energy = $stats.energy

# Update every 10 seconds
loop {
    sleep 10sec
    $stats = (get_battery $prev_energy)
    log_battery $stats
    $prev_energy = $stats.energy
}
