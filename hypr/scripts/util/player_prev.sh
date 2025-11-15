player=spotify
playerctl --player=$player previous
notify-send -t 1000 -c media -r 777 "previous track"
