#!/usr/bin/env zsh

[ -z "$1" ] && exit 1

local name=$(basename "$1")

case "$(xdg-mime query filetype "$1")" in
inode/directory)
	if tmux has-session -t "$name" 2>/dev/null; then
		tmux capture-pane -et "$name" -p
	else
		eza --color=always --sort=type --long --icons always --no-time --no-user --header "$1"
	fi
	;;
*)
	bat "$1"
	;;
esac
