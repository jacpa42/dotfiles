#!/usr/bin/env bash

info="$(fd -gtfile "vat_number.txt" $PROJDIR)"
[ -z "$info" ] && {
    notify-send "failed to find 'vat_number.txt' in $PROJDIR :("
}

wl-copy <$info
notify-send -t 2000 "copied vat number to clipboard"
