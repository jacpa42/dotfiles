#!/usr/bin/env /usr/bin/sh

pgrep "$(basename "$0")" | grep -vw $$ >/dev/null && {
    notify-send -a "picker" -t 1000 -r 666 "screenshot tool is already running"
    exit 1
}

modes="region\noutput\nwindow\nactive"
mode="$(echo -e "$modes" | grep -m 1 "$1")"

[ "$mode" = "window" ] && {
    outputs="$(hyprctl monitors -j | jq -r '.[].name')"

    # If we only have one monitor just screenshot the active one
    [ "$(wc -l <<<"$outputs")" -eq 1 ] && mode="window -m active"
}

[ "$mode" = "output" ] && {
    outputs="$(hyprctl monitors -j | jq -r '.[].name')"

    lc="$(wc -l <<<"$outputs")"
    [ $lc -lt 0 ] && exit 0

    OUTPUT="$([ $lc -gt 1 ] && fzf <<<"$outputs" || head -n 1 <<<"$outputs")"
    [ -z "$OUTPUT" ] && OUTPUT="active"

    mode="output -m $OUTPUT"
}

[ "$mode" = "active" ] && {
    OUTPUT="$(printf "window\noutput" | fzf)"
    [ -z "$OUTPUT" ] && exit 0

    mode="active -m $OUTPUT"
}

cmd="'hyprshot -z -m $mode -o \"\$HOME/Pictures/screenshots/\"'"
echo "$cmd"
hyprctl dispatch "exec sh -c $cmd"
