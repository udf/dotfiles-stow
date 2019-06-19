#!/usr/bin/env python3
# heavily based on https://github.com/Streetwalrus/dotfiles/blob/master/scripts/mkogg

import shutil
import os
from functools import partial
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path
import subprocess

music_path = Path('~/music').expanduser()
ogg_path = Path('~/music_trans').expanduser()


def transcode(infile):
    outfile = infile.with_suffix('.ogg')
    outfile = ogg_path / outfile.relative_to(music_path)
    if outfile.is_file():
        return outfile
    print('Transcoding', infile)
    outfile.parent.mkdir(parents=True, exist_ok=True)

    encode_cmd = [
        'opusenc',
        *'--bitrate 192'.split(),
        '--vbr',
        infile,
        outfile,
    ]

    subprocess.run(
        encode_cmd,
        stderr=subprocess.DEVNULL,
        stdin=subprocess.DEVNULL,
        check=True
    )

    return outfile


def copy_file(infile):
    outfile = ogg_path / infile.relative_to(music_path)
    if outfile.is_file():
        return outfile
    print('Copying', infile)
    os.makedirs(outfile.parent, exist_ok=True)
    shutil.copy(infile, outfile)
    return outfile


def delete_empty_dirs(path):
    if not os.path.isdir(path):
        return
    for dir in os.listdir(path):
        delete_empty_dirs(os.path.join(path, dir))
    if not os.listdir(path):
        print('Removing', path)
        os.rmdir(path)


def main():
    os.nice(16)

    # Load ignored paths
    ignored_paths = []
    try:
        with open(music_path / '.trignore') as f:
            ignored_paths = [
                str(music_path / p)
                for p in f.read().strip().split()
            ]
    except FileNotFoundError:
        pass

    # Gather jobs
    jobs = []
    expected_files = set()
    for root, dirs, files in os.walk(music_path):
        if any(root.startswith(p) for p in ignored_paths):
            print(f'Ignoring {root}')
            continue
        root = Path(root)
        for f in files:
            f = root / f
            if f.suffix.lower() in ('.flac', '.wav', '.aiff'):
                jobs.append(partial(transcode, f))
                continue
            jobs.append(partial(copy_file, f))

    # Run jobs
    with ThreadPoolExecutor() as pool:
        for outfile in pool.map(lambda f: f(), jobs):
            expected_files.add(outfile.relative_to(ogg_path))

    # Delete files that we don't expect to exist in output dir
    for root, dirs, files in os.walk(ogg_path):
        root = Path(root)
        for f in files:
            f = root / f
            if f.relative_to(ogg_path) not in expected_files:
                print('Deleting', f)
                os.remove(f)

    # Remove empty directories in the output dir
    delete_empty_dirs(ogg_path)


if __name__ == '__main__':
    main()
