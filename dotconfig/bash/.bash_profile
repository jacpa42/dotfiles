export PROJDIR=$HOME/Projects
export DOTDIR=$PROJDIR/dotfiles
export XDG_CACHE_HOME=$HOME/.cache
export XDG_CONFIG_HOME=$HOME/.config
export RANDFILE=$HOME/.local/rnd
export GOPATH=$HOME/.local/share/go
export WALLPAPER_DIRECTORY="$PROJDIR/muur_papier"
export DEFAULT_WALLPAPER="knight_templar"
export GTK_THEME='black-metal-khold:dark'
export KITTY_SHELL_INTEGRATION="shell_integration"

export TERMINAL="/usr/bin/kitty"

export PATH=$PATH:~/.cargo/bin:$DOTDIR/bin

export MPD_HOST="$XDG_RUNTIME_DIR/mpd_socks"
export FZF_DEFAULT_OPTS=--color=base16,gutter:1
export XCURSOR_SIZE=24
export XCURSOR_THEME="catppuccin-mocha-mauve-cursors"

export ANKI_WAYLAND=1
export AQ_DRM_DEVICES="/dev/dri/card2:/dev/dri/card1"
export CLUTTER_BACKEND="wayland"
export GDK_BACKEND="wayland,x11,*"
export QT_QPA_PLATFORM="wayland;xcb"
export QT_QPA_PLATFORMTHEME="qt6ct"
export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
export RADV_PERFTEST="video_decode,video_encode"
export SDL_VIDEODRIVER="wayland"
export XDG_SESSION_TYPE="wayland"

export CHAT_WORKSPACE=1
export WEB_WORKSPACE=2
export TERMINAL_WORKSPACE=3
export STEAM_WORKSPACE=4

export EDITOR=nvim
export VISUAL=nvim
export MANPAGER="nvim +Man!"
export MANROFFOPT="-c"
export HISTSIZE=10000
export HISTFILESIZE=10000
export HISTCONTROL="erasedups:ignorespace"

# NOTE:	I have this in my .bash_profile. It launches hyprland if I'm in tty1 and
# no display session is running. This lets me recover my system if I do
# something restarded. Like the other day I added a line to my .zshrc which ran
# 'clear ; paru ; echo ; rustup update ; echo ; cargo install-update -a ; sudo
# shutdown now'. Not sure why I did this but I did do it. So then I would log in
# and my system would do an update and immediately shut down. Anyways pacman
# created a db.lock file which was not deleted (probably because shutdown caused
# a process using it to end) and then I could go remove that line. Long story
# short, now I have this line below and no greeter so I can be relatively
# confident I don't fucking get locked out yk.
#
# From https://wiki.archlinux.org/title/Xinit#Autostart_X_at_login but adapted :)
([ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]) && sway
