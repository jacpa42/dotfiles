export PS1='%F{blue}%B%~%b%f %F{9}❯%f '
export PATH=$PATH:~/.cargo/bin
export RANDFILE=$HOME/.local/rnd
export FZF_DEFAULT_OPTS=--color=base16,gutter:1

export PROJDIR=$HOME/Projects
export DOTDIR=$PROJDIR/dotfiles
export XDG_CACHE_HOME=$HOME/.cache
export XDG_CONFIG_HOME=$HOME/.config
export ZDOTDIR=$XDG_CONFIG_HOME/zsh
export GOPATH=$HOME/.local/share/go

export EDITOR=nvim
export VISUAL=nvim

export MANPAGER="nvim +Man!"
export MANROFFOPT="-c"

export HISTFILE=$ZDOTDIR/.zhistfile
export HISTSIZE=10000
export SAVEHIST=10000

# note:	I have this in my .zprofile. It launches hyprland if I'm in tty1 and no display session is running.
#	This lets me recover my system if I do something restarded. Like the other day I added a line to my .zshrc
# which ran 'clear ; paru ; echo ; rustup update ; echo ; cargo install-update -a ; sudo shutdown now'. Not sure
# why I did this but I did do it. So then I would log in and my system would do an update and immediately shut
# down. Anyways pacman created a db.lock file which was not deleted (probably because shutdown caused a process using it
#	to end) and then I could go remove that line. Long story short, now I have this line below and no greeter so I
# can be relatively confident I don't fucking get locked out yk.
#
# From https://wiki.archlinux.org/title/Xinit#Autostart_X_at_login but adapted :)
([ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]) && start-hyprland
