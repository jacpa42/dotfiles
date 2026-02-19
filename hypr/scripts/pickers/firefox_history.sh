#!/usr/bin/env /usr/bin/bash

file="$(fd -1gHItfile places.sqlite $HOME)"
backup_copy="$(mktemp /tmp/mozhist.XXXXXXX.sqlite)"
trap 'rm "$backup_copy"' EXIT

sqlite3 "file:$file?mode=ro&immutable=1" ".backup $backup_copy"

query="select title,url from moz_places where title is not null order by last_visit_date desc"
sep=".separator \" \""

selection="$(sqlite3 "$backup_copy" "$sep" "$query" | fzf --bind 'ctrl-s:execute-silent(hyprctl dispatch exec xdg-open {-1})' --ghost="search history" --header="ctrl-s to open in background")"

url="${selection##* }"
[ -n "$url" ] && /usr/bin/hyprctl --batch "dispatch exec xdg-open \"$url\"; dispatch workspace 3"
