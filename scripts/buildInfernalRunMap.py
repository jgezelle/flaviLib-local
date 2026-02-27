#!/usr/bin/env python3
"""
Create a run mapping CSV (infernal_runs.csv) where each row corresponds to one
cmsearch --tblout file (one CM/query per file).

This version is for runs where the *search database* is a tiled oligo library FASTA
(i.e., cmsearch was run against a tiled library), not peak window FASTA.

Each row contains:
- tbl_path:       path to a tblout file
- dataset:        chosen dataset label
- db_fasta_path:  path to the FASTA used as the cmsearch database (tiled oligo library)
- query_name:     the query token found inside the tbl (usually the CM name printed by cmsearch)
- class_label:    canonical label among {class1a, class1b, class2, class3, class4}
- map_source:     'explicit' (from map), 'heuristic', or 'blank'

Notes:
- The query is taken from column 3 (index 2) of the first non-comment data line.
- If column 3 is missing or '-', the parser looks ahead in the first 6 tokens for a likely query.
- Mapping order: explicit --cm-map pairs (case-insensitive key match) -> optional CSV map -> optional heuristic.

Example
-------
ROOT=/Users/jeaninegezelle/Desktop/viromelib/flaviLib
WD="$ROOT"/infernal
cd "$WD"
SCRIPT="$ROOT"/scripts/buildInfernalRunMap.py

python "$SCRIPT" \
  --add-dataset tile20 "fa/library_mifsud_simmonds_EDIT_tile20.fa" "tblout/*_tile20.tbl" \
  --add-dataset tile40 "fa/library_mifsud_simmonds_EDIT_tile40.fa" "tblout/*_tile40.tbl" \
  --add-dataset tile80 "fa/library_mifsud_simmonds_EDIT_tile80.fa" "tblout/*_tile80.tbl" \
  --cm-map Class_1a=class1a \
  --cm-map Class_1b=class1b \
  --cm-map Class_2=class2 \
  --auto-class-from-query \
  --out infernal_runs.csv
"""

from __future__ import annotations
import argparse, glob
from pathlib import Path
from typing import Dict, List
import pandas as pd

VALID = {"class1a", "class1b", "class2", "class3", "class4"}

def read_first_data_tokens(tbl_path: Path) -> list[str]:
    with tbl_path.open("r", errors="ignore") as fh:
        for line in fh:
            if not line.strip() or line.startswith("#"):
                continue
            return line.strip().split()
    return []

def extract_query(tokens: list[str]) -> str:
    """
    Infernal/HMMER tblout layout (typical):
      0: target name
      1: target accession (often '-')
      2: query name   <--- want this
      3: query accession (often '-')
    We take tokens[2] when available and not '-'.
    As a fallback, search the first 6 tokens for the first non '-' token
    that looks like a class/cm label (contains 'class' or starts with 'cl').
    """
    if len(tokens) >= 3 and tokens[2] != "-":
        return tokens[2]
    for t in tokens[:6]:
        tl = t.lower()
        if t != "-" and ("class" in tl or tl.startswith("cl")):
            return t
    return tokens[2] if len(tokens) >= 3 else ""

def normalize_lower(s: str) -> str:
    return s.strip().lower()

def heuristic_class(q: str) -> str | None:
    ql = normalize_lower(q)
    if ql in VALID:
        return ql
    # allow cl2 -> class2, cl4 -> class4, etc.
    if ql.startswith("cl"):
        cand = "class" + ql[2:]
        if cand in VALID:
            return cand
    # allow substring matches like "Class_1a", "class1a_result", etc.
    if "class" in ql:
        for v in sorted(VALID, key=len, reverse=True):
            if v in ql:
                return v
    return None

def load_cm_map_csv(path: Path) -> Dict[str, str]:
    df = pd.read_csv(path)
    need = {"query_name", "class_label"}
    if not need.issubset(df.columns):
        raise SystemExit(f"{path} must have columns: query_name,class_label")
    out: Dict[str, str] = {}
    for _, r in df.iterrows():
        q = str(r["query_name"]).strip()
        c = str(r["class_label"]).strip().lower()
        if q and c in VALID:
            out[q] = c
    return out

def main():
    ap = argparse.ArgumentParser(
        description="Build infernal_runs.csv from dataset blocks and class maps (tiled oligo library DB)."
    )
    ap.add_argument(
        "--add-dataset",
        nargs=3,
        action="append",
        metavar=("DATASET", "DB_FASTA_PATH", "TBL_GLOB"),
        help="Add dataset: label DB_FASTA_PATH TBL_GLOB (may repeat).",
    )
    ap.add_argument(
        "--allow-missing-db-fasta",
        action="store_true",
        help="If set, do not error if DB_FASTA_PATH does not exist on disk; just record it.",
    )
    ap.add_argument(
        "--cm-map",
        action="append",
        default=[],
        metavar="Q=CLASS",
        help="Explicit query->class pairs, e.g., Class_1a=class1a, cl2=class2 (may repeat).",
    )
    ap.add_argument(
        "--cm-map-file",
        default=None,
        help="Optional CSV with columns: query_name,class_label",
    )
    ap.add_argument(
        "--auto-class-from-query",
        action="store_true",
        help="Enable simple heuristic mapping from query names to classes.",
    )
    ap.add_argument("--out", default="infernal_runs.csv", help="Output CSV path")
    args = ap.parse_args()

    if not args.add_dataset:
        raise SystemExit("No --add-dataset blocks provided.")

    # Build explicit map (case-insensitive key matching)
    explicit_map_ci: Dict[str, str] = {}
    for item in args.cm_map:
        if "=" in item:
            q, c = item.split("=", 1)
            c = c.strip().lower()
            if c not in VALID:
                raise SystemExit(f"--cm-map invalid class: {c}")
            explicit_map_ci[normalize_lower(q)] = c

    file_map_ci: Dict[str, str] = {}
    if args.cm_map_file:
        tmp = load_cm_map_csv(Path(args.cm_map_file))
        file_map_ci = {normalize_lower(k): v for k, v in tmp.items()}

    rows: List[dict] = []

    for ds, db_fasta, tbl_glob in args.add_dataset:
        db_fasta_path = Path(db_fasta).expanduser().resolve()
        if (not args.allow_missing_db_fasta) and (not db_fasta_path.exists()):
            raise SystemExit(f"DB FASTA not found: {db_fasta_path}")

        tbl_files = sorted(glob.glob(tbl_glob))
        if not tbl_files:
            raise SystemExit(f"No tbl files matched: {tbl_glob}")

        for tbl in tbl_files:
            tbl_path = Path(tbl).expanduser().resolve()
            if not tbl_path.exists():
                raise SystemExit(f"tbl file not found: {tbl_path}")

            tokens = read_first_data_tokens(tbl_path)
            q = extract_query(tokens)
            q_norm = normalize_lower(q)

            cls = ""
            source = "blank"

            # 1) explicit pairs (case-insensitive)
            if q_norm in explicit_map_ci:
                cls = explicit_map_ci[q_norm]
                source = "explicit"
            # 2) CSV map file
            elif q_norm in file_map_ci:
                cls = file_map_ci[q_norm]
                source = "explicit"
            # 3) heuristic
            elif args.auto_class_from_query:
                cand = heuristic_class(q)
                if cand:
                    cls = cand
                    source = "heuristic"

            if cls and cls not in VALID:
                raise SystemExit(f"Mapped class not in {VALID}: {cls} for query {q}")

            rows.append(
                {
                    "tbl_path": str(tbl_path),
                    "dataset": ds,
                    "db_fasta_path": str(db_fasta_path),
                    "query_name": q,
                    "class_label": cls,
                    "map_source": source,
                }
            )

    df = pd.DataFrame(
        rows,
        columns=[
            "tbl_path",
            "dataset",
            "db_fasta_path",
            "query_name",
            "class_label",
            "map_source",
        ],
    )
    outp = Path(args.out).expanduser().resolve()
    df.to_csv(outp, index=False)

    total = len(df)
    blanks = int((df["class_label"] == "").sum())
    print(f"[OK] wrote {outp} with {total} rows")
    if blanks:
        print(f"[NOTE] {blanks} row(s) have empty class_label. Fill with one of: {sorted(VALID)}")
    else:
        n_exp = int((df["map_source"] == "explicit").sum())
        n_heur = int((df["map_source"] == "heuristic").sum())
        print(f"[INFO] mapping sources — explicit: {n_exp}, heuristic: {n_heur}")

if __name__ == "__main__":
    main()
