#!/bin/sh
pgrep "$(basename "$0")" | grep -vw $$ >/dev/null && {
	notify-send "Screenshot is already running"
	exit 1
}

screenshot_path="$HOME/Pictures/screenshots/grimshot_$(date '+%Y-%m-%d_%H-%M-%S.%3N').png"
grim -g "$(slurp)" "$screenshot_path" && wl-copy <"$screenshot_path" || exit 0
notify-send --urgency=low --expire-time=5000 --app-name="hyprpicker" "Screenshot saved to" "$(dirname "$screenshot_path")"
