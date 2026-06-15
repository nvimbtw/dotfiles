hl.config({
    general = {
        gaps_in = 1,
        gaps_out = 1,
        border_size = 1,
        ["col.active_border"] = "0xFF525252",
        ["col.inactive_border"] = "0x33262626",
        resize_on_border = false,
        allow_tearing = false,
        layout = "dwindle",
    },
    decoration = {
        rounding = 1,
        rounding_power = 1,
        active_opacity = 1.0,
        inactive_opacity = 1.0,
        shadow = {
            enabled = false
        },
        blur = {
            enabled = true,
            size = 4,
            passes = 3,
            vibrancy = 0.1696,
            popups = true,
            special = true,
        }
    },
    master = {
        new_status = "master"
    },
    misc = {
        force_default_wallpaper = 1,
        disable_hyprland_logo = true,
        -- vfr = true,
        disable_autoreload = true
    },
    debug = {
        vfr = true,
    },
    input = {
        kb_layout = "us,si",
        kb_options = "caps:swapescape,grp:win_space_toggle",
        follow_mouse = 1,
        sensitivity = 0,
        touchpad = {
            natural_scroll = true,
            scroll_factor = 0.25
        },
        repeat_rate = 50,
        repeat_delay = 200
    }
})

hl.device({
    name = "epic-mouse-v1",
    sensitivity = -0.5
})
