url="https://wiki.hypr.land/Configuring/"

hyprctl --batch "dispatch exec firefox --new-tab \"$url\" ; dispatch focuswindow class:firefox"
