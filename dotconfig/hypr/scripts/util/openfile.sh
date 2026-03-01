#!/usr/bin/env bash
selected="$(fd -tf . $HOME | fuzzel --dmenu --mesg="open file")"
hyprctl dispatch exec "xdg-open \""$selected"\""
