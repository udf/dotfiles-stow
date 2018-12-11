export TERMINAL="urxvt"
export PATH="$HOME/scripts:$PATH"

if [[ "$(tty)" == '/dev/tty1' ]]; then
	exec startx
fi
