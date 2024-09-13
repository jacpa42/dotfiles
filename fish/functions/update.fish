function update --description 'alias update=sudo pacman -Syu && echo && yay && echo && rustup update'
    sudo pacman -Syu && echo && yay && echo && rustup update $argv

end
