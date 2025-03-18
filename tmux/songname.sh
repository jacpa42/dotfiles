#!/bin/bash

spotify_song_name="$(/usr/bin/playerctl -s --player=spotify metadata | /usr/bin/rg title | /usr/bin/sd '.*title\s+' '')"
spotify_status="$(/usr/bin/playerctl -s --player=spotify status)"

firefox_song_name="$(/usr/bin/playerctl -s --player=firefox metadata | /usr/bin/rg title | /usr/bin/sd '.*title\s+' '')"
firefox_status="$(/usr/bin/playerctl -s --player=firefox status)"

# Prefer spotify
if [[ ! -z $spotify_song_name ]]; then 
	if [[ $spotify_status == "Playing" ]] then
		echo "#[fg=colour10]$spotify_song_name #[fg=colour0] |"
		exit 0
	else
		echo "#[fg=colour8]$spotify_song_name #[fg=colour0] |"
		exit 0
	fi
fi

# If no spotify then use firefox
if [[ ! -z $firefox_song_name ]]; then 
	if [[ $firefox_status == "Playing" ]] then
		echo "#[fg=colour10]$firefox_song_name 󰈹#[fg=colour0] |"
		exit 0
	else
		echo "#[fg=colour8]$firefox_song_name 󰈹#[fg=colour0] |"
		exit 0
	fi
fi

exit 0
