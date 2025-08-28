#!/bin/sh

GLOBAL=/usr/share/applications
USER=/home/jacob/.local/share/applications

skim_opts="--no-info --no-multi --no-mouse -tlength --color=none"

declare -A apps

selected="$( \
	fd --exact-depth=1 -edesktop --format="{/.}" . "$GLOBAL" "$USER" | \
	sk $skim_opts \
)"

hyprctl dispatch exec gtk-launch "${selected// /\\ }"
