#!/bin/zsh

battery_life=$(< /sys/class/power_supply/BAT0/capacity); 
index=$((battery_life / 10)); 
chars=('󰂎' '󰁺' '󰁻' '󰁼' '󰁽' '󰁾' '󰁿' '󰂀' '󰂁' '󰂂' '󰁹'); 

echo "$battery_life ${chars[$index]}"
