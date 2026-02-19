#!/usr/bin/env /usr/bin/sh

pgrep "$(basename "$0")" | grep -vw $$ >/dev/null && {
    notify-send "Cycle wall is already running"
    exit 1
}

dir="$PROJDIR/muur_papier/"
default_wallpaper=""
set_default_wallpaper=false
random=false
reverse=false
notify=0

while [[ $# -gt 0 ]]; do
    case "$1" in
    --wallpaper-dir | -w)
        dir="$2"
        shift 2 || exit 0
        ;;
    --notify | -n)
        notify=1
        shift
        ;;
    --set | -s)
        echo "default $2"
        default_wallpaper="$2"
        set_default_wallpaper=true
        shift 2 || exit 0
        ;;
    --reverse | -r)
        reverse=true
        shift
        ;;
    --random | -R)
        random=true
        shift
        ;;
    --help | -h)
        echo "Usage: $0 --wallpaper-dir|-w <wallpaper directory> [--help|-h] [--set|-s <wallpaper>] [--reverse|-r]"
        echo
        echo "	--wallpaper-dir     -w | Specify the directory to search for images."
        echo "	--set               -s | Specify a wallpaper to set."
        echo "	--reverse           -r | Reverse the order of the wallpaper cycling."
        echo "	--random            -R | Choose a random wallpaper."
        echo "	--notify            -n | Send a notification when the wallpaper is changed."
        exit 0
        ;;
    *)
        echo "Unknown arg: $1"
        echo "Usage: $0 --wallpaper-dir|-d <wallpaper directory> [--set|-s <wallpaper>] [--reverse|-r]"
        exit 1
        ;;
    esac
done

img=""
wbg_pid=""

if $set_default_wallpaper; then
    [ -f "$default_wallpaper" ] && img="$default_wallpaper" || img="$(fd -1atfile "$(basename "$default_wallpaper")" "$dir")"
    wbg_pid="$(pgrep -of "^wbg.*$default_wallpaper")"
else
    images=($(fd -at f -e jpg . "$dir"))
    num_images=${#images[@]}
    ((num_images == 0)) && { echo "No images found." && exit 1; }

    F=$(fd 'hyprwall' /tmp --type f)
    [[ $F == "" ]] && F=$(mktemp /tmp/hyprwall.XXX)

    if $random; then
        INDEX=$(($RANDOM % num_images))
        echo "$INDEX" >"$F"
    else
        if [[ ! -s $F ]]; then
            echo 0 >"$F"
            INDEX=0
        else
            read -r INDEX <"$F"
            if $reverse; then
                INDEX=$(((INDEX + num_images - 1) % num_images))
            else
                INDEX=$(((INDEX + 1) % num_images))
            fi
            echo "$INDEX" >"$F"
        fi
    fi

    rand_img() {
        local index=${1:-0}
        local len=${2:-0}
        ((len == 0)) && {
            echo "No images found."
            exit 1
        }
        echo "${images[index % len]}"
    }

    img="$(rand_img $INDEX $num_images)"
    wbg_pid="$(pgrep -of "$img")"
fi

if [ -n "$wbg_pid" ]; then
    # We already have the default going so we just kill all the other wbg processes and exit
    echo "Default wallpaper already set."

    # exclude the one with the default wallpaper and kill others
    pidof wbg | tr ' ' '\n' | grep -vwF -e "$wbg_pid" | xargs kill 2>/dev/null
else
    pids=$(pidof wbg)

    hyprctl dispatch exec "wbg -s "$img""

    # Kill them as we don't need them
    [ -n "$pids" ] && kill $pids
fi
