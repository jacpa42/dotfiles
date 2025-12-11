url="https://dashboard.paystack.com/#/dashboard"

hyprctl --batch "dispatch exec firefox --new-tab \"$url\" ; dispatch focuswindow class:firefox"
