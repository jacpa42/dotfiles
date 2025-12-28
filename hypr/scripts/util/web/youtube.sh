url="https://www.youtube.com/"
hyprctl --batch "dispatch exec qutebrowser \"$url\" ; dispatch focuswindow class:org.qutebrowser.qutebrowser"
