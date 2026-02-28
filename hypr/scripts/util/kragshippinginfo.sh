#!/usr/bin/env /usr/bin/sh

shipping_info.txt
info="$(fd -gtfile "payment_info.txt" $PROJDIR)"
[ -z "$info" ] && {
    notify-send "failed to find 'payment_info.txt' in $PROJDIR :("
}

wl-copy <$PROJDIR/krag/docs/shipping_info.txt
notify-send -t 2000 "copied kragsentrale shipping info to clipboard"
