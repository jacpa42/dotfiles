#!/usr/bin/env bash

info="$(fd -gtfile "shipping_info.txt" $PROJDIR)"
[ -z "$info" ] && {
    notify-send "failed to find 'shipping_info.txt' in $PROJDIR :("
}

wl-copy <$info
notify-send -t 2000 "copied kragsentrale shipping info to clipboard"
