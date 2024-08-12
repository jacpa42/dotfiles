if status is-interactive
end

# function fish_greeting
# 	fortune -a
# end

#starship init fish | source
#enable_transience


set -gx PATH $HOME/.cargo/bin $PATH
set -gx PATH $HOME/.surrealdb $PATH
set -x STOW_DIR $HOME/dotfiles

fzf --fish | source
zoxide init --cmd cd fish | source
