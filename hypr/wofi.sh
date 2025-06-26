#!/usr/bin/env bash

CONFIG="$XDG_CONFIG_HOME/hypr/wofi/config/config"
STYLE="$XDG_CONFIG_HOME/hypr/wofi/src/mocha/style.css"

pidof wofi >/dev/null && pkill wofi && exit

wofi --monitor="DP-1" --conf "${CONFIG}" --style "${STYLE}" "$@" <&0
