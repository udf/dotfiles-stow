if [[ "$(tty)" == '/dev/tty1' ]]; then
    python /etc/X11/xorg.conf.d/gen_config.py
	exec startx
fi
