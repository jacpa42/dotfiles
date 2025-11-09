export SYSTEM="$(uname)"
source "$HOME/.cargo/env" 2>/dev/null
# stuff for sk (https://github.com/lotabout/skim)
export SKIM_DEFAULT_OPTIONS='--prompt="❯ " --cmd-prompt="❯ " --color=16'
# The zsh cmdline prompt
export PS1='%F{blue}%B%~%b%f %F{9}❯%f '

[ "$SYSTEM" = "Darwin" ] && export PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"
[ "$SYSTEM" = "Darwin" ] && eval "$(/opt/homebrew/bin/brew shellenv)"

HISTFILE="$ZDOTDIR/.zhistfile"
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_SAVE_NO_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY
setopt MENU_COMPLETE
setopt AUTO_LIST
setopt COMPLETE_IN_WORD

## alias ##
help() { "$@" | bat --plain -lhelp; }
alias duai='dua interactive'
alias shuffle='mpv --directory-mode=recursive --shuffle .'
alias matrix="$( [ "$SYSTEM" = "Darwin" ] && echo "cmatrix" || echo '"neo-matrix --defaultbg --color=red --fps=144 --speed=8 --charset=cyrillic -m $(fortune)"' )"
alias aqua="asciiquarium --transparent"
alias ff="clear && fastfetch"
alias icat="chafa -w 9 --threads=24 --exact-size=auto -O 9 --format=sixels --passthrough=tmux"
alias l="eza --sort=type --long --icons always --no-time --no-user --header"
alias ll="eza --sort=type --long --icons always --git --all"
alias lll="eza --sort=type --long --icons always --git --all --total-size"
alias v="clear && nvim"
alias o="$( [ "$SYSTEM" = "Darwin" ] && echo "open -a" || echo "xdg-open" )"
alias pipes="pipes-rs -p 20 -f 30 -t 0.4 -r 0.99"
alias rmcache="$([ "$SYSTEM" = "Darwin" ] && echo "brew cleanup --prune=all" || echo "paru -Scv --noconfirm")"
alias rmorphans="$([ "$SYSTEM" = "Darwin" ] && echo "brew autoremove" || echo "paru -Rns \$(paru -Qtdq) --noconfirm")"
alias rmtrash="rm -rf $HOME/.local/share/Trash/*"
alias sl="sl -5 -a -e -d -G -l"
alias sn="$( [ "$SYSTEM" = "Darwin" ] && echo 'pmset sleepnow' || echo 'shutdown now' )"
alias sv="clear && sudo -E nvim"
alias u="clear && $( [ "$SYSTEM" = "Darwin" ] && echo 'brew update && brew upgrade' || echo 'paru -Syu' ) && echo && rustup update && echo && cargo install-update -a"
alias ur="clear && $( [ "$SYSTEM" = "Darwin" ] && echo 'brew update && brew upgrade' || echo 'paru -Syu' ) && echo && rustup update && echo && cargo install-update -a && sudo reboot"
alias us="clear && $( [ "$SYSTEM" = "Darwin" ] && echo 'brew update && brew upgrade' || echo 'paru -Syu' ) && echo && rustup update && echo && cargo install-update -a && $( [ "$SYSTEM" = "Darwin" ] && echo 'pmset sleepnow' || echo 'shutdown now' )"

alias urepo="fd -Htdirectory --absolute-path "\.git$" ~/Projects -x zsh -c 'cd \"{}/..\"; echo \$(pwd); git pull'"
alias t="cd "$HOME" && exec tmux new-session -A -s jacob"


# Yazi
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

# skim-rs integration
function sk-history() {
  local selected
  selected=$(fc -rnl 1 | uniq | sk)
  if [[ -n $selected ]]; then
    BUFFER=$selected
    CURSOR=$#BUFFER
    zle -R -c
  fi
}
zle -N sk-history
bindkey '^R' sk-history

## autocomplete ##
# Should be called before compinit
zmodload zsh/complist

# Use hjlk in menu selection (during completion)
# Doesn't work well with interactive mode
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'l' vi-forward-char

autoload -U compinit; compinit
_comp_options+=(globdots)

# +---------+
# | zstyles |
# +---------+

# Ztyle pattern
# :completion:<function>:<completer>:<command>:<argument>:<tag>

# Define completers
zstyle ':completion:*' completer _extensions _complete _approximate

# Use cache for commands using cache
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$ZDOTDIR/.zcompcache"
# Complete the alias when _expand_alias is used as a function
zstyle ':completion:*' complete true

# Use cache for commands which use it

# Allow you to select in a menu
zstyle ':completion:*' menu select

# Autocomplete options for cd instead of directory stack
zstyle ':completion:*' complete-options true

zstyle ':completion:*' file-sort modification

zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'
zstyle ':completion:*:*:*:*:descriptions' format '%F{blue}-- %D %d --%f'
zstyle ':completion:*:*:*:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:*:*:*:warnings' format ' %F{red}-- no matches found --%f'
# zstyle ':completion:*:default' list-prompt '%S%M matches%s'
# Colors for files and directory
zstyle ':completion:*:*:*:*:default' list-colors ${(s.:.)LS_COLORS}

# Only display some tags for the command cd
zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories
# zstyle ':completion:*:complete:git:argument-1:' tag-order !aliases

# Required for completion to be in good groups (named after the tags)
zstyle ':completion:*' group-name ''

zstyle ':completion:*:*:-command-:*:*' group-order aliases builtins functions commands

source <(zoxide init --cmd j zsh)
source <(krag_cli completions)
source <(sk --shell zsh)

# Syntax highlighting (paru -S zsh-syntax-highlighting-git)
[ "$SYSTEM" = "Linux" ] && source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh || source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
