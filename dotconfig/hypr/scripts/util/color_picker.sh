#!/usr/bin/env bash

fmt=$(echo -e "cmyk\nhex\nrgb\nhsl\nhsv" | fuzzel --dmenu --auto-select --placeholder="color format")
[[ -z "$fmt" ]] && exit 0
exec hyprpicker -nbar -f"$fmt"
