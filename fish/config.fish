if status is-interactive
end

# function fish_greeting
# 	fortune -a
# end

#starship init fish | source
#enable_transience


set -gx PATH $HOME/.cargo/bin $PATH
set -x STOW_DIR $HOME/.config/dotfiles

fzf --fish | source
zoxide init --cmd cd fish | source
