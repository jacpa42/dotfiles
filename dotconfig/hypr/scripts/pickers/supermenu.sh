#!/usr/bin/env bash

script_dir="$DOTDIR/dotconfig/hypr/scripts"
cd $script_dir || exit

preview='bat --plain --color=always --language=sh $(fd --min-depth 2 --glob -1 -texecutable {1}\*)'

selected="$(fd --min-depth 2 -texecutable --format "{/.}" | fuzzel --dmenu --auto-select)"
[ -z "$selected" ] && exit

selected=$(fd --min-depth 2 --glob -1 -texecutable "$selected*")
exec "$selected"
