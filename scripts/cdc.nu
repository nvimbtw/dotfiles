#!/usr/bin/env nu

def main [
    dir: string
] {
    let target = $"~/.config/($dir)"
    if ($target | path exists) {
        cd $target
    } else {
        error make {msg: $"Directory ($target) does not exist"}
    }
}
