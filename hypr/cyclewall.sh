#!/bin/sh

pgrep "$(basename "$0")" | grep -vw $$ >/dev/null && { notify-send "Cycle wall is already running"; exit 1; }

dir="$HOME/Projects/muur_papier/"
default_wallpaper=""
set_default_wallpaper=false
random=false
reverse=false
notify=0

# notifier utility function
notif() {
	# 1 = icon
	notify-send --urgency=low --expire-time=1000 --icon="$1" "Wallpaper changed"
}

while [[ $# -gt 0 ]]; do 
	case "$1" in
		--wallpaper-dir|-w)
			dir="$2"
			shift 2
			;;
		--notify|-n)
			notify=1
			shift 1
			;;
		--default-wallpaper|-d)
			echo "default $2"
			default_wallpaper="$2"
			set_default_wallpaper=true
			shift 2
			;;
		--reverse|-r)
			reverse=true
			shift
			;;
		--random|-R)
			random=true
			shift
			;;
		--help|-h)
			echo "Usage: $0 --wallpaper-dir|-w <wallpaper directory> [--help|-h] [--default-wallpaper|-d <wallpaper>] [--reverse|-r]"
			echo
			echo "	--wallpaper-dir     -w | Specify the directory to search for images."
			echo "	--default-wallpaper -d | Specify the default wallpaper to use (must be in wallpaper-dir)."
			echo "	--reverse           -r | Reverse the order of the wallpaper cycling."
			echo "	--random            -R | Choose a random wallpaper."
			echo "	--notify            -n | Send a notification when the wallpaper is changed."
			exit 0
			;;
		*)
			echo "Unknown arg: $1"
			echo "Usage: $0 --wallpaper-dir|-d <wallpaper directory> [--default-wallpaper|-d <wallpaper>] [--reverse|-r]"
			exit 1
			;;
	esac
done


img=""
wbg_pid=""

if $set_default_wallpaper; then
	echo "$(basename "$default_wallpaper")"
	img="$(fd -1atfile "$(basename "$default_wallpaper")" "$dir")"
	wbg_pid="$(pgrep -of "^wbg $img")"
else
	images=($(fd -at f -e jpg . "$dir"))
	num_images=${#images[@]}
	(( num_images == 0 )) && { echo "No images found."; exit 1; }

	F=$(fd 'hyprwall' /tmp --type f)
	if [[ $F == "" ]]; then
		F=$(mktemp /tmp/hyprwall.XXX)
	fi

	if $random; then
		INDEX=$(($RANDOM % num_images))
		echo "$INDEX">"$F"
	else
		if [[ ! -s $F ]]; then
			echo 0 > "$F"
			INDEX=0
		else
			read -r INDEX < "$F"
			if $reverse; then
				INDEX=$(((INDEX + num_images - 1) % num_images))
			else
				INDEX=$(((INDEX + 1) % num_images))
			fi
			echo "$INDEX">"$F"
		fi
	fi

	rand_img() {
		local index=${1:-0}
		local len=${2:-0}
		(( len == 0 )) && { echo "No images found."; exit 1; }
		echo "${images[index % len]}"
	}

	monitors=($(hyprctl monitors 2>/dev/null | awk '/Monitor/ {print $2}' | sort -r))
	len=${#monitors[@]}
	(( len == 0 )) && { echo "No monitors found."; exit 1; }

	img="$(rand_img $INDEX $num_images)"
	wbg_pid="$(pgrep -of "$img")"
fi


if [ -n "$wbg_pid"	]; then
	# We already have the default going so we just kill all the other wbg processes and exit
	echo "Default wallpaper already set."

	# exclude the one with the default wallpaper and kill others
	pidof wbg | tr ' ' '\n' | grep -vwF -e "$wbg_pid" | xargs kill 2>/dev/null
else
	pids=$(pidof wbg)

	[ $notify -eq 1 ] && notif "$img"

	# Kill them as we don't need them
	[ -n "$pids" ] && kill $pids

	wbg -s "$img" &
fi
