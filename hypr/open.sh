#!/usr/bin/sh
# generic utility to open or focus in hyprland. Nice for single window workspaces

if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: $0 <workspace> <command>"
    echo "Example: $0 1 /usr/bin/qutebrowser"
    exit 1
fi

workspace="$1"
cmd="[workspace $workspace] $2"

if hyprctl workspaces | grep "workspace ID" | awk '{print $3}' | grep -qx "$workspace"; then
	# There is some window here. Focus it
	hyprctl dispatch workspace "$workspace"
else
	# There is no window here. Open one here with the cmd
	/usr/bin/hyprctl dispatch exec "$cmd"
fi
