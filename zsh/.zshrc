# You need the following in ~/.zshenv: 
#
# export XDG_CONFIG_HOME="$HOME/.config"
# export XDG_DATA_HOME="$XDG_CONFIG_HOME/local/share"
# export XDG_CACHE_HOME="$XDG_CONFIG_HOME/cache"
# export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

. "$HOME/.cargo/env"
export STOW_DIR="$HOME/.config/dotfiles"

export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANROFFOPT="-c"

source /usr/share/fzf/completion.zsh
source /usr/share/fzf/key-bindings.zsh


source "$ZDOTDIR/alias.zsh"
source "$ZDOTDIR/autocomplete.zsh"

# eval "$(krag completions "$(basename "$SHELL")")"
eval "$(zoxide init --cmd cd zsh)"
eval "$(glow completion zsh)"

### THEME ###
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source "$ZDOTDIR/themes/catppuccin_macchiato-zsh-syntax-highlighting.zsh"

HISTFILE="$ZDOTDIR/.zhistfile"
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_SAVE_NO_DUPS
setopt SHARE_HISTORY
setopt MENU_COMPLETE
setopt AUTO_LIST
setopt COMPLETE_IN_WORD

# power_level_10k: https://aur.archlinux.org/packages/zsh-theme-powerlevel10k-git
source "/usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme"
[[ ! -f $ZDOTDIR/.p10k.zsh ]] || source $ZDOTDIR/.p10k.zsh
