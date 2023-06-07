#!/usr/bin/python
"""
Enhanced version of music.sh, showing a lot more information and with a
continuous output, which avoids burning CPU with unnecessary script restarts.
"""
import sys
import time

import gi
gi.require_version('Playerctl', '2.0')
from gi.repository import Playerctl, GLib


OUTPUT_WIDTH = int(sys.argv[1]) if len(sys.argv) > 1 else 100
# These icons are from nerd-fonts
# https://github.com/ryanoasis/nerd-fonts
STATUS_ICONS = {
    'Paused': '',
    'Playing': '',
    'Stopped': ''
}


class AutoHideModule:
    def __init__(self, fmt='{}', hidden_fmt='{}', timeout=5):
        self.fmt = fmt
        self.hidden_fmt = hidden_fmt
        self.timeout = timeout
        self.prev_change = 0
        self.prev_output = ''

    def get_output(self, val, hidden_text=''):
        output = self.fmt.format(val)
        if output != self.prev_output:
            self.prev_change = time.monotonic()
        self.prev_output = output
        if time.monotonic() - self.prev_change < self.timeout:
            return output
        return self.hidden_fmt.format(hidden_text)


current_player = None
playerctld = None
last_output = None

volume_module = AutoHideModule('[ {}%]', timeout=5)
player_name_module = AutoHideModule('[{}]', '[{}]', timeout=5)


def ljust_clip(string, n):
    if len(string) > n:
        return string[:n-1] + '…'
    return string.ljust(n)


def get_position_info(position, metadata):
    def fmt(seconds):
        if seconds is None:
            return '--:--'
        prefix = '-' if seconds < 0 else ''
        hours, rem = divmod(round(abs(seconds)), 3600)
        minutes, seconds = divmod(rem, 60)
        if hours:
            return f'{prefix}{hours:02}:{minutes:02}:{seconds:02}'
        return f'{prefix}{minutes:02}:{seconds:02}'

    position_str = fmt(position)
    duration = metadata.get('mpris:length', 0) / 1000000

    if duration:
        return f'{position_str}/{fmt(duration)}', max(position, 0) / duration

    return f'{position_str}', 0


def get_trackname(metadata):
    title = metadata.get('xesam:title', '')
    artist = metadata.get('xesam:artist', '')
    url = metadata.get('xesam:url', '')

    if not title:
        return url.split('/')[-1]
    if not artist:
        return title
    if isinstance(artist, list):
        artist = ', '.join(artist)

    return f'{artist} - {title}'


def get_status_line():
    if not playerctld and not current_player:
        return 0, '%{u#cc6666} No Daemon'
    
    if not current_player:
        return 0, ''

    output = ''
    metadata = current_player.get_property('metadata').unpack()
    try:
        position = current_player.get_position() / 1000000
    except gi.repository.GLib.GError:
        position = None
    position_str, percent = get_position_info(position, metadata)

    # Status icon
    output += STATUS_ICONS.get(current_player.get_property('status'), '')
    output += ' '

    # Player name
    name = current_player.get_property('player-name')
    instance = current_player.get_property('player-instance')
    output += player_name_module.get_output(instance or name, name)

    # Position
    output += f'[{position_str}]'

    # Volume
    volume = round(current_player.get_property('volume') * 100)
    output += volume_module.get_output(volume)

    # Track name
    output += ' ' + get_trackname(metadata)

    return percent, output


def print_status():
    global last_output
    percentage_progress, output = get_status_line()
    output = ljust_clip(output, OUTPUT_WIDTH)
    end_underline_i = round(percentage_progress * OUTPUT_WIDTH)
    output = '%{u#fff}' + output[:end_underline_i] + '%{-u}' + output[end_underline_i:]
    if output != last_output:
        print(output, flush=True)
        last_output = output
    return True


def on_change(player, metadata=None):
    print_status()


def fetch_current_player():
    global current_player
    new_player = None
    player_names = Playerctl.list_players()
    if player_names:
        new_player = Playerctl.Player.new_from_name(player_names[0])
    # TODO: maybe dont compare player object pointers
    if new_player == current_player:
        return
    current_player = new_player
    if not current_player:
        return
    new_player.connect('playback-status', on_change)
    new_player.connect('stop', on_change)
    new_player.connect('seeked', on_change)
    new_player.connect('volume', on_change)
    new_player.connect('metadata', on_change)
    new_player.connect('exit', on_exit)
    print_status()


def on_daemon_update(player, metadata, user_data=None):
    # active player might have changed
    fetch_current_player()


def on_exit(player, user_data=None):
    global current_player
    fetch_current_player()


def on_daemon_exit(player, user_data=None):
    global playerctld
    playerctld = None


def on_daemon_appeared(manager, name):
    global playerctld
    if name.instance == 'playerctld':
        # if previous one was killed, grab a new one
        # also seems to start the daemon if it's not already running
        playerctld = Playerctl.Player.new_from_name(name)
        playerctld.connect('exit', on_daemon_exit)
        playerctld.connect('metadata', on_daemon_update)

# Use player manager to grab new playerctld instances
player_manager = Playerctl.PlayerManager()
player_manager.connect('name-appeared', on_daemon_appeared)

# Get initial playerctld instance
name = Playerctl.PlayerName()
name.name = 'playerctld'
name.instance = 'playerctld'
name.source = Playerctl.Source(1)
on_daemon_appeared(None, name)
fetch_current_player()

GLib.timeout_add(500, print_status)
print_status()
GLib.MainLoop().run()
