#!/usr/bin/env python
import sys
from pathlib import Path
import argparse
from _mpd import client

root = Path('/booty/media/music')


def queue_rated(d, rating):
  for track in client.sticker_find('song', d, 'rating', '=', rating):
    client.add(track['file'])


def queue_unrated(d):
  to_files = lambda l: {t['file'] for t in l}
  rated = to_files(client.sticker_find('song', d, 'rating', '>', 0))
  all_tracks = to_files(client.find(f"(base '{d}')"))
  for track in sorted(all_tracks - rated):
    client.add(track)


parser = argparse.ArgumentParser()
parser.add_argument('dirs', action='extend', nargs='+')
modes = parser.add_mutually_exclusive_group()
modes.add_argument('--unrated', action='store_true')
modes.add_argument('--disliked', action='store_true')
args = parser.parse_args()

f = lambda d: queue_rated(d, 10)
if args.disliked:
  f = lambda d: queue_rated(d, 2)
if args.unrated:
  f = queue_unrated

for d in args.dirs:
  d = Path(d)
  if not d.resolve().exists() and not d.is_absolute():
    d = root / d
  d = d.resolve()
  try:
    d = d.relative_to(root)
  except ValueError as e:
    print(f'Skipping "{d}": {e}')
    continue
  f(d)