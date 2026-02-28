#!/usr/bin/env /usr/bin/sh

info="$(fd -gtfile "payment_info.txt" $PROJDIR)"
[ -z "$info" ] && {
    notify-send "failed to find 'payment_info.txt' in $PROJDIR :("
}

wl-copy <$info
notify-send -t 2000 "copied kragsentrale payment info to clipboard"
