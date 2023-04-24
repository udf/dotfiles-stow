#!/usr/bin/env python
import sys
from pathlib import Path
import argparse
from _mpd import client

root = Path('/booty/media/music')


def queue_rated(d, rating):
  i = 0
  for i, track in enumerate(client.sticker_find('song', d, 'rating', '=', rating)):
    add_fn(track['file'])
  if not args.print:
    print(f'Queued {i + 1} track(s)')


def queue_unrated(d):
  to_files = lambda l: {t['file'] for t in l}
  rated = to_files(client.sticker_find('song', d, 'rating', '>', 0))
  all_tracks = to_files(client.find(f"(base '{d}')"))
  print(f'{len(all_tracks)} tracks, {len(rated)} rated')
  i = 0
  for i, track in enumerate(sorted(all_tracks - rated)):
    add_fn(track)
  if not args.print:
    print(f'Queued {i + 1} track(s)')


parser = argparse.ArgumentParser()
parser.add_argument('dirs', action='extend', nargs='+')
parser.add_argument('--print', action='store_true')
modes = parser.add_mutually_exclusive_group()
modes.add_argument('--unrated', action='store_true')
modes.add_argument('--disliked', action='store_true')
args = parser.parse_args()

f = lambda d: queue_rated(d, 10)
if args.disliked:
  f = lambda d: queue_rated(d, 2)
if args.unrated:
  f = queue_unrated

add_fn = print if args.print else client.add

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