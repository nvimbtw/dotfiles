-- Programs
local mainMod = "ALT"
local terminal = "ghostty"
local fileManager = "dolphin"
local rofiDrun = "rofi -show drun"
local rofiWindow = "rofi -show window"
local rofiRun = "rofi -show run"

-- Screenshots
hl.bind("Print", hl.dsp.exec_cmd("hyprshot -m output -m eDP-1 -o ~/Pictures/Screenshots"))
hl.bind(mainMod .. " + Print", hl.dsp.exec_cmd("hyprshot -m region -o ~/Pictures/Screenshots"))

-- Rofi Submap
hl.bind(mainMod .. " + Space", hl.dsp.submap("rofi"))
hl.define_submap("rofi", function()
    hl.bind("D", function()
        hl.dispatch(hl.dsp.exec_cmd(rofiDrun))
        hl.dispatch(hl.dsp.submap("reset"))
    end)
    hl.bind("W", function()
        hl.dispatch(hl.dsp.exec_cmd(rofiWindow))
        hl.dispatch(hl.dsp.submap("reset"))
    end)
    hl.bind("R", function()
        hl.dispatch(hl.dsp.exec_cmd(rofiRun))
        hl.dispatch(hl.dsp.submap("reset"))
    end)
    hl.bind("P", function()
        hl.dispatch(hl.dsp.exec_cmd("~/.config/rofi/scripts/bitwarden.sh"))
        hl.dispatch(hl.dsp.submap("reset"))
    end)
    hl.bind("S", function()
        hl.dispatch(hl.dsp.exec_cmd("~/.config/rofi/scripts/systemControl.sh"))
        hl.dispatch(hl.dsp.submap("reset"))
    end)
    hl.bind("G", function()
        hl.dispatch(hl.dsp.exec_cmd("~/.config/rofi/scripts/web-search.sh"))
        hl.dispatch(hl.dsp.submap("reset"))
    end)
    hl.bind("K", function()
        hl.dispatch(hl.dsp.exec_cmd("~/.config/rofi/scripts/calc.sh"))
        hl.dispatch(hl.dsp.submap("reset"))
    end)
    hl.bind("T", function()
        hl.dispatch(hl.dsp.exec_cmd("~/.config/rofi/scripts/tasks.sh"))
        hl.dispatch(hl.dsp.submap("reset"))
    end)
    hl.bind("C", function()
        hl.dispatch(hl.dsp.exec_cmd("cliphist list | rofi -dmenu -display-columns 2 | cliphist decode | wl-copy"))
        hl.dispatch(hl.dsp.submap("reset"))
    end)
    hl.bind("B", function()
        hl.dispatch(hl.dsp.exec_cmd("~/.config/rofi/scripts/bluetooth.sh"))
        hl.dispatch(hl.dsp.submap("reset"))
    end)
    hl.bind("N", function()
        hl.dispatch(hl.dsp.exec_cmd("~/.config/rofi/scripts/network-switcher.sh"))
        hl.dispatch(hl.dsp.submap("reset"))
    end)
    hl.bind("M", function()
        hl.dispatch(hl.dsp.exec_cmd("~/.config/rofi/scripts/pacman.sh"))
        hl.dispatch(hl.dsp.submap("reset"))
    end)
    hl.bind("escape", hl.dsp.submap("reset"))
end)

-- Basic Binds
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("cliphist wipe"))
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + T", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("chromium"))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd("eww reload"))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("eww open console"))
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.exec_cmd("eww close console"))
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("swaync-client -t -sw"))
hl.bind(mainMod .. " + Y", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + F", hl.dsp.exec_cmd("/home/x_x/Downloads/organize_downloads.sh"))

-- Focus
hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "down" }))

-- Move window
hl.bind(mainMod .. " + SHIFT + h", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + l", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + k", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + j", hl.dsp.window.move({ direction = "down" }))

-- Workspaces
for i = 1, 9 do
    hl.bind(mainMod .. " + " .. i, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end
hl.bind(mainMod .. " + 0", hl.dsp.focus({ workspace = 10 }))
hl.bind(mainMod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }))

-- Mouse workspace scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Brightness
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set +10%"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 10%-"), { locked = true, repeating = true })

-- Volume (was bindel — now hl.bind with locked + repeating flags)
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+"),
    { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
    { locked = true, repeating = true })

-- Mouse binds (was bindm — now hl.bind with { mouse = true })
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
