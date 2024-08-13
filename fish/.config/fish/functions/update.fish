function update --wraps='sudo pacman -Syu && yay' --wraps='sudo pacman -Syu && echo && yay' --wraps='sudo pacman -Syu & echo & yay' --wraps='sudo pacman -Syu & yay' --description 'alias update=sudo pacman -Syu && echo && yay'
  sudo pacman -Syu && echo && yay $argv
        
end
