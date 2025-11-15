url="https://frame.work"

hyprctl --batch "dispatch exec firefox --new-tab \"$url\" ; dispatch focuswindow class:firefox"
