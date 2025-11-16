applications="$(fd -aedesktop --format "{.}" -d1 . "/usr/share/applications")\n$(fd -aedesktop --format "{.}" -d1 . "/home/jacob/.local/share/applications")"

selected="$(echo -e "$applications" | fzf --preview-window="right:60%" --preview="bat --plain --color=always {1}.desktop")"
[ -z "$selected" ] && exit

hyprctl dispatch exec "gtk-launch \""$(basename "$selected")"\""
