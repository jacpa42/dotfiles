#!/bin/env /bin/sh
pgrep "$(basename "$0")" | grep -vw $$ >/dev/null && {
	notify-send "Color picker is already running"
	exit 0
}

sleep 0.1 # so that wmenu disappears :(

exec hyprpicker -ar -f"${fmt:-hex}"
