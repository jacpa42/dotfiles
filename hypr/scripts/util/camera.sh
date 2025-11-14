pgrep "$(basename "$0")" | grep -vw $$ >/dev/null && {
    notify-send -a "camera" -t 1000 -r 666 "camera is already running"
    exit 1
}

hyprctl dispatch exec '[float; center 1; pin; size 70% 70%; stayfocused; bordersize 1; workspace] mpv --demuxer-lavf-o=video_size=1920x1080,input_format=rawvideo,framerate=30 av://v4l2:/dev/video0 --profile=low-latency --untimed'
