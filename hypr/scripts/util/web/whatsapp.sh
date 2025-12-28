url="https://web.whatsapp.com/"
hyprctl --batch "dispatch exec qutebrowser \"$url\" ; dispatch focuswindow class:org.qutebrowser.qutebrowser"
