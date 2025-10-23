#!/bin/env /bin/sh
pgrep wmenu | grep -vw $$ >/dev/null && {
	notify-send "wmenu already running"
	exit 0
}

eval wmenu -p"emoji" $wmenu_opts <$HOME/Projects/dotfiles/hypr/wmenu/emojis | awk '{printf "%s", $NF}' | wl-copy
