#!/usr/bin/zsh

application="qutebrowser"
exectuable=(/usr/bin/qutebrowser)
clients=("${(@f)$(hyprctl clients | rg "initialClass|workspace" | awk '{print $2}')}")
len=${#clients[@]}

for ((i=2; i<=$len; i+=2)); do
	echo "${clients[$i]}" | grep -q "$application"
	if [ $? -eq 0 ]; then
		hyprctl -q dispatch workspace "${clients[(($i-1))]}"
		exit 0
	fi
done

exec "${exectuable[@]}"
