#!/bin/bash

hyprpaper_path="$HOME/.config/hypr/hyprpaper.conf"
read -r firstline <"$hyprpaper_path"
hyprctl hyprpaper wallpaper ",$(echo "$firstline" | sed 's/.* //')"

sed -i '1{h;d}; /^$/{x;p;x}' "$hyprpaper_path"
