#!/usr/bin/env python
import argparse
from pathlib import Path
from mpd import CommandError

parser = argparse.ArgumentParser()
parser.add_argument('--clean', action='store_true')
args = parser.parse_args()


from _mpd import client
client.timeout = 10
client.idletimeout = 10

music_dir = Path('/booty/media/music')
PLAYLIST_NAME = 'all_favs'

try:
  client.rm(PLAYLIST_NAME)
except CommandError:
  pass

if args.clean:
  for track in client.sticker_find('song', 'favourites', 'rating', '=', 2):
    p = (music_dir / track['file'])
    print('deleting', p)
    p.unlink()

client.update('favourites')
client.idle('update')

for track in client.sticker_find('song', 'albums', 'rating', '=', 10):
  client.playlistadd(PLAYLIST_NAME, track['file'])

client.playlistadd(PLAYLIST_NAME, 'favourites')
