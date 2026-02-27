
#!/usr/bin/env python3
"""
Add 'accession' + 'organism' columns to a CSV produced by sortclasses_eval.py
(e.g. groups/20260217/window_hits_long.csv).

Input CSV must contain either:
  - window   (as written by sortclasses_eval.py: it renames window_id -> window)
  - window_id

Window/tile IDs look like:
  DQ211652.1_80_276
  NC_009942.1_0_196

We extract accession as everything before the last two underscore-delimited integers:
  DQ211652.1_80_276 -> DQ211652.1

NCBI lookup method:
  Uses NCBI Entrez Direct (EDirect): epost | esummary | xtract
  (No bash -lc, so conda PATH issues are avoided.)

Install:
  conda activate viromelib
  conda install -c bioconda entrez-direct

Usage:
  python add_organism_by_accession.py \
    --in-csv  groups/20260217/window_hits_long.csv \
    --out-csv groups/20260217/window_hits_long.with_organism.csv

Optional:
  --window-col window_id
  --db nuccore
  --chunk-size 200
"""

from __future__ import annotations
import sys, csv, argparse, subprocess, itertools, re, shutil
from pathlib import Path
from typing import Dict, Iterable, List

def chunked(it: Iterable[str], n: int = 200):
    it = iter(it)
    while True:
        block = list(itertools.islice(it, n))
        if not block:
            break
        yield block

def strip_ver(acc: str) -> str:
    # e.g. NC_045512.2 -> NC_045512
    return re.sub(r"\.[0-9]+$", "", acc)

def parse_accession_from_window_id(win: str) -> str:
    """
    DQ211652.1_80_276 -> DQ211652.1
    Robust approach: if last two underscore-split tokens are digits, drop them.
    Otherwise return original string as fallback.
    """
    s = (win or "").strip()
    if not s:
        return ""
    parts = s.split("_")
    if len(parts) >= 3 and parts[-1].isdigit() and parts[-2].isdigit():
        return "_".join(parts[:-2])
    return s

def require_exec(exe: str):
    if shutil.which(exe) is None:
        sys.exit(
            f"ERROR: required command '{exe}' not found in PATH for this Python process.\n"
            f"Install EDirect in this env:\n"
            f"  conda activate viromelib\n"
            f"  conda install -c bioconda entrez-direct\n"
            f"Then verify:\n"
            f"  which epost esummary xtract\n"
        )

def run_edirect_pipeline(accession_block: List[str], db: str) -> str:
    """
    Run: epost -db <db> -format acc | esummary -db <db> | xtract ...
    Returns TSV lines: AccessionVersion <tab> Organism
    """
    for exe in ("epost", "esummary", "xtract"):
        require_exec(exe)

    input_str = "\n".join(accession_block) + "\n"

    p1 = subprocess.Popen(
        ["epost", "-db", db, "-format", "acc"],
        stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE,
        text=True
    )
    p2 = subprocess.Popen(
        ["esummary", "-db", db],
        stdin=p1.stdout, stdout=subprocess.PIPE, stderr=subprocess.PIPE,
        text=True
    )
    assert p1.stdout is not None
    p1.stdout.close()

    p3 = subprocess.Popen(
        ["xtract", "-pattern", "DocumentSummary", "-element", "AccessionVersion", "Organism"],
        stdin=p2.stdout, stdout=subprocess.PIPE, stderr=subprocess.PIPE,
        text=True
    )
    assert p2.stdout is not None
    p2.stdout.close()

    # Important: feed the accessions into p1
    assert p1.stdin is not None
    out1, err1 = p1.communicate(input=input_str)
    # p1 stdout was piped to p2; out1 is None/empty, that's fine

    out3, err3 = p3.communicate()
    _, err2 = p2.communicate()

    if p1.returncode != 0 or p2.returncode != 0 or p3.returncode != 0:
        sys.exit(
            "ERROR: EDirect pipeline failed\n"
            f"epost rc={p1.returncode}\n{(err1 or '').strip()}\n"
            f"esummary rc={p2.returncode}\n{(err2 or '').strip()}\n"
            f"xtract rc={p3.returncode}\n{(err3 or '').strip()}\n"
        )

    return out3

def fetch_organisms_for_accessions(accessions: List[str], db: str, chunk_size: int) -> Dict[str, str]:
    """
    Returns dict accessionVersion (and versionless fallback) -> organism
    """
    acc2org: Dict[str, str] = {}
    uniq = sorted(set(a for a in accessions if a))

    for block in chunked(uniq, chunk_size):
        tsv = run_edirect_pipeline(block, db=db)
        for line in tsv.splitlines():
            parts = line.rstrip("\n").split("\t")
            if len(parts) >= 2:
                av, org = parts[0].strip(), parts[1].strip()
                if av and org:
                    acc2org[av] = org
                    acc2org.setdefault(strip_ver(av), org)

    return acc2org

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--in-csv", required=True)
    ap.add_argument("--out-csv", required=True)
    ap.add_argument("--window-col", default=None,
                    help="Column containing tiled IDs. If omitted, auto-uses 'window' then 'window_id'.")
    ap.add_argument("--db", default="nuccore", help="NCBI Entrez db (default: nuccore)")
    ap.add_argument("--chunk-size", type=int, default=200, help="EDirect batch size (default: 200)")
    args = ap.parse_args()

    in_path = Path(args.in_csv)
    out_path = Path(args.out_csv)

    # Read input
    with in_path.open("r", newline="") as fh:
        rdr = csv.DictReader(fh)
        rows = list(rdr)
        if not rows:
            sys.exit("ERROR: input CSV is empty")
        fields = rdr.fieldnames or []

    # Determine window column
    window_col = args.window_col
    if window_col is None:
        if "window" in fields:
            window_col = "window"
        elif "window_id" in fields:
            window_col = "window_id"
        else:
            sys.exit("ERROR: input CSV must have 'window' or 'window_id' (or pass --window-col).")
    if window_col not in fields:
        sys.exit(f"ERROR: --window-col '{window_col}' not found in CSV columns: {fields}")

    # Extract accessions
    for r in rows:
        win = str(r.get(window_col, "")).strip()
        r["accession"] = parse_accession_from_window_id(win)

    accessions = [str(r["accession"]).strip() for r in rows if str(r.get("accession","")).strip()]

    # Fetch organisms
    acc2org = fetch_organisms_for_accessions(accessions, db=args.db, chunk_size=args.chunk_size)

    # Output header: preserve all + accession + organism (append if missing)
    out_fields = list(rows[0].keys())
    if "accession" not in out_fields:
        out_fields.append("accession")
    if "organism" not in out_fields:
        out_fields.append("organism")

    # Write output
    out_path.parent.mkdir(parents=True, exist_ok=True)
    with out_path.open("w", newline="") as oh:
        w = csv.DictWriter(oh, fieldnames=out_fields)
        w.writeheader()
        for r in rows:
            acc = str(r.get("accession", "")).strip()
            r["organism"] = acc2org.get(acc) or acc2org.get(strip_ver(acc)) or ""
            w.writerow(r)

    print(f"[OK] wrote: {out_path.resolve()}")

if __name__ == "__main__":
    main()