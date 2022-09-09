#!/usr/bin/env python
import argparse
import os
from pathlib import Path
import json
import re

import requests
import mutagen


# tag: vocadb entry type
TAG_NAMES = {
  'albumartist': 'Artist',
  'artist': 'Artist',
  'title': 'Song'
}
TL_CACHE_FILE = Path('~/.cache').expanduser() / 'vocadb-tl.json'
TL_SEPARATOR = '\u2063'

tl_cache = {}
if TL_CACHE_FILE.exists():
  with open(TL_CACHE_FILE) as f:
    tl_cache = json.load(f)


def walk_files_sorted(path):
  for root, dirs, files in os.walk(path, topdown=True):
    dirs.sort()
    files.sort()
    root = Path(root)
    for file in files:
      yield root / file


def cache_value(key, value):
  tl_cache[key] = value
  with open(TL_CACHE_FILE, 'w') as f:
    json.dump(tl_cache, f, indent=2, ensure_ascii=False)


def get_english_name(tag, entryType):
  try:
    return tl_cache[tag]
  except KeyError:
    pass

  print('  search:', tag)
  r = requests.get(
    'https://vocadb.net/api/entries',
    params={
      # 'fields': ['Names'],
      'lang': 'English',
      'query': tag,
      'entryTypes': entryType,
      'maxResults': 1
    }
  ).json()

  translated = None
  try:
    if r['items']:
      translated = r['items'][0]['name']
  except:
    print(f'Error parsing response for "{tag}":', r)
    raise

  cache_value(tag, translated)
  return translated


def tl_tag(tag, entryType):
  fmt_tl = lambda tl: f'{tag} {TL_SEPARATOR}({tl})' if tl != tag else tag

  non_ascii = re.findall('([^ -~‐]+)', tag)
  if not non_ascii:
    return tag

  if TL_SEPARATOR in tag:
    tag = tag.split(TL_SEPARATOR)[0].strip()

  # translate entire tag
  if 'feat' not in tag and (tl := get_english_name(tag, entryType)):
    return fmt_tl(tl)

  # try subbing non ascii parts
  first_sub = -1
  def sub_part(m):
    if len(m[0]) < 2:
      return m[0]
    nonlocal first_sub
    if tl := get_english_name(m[0], entryType):
      # remember first replacement so we can trim
      if first_sub < 0:
        first_sub = m.start()
      return tl
    print(f'  failed to tl "{m[0]}" from "{tag}"')
    return m[0]

  # exclude some full width chars
  e = re.escape('（）・、＆‐×＠')
  tl, num = re.subn(fr'[^\W{e}\-_]*[^ -~{e}]+[^\W{e}\-]*[!\?]*', sub_part, tag)
  if num:
    return fmt_tl(tl[max(0, first_sub):])

  return tag


for f in walk_files_sorted('.'):
  if f.suffix.lower() != '.flac':
    continue
  print('Checking', f)
  m = mutagen.File(f)

  modified = False
  for key, entryType in TAG_NAMES.items():
    if key not in m:
      continue
    tags = m[key]
    new_tags = [tl_tag(tag, entryType) for tag in tags]
    if new_tags == tags:
      continue
    modified = True
    for old, new in zip(tags, new_tags):
      print('', f'{key}:', old, '->', new)
    m[key] = new_tags

  if modified:
    m.save()
