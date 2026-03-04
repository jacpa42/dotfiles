#!/usr/bin/env bash

modes="region\noutput\nwindow\nactive window"
mode="$(echo -e "$modes" | fuzzel --dmenu --auto-select)"

if [[ "$mode" == "window" ]]; then
    outputs="$(hyprctl monitors -j | jq -r '.[].name')"

    # If we only have one monitor just screenshot the active one
    [ "$(wc -l <<<"$outputs")" -eq 1 ] && mode="window -m active"
elif [[ "$mode" = "output" ]]; then
    outputs="$(hyprctl monitors -j | jq -r '.[].name')"

    lc="$(wc -l <<<"$outputs")"
    [ $lc -lt 0 ] && exit 0

    OUTPUT="$([ $lc -gt 1 ] && fuzzel --dmenu <<<"$outputs" || head -n 1 <<<"$outputs")"
    [ -z "$OUTPUT" ] && OUTPUT="active"

    mode="output -m $OUTPUT"
elif [[ "$mode" = "active window" ]]; then
    mode="active -m window"
fi

echo "mode=$mode"

hyprshot -z -m $mode -o "$HOME/Pictures/screenshots/"
