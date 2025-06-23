/usr/bin/pactl set-default-sink "$(
  /usr/bin/pactl list sinks | grep -E '^Sink|Description' | while read -r line; do
    case $line in
      Sink*) sink_id=${line#Sink #} ;;
      *Description:*) echo "$sink_id ${line#*Description: }" ;;
    esac
  done | "$XDG_CONFIG_HOME/hypr/wofi.sh" --dmenu | cut -d' ' -f1
)"
