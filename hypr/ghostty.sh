#!/usr/bin/zsh

application="ghostty"
exectuable=(ghostty --fullscreen -e "tmux new-session -A -s jacpc")
clients=("${(@f)$(hyprctl clients | rg "initialClass|workspace" | awk '{print $2}')}")

for ((i=2; i<=${#clients[@]}; i+=2)); do
	echo "${clients[$i]}" | grep -q "$application"
	if [ $? -eq 0 ]; then
		hyprctl -q dispatch workspace "${clients[(($i-1))]}"
		exit 0
	fi
done

exec "${exectuable[@]}"
