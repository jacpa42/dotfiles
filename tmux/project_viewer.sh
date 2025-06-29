#!/usr/bin/env zsh

[ -z "$1" ] && exit 1

local dir="$1"
local name=$(basename "$dir")

if tmux has-session -t "$name" 2>/dev/null; then
	tmux capture-pane -et "$name" -p
else
	eza --color=always --sort=type --long --icons always --no-time --no-user --header "$dir"
fi
