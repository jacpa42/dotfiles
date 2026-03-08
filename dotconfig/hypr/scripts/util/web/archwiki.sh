#!/usr/bin/env bash
hyprctl dispatch workspace "$WEB_WORKSPACE"
exec xdg-open "https://wiki.archlinux.org/title/Main_page"
