if ((^tty | str trim) == "/dev/tty1") {
    exec uwsm start hyprland.desktop
}

$env.config.show_banner = false
$env.LANG = "en_US.UTF-8"
$env.LC_ALL = "en_US.UTF-8"

mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

source ~/.zoxide.nu
