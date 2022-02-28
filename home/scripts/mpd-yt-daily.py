#!/usr/bin/env python
import os
import random
import shutil
import sys
from pathlib import Path

from mpd import CommandError

from _mpd import client

client.timeout = 10
client.idletimeout = 10


def map_key(iterable, key):
  for v in iterable:
    if key in v:
      yield v[key]


def delete_empty_dirs(path):
  if path.name in {'.stfolder'}:
    return
  if not os.path.isdir(path):
    return
  for dir in os.listdir(path):
    delete_empty_dirs(path / dir)
  if not os.listdir(path):
    print('Removing', path)
    os.rmdir(path)


music_dir = Path('/booty/media/music')
subdir = 'pending/yt'
PLAYLIST_NAME = '_yt_pending'

print('deleting disliked')
for track in client.sticker_find('song', subdir, 'rating', '=', 2):
  p = (music_dir / track['file'])
  print('deleting', p)
  p.unlink(missing_ok=True)

if sys.argv[-1] not in {'--new', '--move'}:
  exit()

print('moving liked')
for track in client.sticker_find('song', subdir, 'rating', '=', 10):
  p = (music_dir / track['file'])
  print('moving', p)
  shutil.move(p, music_dir / 'favourites/pending')


delete_empty_dirs(music_dir / subdir)
client.update(subdir)
client.idle('update')


if sys.argv[-1] != '--new':
  exit()

try:
  client.rm(PLAYLIST_NAME)
except CommandError:
  pass

dirs = [p for p in map_key(client.lsinfo(subdir), 'directory')]

dirs = sorted(dirs)
last = dirs.pop()
print('last day', last)
random.shuffle(dirs)
dirs = dirs[:9] + [last]

print('adding', dirs)
files = []
for d in dirs:
  files.extend(p for p in map_key(client.listall(d), 'file'))
print(len(files), 'tracks')
random.shuffle(files)
for track in files:
  client.playlistadd(PLAYLIST_NAME, track)
