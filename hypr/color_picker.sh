#!/usr/bin/sh

pgrep "$(basename "$0")" | grep -vw $$ >/dev/null && { notify-send "Color picker is already running"; exit 1; }

fmt="$(echo -e "hex\ncmyk\nrgb\nhsl\nhsv" | $HOME/.config/hypr/wofi.sh --dmenu -w 5 -L 3)"
echo "$format"
hyprpicker -ar -f"${fmt:-hex}"
