function l --wraps='eza -L --git -T --header' --wraps='eza -l --git -T --header' --wraps='eza --git -T --header' --wraps='eza --git --header' --wraps='eza -l --git --header' --description 'alias l eza -l --git --header'
  eza -l --git --header $argv
        
end
