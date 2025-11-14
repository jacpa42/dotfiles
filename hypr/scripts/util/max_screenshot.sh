pgrep "$(basename "$0")" | grep -vw $$ >/dev/null && {
    notify-send -a "picker" -t 1000 -r 666 "screenshot tool is already running"
    exit 1
}

hyprctl dispatch 'exec sh -c
screenshot_path="$HOME/Pictures/screenshots/grimshot_$(date "+%Y-%m-%d_%H-%M-%S.%N").png"
grim "$screenshot_path" && wl-copy <"$screenshot_path" || exit 0
notify-send --urgency=low --expire-time=5000 --app-name="hyprpicker" "Screenshot saved to" "$(dirname "$screenshot_path")"'
exit
