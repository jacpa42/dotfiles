cd /home/jacob/.password-store || exit 1

selected="$(fd -tfile --format="{.}" | sk)"
[ -z "$selected" ] && exit

notify-send -t 2000 "$(pass --clip "$selected")"
