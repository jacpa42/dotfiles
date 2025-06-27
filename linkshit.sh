#!/usr/bin/bash

DOTDIR="$HOME/.config/dotfiles"
CNFDIR="$HOME/.config"

ln -vsfn $DOTDIR/bat     $CNFDIR/bat
ln -vsfn $DOTDIR/dunst   $CNFDIR/dunst
ln -vsfn $DOTDIR/ghostty $CNFDIR/ghostty
ln -vsfn $DOTDIR/hypr    $CNFDIR/hypr
ln -vsfn $DOTDIR/ncspot  $CNFDIR/ncspot
ln -vsfn $DOTDIR/nvim    $CNFDIR/nvim
ln -vsfn $DOTDIR/tmux    $CNFDIR/tmux
ln -vsfn $DOTDIR/yazi    $CNFDIR/yazi
ln -vsfn $DOTDIR/zsh     $CNFDIR/zsh
ln -vsfn $DOTDIR/zsh/.zprofile $HOME/.zprofile

[ "$SYSTEM" = "Darwin" ] \
	&& ln -vsfn $DOTDIR/qutebrowser $HOME/.qutebrowser \
	|| ln -vsfn $DOTDIR/qutebrowser $CNFDIR/qutebrowser

[ "$SYSTEM" = "Darwin" ] \
	&& ln -vsfn $DOTDIR/ghostty/config_macos $DOTDIR/ghostty/config \
	|| ln -vsfn $DOTDIR/ghostty/config_arch  $DOTDIR/ghostty/config

[ "$SYSTEM" = "Darwin" ] \
	&& ln -vsfn $DOTDIR/sketchybar $CNFDIR/sketchybar
