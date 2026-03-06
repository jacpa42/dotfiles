#!/usr/bin/env bash

info="$(fd -gtfile "payment_info.txt" $PROJDIR)"
[ -z "$info" ] && {
    notify-send "failed to find 'payment_info.txt' in $PROJDIR :("
}

wl-copy <$info
notify-send -t 2000 "copied kragsentrale payment info to clipboard"
