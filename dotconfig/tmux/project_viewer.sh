#!/usr/bin/env zsh

[ -z "$1" ] && exit 1

local dirname=$(basename "$1")
local mime=$([ "$SYSTEM" = "Linux" ] && echo "$(xdg-mime query filetype "$1")" || echo "$(file --mime-type -b "$1")")

case "$mime" in
inode/directory)
	if tmux has-session -t "$dirname" 2>/dev/null; then
		tmux capture-pane -et "$dirname" -p
	else
		eza --color=always --sort=type --long --icons always --no-time --no-user --header "$1"
	fi
	;;
*)
	bat "$1"
	;;
esac
