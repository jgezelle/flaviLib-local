#!/usr/bin/env python3
"""
cluster_mlocarna_alignment.py

Splits a single mlocarna alignment into sub-clusters by pairwise sequence
identity, then reports each cluster's stall-position range and writes out
one ungapped FASTA per cluster (gaps stripped from the aligned sequence) for
re-alignment as an independent sub-group.

Motivation: an mlocarna run over a full set of xrRNA candidates from one
Mifsud clade (e.g. all PLLG members) can return an empty/zero-score alifold
consensus even when real, conserved sub-motifs exist within the set --
because the pooled alignment is forcing RNAalifold to find one structure
shared by what may actually be several unrelated sequences plus a few
small, internally-consistent sub-clusters. Clustering by identity first
exposes those sub-clusters so each can be re-aligned and consensus-folded
on its own.

Input format: plain-text mlocarna alignment output, one sequence per line
as `HEADER  ALIGNED_SEQUENCE` (whitespace-separated, header may itself
contain '|'-delimited fields), terminated before any 'alifold' consensus
line. This matches mlocarna's default stdout / saved alignment listing.
Header fields are expected in the form used by build_pllg_outputs.py's
FASTA export: `accession|species|tree_tip_label|pv=...|stall=...`.

Usage:
    python3 cluster_mlocarna_alignment.py mlocarna_alignment.txt \
        --identity-threshold 0.80 --min-columns 15 -o cluster_out/
"""

import argparse
import os
from collections import defaultdict


def parse_alignment(path):
    records = []
    with open(path) as f:
        for line in f:
            line = line.rstrip("\n")
            if not line.strip() or line.strip().startswith("alifold"):
                continue
            parts = line.split()
            if len(parts) < 2:
                continue
            header, seq = parts[0], parts[-1]
            if not set(seq.upper()) <= set("ACGUTN-"):
                continue  # not an alignment row (e.g. a log line)
            records.append((header, seq))
    return records


def parse_header_fields(header):
    """header: accession|species|tree_tip_label|pv=...|stall=..."""
    fields = header.split("|")
    out = {"accession": fields[0] if len(fields) > 0 else header,
           "species": fields[1] if len(fields) > 1 else "",
           "tip_label": fields[2] if len(fields) > 2 else header}
    for f in fields[3:]:
        if f.startswith("pv="):
            out["pvalue"] = f[3:]
        elif f.startswith("stall="):
            out["stall"] = int(f[len("stall="):])
    return out


def pct_identity(a, b):
    """Fraction identity over columns where neither sequence has a gap."""
    match = compared = 0
    for x, y in zip(a, b):
        if x == "-" or y == "-":
            continue
        compared += 1
        if x == y:
            match += 1
    return (match / compared if compared else 0.0), compared


def cluster_by_identity(records, threshold, min_columns):
    n = len(records)
    parent = list(range(n))

    def find(x):
        while parent[x] != x:
            parent[x] = parent[parent[x]]
            x = parent[x]
        return x

    def union(x, y):
        rx, ry = find(x), find(y)
        if rx != ry:
            parent[rx] = ry

    for i in range(n):
        for j in range(i + 1, n):
            idn, compared = pct_identity(records[i][1], records[j][1])
            if compared >= min_columns and idn >= threshold:
                union(i, j)

    groups = defaultdict(list)
    for i in range(n):
        groups[find(i)].append(i)
    return list(groups.values())


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("alignment", help="mlocarna plain-text alignment (header, seq per line)")
    ap.add_argument("--identity-threshold", type=float, default=0.80)
    ap.add_argument("--min-columns", type=int, default=15,
                     help="minimum aligned non-gap columns required to compare two sequences")
    ap.add_argument("-o", "--outdir", default="clusters")
    args = ap.parse_args()

    records = parse_alignment(args.alignment)
    print(f"Parsed {len(records)} aligned sequences from {args.alignment}")

    groups = cluster_by_identity(records, args.identity_threshold, args.min_columns)
    groups.sort(key=len, reverse=True)

    os.makedirs(args.outdir, exist_ok=True)

    print(f"\nClusters at >={args.identity_threshold*100:.0f}% identity "
          f"(min {args.min_columns} aligned non-gap columns):\n")

    summary_path = os.path.join(args.outdir, "cluster_summary.tsv")
    with open(summary_path, "w") as summary:
        summary.write("cluster\tn\tstall_min\tstall_max\ttip_labels\n")
        cluster_idx = 0
        for group in groups:
            metas = [parse_header_fields(records[i][0]) for i in group]
            stalls = [m["stall"] for m in metas if "stall" in m]
            label = "singleton" if len(group) == 1 else f"cluster{chr(65 + cluster_idx)}"
            if len(group) > 1:
                cluster_idx += 1

            stall_range = f"{min(stalls)}-{max(stalls)}" if stalls else "NA"
            tip_labels = ";".join(m["tip_label"] for m in metas)
            summary.write(f"{label}\t{len(group)}\t"
                           f"{min(stalls) if stalls else ''}\t{max(stalls) if stalls else ''}\t"
                           f"{tip_labels}\n")

            print(f"{label}: n={len(group)}, stall range {stall_range}")
            for m in metas:
                print(f"    {m['tip_label']}  (stall={m.get('stall','?')}, pv={m.get('pvalue','?')})")

            if len(group) > 1:
                outfasta = os.path.join(args.outdir, f"{label}_n{len(group)}.fa")
                with open(outfasta, "w") as out:
                    for i in group:
                        header, seq = records[i]
                        ungapped = seq.replace("-", "")
                        out.write(f">{header}\n{ungapped}\n")
                print(f"    -> wrote {outfasta}\n")
            else:
                print()

    n_singletons = sum(1 for g in groups if len(g) == 1)
    print(f"Summary written to {summary_path}")
    print(f"{n_singletons}/{len(records)} sequences are singletons "
          f"(no partner >= {args.identity_threshold*100:.0f}% identity)")


if __name__ == "__main__":
    main()
