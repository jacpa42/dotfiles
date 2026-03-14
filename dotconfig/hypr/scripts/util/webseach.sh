#!/usr/bin/env bash

output="$(fuzzel -l0 --dmenu --placeholder="search web")"
[ -z "$output" ] && exit 0
url="https://www.google.com/search?q=$(printf "%s" "$output" | sed -n '1p' | urlencode)&udm=14"
hyprctl dispatch workspace "$WEB_WORKSPACE"
default_browser="$(xdg-mime query default x-scheme-handler/https)"
hyprctl dispatch focuswindow class:"${default_browser%%.*}"
exec xdg-open "$url"
