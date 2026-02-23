#!/usr/bin/env /usr/bin/bash
# NOTE: https://wiki.archlinux.org/title/Migrate_installation_to_new_hardware#List_of_installed_packages

cd "$(dirname $0)"

install_paru() {
    ### check for paru ###
    which paru && exit 0
    ### Install paru ###
    PARU_DIR="$(mktemp --directory "/tmp/bootstrap_paruXXXXXX")"

    git clone --depth 1 --single-branch https://aur.archlinux.org/paru.git "$PARU_DIR"
    makepkg -D "$PARU_DIR" -sirc

    which paru && exit 0 || exit 1
}

if [ ! install_paru ]; then
    echo "failed to find or install https://aur.archlinux.org/paru.git"
    exit 1
fi

PACKAGES_FILE="packages"
[[ -f "$PACKAGES_FILE" ]] || {
    echo "Failed to find packages \"$PACKAGES_FILE\""
    exit 1
}

### Install packages ###
paru -Syu --needed $(cat "$PACKAGES_FILE")
### Remove orphan files ###
paru -Rns $(paru -Qtdq)
### Link all my dotfiles ###
./linkshit.sh
