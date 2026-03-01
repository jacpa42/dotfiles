# prompt
export PS1='\[\e[34m\]\[\e[1m\]\w\[\e[0m\] \[\e[91m\]❯\[\e[0m\] '
echo -en "\x1b[\x36 q"
set_prompt() {
    local EXIT="$?"
    local BLUE="\[\e[34m\]\[\e[1m\]"
    local RED="\[\e[91m\]"
    local GREEN="\[\e[92m\]"
    local RESET="\[\e[0m\]"

    if [ $EXIT -eq 0 ]; then
        ARROW_COLOR="$BLUE"
    else
        ARROW_COLOR="$RED"
    fi
    PS1="${BLUE}\w${RESET} ${ARROW_COLOR}❯${RESET} "
}

PROMPT_COMMAND=set_prompt

## alias ##
h() { "$@" --help 2>&1 | bat --plain -lhelp --paging=always; }
function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    yazi "$@" --cwd-file="$tmp"
    IFS= read -r -d '' cwd <"$tmp"
    [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
    rm -f -- "$tmp"
}
alias duai='dua interactive'
alias shuffle='mpv --resume-playback=no --directory-mode=recursive --directory-filter-types="video,audio,playlist,archive" --shuffle .'
alias aqua="asciiquarium --transparent"
alias ff="clear && fastfetch"
alias icat="chafa -w 9 --threads=24 --exact-size=auto -O 9 --format=sixels --passthrough=tmux"
alias l="eza --sort=type --long --icons always --no-time --no-user --header"
alias ll="eza --sort=type --long --icons always --git --all"
alias lll="eza --sort=type --long --icons always --git --all --total-size"
alias v="clear && nvim"
alias o="xdg-open"
alias pipes="pipes-rs -p 10 -f 60 -t 0.4 -r 0.99"
alias rmcache="paru -Scv --noconfirm"
alias rmorphans="paru -Rns \$(paru -Qtdq) --noconfirm"
alias rmtrash="rm -rf $HOME/.local/share/Trash/*"
alias sl="sl -5 -a -e -d -G -l"
alias sn="systemctl sleep"
alias sv="sudo -E nvim"
alias wifi='sudo -E nvim /etc/NetworkManager/system-connections'
update="clear; paru -Syu --noconfirm"
alias u="$update"
alias ur="$update; systemctl reboot"
alias us="$update; systemctl suspend"
alias urepo="fd -Htdirectory --absolute-path "\.git$" ~/Projects -x bash -c 'cd \"{}/..\"; echo \$(pwd); git pull'"
alias t="cd "$HOME" && exec tmux new-session -A -s jacob"

source <(zoxide init --cmd j bash)
source <(krag_cli completions --shell bash)
source <(fzf --bash)
