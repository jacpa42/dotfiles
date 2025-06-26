#!/usr/bin/sh
# Generic utility to open or focus in Hyprland. Nice for single window workspaces

if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: $0 <workspace> <command>"
    echo "Example: $0 1 /usr/bin/qutebrowser"
    exit 1
fi

workspace="$1"
cmd="$2"

if hyprctl workspaces | awk '/workspace ID/ { id=$3 } /windows:/ && $2 > 0 { print id }' | grep -qx "$workspace"; then
	# There is some window here. Focus it.
	hyprctl dispatch workspace "$workspace"
else
	# There is no window here. Open one here with the cmd
	hyprctl dispatch workspace "$workspace"
	exec "$cmd"
fi
