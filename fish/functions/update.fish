function update --wraps='sudo pacman -Syu && echo && yay && echo && rustup update && sudo pacman -Rns  && yay -Rns ' --wraps='sudo pacman -Syu && echo && yay && echo && rustup update & sudo pacman -Rns  & yay -Rns ' --wraps='sudo pacman -Syu && echo && yay && echo && rustup update && sudo pacman -Rns ' --description 'alias update=sudo pacman -Syu && echo && yay && echo && rustup update'
  sudo pacman -Syu && echo && yay && echo && rustup update $argv
        
end
