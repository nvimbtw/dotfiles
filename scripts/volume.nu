#!/usr/bin/env nu

def main [
    vol: int 
] {
    pamixer --set-volume $vol
    echo $vol | save --force ~/.tmp/volume.txt
}
