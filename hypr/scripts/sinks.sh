#!/bin/env /bin/sh
pgrep wmenu | grep -vw $$ >/dev/null && {
	notify-send "wmenu already running"
	exit 0
}

options=""
declare -A sinks
declare -A ports

while IFS= read -r line; do
	case "$line" in
	*Name:*)
		sink=$(echo "$line" | awk '{print $2}')
		;;
	*Description:*)
		description="${line#*Description: }"
		;;
	*)
		# Get the second field (port name), remove the trailing ':'
		port_name=$(echo "$line" | awk '{print $1}' | sed 's/:$//')
		# Get text between ':' and '(', then trim spaces
		port_desc=$(echo "$line" | sed -E 's/^[^:]+:[[:space:]]*(.*?)[[:space:]]*\(.*/\1/')

		key="${description} <-> ${port_desc}"
		options="${options}${key}\n"

		sinks["$key"]="$sink"
		ports["$key"]="$port_name"
		;;
	esac
done <<EOF
$(pactl list sinks | grep -E '^\s*(Name:|Description:|analog-output|hdmi-output|usb-audio)')
EOF

choice=$(echo -e "${options%??}" | eval wmenu -p"sink" $wmenu_opts)

if [ -n "$choice" ]; then
	selected_sink="${sinks[$choice]}"
	selected_port="${ports[$choice]}"
	if [ -n "$selected_sink" ] && [ -n "$selected_port" ]; then
		pactl set-default-sink "$selected_sink"
		pactl set-sink-port "$selected_sink" "$selected_port"
	else
		echo "Invalid choice or no sink/port found."
	fi
fi
