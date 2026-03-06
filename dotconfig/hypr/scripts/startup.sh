#!/usr/bin/env bash

default_wallpaper="blue-flowers.jpg"
wallpaper_directory="$PROJDIR/muur_papier"
cyclewall="$DOTDIR/dotconfig/hypr/scripts/util/cyclewall.sh"

# This spawns hyprpaper!

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

hyprpaper &
disown
while ! pidof -q hyprpaper; do
    sleep 0.1
done
sleep 0.3 # Wait for socket to connect or smthn idk
$cyclewall --force -w $wallpaper_directory --set-last -s $default_wallpaper
