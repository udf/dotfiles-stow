export TERMINAL="urxvt"
export PATH="$HOME/scripts:$PATH"
export QT_QPA_PLATFORMTHEME="qt5ct"

if [[ "$(tty)" == '/dev/tty1' ]]; then
	exec startx
fi
