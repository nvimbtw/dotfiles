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
    animations = {
        enabled = true,
        bezier = {
            { "easeOutQuint",   0.23, 1,    0.32, 1 },
            { "easeInOutCubic", 0.65, 0.05, 0.36, 1 },
            { "linear",         0,    0,    1,    1 },
            { "almostLinear",   0.5,  0.5,  0.75, 1.0 },
            { "quick",          0.15, 0,    0.1,  1 },
        },
        animation = {
            { "global",        1, 10,  "default" },
            { "border",        1, 1,   "easeOutQuint" },
            { "windows",       1, 1,   "easeOutQuint" },
            { "windowsIn",     1, 1,   "easeOutQuint", "popin 87%" },
            { "windowsOut",    1, 0.8, "linear",       "popin 87%" },
            { "fadeIn",        1, 0.8, "almostLinear" },
            { "fadeOut",       1, 0.7, "almostLinear" },
            { "fade",          1, 1,   "quick" },
            { "layers",        1, 1.5, "easeOutQuint" },
            { "layersIn",      1, 1.5, "easeOutQuint", "fade" },
            { "layersOut",     1, 0.8, "linear",       "fade" },
            { "fadeLayersIn",  1, 0.8, "almostLinear" },
            { "fadeLayersOut", 1, 0.7, "almostLinear" },
            { "workspaces",    1, 0.8, "almostLinear", "fade" },
            { "workspacesIn",  1, 0.6, "almostLinear", "fade" },
            { "workspacesOut", 1, 0.8, "almostLinear", "fade" },
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
