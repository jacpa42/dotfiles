alias aqua="asciiquarium --transparent"
alias icat="chafa -w 9 --threads=24 --exact-size=auto -O 9 --format=kitty --passthrough=tmux"
alias l="eza --long --no-time --no-user --header --colour always --icons"
alias ll="eza --long --colour always --icons --git --all"
alias lll="eza --total-size --long --colour always --icons --git --all"
alias nv="clear && nvim"
alias snv="clear && sudo -E nvim"
alias u="paru && echo && rustup update && echo && cargo install-update -a"
alias ff="fastfetch"
alias rmorphans="paru -Rns \$(paru -Qtdq)"
alias pipes="pipes-rs -p 20 -f 30 -t 0.4 -r 0.99"
alias open="xdg-open"
alias clock="peaclock --config-dir ~/.config/peaclock"
videolen() { ffmpeg -i "$1" 2>&1 | rg --color=always Duration | sed 's/,.*//' }
vidplayord() {
    if [[ -z "$1" ]]; then
        echo "Usage: mp4play [directory]"
        echo ""
        echo "This script plays all .mp4 files in the specified directory in natural order."
        echo "If no directory is provided, it defaults to the current directory."
        echo ""
        echo "Example:"
        echo "  mp4play /path/to/directory   # Plays all .mp4 files in the specified directory"
        echo "  mp4play                      # Plays all .mp4 files in the current directory"
        return 0
    fi

    directory="${1}"  # Use first argument as directory

    # Loop through .mp4 files in natural order and open them
    for file in $(ls -v "$directory"/*.mp4 2>/dev/null); do
        echo "playing $file" && [[ -f "$file" ]] && xdg-open "$file"
    done
}
