sk <$HOME/Projects/dotfiles/hypr/scripts/pickers/emojis | awk '{printf "%s", $NF}' | wl-copy || exit 1
notify-send -a "picker" -t 2000 -r 666 "Copied $(wl-paste) to clipboard"
