#!/usr/bin/env bash

fmt=$(echo -e "cmyk\nhex\nrgb\nhsl\nhsv" | fuzzel --dmenu --auto-select --placeholder="color format")
exec hyprpicker -nbar -f"${fmt:-hex}"
