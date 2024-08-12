function update --wraps='sudo pacman -Syu && yay' --description 'alias update=sudo pacman -Syu && yay'
  sudo pacman -Syu && yay $argv
        
end
