url="https://mail.proton.me/u/0/inbox"
hyprctl --batch "dispatch exec qutebrowser \"$url\" ; dispatch focuswindow class:org.qutebrowser.qutebrowser"
