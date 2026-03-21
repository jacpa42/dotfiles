#!/usr/bin/env bash

mode=""
args=()
for arg in "$@"; do
    case "$arg" in
    -r | --region) mode="region" ;;
    -o | --output) mode="output" ;;
    -w | --window) mode="window" ;;
    -a | --active-window) mode="active window" ;;
    *) args+=("$arg") ;;
    esac
done
[[ -z "$mode" ]] && mode="$(printf "region\noutput\nwindow\nactive window" | fuzzel --dmenu --auto-select)"
[[ -z "$mode" ]] && exit

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
