#!/bin/bash

DOTDIR="${DOTDIR:-$HOME/projects/dotfiles}"
CNFDIR="$HOME/.config"

ln -vsfn $DOTDIR/ashell $CNFDIR/ashell
ln -vsfn $DOTDIR/bat $CNFDIR/bat
ln -vsfn $DOTDIR/dunst $CNFDIR/dunst
ln -vsfn $DOTDIR/hypr $CNFDIR/hypr
ln -vsfn $DOTDIR/nvim $CNFDIR/nvim
ln -vsfn $DOTDIR/tmux $CNFDIR/tmux
ln -vsfn $DOTDIR/yazi $CNFDIR/yazi
ln -vsfn $DOTDIR/zsh $CNFDIR/zsh
ln -vsfn $DOTDIR/mpv $CNFDIR/mpv
ln -vsfn $DOTDIR/imv $CNFDIR/imv
ln -vsfn $DOTDIR/zsh/.zprofile $HOME/.zprofile
ln -vsfn $DOTDIR/lazygit $HOME/lazygit
ln -vsfn $DOTDIR/foot $CNFDIR/foot
ln -vsfn $DOTDIR/qutebrowser $CNFDIR/qutebrowser
