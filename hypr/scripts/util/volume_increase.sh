#!/usr/bin/env /usr/bin/sh

wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%+ -l 1.0
msg="volume set to $(wpctl get-volume @DEFAULT_AUDIO_SINK@)"
notify-send -t 1000 -c media -r 777 "$msg"
