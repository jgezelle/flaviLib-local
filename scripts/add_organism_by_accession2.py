#!/usr/bin/env python3
"""
Add accession + taxid + organism + genus columns to a CSV produced by sortclasses_eval.py,
e.g. groups/20260218/window_all_long.csv

Input CSV must contain either:
  - window   (sortclasses_eval writes this)
  - window_id

Window/tile IDs look like:
  DQ211652.1_80_276
  NC_009942.1_0_196

We extract accession as everything before the last two underscore-delimited integers:
  DQ211652.1_80_276 -> DQ211652.1

Requires Entrez Direct (EDirect):
  conda install -c bioconda entrez-direct

Usage:
  python add_organism_by_accession.py \
    --in-csv  groups/20260218/window_all_long.csv \
    --out-csv groups/20260218/window_all_long.with_taxonomy.csv
"""

from __future__ import annotations
import sys, csv, argparse, subprocess, itertools, re, shutil
from pathlib import Path
from typing import Dict, Iterable, List, Tuple

def chunked(it: Iterable[str], n: int = 200):
    it = iter(it)
    while True:
        block = list(itertools.islice(it, n))
        if not block:
            break
        yield block

def strip_ver(acc: str) -> str:
    return re.sub(r"\.[0-9]+$", "", acc)

def parse_accession_from_window_id(win: str) -> str:
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
            f"  which epost esummary efetch xtract\n"
        )

def run_pipe(cmd1, cmd2, cmd3, input_str: str) -> Tuple[str, str]:
    """
    Run a 3-command pipeline: cmd1 | cmd2 | cmd3
    Feed input_str to cmd1 stdin.
    Return (stdout, combined_stderr).
    """
    p1 = subprocess.Popen(cmd1, stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    p2 = subprocess.Popen(cmd2, stdin=p1.stdout, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    assert p1.stdout is not None
    p1.stdout.close()
    p3 = subprocess.Popen(cmd3, stdin=p2.stdout, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    assert p2.stdout is not None
    p2.stdout.close()

    assert p1.stdin is not None
    _, err1 = p1.communicate(input=input_str)
    out3, err3 = p3.communicate()
    _, err2 = p2.communicate()

    if p1.returncode != 0 or p2.returncode != 0 or p3.returncode != 0:
        raise RuntimeError(
            "Pipeline failed\n"
            f"cmd1 rc={p1.returncode}\n{(err1 or '').strip()}\n"
            f"cmd2 rc={p2.returncode}\n{(err2 or '').strip()}\n"
            f"cmd3 rc={p3.returncode}\n{(err3 or '').strip()}\n"
        )

    return out3, "\n".join([e for e in [err1, err2, err3] if e])

def fetch_taxid_and_organism(accessions: List[str], chunk_size: int = 200) -> Dict[str, Tuple[str, str]]:
    """
    For each accession (or accession.version), fetch (taxid, organism) from nuccore.
    Returns mapping key->(taxid, organism), with fallback versionless keys included.
    """
    for exe in ("epost", "esummary", "xtract"):
        require_exec(exe)

    acc2info: Dict[str, Tuple[str, str]] = {}
    uniq = sorted(set(a for a in accessions if a))

    # nuccore DocumentSummary contains TaxId and Organism
    for block in chunked(uniq, chunk_size):
        inp = "\n".join(block) + "\n"
        out, _ = run_pipe(
            ["epost", "-db", "nuccore", "-format", "acc"],
            ["esummary", "-db", "nuccore"],
            ["xtract", "-pattern", "DocumentSummary", "-element", "AccessionVersion", "TaxId", "Organism"],
            inp
        )
        for line in out.splitlines():
            parts = line.rstrip("\n").split("\t")
            if len(parts) >= 3:
                accver, taxid, org = parts[0].strip(), parts[1].strip(), parts[2].strip()
                if accver:
                    acc2info[accver] = (taxid, org)
                    acc2info.setdefault(strip_ver(accver), (taxid, org))  # fallback key

    return acc2info

def fetch_genus_by_taxid(taxids: List[str], chunk_size: int = 200) -> Dict[str, str]:
    """
    For each TaxId, fetch genus (rank=genus) from taxonomy lineage via efetch XML.
    Returns taxid -> genus_name (may be empty if not found).
    """
    for exe in ("epost", "efetch", "xtract"):
        require_exec(exe)

    tax2genus: Dict[str, str] = {}
    uniq = sorted(set(t for t in taxids if t and t != "0"))

    for block in chunked(uniq, chunk_size):
        inp = "\n".join(block) + "\n"
        try:
            out, _ = run_pipe(
                ["epost", "-db", "taxonomy"],
                ["efetch", "-db", "taxonomy", "-format", "xml"],
                # For each Taxon, print TaxId then the ScientificName of lineage nodes with Rank=genus
                ["xtract", "-pattern", "Taxon", "-element", "TaxId",
                 "-block", "LineageEx/Taxon", "-if", "Rank", "-equals", "genus", "-element", "ScientificName"],
                inp
            )
        except RuntimeError as e:
            # If taxonomy lookup fails for some block, bail with useful info
            raise SystemExit(str(e))

        for line in out.splitlines():
            parts = line.rstrip("\n").split("\t")
            if not parts:
                continue
            taxid = parts[0].strip()
            genus = parts[1].strip() if len(parts) >= 2 else ""
            if taxid:
                tax2genus[taxid] = genus

    return tax2genus

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--in-csv", required=True)
    ap.add_argument("--out-csv", required=True)
    ap.add_argument("--window-col", default=None,
                    help="Column containing tiled IDs. If omitted, auto-uses 'window' then 'window_id'.")
    ap.add_argument("--chunk-size", type=int, default=200)
    args = ap.parse_args()

    in_path = Path(args.in_csv)
    out_path = Path(args.out_csv)

    with in_path.open("r", newline="") as fh:
        rdr = csv.DictReader(fh)
        rows = list(rdr)
        if not rows:
            sys.exit("ERROR: input CSV is empty")
        fields = rdr.fieldnames or []

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

    accessions = [str(r.get("accession", "")).strip() for r in rows if str(r.get("accession", "")).strip()]

    # Fetch (taxid, organism) from nuccore
    acc2info = fetch_taxid_and_organism(accessions, chunk_size=args.chunk_size)

    # Collect taxids then fetch genus from taxonomy
    taxids = []
    for r in rows:
        acc = str(r.get("accession", "")).strip()
        taxid, org = acc2info.get(acc) or acc2info.get(strip_ver(acc)) or ("", "")
        if taxid:
            taxids.append(taxid)
    tax2genus = fetch_genus_by_taxid(taxids, chunk_size=args.chunk_size)

    # Output fields: preserve all + accession + taxid + organism + genus
    out_fields = list(rows[0].keys())
    for col in ("accession", "taxid", "organism", "genus"):
        if col not in out_fields:
            out_fields.append(col)

    out_path.parent.mkdir(parents=True, exist_ok=True)
    with out_path.open("w", newline="") as oh:
        w = csv.DictWriter(oh, fieldnames=out_fields)
        w.writeheader()
        for r in rows:
            acc = str(r.get("accession", "")).strip()
            taxid, org = acc2info.get(acc) or acc2info.get(strip_ver(acc)) or ("", "")
            r["taxid"] = taxid
            r["organism"] = org
            genus = tax2genus.get(taxid, "") if taxid else ""
            r["genus"] = genus if genus else "Unclassified"
            w.writerow(r)

    print(f"[OK] wrote: {out_path.resolve()}")

if __name__ == "__main__":
    main()