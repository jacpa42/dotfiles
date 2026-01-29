#!/usr/bin/env /usr/bin/sh

wpctl set-mute @DEFAULT_SINK@ toggle
msg="volume set to $(wpctl get-volume @DEFAULT_AUDIO_SINK@)"
notify-send -t 1000 -c media -r 777 "$msg"
