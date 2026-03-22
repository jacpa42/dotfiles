format_exts() {
    local color="$1"
    shift
    local exts=("$@")

    exts=("${exts[@]/#/*.}")        # prepend *.
    exts=("${exts[@]/%/=${color}}") # append =color

    local IFS=:
    LS_COLORS+=":${exts[*]}"
}

set_ls_colors() {

    # 09 is cross out
    # 03 is italic
    #
    # rs | reset / normal text
    # di | directory
    # ln | symbolic link
    # pi | named pipe (FIFO)
    # so | socket
    # bd | block device
    # cd | character device
    # or | symbolic link pointing to missing target
    # mi | missing file
    # su | setuid file
    # sg | setgid file
    # ca | capability file
    # tw | sticky directory writable by others
    # ow | other-writable directory
    # st | sticky directory
    # ex | executable file

    # system files
    LS_COLORS="rs=0:di=01;34:ln=04;36:pi=40;33:so=03;35:bd=40;33;01:cd=40;33;01:or=04;31;01:mi=00:su=37;41:sg=30;43:ca=00:tw=30;42:ow=34;42:st=37;44:ex=03;32:*~=00;90:*#=00;90"

    # temp files
    format_exts "00;90" bak crdownload dpkg-dist dpkg-new dpkg-old dpkg-tmp old orig part rej rpmnew rpmorig rpmsave swp tmp ucf-dist ucf-new ucf-old

    # audio stuff
    format_exts "03;33" aac asf au avi cgm dl emf flac flc fli flv gl m4a mid midi mka mp3 mp3 mpc oga ogg ogv ogx opus ra rm rmvb spx wav xcf xspf xwd yuv

    # image stuff
    format_exts "03;35" arw avif bmp gif heic jpeg jpg jxl mjpeg mjpg mng pbm pcx pgm png ppm qoi svg svgz tga tif tiff webm webp xbm xpm

    # complex document stuff
    format_exts "00;31" 7z ace alz apk apkg arc arj bz bz2 cab cpio crate csv cue deb dic docx drpm dwm dxf dz ear egg esd fbx gz jar lha lrz lz lz4 lzh lzma lzo mtl nfo obj ods pdf pyz qet rar rpm rz sar srt swm t7z tar taz tbz tbz2 tgz tlz toml ttf txz tz tzo tzst udeb war whl wim xlsx xz z zip zoo zst

    # video stuff
    format_exts "01;36" m2v m4v mkv mov mp4 mp4v mpeg mpg nuv ogm qt vob webm webp wmv

    # code header stuff
    format_exts "03;37" zon sh ron mk html h hpp glsl css

    # code source stuff
    format_exts "03;33" zig py rs lua js ino cpp c

    # config
    format_exts "01;35" yml service json ini desktop pem conf

    export LS_COLORS="$LS_COLORS:fi=01;37"
}
set_ls_colors

set_prompt() {
    local BLUE="\[\e[34m\]\[\e[1m\]"
    local RED="\[\e[91m\]"
    local GREEN="\[\e[92m\]"
    local RESET="\[\e[0m\]"
    [[ $? -eq 0 ]] && ARROW_COLOR="$BLUE" || ARROW_COLOR="$RED"
    PS1="${BLUE}\w${RESET} ${ARROW_COLOR}❯${RESET} "
}
export PROMPT_COMMAND=set_prompt

set -o vi
bind "set vi-cmd-mode-string \1\e[34;1m\1\e[2 q\2\1\e[0m\2"
bind "set vi-ins-mode-string \1\e[34;1m\1\e[\x36 q\2\1\e[0m\2"
bind 'set keyseq-timeout 50'
bind 'set show-mode-in-prompt on'
bind 'set show-all-if-ambiguous on'
bind 'set colored-stats on'
bind 'set visible-stats on'
bind 'set mark-symlinked-directories on'
bind 'set menu-complete-display-prefix on'
bind 'set echo-control-characters off'
bind 'set enable-bracketed-paste on'
bind 'TAB:menu-complete'
bind '"\e[Z": menu-complete-backward'
bind '"\C-l": clear-screen'

## aliases ##
h() { "$@" --help 2>&1 | bat --plain -lhelp --paging=always; }
function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    yazi "$@" --cwd-file="$tmp"
    IFS= read -r -d '' cwd <"$tmp"
    [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
    rm -f -- "$tmp"
}
alias duai='dua interactive'
alias shuffle='mpv --resume-playback=no --directory-mode=recursive --directory-filter-types="video,audio,playlist,archive" --shuffle .'
alias aqua="asciiquarium --transparent"
alias ff="clear && fastfetch"
alias icat="chafa -w 9 --threads=24 --exact-size=auto -O 9 --format=sixels --passthrough=tmux"
alias l="ls --group-directories-first --indicator-style=none -gcGh --time-style=\"+%H:%M %d/%m/%y\" --color=auto"
alias ll="ls --group-directories-first -AgcGh --time-style=\"+%H:%M %d/%m/%y\" --color=auto"
alias v="clear && nvim"
alias o="xdg-open"
alias pipes="pipes-rs -p 10 -f 60 -t 0.4 -r 0.99"
alias rmcache="paru -Scv --noconfirm"
alias rmorphans="paru -Rns \$(paru -Qtdq) --noconfirm"
alias rmtrash="rm -rf $HOME/.local/share/Trash/*"
alias sl="sl -5 -a -e -d -G -l"
alias sn="systemctl sleep"
alias sv="sudo -E nvim"
alias wifi='sudo -E nvim /etc/NetworkManager/system-connections'
update="clear; paru -Syu --noconfirm"
alias u="$update"
alias ur="$update; systemctl reboot"
alias us="$update; systemctl suspend"
alias urepo="fd -Htdirectory --absolute-path "\.git$" ~/Projects -x bash -c 'cd \"{}/..\"; echo \$(pwd); git pull'"
alias repostat="fd -Htdirectory --absolute-path "\.git$" ~/Projects -x bash -c 'cd \"{}/..\"; echo \$(pwd); git status'"

source <(zoxide init --cmd j bash)
source <(krag_cli completions --shell bash)
source <(fzf --bash)
