#!/usr/bin/env /usr/bin/sh

pgrep "$(basename "$0")" | grep -vw $$ >/dev/null && {
    notify-send "Cycle wall is already running"
    exit 1
}

# Sets LASTWALLPAPER each time we update the wall paper
LASTWALLPAPER="$XDG_CACHE_HOME/lastwallpaper"
dir="$PROJDIR/muur_papier/"
requested_wallpaper=""
set_last_used=""
random=""
reverse=""
notify=0

while [[ $# -gt 0 ]]; do
    case "$1" in
    --wallpaper-dir | -w)
        dir="$2"
        shift 2 || exit 1
        ;;
    --notify | -n)
        notify=1
        shift
        ;;
    --set | -s)
        requested_wallpaper="$2"
        shift 2 || exit 1
        ;;
    --set-last | -S)
        set_last_used=true
        shift
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
        echo "	--set-last          -S | Trys to set the wallpaper to the last set wallpaper. On failure default behaviour occurs."
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

set_requested() {
    req_wall="$1"
    [ -f "$req_wall" ] && img="$req_wall" || img="$(fd -1atfile "$(basename "$req_wall")" "$dir")"
    wbg_pid="$(pgrep -of "^wbg.*$req_wall")"
}

set_random() {
    random="$1"
    reverse="$2"

    images=($(fd -at f -e jpg . "$dir"))
    num_images=${#images[@]}
    ((num_images == 0)) && { echo "No images found." && exit 1; }

    F=$(fd 'hyprwall' /tmp --type f)
    [[ $F == "" ]] && F=$(mktemp /tmp/hyprwall.XXX)

    if [[ -n "$random" ]]; then
        INDEX=$(($RANDOM % num_images))
        echo "$INDEX" >"$F"
    else
        if [[ ! -s $F ]]; then
            echo 0 >"$F"
            INDEX=0
        else
            read -r INDEX <"$F"
            if [[ -n "$reverse" ]]; then
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
}

wallpaper_set=""

# Set last used if requested
[[ -r "$LASTWALLPAPER" ]] && [[ -n "$set_last_used" ]] && {
    wallpaper_set=true
    requested_wallpaper="$(cat $LASTWALLPAPER)"
    set_requested "$requested_wallpaper"
}
# Otherwise fallback to requested
[[ -z "$wallpaper_set" ]] && [[ -n "$requested_wallpaper" ]] && {
    wallpaper_set=true
    set_requested "$requested_wallpaper"
}
# Otherwise fallback to random
[[ -z "$wallpaper_set" ]] && {
    set_random "$random" "$reverse"
}

if [ -n "$wbg_pid" ]; then
    # We already have the default going so we just kill all the other wbg processes and exit
    echo "Wallpaper already set."

    # exclude the one with the default wallpaper and kill others
    pidof wbg | tr ' ' '\n' | grep -vwF -e "$wbg_pid" | xargs kill 2>/dev/null
else
    pids=$(pidof wbg)

    # Spawn wbg
    echo "$img" >"$LASTWALLPAPER"
    hyprctl dispatch exec "wbg -s "$img""

    # Kill them as we don't need them
    [ -n "$pids" ] && kill $pids
fi
