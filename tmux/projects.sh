# TODO:	Make this actually useful
# Ideas: Wallpaper switcher with terminal image viewer and Tmux session fuzzy finder
# I only use yazi for the image viewing and the zoxide integration. This can be
# done with fd, yazi? and tmux!

fd -aejpg -tfile | fzf --preview="env icat {}"
