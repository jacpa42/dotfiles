#!/usr/bin/env bash
selected="$(hyprctl -j clients | jq -r '.[] | "\(.class) \(.title) \(.address)"' | fuzzel --dmenu --auto-select)"
[[ -z "$selected" ]] && exit
hyprctl dispatch focuswindow "address:${selected##* }"
