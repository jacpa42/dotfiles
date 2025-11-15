url="https://www.fnb.co.za/"

hyprctl --batch "dispatch exec firefox --new-tab \"$url\" ; dispatch focuswindow class:firefox"
