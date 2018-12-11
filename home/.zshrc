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
