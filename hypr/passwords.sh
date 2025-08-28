#!/bin/sh

PASSWORD_DIRECTORY=/home/jacob/.password-store
skim_opts="--no-info --no-multi --no-mouse -tlength --color=none"

cd "$PASSWORD_DIRECTORY" || exit 1

selected="$(fd -tfile --format="{.}" | sk $skim_opts)"

[ ! -z "$selected" ] && notify-send "$(pass -c "$selected")"
