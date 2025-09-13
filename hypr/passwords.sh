#!/bin/sh

PASSWORD_DIRECTORY=/home/jacob/.password-store
SKIM_OPTS="--no-info --no-multi --no-mouse -tlength --color=none"

cd "$PASSWORD_DIRECTORY" || exit 1

selected="$(fd -tfile --format="{.}" | sk $SKIM_OPTS)"

MSG="$(pass --clip "$selected")"

[ ! -z "$selected" ] && notify-send "$MSG"
