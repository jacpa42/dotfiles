#!/usr/bin/env bash

TARGET_DIR=""
SESSION_NAME=""
OPERATION=""
WORKING_DIRECTORY="$(tmux display-message -Cp -d 0 '#{session_path}' || exit 0)"
cd "$WORKING_DIRECTORY"

case "$1" in
git)
    exec lazygit
    ;;
gitweb)
    url="$(git config --get remote.origin.url)"
    [[ -z "$url" ]] && notify-send "Failed to find git url for \"$WORKING_DIRECTORY\""
    hyprctl dispatch workspace 3
    xdg-open "$(git config --get remote.origin.url)"
    ;;
btop)
    exec btop
    ;;
panes)
    selected="$(tmux list-panes -a -F '#S:#I.#P #W #{pane_current_path}' |
        fuzzel --dmenu --auto-select --placeholder="Choose project pane" | awk '{print $1}')"
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
    WORKING_DIRECTORY="$PROJDIR"
    cd "$WORKING_DIRECTORY"

    TARGET_DIR="$PROJDIR$(fd --format="{//}" -Hgtd .git | fuzzel --dmenu --auto-select --placeholder="Choose project")"
    [ -z "$TARGET_DIR" ] && exit 0

    hyprctl dispatch workspace 4

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
        tmux new-session -dAs "$SESSION_NAME" -c "$TARGET_DIR" 'exec /usr/bin/env $SHELL'
        tmux switch-client -t "$SESSION_NAME"
    fi
    ;;
home_session)
    TARGET_DIR="$HOME"
    hyprctl dispatch workspace 4
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
        tmux new-session -dAs "$SESSION_NAME" -c "$TARGET_DIR" 'exec /usr/bin/env $SHELL'
        tmux switch-client -t "$SESSION_NAME"
    fi
    ;;
esac
