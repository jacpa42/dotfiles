#!/usr/bin/env /usr/bin/sh

selected="$(fzf <$HOME/Projects/dotfiles/hypr/scripts/pickers/emojis)"
[ -z "$selected" ] && exit
echo "$selected" | awk '{printf "%s", $NF}' | wl-copy || exit 1
notify-send -a "picker" -t 2000 -r 666 "Copied $(wl-paste) to clipboard"
