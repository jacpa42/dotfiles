#!/usr/bin/env zsh

TARGET_DIR=""
SESSION_NAME=""
OPERATION=""

case "$1" in
git)
	exec lazygit
	;;
*)
	project_dirs="$HOME\n$(fd --exec="dirname" -Htd --glob .git "$HOME/Projects")"
	prev="$HOME/.config/tmux/project_viewer.sh {}"
	TARGET_DIR="$(echo -e "$project_dirs" | sk --preview-window="right:70%" --preview="$prev")"
	[ -z "$TARGET_DIR" ] && exit 0
	SESSION_NAME=$(basename "$TARGET_DIR")
	;;
esac

# Otherwise just switch tmux sessions
FOUND_SESSION=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | while read -r s; do
	dir=$(tmux display-message -p -t "$s" "#{session_path}")
	if [ "$dir" = "$TARGET_DIR" ]; then
		echo "$s"
		break
	fi
done)

if [ -n "$FOUND_SESSION" ]; then
	tmux switch-client -t "$FOUND_SESSION"
else
	tmux new-session -dAs "$SESSION_NAME" -c "$TARGET_DIR" -n "code" 'nvim; exec $SHELL'
	tmux switch-client -t "$SESSION_NAME"
fi
