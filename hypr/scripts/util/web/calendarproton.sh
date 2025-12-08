url="https://calendar.proton.me/u/0/"

hyprctl --batch "dispatch exec firefox --new-tab \"$url\" ; dispatch focuswindow class:firefox"
