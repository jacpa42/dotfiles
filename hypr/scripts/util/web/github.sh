url="https://github.com/"

hyprctl --batch "dispatch exec firefox --new-tab \"$url\" ; dispatch focuswindow class:firefox"
