#!/usr/bin/env bash
hyprctl dispatch workspace "$WEB_WORKSPACE"
exec xdg-open "https://calendar.proton.me/u/0/"
