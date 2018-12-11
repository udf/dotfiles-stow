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

# automatically cd on dir name
setopt autocd

# print error on glob match failiure
setopt nomatch

# report background job status immediately
setopt notify

# prompt
setopt promptsubst
export PROMPT='%B%F{magenta}[%b%F{red}%(?..%? )%B%F{green}%m %b%F{magenta}%50<…<%~%<<%B]%# %f%b'
export RPROMPT='$(gitprompt-rs zsh)'
export EDITOR='nvim -p'

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
alias valgrindlc='valgrind --leak-check=full --show-leak-kinds=all'

# copy current command line to clipboard
zmodload zsh/parameter
function clip_cmd() {
    echo -n "$BUFFER" | xclip -sel clip
}
zle -N clip_cmd
bindkey "^X" clip_cmd

# Add Python package binaries to path
export PATH="$HOME/.local/bin:$PATH"
