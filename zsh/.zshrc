# Enable Powerlevel10k instant pjjompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# I need SYSTEM to be set in .zprofile!!!
# Use 'export SYSTEM="$(uname)"'
# MacOS : SYSTEM = Darwin
# Linux : SYSTEM = Linux

source "$HOME/.cargo/env" 2>/dev/null

export SKIM_DEFAULT_OPTIONS='
--prompt="❯ " --cmd-prompt="❯ " --color=bg:#00000000,matched:#F37799,matched_bg:#00000000,current_match:#F37799,current_match_bg:#00000000,spinner:#F5C2E7,info:#89B4FA,cursor:#F5C2E7
'

[ $SYSTEM = "Darwin" ] && export PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"
[ $SYSTEM = "Darwin" ] && eval "$(/opt/homebrew/bin/brew shellenv)"

HISTFILE="$ZDOTDIR/.zhistfile"
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_SAVE_NO_DUPS
setopt HIST_FIND_NO_DUPS
setopt SHARE_HISTORY
setopt MENU_COMPLETE
setopt AUTO_LIST
setopt COMPLETE_IN_WORD

# power_level_10k: https://aur.archlinux.org/packages/zsh-theme-powerlevel10k-git
prefix=$([ "$SYSTEM" = "Darwin" ] && echo "$(brew --prefix)/share/powerlevel10k" || echo "/usr/share/zsh-theme-powerlevel10k")
source "$prefix/powerlevel10k.zsh-theme"
[[ ! -f $ZDOTDIR/.p10k.zsh ]] || source $ZDOTDIR/.p10k.zsh

## alias ##
alias duai='dua interactive'
alias matrix='neo --defaultbg --color=red --fps=144 --speed=8 --charset=cyrillic -m "$(fortune)"'
alias camera="$( [ "$SYSTEM" = "Darwin" ] && echo "open -a 'Photo Booth'" || echo "ffplay /dev/video0" )"
alias aqua="asciiquarium --transparent"
alias ff="clear && fastfetch"
alias icat="chafa -w 9 --threads=24 --exact-size=auto -O 9 --format=kitty --passthrough=tmux"
alias l="eza --sort=type --long --icons always --no-time --no-user --header"
alias ll="eza --sort=type --long --icons always --git --all"
alias lll="eza --sort=type --long --icons always --git --all --total-size"
alias nv="clear && nvim"
alias o="$( [ "$SYSTEM" = "Darwin" ] && echo "open -a" || echo "xdg-open" )"
alias pipes="pipes-rs -p 20 -f 30 -t 0.4 -r 0.99"
alias rmcache="$([ "$SYSTEM" = "Darwin" ] && echo "brew cleanup --prune=all" || echo "paru -Scv --noconfirm")"
alias rmorphans="$([ "$SYSTEM" = "Darwin" ] && echo "brew autoremove" || echo "paru -Rns \$(paru -Qtdq) --noconfirm")"
alias rmtrash="rm -rf $HOME/.local/share/Trash/*"
alias sl="sl -5 -a -e -d -G -l"
alias sn="$( [ "$SYSTEM" = "Darwin" ] && echo 'pmset sleepnow' || echo 'shutdown now' )"
alias snv="clear && sudo -E nvim"
alias u="clear && $( [ "$SYSTEM" = "Darwin" ] && echo 'brew update && brew upgrade' || echo 'paru -Syu' ) && echo && rustup update && echo && cargo install-update -a"
alias ur="clear && $( [ "$SYSTEM" = "Darwin" ] && echo 'brew update && brew upgrade' || echo 'paru -Syu' ) && echo && rustup update && echo && cargo install-update -a && sudo reboot"
alias us="clear && $( [ "$SYSTEM" = "Darwin" ] && echo 'brew update && brew upgrade' || echo 'paru -Syu' ) && echo && rustup update && echo && cargo install-update -a && $( [ "$SYSTEM" = "Darwin" ] && echo 'pmset sleepnow' || echo 'shutdown now' )"

alias urepo="fd -Htdirectory --absolute-path "\.git$" ~/Projects -x zsh -c 'cd \"{}/..\"; echo \$(pwd); git pull'"
alias t="cd "$HOME" && exec tmux new-session -A -s jacob"

function offday() {
	days="${1:-+0}"
	date -d "$days days" +"%H:%M:%S %d-%m-%Y"
}

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
  selected=$(fc -rl 1 | sk | sed 's/^ *[0-9]* *//')
  if [[ -n $selected ]]; then
    BUFFER=$selected
    CURSOR=$#BUFFER
    zle -R -c
  fi
}
zle -N sk-history
bindkey '^R' sk-history

###########

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

##################

### theme ###
prefix=$([ "$SYSTEM" = "Darwin" ] && echo "$(brew --prefix)/share" || echo "/usr/share/zsh/plugins")
source "$prefix/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "$ZDOTDIR/themes/catppuccin_mocha-zsh-syntax-highlighting.zsh"
