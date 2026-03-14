#!/usr/bin/env bash

TARGET_DIR=""
SESSION_NAME=""
OPERATION=""
WORKING_DIRECTORY="$(tmux display-message -Cp -d 0 '#{session_path}' || exit 0)"
cd "$WORKING_DIRECTORY"

focus_terminal_window() {
    local window_class="tmux"
    local switch_window="$(hyprctl dispatch focuswindow "class:$window_class")"
    [[ "$switch_window" == "ok" ]] || {
        notify-send --expire-time=3000 --replace-id=21346532 "Failed to find window with class:\"$window_class\""
        return 1
    }
    return 0
}

case "$1" in
git)
    exec lazygit
    ;;
gitweb)
    url="$(git config --get remote.origin.url)"
    [[ -z "$url" ]] && notify-send "Failed to find git url for \"$WORKING_DIRECTORY\""
    hyprctl dispatch workspace "$WEB_WORKSPACE"
    default_browser="$(xdg-mime query default x-scheme-handler/https)"
    hyprctl dispatch focuswindow "class:${default_browser%%.*}"
    xdg-open "$(git config --get remote.origin.url)"
    ;;
btop)
    exec btop
    ;;
projects)
    WORKING_DIRECTORY="$PROJDIR"
    cd "$WORKING_DIRECTORY"

    TARGET_DIR="$(fd --format="{//}" -Hgtd .git | fuzzel --dmenu --placeholder="Choose project")"
    [[ -z "$TARGET_DIR" ]] && exit 0 || TARGET_DIR="$PROJDIR/$TARGET_DIR"
    [[ -d "$TARGET_DIR" ]] || {
        notify-send -t 2000 "\"$TARGET_DIR\" is not a directory :("
        exit 1
    }

    focus_terminal_window || exit 1

    SESSION_NAME=$(basename "$TARGET_DIR")

    # Otherwise just switch tmux sessions
    FOUND_SESSION=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | while read -r s; do
        dir=$(tmux display-message -p -t "$s" "#{session_path}")
        if [ "$dir" = "$TARGET_DIR" ]; then
            echo "$s"
            break
        fi
    done)

    if [[ -n "$FOUND_SESSION" ]]; then
        tmux switch-client -t "$FOUND_SESSION"
    else
        tmux new-session -dAs "$SESSION_NAME" -c "$TARGET_DIR" -n "code" 'exec /usr/bin/env $SHELL'
        tmux switch-client -t "$SESSION_NAME"
    fi
    ;;
home_session)
    TARGET_DIR="$HOME"
    SESSION_NAME=$(basename "$TARGET_DIR")
    focus_terminal_window || exit 1

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
        tmux new-session -dAs "$SESSION_NAME" -c "$TARGET_DIR" -n "code" 'exec /usr/bin/env $SHELL'
        tmux switch-client -t "$SESSION_NAME"
    fi
    ;;
esac
