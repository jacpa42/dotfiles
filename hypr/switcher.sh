#!/usr/bin/bash

GLOBAL=/usr/share/applications
USER=/home/jacob/.local/share/applications

declare -A apps

selected="$( \
	fd --exact-depth=1 -edesktop --format="{/.}" . "$GLOBAL" "$USER" | \
	sk --no-info --no-multi --no-mouse -tlength \
	)"


hyprctl dispatch exec gtk-launch "${selected// /\\ }"
