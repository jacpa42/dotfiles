#!/usr/bin/env /usr/bin/sh

cd /home/jacob/.password-store || exit 1

selected="$(fd -tfile --format="{.}" | fzf)"
[ -z "$selected" ] && exit

notify-send -t 2000 "$(pass --clip "$selected")"
