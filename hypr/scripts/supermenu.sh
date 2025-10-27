#!/bin/env /bin/sh
pgrep wmenu | grep -vw $$ >/dev/null && {
	notify-send "wmenu already running"
	exit 0
}

script_dir="$HOME/Projects/dotfiles/hypr/scripts"
selected="$(fd --format "{/.}" -esh . "$script_dir" | eval wmenu -p"supermenu" $wmenu_opts).sh"
exec "$script_dir/$selected"
