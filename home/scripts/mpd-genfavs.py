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

exclude_favourites = [t['file'] for t in client.sticker_find('song', 'favourites', 'rating', '=', 2)]
if args.clean:
  for f in exclude_favourites:
    p = (music_dir / f)
    print('deleting', p)
    p.unlink()

client.update('favourites')
client.idle('update')

for track in client.sticker_find('song', 'albums', 'rating', '=', 10):
  client.playlistadd(PLAYLIST_NAME, track['file'])

all_favourites = {t['file'] for t in client.find("(base 'favourites')")}
for f in all_favourites - set(exclude_favourites):
  client.playlistadd(PLAYLIST_NAME, f)
