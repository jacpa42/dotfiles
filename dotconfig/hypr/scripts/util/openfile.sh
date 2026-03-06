#!/usr/bin/env bash

selected="$(fd -utf -E '\.*/' . $HOME | fuzzel --dmenu --placeholder="open file")"
exec xdg-open $selected
