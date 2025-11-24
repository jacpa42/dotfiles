#!/usr/bin/env /usr/bin/sh

# Search for all the common websites as like a sudo bookmarks thing with grep
scriptdir=$HOME/Projects/dotfiles/hypr/scripts/util/web
output=$(grep -R $scriptdir -ohe "\"https.*\"" | fzf --print-query)

[ -z "$output" ] && exit 0

lc=$(echo "$output" | wc -l)
url="$([ $lc -eq 1 ] &&
    echo "https://www.google.com/search?q=$(printf "%s" "$output" | sed -n '1p' | urlencode)&udm=14" ||
    printf "%s" "$output" | sed -n '2p')"

hyprctl --batch "dispatch exec firefox --new-tab $url ; dispatch focuswindow class:firefox"
