#!/usr/bin/env python3
"""
tblout_to_gdf.py

Filters a cmsearch --tblout file at a conservative E-value cutoff and writes
an esl-sfetch GDF coordinate file (<newname> <from> <to> <source_seqname>,
one per line) for batch subsequence extraction with `esl-sfetch -Cf`.

cmsearch --tblout columns (Infernal 1.1.x, whitespace-delimited, 18 fields):
  target_name accession query_name accession mdl mdl_from mdl_to
  seq_from seq_to strand trunc pass gc bias score evalue inc description

Usage:
    python3 tblout_to_gdf.py clusterA_library_wide.tbl --max-evalue 1e-10 -o clusterA_hits.gdf
"""

import argparse


def parse_tblout(path):
    rows = []
    with open(path) as f:
        for line in f:
            if line.startswith("#") or not line.strip():
                continue
            fields = line.split()
            if len(fields) < 16:
                continue
            rows.append({
                "target_name": fields[0],
                "seq_from": int(fields[7]),
                "seq_to": int(fields[8]),
                "strand": fields[9],
                "score": float(fields[14]),
                "evalue": float(fields[15]),
                "inc": fields[16] if len(fields) > 16 else "",
            })
    return rows


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("tblout")
    ap.add_argument("--max-evalue", type=float, default=1e-10,
                     help="conservative E-value cutoff (default 1e-10; "
                          "Infernal's own default --incE is 0.01, which is "
                          "too permissive for filtering out reverse-strand "
                          "self-hits of a self-complementary stem)")
    ap.add_argument("-o", "--out", default="hits.gdf")
    args = ap.parse_args()

    rows = parse_tblout(args.tblout)
    kept = [r for r in rows if r["evalue"] <= args.max_evalue]

    with open(args.out, "w") as out:
        for r in kept:
            newname = f"{r['target_name']}/{r['seq_from']}-{r['seq_to']}"
            # esl-sfetch: from > to on DNA/RNA => reverse complement fetched
            # automatically, so seq_from/seq_to are passed through as-is
            # regardless of strand.
            out.write(f"{newname}\t{r['seq_from']}\t{r['seq_to']}\t{r['target_name']}\n")

    print(f"{len(rows)} total hits in {args.tblout}; "
          f"{len(kept)} pass E<={args.max_evalue}; wrote {args.out}")


if __name__ == "__main__":
    main()
