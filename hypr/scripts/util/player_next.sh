player=spotify
playerctl --player=$player next
notify-send -t 1000 -c media -r 777 "next track"
