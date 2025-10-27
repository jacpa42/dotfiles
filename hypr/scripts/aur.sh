#!/bin/env /bin/sh
pgrep wmenu | grep -vw $$ >/dev/null && {
	notify-send "wmenu already running"
	exit 0
}

# Requires urlencode and wmenu

selected="$(echo "" | eval wmenu -p"aursearch" $wmenu_opts -l0)"
[ -z "$selected" ] && exit 0

url="https://aur.archlinux.org/packages?K=$(echo "$selected" | urlencode -nb)"
firefox --new-tab "$url"
