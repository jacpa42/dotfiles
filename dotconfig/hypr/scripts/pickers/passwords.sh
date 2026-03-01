#!/usr/bin/env bash

shopt -s nullglob globstar

if [[ -z $WAYLAND_DISPLAY ]]; then
    echo "Error: No Wayland display detected" >&2
    exit 1
fi

prefix=${PASSWORD_STORE_DIR-~/.password-store}
password_files=("$prefix"/**/*.gpg)
password_files=("${password_files[@]#"$prefix"/}")
password_files=("${password_files[@]%.gpg}")

password=$(printf '%s\n' "${password_files[@]}" | fuzzel --dmenu "$@")

[[ -n $password ]] || exit

notify-send -t 2000 "$(pass -c "$password")"
