apps="/usr/share/applications"
cd $apps || exit

selected="$(fd --format "{/.}" -edesktop -d1 | sk --preview-window="right:60%" --preview="bat --plain --color=always {1}.desktop")"
[ -z "$selected" ] && exit

hyprctl dispatch exec gtk-launch "$selected"
