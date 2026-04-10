import pandas as pd
from pathlib import Path

for f in Path('./clean').glob('*.csv'):
    pd.read_csv(f).to_csv('./imp/' + f.name, index=False, na_rep=r'\N')