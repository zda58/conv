from pathlib import Path
import shutil
import os

src = Path('./clean')
dst = Path(os.path.expanduser('~/data/'))
dst.mkdir(parents=True, exist_ok=True)

for file in src.iterdir():
    if file.is_file():
        shutil.copy2(file, dst)