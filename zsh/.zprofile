export SYSTEM="$(uname)"

if [ $SYSTEM = "Darwin" ]; then
	export HOMEBREW_NO_EMOJI=1
	export HOMEBREW_NO_ENV_HINTS=1
else
	export wmenu_opts='-i -l5 -f"JetBrainsMonoNerdFont Regular 14.5 @wght=200" -M090618ff -N090618ff -sDCD7BA -m7E9CD8ff -nDCD7BAff -S957FB8ff'
	export RADV_PERFTEST="video_decode,video_encode"
	export CLUTTER_BACKEND="wayland"
	export GDK_BACKEND="wayland,x11,*"
	export GTK2_RC_FILES="/usr/share/themes/Emacs/gtk-2.0-key/gtkrc"
	export GTK_THEME="Adwaita:dark"
	export HYPRCURSOR_SIZE="24"
	export CURSOR_THEME="catppuccin-mocha-mauve-cursors"
	export HYPRCURSOR_THEME="$CURSOR_THEME"
	export QT_AUTO_SCREEN_SCALE_FACTOR="1"
	export QT_QPA_PLATFORM="wayland;xcb"
	export QT_QPA_PLATFORMTHEME="qt6ct"
	export QT_STYLE_OVERRIDE="Adwaita-Dark"
	export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
	export RANDFILE="$HOME/.local/rnd"
	export STOW_DIR="$HOME/.config/dotfiles"
	export XCURSOR_SIZE="24"
	export XCURSOR_THEME="$CURSOR_THEME"
	export XDG_SESSION_TYPE="wayland"
fi

# The zsh cmdline prompt
export PS1='%F{blue}%B%~%b%f %F{9}❯%f '

export SKIM_DEFAULT_OPTIONS='--prompt="❯ " --cmd-prompt="❯ " --color=16'
export DOTDIR="$HOME/Projects/dotfiles"
export ZDOTDIR="$HOME/.config/zsh"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export GOPATH="$HOME/.local/share/go"

export EDITOR="nvim"
export VISUAL="nvim"

# https://www.youtube.com/watch?v=OKuUoZaPiwE&list=LL&index=1
bindkey -v
export KEYTIMEOUT=1

# v in normal changes edits the current command in neovim
autoload edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

export VI_MODE_SET_CURSOR=true
function zle-keymap-select { [[ ${KEYMAP} == vicmd ]] && echo -ne '\e[2 q' || echo -ne '\e[6 q' }
zle -N zle-keymap-select

function zle-line-init { zle -K viins; echo -ne '\e[6 q' }
zle -N zle-line-init

function vi-yank-clipboard { zle vi-yank; wl-copy "$CUTBUFFER" }
zle -N vi-yank-clipboard
bindkey -M vicmd 'yy' vi-yank-clipboard

export LANG="en_ZA.UTF-8"
export LC_ALL="en_ZA.UTF-8"
export MANPAGER="nvim +Man!"
export MANROFFOPT="-c"

# NOTE:	I have this in my .zprofile. It launches hyprland if I'm in tty1 and no display session is running.
#	This lets me recover my system if I do something restarded. Like the other day I added a line to my .zshrc
# which ran 'clear ; paru ; echo ; rustup update ; echo ; cargo install-update -a ; sudo shutdown now'. Not sure
# why I did this but I did do it. So then I would log in and my system would do an update and immediately shut
# down. Anyways pacman created a db.lock file which was not deleted (probably because shutdown caused a process using it
#	to end) and then I could go remove that line. Long story short, now I have this line below and no greeter so I
# can be relatively confident I don't fucking get locked out yk.
#
# From https://wiki.archlinux.org/title/Xinit#Autostart_X_at_login but adapted :)
([ "$SYSTEM" = "Linux" ] && [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]) && (exec river || exec Hyprland)
