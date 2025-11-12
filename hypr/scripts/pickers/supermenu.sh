script_dir="$HOME/Projects/dotfiles/hypr/scripts"
cd $script_dir || exit

selected="$(fd -texecutable | sk)"
[ -z "$selected" ] && exit

exec "$selected"
