#!/bin/bash

spotify_song_name="$(/usr/bin/playerctl -s --player=spotify metadata | /usr/bin/rg title | /usr/bin/sd '.*title\s+' '')"
spotify_status="$(/usr/bin/playerctl -s --player=spotify status)"

firefox_song_name="$(/usr/bin/playerctl -s --player=firefox metadata | /usr/bin/rg title | /usr/bin/sd '.*title\s+' '')"
firefox_status="$(/usr/bin/playerctl -s --player=firefox status)"

	#	If spotify is playing, display it.
if [[ ! -z $spotify_song_name && $spotify_status == "Playing" ]]; then 
	echo "#[fg=colour10]$spotify_song_name #[fg=colour0] |"
	exit 0
#	Else if firefox is playing display it
elif [[ ! -z $firefox_song_name && $firefox_status == "Playing" ]]; then
	echo "#[fg=colour208]$firefox_song_name 󰈹#[fg=colour0] |"
	exit 0
#	Else if spotify is paused display it.
elif [[ ! -z $spotify_song_name ]]; then
	echo "#[fg=colour8]$spotify_song_name #[fg=colour0] |"
	exit 0
#	Else if firefox is paused display it.
elif [[ ! -z $firefox_song_name ]]; then
	echo "#[fg=colour8]$firefox_song_name 󰈹#[fg=colour0] |"
	exit 0
fi

exit 0
