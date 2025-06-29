#!/usr/bin/bash

DOTDIR="${DOTDIR:-$HOME/Projects/dotfiles}"
CNFDIR="$HOME/.config"

ln -vsfn $DOTDIR/bat $CNFDIR/bat
ln -vsfn $DOTDIR/dunst $CNFDIR/dunst
ln -vsfn $DOTDIR/ghostty $CNFDIR/ghostty
ln -vsfn $DOTDIR/hypr $CNFDIR/hypr
ln -vsfn $DOTDIR/nvim $CNFDIR/nvim
ln -vsfn $DOTDIR/tmux $CNFDIR/tmux
ln -vsfn $DOTDIR/yazi $CNFDIR/yazi
ln -vsfn $DOTDIR/zsh $CNFDIR/zsh

ln -vsfn $DOTDIR/zsh/.zprofile $HOME/.zprofile
ln -vsfn $DOTDIR/lazygit "$(lazygit --print-config-dir)"

[ "$SYSTEM" = "Darwin" ] &&
	ln -vsfn $DOTDIR/qutebrowser $HOME/.qutebrowser ||
	ln -vsfn $DOTDIR/qutebrowser $CNFDIR/qutebrowser

[ "$SYSTEM" = "Darwin" ] &&
	ln -vsfn $DOTDIR/ghostty/config_macos $DOTDIR/ghostty/config ||
	ln -vsfn $DOTDIR/ghostty/config_arch $DOTDIR/ghostty/config

[ "$SYSTEM" = "Darwin" ] &&
	ln -vsfn $DOTDIR/sketchybar $CNFDIR/sketchybar
