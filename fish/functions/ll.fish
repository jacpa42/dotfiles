function ll --wraps='eza --colour always --long --icons --total-size --git --all' --wraps='eza --colour always --icons --git --all' --wraps='eza --long --colour always --icons --git --all' --description 'alias ll=eza --long --colour always --icons --git --all'
  eza --long --colour always --icons --git --all $argv
        
end
