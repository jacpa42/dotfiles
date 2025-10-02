#!/bin/env /bin/sh
pgrep wmenu | grep -vw $$ >/dev/null && {
	notify-send "wmenu already running"
	exit 0
}

PASSWORD_DIRECTORY=/home/jacob/.password-store
cd "$PASSWORD_DIRECTORY" || exit 1

selected="$(fd -tfile --format="{.}" | eval wmenu -p"pass" $wmenu_opts)"
MSG="$(pass --clip "$selected")"

[ ! -z "$selected" ] && notify-send -t 2000 "$MSG"
