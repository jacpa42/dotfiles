#!/bin/env /bin/sh
pgrep wmenu | grep -vw $$ >/dev/null && {
	notify-send "wmenu already running"
	exit 0
}

# Requires urlencode and wmenu

selected="$(echo "" | eval wmenu -p"websearch" $wmenu_opts -l0)"
[ -z "$selected" ] && exit 0

url="https://www.google.com/search?q=$(echo "$selected" | urlencode -nb)&udm=14"
firefox --new-tab "$url"
