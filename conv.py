import sys
from pathlib import Path

import polars as pl
import pyreadstat


def xpt_to_csv(xpt_path: str) -> Path:
    df, meta = pyreadstat.read_xport(xpt_path)
    pldf = pl.from_pandas(df)
    print(pldf)

    csv_path = Path(xpt_path).with_suffix(".csv")
    pldf.write_csv(csv_path)
    print(f"\nwrote to {csv_path}")
    return csv_path


if __name__ == "__main__":
    if len(sys.argv) != 2:
        sys.exit(1)
    xpt_to_csv(sys.argv[1])
