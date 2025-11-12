script_dir="$HOME/Projects/dotfiles/hypr/scripts"
cd $script_dir || exit

selected="$(fd --min-depth 2 -texecutable | sk)"
[ -z "$selected" ] && exit

exec "$selected"
