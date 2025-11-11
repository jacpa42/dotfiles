#!/usr/bin/env zsh

TARGET_DIR=""
SESSION_NAME=""
OPERATION=""

case "$1" in
git)
	exec lazygit
	;;
btop)
	exec btop
	;;
panes)
	previewer="tmux capture-pane -ept {1}"
	requested_pane="$(tmux list-panes -a -F '#S:#I.#P  #{pane_current_command}  #{pane_current_path}' |
		sk --preview-window="right:60%" --preview="$previewer" | awk '{print $1}')"
	[ -z "$requested_pane" ] && exit 0
	tmux select-pane -t "$requested_pane"
	;;
*)
	custom_dirs="$HOME\n$HOME/Projects/server\n"
	project_dirs="$custom_dirs$(fd --exec="dirname" -Htd --glob .git "$HOME/Projects")"
	prev="$HOME/.config/tmux/project_viewer.sh {}"
	TARGET_DIR="$(echo -e "$project_dirs" | sk --preview-window="right:60%" --preview="$prev")"
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
	tmux new-session -dAs "$SESSION_NAME" -c "$TARGET_DIR" -n "code" 'nvim; /bin/env $SHELL'
	tmux switch-client -t "$SESSION_NAME"
fi
