#!/usr/bin/env bash

selected="$(fd -utf -E '\.*/' . $HOME | fuzzel --dmenu --placeholder="open file")"

mime_type="$(xdg-mime query filetype "$selected")"
app="$(xdg-mime query default "$mime_type")"
desktop_file="$(fd -1 "$app" /usr/share/applications ~/.local/share/applications/)"

grep -q "^Terminal=true$" "$desktop_file" && {
    app_name="$(grep -m1 -oP 'Icon=\K.*' "$desktop_file")"
    [[ -n "$app_name" ]] &&
        footclient -a "$app_name" -T "$app_name" xdg-open "$selected" ||
        footclient xdg-open "$selected"
} || {
    xdg-open "$selected"
}
