#!/usr/bin/env /usr/bin/sh
selected="$(fzf --walker-root=$HOME --walker=file \
    --bind 'ctrl-s:execute-silent(hyprctl dispatch exec xdg-open {-1})' \
    --ghost="open file" \
    --header="ctrl-s to open in background")"
hyprctl dispatch exec "xdg-open \""$selected"\""
