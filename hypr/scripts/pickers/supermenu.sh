#!/usr/bin/env /usr/bin/sh

script_dir="$HOME/projects/dotfiles/hypr/scripts"
cd $script_dir || exit

preview='bat --plain --color=always --language=sh $(fd --min-depth 2 --glob -1 -texecutable {1}\*)'

selected="$(fd --min-depth 2 -texecutable --format "{/.}" | fzf --preview-window="right:60%" --preview="$preview")"
[ -z "$selected" ] && exit

selected=$(fd --min-depth 2 --glob -1 -texecutable "$selected*")
exec "$selected"
