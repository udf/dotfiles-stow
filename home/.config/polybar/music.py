#!/usr/bin/python
"""
Enhanced version of music.sh, showing a lot more information and with a
continuous output, which avoids burning CPU with unnecessary script restarts.
"""
import sys
import os
import re
from socket import socket, AF_UNIX, SOCK_STREAM
import time

import gi
gi.require_version('Playerctl', '2.0')
from gi.repository import Playerctl, GLib


output_width = int(sys.argv[1]) if len(sys.argv) > 1 else 100

current_player = None
prev_output = None


# Based on https://github.com/kiike/cmus-remote/blob/master/backend.py
def cmus_get_filename():
    s = socket(AF_UNIX, SOCK_STREAM)
    s.connect(cmus_get_filename.socket_path)

    if not s.send(b'status\n'):
        return 'error getting filename'

    recv = s.recv(4096)
    s.close()

    result = re.findall(r'file (.+)\n', recv.decode('utf-8'))
    if not result:
        return ''

    return os.path.splitext(os.path.basename(result[0]))[0]


cmus_get_filename.socket_path = os.path.join(
    '/run', 'user', str(os.getuid()), 'cmus-socket'
)


def ljust_clip(string, n):
    if len(string) > n:
        return string[:n-3] + '...'
    return string.ljust(n)


def get_status(player):
    status = player.get_property('status')
    return {
        '': '',
        'Playing': ' ',
        'Paused': ' ',
        'Stopped': ' '
    }.get(status, f'[{status}]')


def get_position(player, metadata):
    def fmt(microseconds):
        hours, rem = divmod(round(microseconds / 10**6), 3600)
        minutes, seconds = divmod(rem, 60)
        if hours:
            return f'{hours:02}:{minutes:02}:{seconds:02}'
        return f'{minutes:02}:{seconds:02}'

    position = player.get_property('position')
    position_str = fmt(position)
    duration = metadata.get('mpris:length', 0)

    if duration:
        return '{}/{}'.format(position_str, fmt(duration)), position/duration

    return f'{position_str}', 0


def get_trackname(player, metadata):
    title = metadata.get('xesam:title', '')
    artist = ', '.join(metadata.get('xesam:artist', ''))

    if not artist:
        if not title and 'cmus' in player.get_property('player-name'):
            return cmus_get_filename()
        else:
            return title

    return '{} - {}'.format(artist, title)


def print_status(player=None, metadata=None):
    output = ""
    percentage_progress = 0

    def append_output(data, fmt='{}'):
        nonlocal output
        if data:
            output += fmt.format(data)

    global current_player
    if player is None:
        player = Playerctl.Player()
    current_player = player

    try:
        player.on('play', on_change)
        player.on('pause', on_change)
        player.on('stop', on_change)
        player.on('exit', on_change)
        player.on('metadata', on_change)

        if metadata is None:
            metadata = player.get_property('metadata').unpack()

        append_output(get_status(player))
        append_output(player.get_property('player-name').strip('.'), '[{}]')

        if player.get_property('status') != "Stopped":
            position, percentage_progress = get_position(player, metadata)
            append_output(position, '[{}]')
            append_output(get_trackname(player, metadata), ' {}')
    except:
        output = ""

    global prev_output
    output = ljust_clip(output, output_width)
    if output != prev_output:
        end_underline_pos = round(percentage_progress * output_width)
        print('%{u#fff}' + output[:end_underline_pos] + '%{-u}' + output[end_underline_pos:], flush=True)
        prev_output = output
    return True


def on_change(player, metadata=None):
    print_status()


GLib.timeout_add(500, print_status)
print_status()
GLib.MainLoop().run()
