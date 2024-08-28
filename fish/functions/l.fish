function l --wraps='eza -L --git -T --header' --wraps='eza -l --git -T --header' --wraps='eza --git -T --header' --wraps='eza --git --header' --wraps='eza -l --git --header' --wraps='eza --long --no-time --no-user --header --colour always --icons' --description 'alias l=eza --long --no-time --no-user --header --colour always --icons'
  eza --long --no-time --no-user --header --colour always --icons $argv
        
end
