#!/usr/bin/env nu

def generate_graph [data, field, width: int] {
    let blocks = [" ", "▂", "▃", "▄", "▅", "▆", "▇", "█"]
    if ($data | is-empty) { return "" }

    # Take last 'width' entries first for rolling variance
    let tail_data = if ($data | length) > $width {
        $data | last $width
    } else {
        $data
    }
    
    let values = $tail_data | get $field
    
    # Determine range
    mut min = 0
    mut max = 100
    
    if $field == "capacity" {
        $min = 0
        $max = 100
    } else {
        $min = ($values | math min)
        $max = ($values | math max)
    }

    # Freeze variables for the each loop capture
    let final_min = $min
    let final_max = $max
    let final_step = (if $final_max == $final_min { 1 } else { ($final_max - $final_min) / (($blocks | length) - 1) })

    $values | each { |val|
        mut idx = (($val - $final_min) / $final_step | math floor | into int)
        if $idx >= ($blocks | length) { 
            $idx = (($blocks | length) - 1) 
        } else if $idx < 0 { 
            $idx = 0 
        }
        $blocks | get $idx
    } | str join ""
}

def main [type: string = "capacity", width: int = 20] {
    let bat_log = $"($env.HOME)/.cache/eww_battery.csv"
    let sys_log = $"($env.HOME)/.cache/eww_sys_stats.csv"
    
    let log_file = if ($type == "cpu" or $type == "mem") { $sys_log } else { $bat_log }

    if not ($log_file | path exists) {
        print ""
        return
    }

    let data = (open $log_file)
    if ($data | is-empty) {
        print ""
        return
    }

    if $type == "capacity" {
        print (generate_graph $data "capacity" $width)
    } else if $type == "power" {
        print (generate_graph $data "power" $width)
    } else if $type == "cpu" {
        print (generate_graph $data "cpu" $width)
    } else if $type == "mem" {
        print (generate_graph $data "mem" $width)
    }
}