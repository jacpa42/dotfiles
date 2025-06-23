#!/usr/bin/env zsh
: "${INFO:=$(osascript -e 'output volume of (get volume settings)')}"

case ${INFO} in
0)
    ICON=""
    ICON_PADDING_RIGHT=24
    ;;
5)
    ICON=""
    ICON_PADDING_RIGHT=22
    ;;
[1-9][0-9])
    ICON=""
    ICON_PADDING_RIGHT=15
    ;;
*)
    ICON=""
    ICON_PADDING_RIGHT=3
    ;;
esac

sketchybar --set $NAME icon=$ICON icon.padding_right=$ICON_PADDING_RIGHT label="$INFO%"
