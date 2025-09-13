#!/bin/sh

pgrep "$(basename "$0")" | grep -vw $$ >/dev/null && {
	notify-send "Color picker is already running"
	exit 0
}

hyprpicker -ar -f"${fmt:-hex}"
