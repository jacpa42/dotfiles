#!/usr/bin/env bash

CONFIG="$XDG_CONFIG_HOME/hypr/wofi/config/config"
STYLE="$XDG_CONFIG_HOME/hypr/wofi/src/mocha/style.css"

if [[ ! $(pidof wofi) ]]; then
	if [ -t 0 ]; then
		wofi --monitor="DP-1" --conf "${CONFIG}" --style "${STYLE}" "$@"
	else
		wofi --monitor="DP-1" --conf "${CONFIG}" --style "${STYLE}" "$@" <&0
	fi
else
  pkill wofi
fi
