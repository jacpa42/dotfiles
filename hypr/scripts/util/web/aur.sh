url="https://aur.archlinux.org/packages"
hyprctl --batch "dispatch exec qutebrowser \"$url\" ; dispatch focuswindow class:org.qutebrowser.qutebrowser"
