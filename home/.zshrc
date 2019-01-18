export GPG_TTY=$(tty)

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
compinit

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

bindkey "\e[1;5C" forward-word
bindkey "\e[1;5D" backward-word
bindkey "\e[1;5E" backward-kill-word

# make time builtin look like bash
TIMEFMT=$'\nreal\t%*Es\nuser\t%*Us\nsys\t%*Ss'

# make *-word commands not match these characters
WORDCHARS='*?_[]~!#$%^(){}<>'

# automatically cd on dir name
setopt autocd

# print error on glob match failiure
setopt nomatch

# report background job status immediately
setopt notify

WINDOW_TITLE="urxvt"

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
    echo -ne "\033]0;$WINDOW_TITLE: $2\007"
}

setopt promptsubst
export PROMPT='$(do_prompt)'
export RPROMPT='$(gitprompt-rs zsh)'
export EDITOR='nvim -p'

# copy current command line to clipboard
zmodload zsh/parameter
function clip_cmd() {
    echo -n "$BUFFER" | xclip -sel clip
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
alias ytadl='youtube-dl --download-archive downloaded.txt --no-post-overwrites -ciwx'
alias ytvdl='youtube-dl -f bestvideo+bestaudio'

# mounts a virtualbox share
alias vboxmount='sudo mount -o uid=1000,gid=1000 -t vboxsf'

# Adds changed files and commits
alias gitac='git add -u && git commit'

# shorthands
alias subl='subl3'
alias p='pacman'
alias v='nvim'
alias k='kak'
alias valgrindlc='valgrind --leak-check=full --show-leak-kinds=all'
alias sv='sudo --preserve-env=HOME nvim'
alias gitc='git commit'
alias gita='git add'
alias gitd='git diff'
alias gitds='git diff --stat'

# Add Python package binaries to path
export PATH="$HOME/.local/bin:$PATH"

# history search plugin
source ~/zsh/zsh-history-substring-search/zsh-history-substring-search.zsh
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=green,fg=white,bold'
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='bg=red,fg=white,bold'
bindkey "\e[A"  history-substring-search-up
bindkey "\e[B"  history-substring-search-down
