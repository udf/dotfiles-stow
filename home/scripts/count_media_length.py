#!/usr/bin/env python3
import os
from concurrent.futures import ThreadPoolExecutor

import ffmpeg


def walk_files(path):
  for root, dirs, files in os.walk(path):
    for file in files:
      yield os.path.join(root, file)


def probe_media_length(path):
  try:
    d = ffmpeg.probe(path)
    if 'duration' not in d['format']:
      return 0
    return float(d['format']['duration'])
  except ffmpeg.Error as e:
    # this is fine
    pass
  return 0


print('Gathering files...')
files = list(walk_files('.'))
num_files = len(files)

print('Probing...')
total_len = 0
with ThreadPoolExecutor() as pool:
  for i, length in enumerate(pool.map(probe_media_length, files)):
    print(f'\r{round((i + 1) / num_files * 100, 2):.2f}% ({i + 1}/{num_files})', end='')
    total_len += length

print('\r', end='')
print(f'{round(total_len / 3600, 2)} hours ({round(total_len / 3600 / 24, 2)} days)')