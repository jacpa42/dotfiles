#!/usr/bin/env /usr/bin/sh
selected="$(fd -tf . $HOME | fuzzel --dmenu --mesg="copy file")"
wl-copy <"$selected"
