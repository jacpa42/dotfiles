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
music)
    tmux new-window -Sn "music" mpv --directory-mode=recursive --shuffle . $HOME/Music/
    ;;
panes)
    previewer="tmux capture-pane -ept {1}"
    selected="$(tmux list-panes -a -F '#S:#I.#P #W #{pane_current_path}' |
        fzf --preview-window="right:60%" --preview="$previewer" | awk '{print $1}')"
    [ -z "$selected" ] && exit 0

    session=${selected%%:*}
    win_pane=${selected#*:}
    window=${win_pane%%.*}
    pane=${selected##*.}

    tmux switch-client -t "$session"
    tmux select-window -t "$window"
    tmux select-pane -t "$pane"
    exit 0
    ;;
projects)
    custom_dirs="$HOME\n$HOME/Projects/server\n"
    project_dirs="$custom_dirs$(fd --exec="dirname" -Htd --glob .git "$HOME/Projects")"
    prev="$HOME/.config/tmux/project_viewer.sh {}"
    TARGET_DIR="$(echo -e "$project_dirs" | fzf --preview-window="right:60%" --preview="$prev")"
    [ -z "$TARGET_DIR" ] && exit 0
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
        tmux new-session -dAs "$SESSION_NAME" -c "$TARGET_DIR" -n "code" 'nvim; /bin/env $SHELL'
        tmux switch-client -t "$SESSION_NAME"
    fi
    ;;
esac
