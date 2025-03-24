#!/bin/bash

spotify_song_name="$(/usr/bin/playerctl -s --player=spotify metadata | /usr/bin/rg title | /usr/bin/sd '.*title\s+' '')"
spotify_status="$(/usr/bin/playerctl -s --player=spotify status)"

firefox_song_name="$(/usr/bin/playerctl -s --player=firefox metadata | /usr/bin/rg title | /usr/bin/sd '.*title\s+' '')"
firefox_status="$(/usr/bin/playerctl -s --player=firefox status)"

# Function to truncate the song name if it's longer than 20 characters
truncate_song_name() {
    local song_name="$1"
    local max_length=50
    if [ ${#song_name} -gt $max_length ]; then
        echo "${song_name:0:$max_length}..."
    else
        echo "$song_name"
    fi
}

# If Spotify is playing, display it.
if [[ ! -z $spotify_song_name && $spotify_status == "Playing" ]]; then
    truncated_song=$(truncate_song_name "$spotify_song_name")
    echo "#[fg=colour10]$truncated_song #[fg=colour0] |"
    exit 0
# Else if Firefox is playing, display it.
elif [[ ! -z $firefox_song_name && $firefox_status == "Playing" ]]; then
    truncated_song=$(truncate_song_name "$firefox_song_name")
    echo "#[fg=colour208]$truncated_song 󰈹#[fg=colour0] |"
    exit 0
# Else if Spotify is paused, display it.
elif [[ ! -z $spotify_song_name ]]; then
    truncated_song=$(truncate_song_name "$spotify_song_name")
    echo "#[fg=colour8]$truncated_song #[fg=colour0] |"
    exit 0
# Else if Firefox is paused, display it.
elif [[ ! -z $firefox_song_name ]]; then
    truncated_song=$(truncate_song_name "$firefox_song_name")
    echo "#[fg=colour8]$truncated_song 󰈹#[fg=colour0] |"
    exit 0
fi

exit 0
