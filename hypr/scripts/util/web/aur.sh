url="https://aur.archlinux.org/packages"
hyprctl --batch "dispatch exec firefox --new-tab \"$url\" ; dispatch focuswindow class:firefox"
