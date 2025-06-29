#!/usr/bin/env zsh

LAZYGIT=0

export -f preview

case "$1" in
	git)
		# Opens lazy git here in new pane
		LAZYGIT=1
		TARGET_DIR="$(echo -e "$(fd --exec="dirname" -Htd --glob .git "$HOME/.config")\n$(fd --exec="dirname" -Htd --glob .git "$HOME/Projects")" | sk --preview="eza --color=always --sort=type --long --icons always --no-time --no-user --header {}")"
		;;
	*)
		TARGET_DIR="$(echo -e "$HOME\n$(fd --exec="dirname" -Htd --glob .git "$HOME/.config")\n$(fd --exec="dirname" -Htd --glob .git "$HOME/Projects")" | sk --preview-window="right:60%" --preview="$HOME/.config/tmux/project_viewer.sh {}")"
		;;
esac

[ -z "$TARGET_DIR" ] && exit 1
SESSION_NAME=$(basename "$TARGET_DIR")

# If we want lazygit:
if [ $LAZYGIT -eq 1 ]; then
	cd "$TARGET_DIR"
	tmux display-popup -E -w 30% -h 40% -T "$SESSION_NAME" "lazgit" 2>$HOME/log.txt
	disown
	exit 0
fi

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

