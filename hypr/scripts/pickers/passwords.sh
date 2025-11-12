cd /home/jacob/.password-store || exit 1

selected="$(fd -tfile --format="{.}" | sk)"
MSG="$(pass --clip "$selected")"

[ ! -z "$selected" ] && notify-send -t 2000 "$MSG"
