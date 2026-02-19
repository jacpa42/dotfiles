#!/usr/bin/env /usr/bin/sh

applications="$(fd -aedesktop --format "{/.}" -d1 . /usr/share/applications /home/jacob/.local/share/applications)"

selected="$(echo -e "$applications" | fzf)"
[ -z "$selected" ] && exit

hyprctl dispatch exec "gtk-launch \""$(basename "$selected")"\""
