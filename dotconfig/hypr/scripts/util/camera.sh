#!/usr/bin/env bash
exec mpv --demuxer-lavf-o=video_size=1920x1080,input_format=rawvideo,framerate=30 av://v4l2:/dev/video0 --profile=low-latency --untimed
