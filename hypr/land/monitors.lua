hl.monitor({
    output   = "eDP-1",
    mode     = "2560x1600@60",
    position = "0x0",
    scale    = 2,
})

hl.monitor({
    output   = "HDMI-A-1",
    mode     = "highrr",
    position = "1280x0",
    scale    = 1,
    mirror   = "eDP-1",
})
