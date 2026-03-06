#!/usr/bin/env bash

selected="$(fd -tf . $HOME | fuzzel --dmenu --placeholder="open file")"
exec xdg-open $selected
