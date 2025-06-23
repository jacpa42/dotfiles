#!/usr/bin/env zsh

ICON_PADDING_RIGHT=5

case $INFO in
"Ghostty")
    ICON=󱙝
    ;;
"qutebrowser")
    ICON=
    ;;
# Why the fuck does WhatsApp have this unicode in its name??
"‎WhatsApp")
    ICON=
    ;;
"Spotify")
    ICON_PADDING_RIGHT=5
    ICON=
    ;;
"Preview")
    ICON_PADDING_RIGHT=3
    ICON=
    ;;
"Finder")
    ICON=󰀶
    ;;
"Safari")
    ICON_PADDING_RIGHT=4
    ICON=󰀹
    ;;
*)
    ICON_PADDING_RIGHT=2
    ICON=
    ;;
esac

echo "\"$INFO\" $ICON"

sketchybar --set $NAME icon=$ICON icon.padding_right=$ICON_PADDING_RIGHT
sketchybar --set $NAME.name label="$INFO"
