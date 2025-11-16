#!/usr/bin/env /usr/bin/sh

player=spotify
playerctl --player=$player play-pause
notify-send -t 1000 -c media -r 777 "toggled play/pause"
