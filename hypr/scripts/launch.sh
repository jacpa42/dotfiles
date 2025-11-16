#!/usr/bin/env /usr/bin/sh
[ -z "$1" ] && exit 1

/usr/bin/flock -n -E 2 /tmp/picklock.lock --command "footclient -a footpopup --override colors.alpha=1.0 $1" && exit 0
[ "$?" -eq 2 ] && notify-send -a "picker" -t 1000 -r 666 "picker already running" && exit 1
