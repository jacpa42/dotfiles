#!/usr/bin/env bash
hyprctl dispatch workspace "$WEB_WORKSPACE"
default_browser="$(xdg-mime query default x-scheme-handler/https)"
hyprctl dispatch focuswindow class:"${default_browser%%.*}"
exec xdg-open "https://admin.shopify.com/store"
