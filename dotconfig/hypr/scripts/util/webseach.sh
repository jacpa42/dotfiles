#!/usr/bin/env bash

output="$(fuzzel -l1 --dmenu --placeholder="search web" <<<"")"
[ -z "$output" ] && exit 0
url="https://www.google.com/search?q=$(printf "%s" "$output" | sed -n '1p' | urlencode)&udm=14"
hyprctl dispatch workspace 3
exec xdg-open "$url"
