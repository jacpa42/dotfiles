#!/usr/bin/env bash
hyprctl dispatch workspace "$WEB_WORKSPACE"
exec xdg-open "https://archlinux.org/packages/"
