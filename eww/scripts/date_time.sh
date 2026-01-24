#!/usr/bin/env nu

let date = (date now | format date "%-d. %b")
print $"  ($date)"
