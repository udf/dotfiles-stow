export GPG_TTY=$(tty)

# Wait 50ms for key sequences (fixes ctrl+ bindings being slow)
KEYTIMEOUT=5

# History
HISTFILE=~/.histfile
HISTSIZE=10000000
SAVEHIST=10000000
setopt appendhistory
setopt histfindnodups
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

# dircolours
eval $(dircolors ~/.dir_colors)

# escape key codes
bindkey -e
bindkey "\e[5~" beginning-of-history    # PAGE UP
bindkey "\e[6~" end-of-history          # PAGE DOWN
bindkey "\e[7~" beginning-of-line       # HOME
bindkey "\e[8~" end-of-line             # END
bindkey "\e[3~" delete-char             # DELETE
bindkey "\e[2~" quoted-insert           # INSERT

export WORDCHARS=
bindkey "\e[1;5C" emacs-forward-word
bindkey "\e[1;5D" emacs-backward-word
bindkey "\e[1;5E" vi-backward-kill-word

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

# set window title to running command
function preexec() {
    printf '%s' $'\033]0;' "$WINDOW_TITLE: $2" $'\007'
}

# Issue a BELL when a command is done
function precmd() {
    echo -ne '\a'
}

setopt promptsubst
export PROMPT='$(do_prompt)'
export RPROMPT='$(gitprompt-rs zsh)'
export EDITOR='nvim -p'

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
alias ytadl='youtube-dl --no-post-overwrites -ciwx'
alias ytvdl='youtube-dl -f bestvideo+bestaudio'
alias ytpadl='youtube-dl -ix --no-post-overwrites -o "%(playlist)s/%(playlist_index)s. %(title)s-%(id)s.%(ext)s"'
alias ytpvdl='youtube-dl -i -f bestvideo+bestaudio -o "%(playlist)s/%(playlist_index)s. %(title)s-%(id)s.%(ext)s"'

# mounts a virtualbox share
alias vboxmount='sudo mount -o uid=1000,gid=1000 -t vboxsf'

# Adds changed files and commits
alias gitac='git add -u && git commit'

# shorthands
alias subl='subl3'
alias p='pacman'
alias k='kak'
alias v='nvim'
alias valgrindlc='valgrind --leak-check=full --show-leak-kinds=all'
alias sv='sudo --preserve-env=HOME nvim'
alias gitc='git commit'
alias gita='git add'
alias gitd='git diff'
alias gitds='git diff --stat'

# Add scripts directory to path
export PATH="$HOME/scripts:$PATH"

# Add Python package binaries to path
export PATH="$HOME/.local/bin:$PATH"

# Add Cargo package binaries to path
export PATH="$HOME/.cargo/bin:$PATH"

# Add npm package binaries to path
export PATH="$HOME/.npm-packages/bin:$PATH"

# syntax highlighting plugin
source ~/zsh/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

# nix on arch
[ -f /etc/profile.d/nix.sh ] && source /etc/profile.d/nix.sh

# fzf
source /usr/share/fzf/completion.zsh
source /usr/share/fzf/key-bindings.zsh

# fzf's CTRL+R but with unique entries
fzf-history-widget() {
  local selected num
  setopt localoptions noglobsubst noposixbuiltins pipefail 2> /dev/null
  selected=( $(fc -lr 1 | uniq_lines.py |
    FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} $FZF_DEFAULT_OPTS -n2..,.. --tiebreak=index --bind=ctrl-r:toggle-sort $FZF_CTRL_R_OPTS --query=${(qqq)LBUFFER} +m" $(__fzfcmd)) )
  local ret=$?
  if [ -n "$selected" ]; then
    num=$selected[1]
    if [ -n "$num" ]; then
      zle vi-fetch-history -n $num
    fi
  fi
  zle reset-prompt
  return $ret
}
zle     -N   fzf-history-widget
bindkey '^R' fzf-history-widget

# run program, so that when it quits we get dropped into a shell
if [[ -v ZSH_RUN ]]; then
    $ZSH_RUN
fi
