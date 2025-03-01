export GPG_TTY=$(tty)
export LIBVIRT_DEFAULT_URI="qemu:///system"
export TERM=xterm-color
export LC_TIME=C

# Wait 50ms for key sequences (fixes ctrl+ bindings being slow)
KEYTIMEOUT=5

# History
HISTFILE=~/.histfile
HISTSIZE=10000000
SAVEHIST=10000000
setopt histignoredups
setopt histreduceblanks
setopt INC_APPEND_HISTORY

# completion
autoload -Uz compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
# Include hidden files
_comp_options+=(globdots)

bindkey -M menuselect '^[[Z' reverse-menu-complete

# dircolours
eval $(dircolors ~/.dir_colors)

# escape key codes
bindkey -e
bindkey "\e[H" beginning-of-line       # HOME
bindkey "\e[F" end-of-line             # END
bindkey "\e[3~" delete-char             # DELETE
bindkey "\e[2~" quoted-insert           # INSERT

# keypad enter
bindkey -s "^[OM" "^M"

export WORDCHARS=
bindkey "\e[1;5C" emacs-forward-word
bindkey "\e[1;5D" emacs-backward-word
bindkey "^H" vi-backward-kill-word

# make time builtin look like bash
TIMEFMT=$'\nreal\t%*Es\nuser\t%*Us\nsys\t%*Ss'

# automatically cd on dir name
setopt autocd

# print error on glob match failiure
setopt nomatch

# report background job status immediately
setopt notify

WINDOW_TITLE="term"

# prompt
function do_prompt() {
    two_line=$(( `print -P '%~' | /usr/bin/wc -m` + 50 >= `/usr/bin/tput cols` ))
    echo -n '%B%F{magenta}'
    (( $two_line )) && echo -n '┌'
    echo -n '[%b%F{red}%(?..%? )%B%F{green}%m %b%F{magenta}%~%B]'
    (( $two_line )) && echo -n "\n└"
    echo -n '%# %f%b'

    # reset window title
    echo -ne "%{\033]0;$WINDOW_TITLE\007%}"
}

function setwindowtitle() {
    printf '%s' $'\033]0;' "$WINDOW_TITLE: $1" $'\007'
}

# set window title to running command
function preexec() {
    setwindowtitle "$2"
}

# Issue a BELL when a command is done
function precmd() {
    echo -ne '\a'
}

setopt promptsubst
export PROMPT='$(do_prompt)'
export RPROMPT='$(gitprompt-rs zsh)'
export EDITOR='nvim -p'
if [[ -v DISPLAY ]] && which vscodium &> /dev/null; then
  export EDITOR='vscodium --wait'
fi
if [[ -v DISPLAY ]] && which code &> /dev/null; then
  export EDITOR='code --wait'
fi

# Edit line in vim with alt-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^[e' edit-command-line

# copy current command line to clipboard
function clip_cmd() {
    echo -nE "$BUFFER" | xclip -sel clip
}
zle -N clip_cmd
bindkey "^X" clip_cmd

# colour aliases
alias ls='ls --color=auto'
alias grep='grep --colour=auto'
alias egrep='egrep --colour=auto'
alias fgrep='fgrep --colour=auto'

# confirm before overwriting something
alias cp="cp -i"
alias mv="mv -i"
# human-readable sizes
alias df='df -h'
# show sizes in MB
alias free='free -m'

# mpv aliases
alias wub='mpv --no-video --shuffle "https://www.youtube.com/playlist?list=PLjgVd_07uAd95EmLlzcafgYjwIqHnIDUg"'
alias mpvc="mpv --no-video \$(xclip -selection clipboard -o)"
alias mpva='mpv --no-video'
alias mpvas='mpv --no-video --shuffle'

# youtube-dl
alias yt-dlpm="yt-dlp --add-metadata --replace-in-metadata 'album' '.' '' --parse-metadata 'title:%(track)s' --parse-metadata 'uploader:%(artist)s'"
alias ytadl='yt-dlpm -f bestaudio --no-post-overwrites -ciwx'
alias ytvdl='yt-dlpm -f bestvideo+bestaudio'
alias ytpadl='yt-dlpm -ix -f bestaudio --no-post-overwrites -o "%(playlist)s/%(playlist_index)s. %(title)s-%(id)s.%(ext)s"'
alias ytpvdl='yt-dlpm -i -f bestvideo+bestaudio -o "%(playlist)s/%(playlist_index)s. %(title)s-%(id)s.%(ext)s"'

# mounts a virtualbox share
alias vboxmount='sudo mount -o uid=1000,gid=1000 -t vboxsf'

# Adds changed files and commits
alias gitac='git add -u && git commit'

# shorthands
alias code='vscodium'
alias p='pacman'
alias k='kak'
alias v='nvim'
alias valgrindlc='valgrind --leak-check=full --show-leak-kinds=all'
alias sv='sudo --preserve-env=HOME nvim'
alias gitc='git commit'
alias gita='git add'
alias gitd='git diff'
alias gitds='git diff --stat'

deemixf() {
    i=0
    for url in "$@"; do
        i=$((i+1))
        setwindowtitle "($i/$#) deemix $url"
        echo "($i/$#) $ deemix -b flac $url"
        deemix -b flac "$url"
    done
}

# ddc
alias dell_brightness='ddcutil --model "DELL S2721DGF" setvcp 10'

# Add scripts directory to path
export PATH="$HOME/scripts:$PATH"

# Add Python package binaries to path
export PATH="$HOME/.local/bin:$PATH"

# Add Cargo package binaries to path
export PATH="$HOME/.cargo/bin:$PATH"

# Add npm package binaries to path
export PATH="$HOME/.npm-packages/bin:$PATH"

# Add ruby gem binaries to path
export PATH="$HOME/.local/share/gem/ruby/3.0.0/bin:$PATH"

# syntax highlighting plugin
source ~/zsh/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

# nix on arch
[ -f /usr/etc/profile.d/nix.sh ] && source /usr/etc/profile.d/nix.sh

# fzf
source /usr/share/fzf/completion.zsh
source /usr/share/fzf/key-bindings.zsh

# CTRL-Y - Paste the selected directory path(s) into the command line
__fzf_select_dir() {
  setopt localoptions pipefail no_aliases 2> /dev/null
  local item
  FZF_DEFAULT_COMMAND=${FZF_CTRL_T_COMMAND:-} \
  FZF_DEFAULT_OPTS=$(__fzf_defaults "--reverse --walker=dir,follow,hidden --scheme=path" "${FZF_CTRL_T_OPTS-} -m") \
  FZF_DEFAULT_OPTS_FILE='' $(__fzfcmd) "$@" < /dev/tty | while read item; do
    echo -n "${(q)item} "
  done
  local ret=$?
  echo
  return $ret
}

fzf-dir-widget() {
  LBUFFER="${LBUFFER}$(__fzf_select_dir)"
  local ret=$?
  zle reset-prompt
  return $ret
}
zle     -N   fzf-dir-widget
bindkey '^Y' fzf-dir-widget

reload-fzf-history-widget() {
  fc -RI
  zle fzf-history-widget
}
zle     -N            reload-fzf-history-widget
bindkey -M emacs '^R' reload-fzf-history-widget
bindkey -M vicmd '^R' reload-fzf-history-widget
bindkey -M viins '^R' reload-fzf-history-widget


# run program, so that when it quits we get dropped into a shell
if [[ -v ZSH_RUN ]]; then
    $ZSH_RUN
fi
