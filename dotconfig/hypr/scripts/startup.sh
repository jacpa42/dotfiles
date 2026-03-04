#!/usr/bin/env bash

default_wallpaper="blue-flowers.jpg"
wallpaper_directory="$PROJDIR/muur_papier"
cyclewall="$DOTDIR/dotconfig/hypr/scripts/util/cyclewall.sh"

ashell &
foot --server &
mpd &
fcitx5 -d &
hyprctl setcursor $HYPRCURSOR_THEME $HYPRCURSOR_SIZE &
dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP &
dbus-update-activation-environment --systemd QT_QPA_PLATFORMTHEME=$QT_QPA_PLATFORMTHEME &
gsettings set org.gnome.desktop.interface gtk-theme Adwaita &
gsettings set org.gnome.desktop.interface color-scheme prefer-dark &
gsettings set org.gnome.desktop.interface cursor-theme $HYPRCURSOR_THEME &

# This spawns hyprpaper!
$cyclewall -w $wallpaper_directory --set-last -s $default_wallpaper

disown
