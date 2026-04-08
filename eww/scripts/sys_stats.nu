#!/usr/bin/env nu

def get_stats [] {
    # CPU Usage (average of all cores)
    # Skip the "cpu" string at the start of the first line
    let cpu_line_start = (open /proc/stat | lines | first | split row -r '\s+' | drop 1 | where { $in != "" } | skip 1 | into int)
    sleep 1sec # Increased from 500ms for better smoothing
    let cpu_line_end = (open /proc/stat | lines | first | split row -r '\s+' | drop 1 | where { $in != "" } | skip 1 | into int)
    
    let total_start = ($cpu_line_start | math sum)
    let idle_start = ($cpu_line_start | get 3)
    
    let total_end = ($cpu_line_end | math sum)
    let idle_end = ($cpu_line_end | get 3)
    
    let total_delta = ($total_end - $total_start)
    let idle_delta = ($idle_end - $idle_start)
    
    let cpu_usage = (if $total_delta > 0 {
        (100 * (1 - ($idle_delta / $total_delta)) | math round)
    } else { 0 })

    # Memory Usage
    let mem = (open /proc/meminfo | lines | reduce -f {} { |it, acc| 
        let parts = ($it | split row -r ':\s+')
        if ($parts | length) >= 2 {
            let key = ($parts | get 0)
            let val = ($parts | get 1 | str replace -r ' kB' '' | str trim | into int)
            $acc | insert $key $val
        } else {
            $acc
        }
    })
    
    let mem_total = $mem.MemTotal
    let mem_free = $mem.MemFree
    let mem_cached = ($mem | get --optional Cached | default 0)
    let mem_buffers = ($mem | get --optional Buffers | default 0)
    let mem_sreclaimable = ($mem | get --optional SReclaimable | default 0)
    
    # Better estimation of "used" memory
    let mem_used = ($mem_total - $mem_free - $mem_cached - $mem_buffers - $mem_sreclaimable)
    let mem_usage = (100 * ($mem_used / $mem_total) | math round)

    {
        cpu: $cpu_usage,
        mem: $mem_usage,
        mem_used_gb: (($mem_used / 1024 / 1024) | math round --precision 1),
        mem_total_gb: (($mem_total / 1024 / 1024) | math round --precision 1)
    }
}

def log_stats [stats] {
    let log_file = $"($env.HOME)/.cache/eww_sys_stats.csv"
    let now = (date now | into int)
    let row = {
        timestamp: $now, 
        cpu: $stats.cpu, 
        mem: $stats.mem
    }
    
    if not ($log_file | path exists) {
        [$row] | save $log_file
    } else {
        let day_ago = ((date now) - 24hr | into int)
        let data = (open $log_file | append $row | where timestamp > $day_ago)
        $data | save $log_file --force
    }
}

# Continuous output for eww
loop {
    let stats = (get_stats)
    print ($stats | to json --raw)
    log_stats $stats
    sleep 2sec
}
