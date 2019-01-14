export TERMINAL="urxvt"
export PATH="$HOME/scripts:$PATH"
export QT_QPA_PLATFORMTHEME="qt5ct"
export GDK_SCALE=1

if [[ "$(tty)" == '/dev/tty1' ]]; then
	exec startx
fi
