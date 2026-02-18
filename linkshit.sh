#!/usr/bin/env /usr/bin/bash
[ -d "$DOTDIR" ] || {
    echo "DOTDIR \($DOTDIR\) doesnt exist"
    exit 1
}
[ -d "$XDG_CONFIG_HOME" ] || {
    echo "XDG_CONFIG_HOME \($XDG_CONFIG_HOME\) doesnt exist"
    exit 1
}

ln -vsfn $DOTDIR/ashell $XDG_CONFIG_HOME/ashell
ln -vsfn $DOTDIR/bat $XDG_CONFIG_HOME/bat
ln -vsfn $DOTDIR/dunst $XDG_CONFIG_HOME/dunst
ln -vsfn $DOTDIR/hypr $XDG_CONFIG_HOME/hypr
ln -vsfn $DOTDIR/nvim $XDG_CONFIG_HOME/nvim
ln -vsfn $DOTDIR/tmux $XDG_CONFIG_HOME/tmux
ln -vsfn $DOTDIR/yazi $XDG_CONFIG_HOME/yazi
ln -vsfn $DOTDIR/zsh $XDG_CONFIG_HOME/zsh
ln -vsfn $DOTDIR/mpv $XDG_CONFIG_HOME/mpv
ln -vsfn $DOTDIR/imv $XDG_CONFIG_HOME/imv
ln -vsfn $DOTDIR/zsh/.zprofile $HOME/.zprofile
ln -vsfn $DOTDIR/lazygit $XDG_CONFIG_HOME/lazygit
ln -vsfn $DOTDIR/foot $XDG_CONFIG_HOME/foot
ln -vsfn $DOTDIR/qutebrowser $XDG_CONFIG_HOME/qutebrowser
ln -vsfn $DOTDIR/xdg-desktop-portal-termfilechooser $XDG_CONFIG_HOME/xdg-desktop-portal-termfilechooser
ln -vsfn $DOTDIR/xdg-desktop-portal $XDG_CONFIG_HOME/xdg-desktop-portal
ln -vsfn $DOTDIR/rmpc $XDG_CONFIG_HOME/rmpc
ln -vsfn $DOTDIR/mpd $XDG_CONFIG_HOME/mpd
