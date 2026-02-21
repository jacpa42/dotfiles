#!/usr/bin/env /usr/bin/sh

xdg-open "$(fd -atfile . $HOME | fzf)"
