#!/usr/bin/env python3
# heavily based on https://github.com/Streetwalrus/dotfiles/blob/master/scripts/mkogg

import shutil
import os
from functools import partial
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path
import subprocess

music_path = Path('/booty/media/music')
out_path = Path('/booty/media/music_trans')


def transcode(infile):
    outfile = infile.with_suffix('.opus')
    outfile = out_path / outfile.relative_to(music_path)
    if outfile.is_file():
        return outfile
    print('Transcoding', infile)
    outfile.parent.mkdir(parents=True, exist_ok=True)

    outtmp = outfile.with_suffix('.tmp')
    encode_cmd = [
        'opusenc',
        *'--bitrate 192'.split(),
        '--vbr',
        infile,
        outtmp,
    ]

    subprocess.run(
        encode_cmd,
        stderr=subprocess.DEVNULL,
        stdin=subprocess.DEVNULL,
        check=True
    )

    subprocess.run(
        ['r128gain', outtmp],
        stderr=subprocess.DEVNULL,
        stdin=subprocess.DEVNULL,
        check=True
    )

    os.rename(outtmp, outfile)

    return outfile


def copy_file(infile):
    outfile = out_path / infile.relative_to(music_path)
    if outfile.is_file():
        return outfile
    print('Copying', infile)
    os.makedirs(outfile.parent, exist_ok=True)
    shutil.copy(infile, outfile)
    return outfile


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


def walk_files(path):
  for root, dirs, files in os.walk(path):
    root = Path(root)
    for file in files:
      yield root / file


def main():
    os.nice(16)

    # Gather jobs
    jobs = []
    expected_files = set()

    files = set()
    for playlist in walk_files(music_path / 'playlists'):
        jobs.append(partial(copy_file, playlist))
        with open(playlist) as pl:
            for f in pl:
                files.add(music_path / f.strip('\n'))

    # copy art from all parent directories
    directories = set()
    for f in files:
        directories.add(f.parent)
    for d in directories:
        for f in d.iterdir():
            if f.suffix in {'.jpg', '.jpeg', '.jp2', '.png'}:
                files.add(f)

    for f in files:
        if f.suffix.lower() in ('.flac', '.wav', '.aiff'):
            jobs.append(partial(transcode, f))
            continue
        jobs.append(partial(copy_file, f))

    # Run jobs
    with ThreadPoolExecutor(max_workers=32) as pool:
        for outfile in pool.map(lambda f: f(), jobs):
            expected_files.add(outfile.relative_to(out_path))

    # Delete files that we don't expect to exist in output dir
    for f in walk_files(out_path):
        if f.relative_to(out_path) not in expected_files:
            print('Deleting', f)
            os.remove(f)

    # Remove empty directories in the output dir
    delete_empty_dirs(out_path)


if __name__ == '__main__':
    main()
