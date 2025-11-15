#!/usr/bin/env /usr/bin/sh

output=$(
    sk --print-query <<EOF
https://aur.archlinux.org/packages
https://frame.work
https://github.com/
https://mail.proton.me/u/0/inbox
https://web.whatsapp.com/
https://wiki.hypr.land/Configuring/
https://www.youtube.com/
https://www.fnb.co.za/
https://ziglang.org/documentation/master/
EOF
)

[ -z "$output" ] && exit 0

lc=$(echo "$output" | wc -l)
url="$([ $lc -eq 1 ] &&
    echo "https://www.google.com/search?q=$(printf "%s" "$output" | sed -n '1p' | urlencode)&udm=14" ||
    printf "%s" "$output" | sed -n '2p')"

hyprctl --batch "dispatch exec firefox --new-tab \"$url\" ; dispatch focuswindow class:firefox"
