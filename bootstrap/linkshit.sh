#!/usr/bin/env bash
[ -d "$DOTDIR" ] || {
    echo "DOTDIR \($DOTDIR\) doesnt exist"
    exit 1
}
[ -d "$XDG_CONFIG_HOME" ] || {
    echo "XDG_CONFIG_HOME \($XDG_CONFIG_HOME\) doesnt exist"
    exit 1
}

# special :)
ln -vsfn $DOTDIR/dotconfig/bash/.bash_profile $HOME/.bash_profile
ln -vsfn $DOTDIR/dotconfig/bash/.bashrc $HOME/.bashrc

# custom desktop file stuff
ln -vsfn $DOTDIR/custom_desktop_files/* $HOME/.local/share/applications/

# .config files
ln -vsfn $DOTDIR/dotconfig/* $XDG_CONFIG_HOME/
