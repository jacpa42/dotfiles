#!/usr/bin/env /usr/bin/sh

applications="/usr/share/applications /home/jacob/.local/share/applications"
selected="$(fd -aedesktop --format "{/.}" -d1 . $applications | sort -u | fzf)"
[ -z "$selected" ] && exit
hyprctl dispatch exec "gtk-launch \"$selected\""
