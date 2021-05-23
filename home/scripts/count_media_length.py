#!/usr/bin/env python3
import os
import ffmpeg


def walk_files(path):
  for root, dirs, files in os.walk(path):
    for file in files:
      yield os.path.join(root, file)


print('Gathering files...')
files = list(walk_files('.'))
num_files = len(files)

print('Probing...')
total_len = 0
for i, f in enumerate(files):
  print(f'\r{round((i + 1) / num_files * 100, 2)}% ({i + 1}/{num_files})', end='')
  try:
    d = ffmpeg.probe(f)
    if 'duration' not in d['format']:
      continue
    total_len += float(d['format']['duration'])
  except ffmpeg.Error as e:
    # this is fine
    pass

print('\r', end='')
print(f'{round(total_len / 3600, 2)} hours ({round(total_len / 3600 / 24, 2)} days)')