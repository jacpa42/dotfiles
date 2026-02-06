#/usr/bin/env /usr/bin/bash

file="$(fd -1Htfile '^places.sqlite$' $HOME/.config/mozilla)"
backup_copy="$(mktemp /tmp/mozhist.XXXXXXX.sqlite)"
trap 'rm "$backup_copy"' EXIT

sqlite3 "file:$file?mode=ro&immutable=1" ".backup $backup_copy"
url="$(sqlite3 "$backup_copy" \
    ".separator \" \"" \
    'select title,url from moz_places where title is not null order by frecency desc' \
    | fzf)"

url="${url##*https://}"
[ -n "$url" ] && /usr/bin/hyprctl --batch "dispatch exec xdg-open "https://$url"; dispatch workspace 3"
