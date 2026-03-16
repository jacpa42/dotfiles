#!/usr/bin/env bash

wallpaper_dir="$PROJDIR/muur_papier/"
requested_wallpaper=
set_last_used=
random=
force=
reverse=
notify=

while [[ $# -gt 0 ]]; do
    case "$1" in
    --wallpaper-dir | -w)
        wallpaper_dir="$2"
        shift 2 || exit 1
        ;;
    --notify | -n)
        notify=true
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
    --force | -f)
        force=true
        shift
        ;;
    *)
        echo "Usage: $0 --wallpaper-dir|-w <wallpaper directory> [--help|-h] [--set|-s <wallpaper>] [--reverse|-r]"
        echo
        echo "	--wallpaper-dir     -w | Specify the directory to search for images."
        echo "	--set               -s | Specify a wallpaper to set."
        echo "	--set-last          -S | Trys to set the wallpaper to the last set wallpaper. On failure default behaviour occurs."
        echo "	--reverse           -r | Reverse the order of the wallpaper cycling."
        echo "	--random            -R | Choose a random wallpaper."
        echo "	--force             -f | Tell hyprpaper to set the wallpaper even if it is already loaded."
        echo "	--notify            -n | Send a notification when the wallpaper is changed."
        exit 0
        ;;
    esac
done

STATE_FILE=$XDG_CACHE_HOME/lastwallpaper
[[ -r "$STATE_FILE" ]] && STATE="$(<$STATE_FILE)" || STATE=
current_image="${STATE%%$'\n'*}"
current_image_index="${STATE#*$'\n'}"
next_image=
next_image_index=

set_requested() {
    local req_wall="$1"
    [ -f "$req_wall" ] && next_image="$req_wall" || next_image="$(fd -1atfile "$(basename "$req_wall")" "$wallpaper_dir")"
    next_image_index="$(fd -atf -ejpg . "$wallpaper_dir" | rg -nxF "$next_image" | cut -d: -f1)"
    next_image_index="${next_image_index:-0}"
}

set_random() {
    local random="$1"
    local reverse="$2"

    local images=($(fd -atf -ejpg . "$wallpaper_dir"))
    local num_images=${#images[@]}
    ((num_images == 0)) && { echo "No images found." && exit 1; }

    if [[ -n "$random" ]]; then
        next_image_index=$(($RANDOM % num_images))
    elif [[ -z "$current_image_index" ]]; then
        next_image_index=0
    elif [[ -n "$reverse" ]]; then
        next_image_index=$(((current_image_index + num_images - 1) % num_images))
    else
        next_image_index=$(((current_image_index + 1) % num_images))
    fi

    next_image="${images[next_image_index]}"

}

wallpaper_set=

# Set last used if requested
[[ -z "$wallpaper_set" && -n "$current_image" && -n "$set_last_used" ]] && {
    wallpaper_set=true
    requested_wallpaper="$current_image"
    set_requested "$requested_wallpaper"
}

# Otherwise fallback to requested
[[ -z "$wallpaper_set" && -n "$requested_wallpaper" ]] && {
    wallpaper_set=true
    set_requested "$requested_wallpaper"
}

# Otherwise fallback to random
[[ -z "$wallpaper_set" ]] && {
    wallpaper_set=true
    set_random "$random" "$reverse"
}

[[ -n "$force" || $current_image != $next_image ]] && {
    hyprctl hyprpaper wallpaper ",$next_image," || exit 2
    printf "$next_image\n$next_image_index" >"$STATE_FILE"
}
