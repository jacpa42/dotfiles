pgrep "$(basename "$0")" | grep -vw $$ >/dev/null && {
    notify-send -a "picker" -t 1000 -r 666 "color picker is already running"
    exit 0
}

hyprctl dispatch exec "hyprpicker -ar -f"${fmt:-hex}""
