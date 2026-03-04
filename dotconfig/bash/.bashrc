set_prompt() {
    local BLUE="\[\e[34m\]\[\e[1m\]"
    local RED="\[\e[91m\]"
    local GREEN="\[\e[92m\]"
    local RESET="\[\e[0m\]"
    [[ $? -eq 0 ]] && ARROW_COLOR="$BLUE" || ARROW_COLOR="$RED"
    PS1="${BLUE}\w${RESET} ${ARROW_COLOR}❯${RESET} "
}

export PROMPT_COMMAND=set_prompt
export EDITOR=nvim
export VISUAL=nvim
export MANPAGER="nvim +Man!"
export MANROFFOPT="-c"
export HISTSIZE=10000
export HISTFILESIZE=10000
export HISTCONTROL="erasedups:ignorespace"

set -o vi
bind "set vi-cmd-mode-string \1\e[34;1m\2NOR \1\e[2 q\2\1\e[0m\2"
bind "set vi-ins-mode-string \1\e[34;1m\2INS \1\e[\x36 q\2\1\e[0m\2"
bind 'set keyseq-timeout 50'
bind 'set show-mode-in-prompt on'
bind 'set show-all-if-ambiguous on'
bind 'set colored-stats on'
bind 'set visible-stats on'
bind 'set mark-symlinked-directories on'
bind 'set menu-complete-display-prefix on'
bind 'set echo-control-characters off'
bind 'set enable-bracketed-paste on'
bind 'TAB:menu-complete'
bind '"\e[Z": menu-complete-backward'
bind '"\C-l": clear-screen'

## aliases ##
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
alias repostat="fd -Htdirectory --absolute-path "\.git$" ~/Projects -x bash -c 'cd \"{}/..\"; echo \$(pwd); git status'"
alias t="cd "$HOME" && exec tmux new-session -A -s jacob"

source <(zoxide init --cmd j bash)
source <(krag_cli completions --shell bash)
source <(fzf --bash)
