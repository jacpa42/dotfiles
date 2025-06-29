#!/usr/bin/env zsh

case "$1" in
git)
	# Opens lazy git here in new pane
	exec lazygit
	;;
*)
	TARGET_DIR="$(echo -e "$HOME\n$(fd --exec="dirname" -Htd --glob .git "$HOME/.config")\n$(fd --exec="dirname" -Htd --glob .git "$HOME/Projects")" | sk --preview-window="right:60%" --preview="$HOME/.config/tmux/project_viewer.sh {}")"
	;;
esac

[ -z "$TARGET_DIR" ] && exit 1
SESSION_NAME=$(basename "$TARGET_DIR")

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
	tmux new-session -ds "$SESSION_NAME" -c "$TARGET_DIR"
	tmux switch-client -t "$SESSION_NAME"
fi
