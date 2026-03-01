#!/usr/bin/env bash
selected="$(fd -tf . $HOME | fuzzel --dmenu --mesg="copy file")"
wl-copy <"$selected"
