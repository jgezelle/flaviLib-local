#!/usr/bin/env python3
"""Is a CM's library search returning anything beyond its own seed?

Compares the included (`!`) plus-strand hits of one or more cmsearch tblouts with the sequences
of a Stockholm seed, by accession and hit start. Used 2026-10-29 for the class1c saturation and
lineage checks.

  seed_vs_hits.py SEED.stk TBL [TBL ...] [--tol 5]

Seed names are matched in either of the two forms found in this project:
  ACC.V|FEATURE/from-to                      (esl-sfetch -C naming)
  ACC_V_FEATURE_from-to                      (after MATER / R-scape, `.` and `|` -> `_`)
The accession is taken as everything before the first `|`, or for the second form the leading
`<letters/digits/underscore>_<version>` before the feature coordinates, so `NC_023176_1_...` is
NC_023176.1, not NC.023176. from-to is the trailing `<int>-<int>`.

For each tblout: included hits, distinct accessions, hits matching a seed sequence (same accession,
start within --tol nt), hits matching none, seed sequences with no matching hit, and the
sub-threshold (`?`) rows. With two or more tblouts, also per-hit bit-score change from the first
to each later one.
"""
import argparse
import re
import sys


def seed_entries(stk):
    names = []
    for line in open(stk):
        if not line.strip() or line.startswith(("#", "//")):
            continue
        n = line.split()[0]
        if n not in names:
            names.append(n)
    out = []
    for n in names:
        m = re.search(r"(\d+)-(\d+)$", n)
        if not m:
            sys.exit(f"cannot parse coordinates from seed name {n}")
        if "|" in n:
            acc = n.split("|")[0]
        else:
            m2 = re.match(r"^(.+?)_(\d+)_\d+-\d+_", n)
            if not m2:
                sys.exit(f"cannot parse accession from seed name {n}")
            acc = f"{m2.group(1)}.{m2.group(2)}"
        out.append((acc, int(m.group(1)), int(m.group(2)), n))
    return out


def tbl(path):
    rows = []
    for line in open(path):
        if line.startswith("#") or not line.strip():
            continue
        f = line.split()
        rows.append(dict(acc=f[0].split("|")[0], target=f[0], mcols=f"{f[5]}-{f[6]}", sfrom=int(f[7]),
                         sto=int(f[8]), strand=f[9], bits=float(f[14]), E=f[15], inc=f[16]))
    return rows


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("seed"); ap.add_argument("tbl", nargs="+"); ap.add_argument("--tol", type=int, default=5)
    a = ap.parse_args()
    S = seed_entries(a.seed)
    print(f"seed: {len(S)} sequences, {len({s[0] for s in S})} accessions")
    tables = []
    for t in a.tbl:
        R = tbl(t)
        inc = [r for r in R if r["inc"] == "!" and r["strand"] == "+"]
        tables.append(inc)
        match = lambda r: [s for s in S if s[0] == r["acc"] and abs(s[1] - r["sfrom"]) <= a.tol]
        unmatched = [r for r in inc if not match(r)]
        missed = [s for s in S if not any(r["acc"] == s[0] and abs(r["sfrom"] - s[1]) <= a.tol for r in inc)]
        exact = sum(1 for r in inc if any(s[1] == r["sfrom"] and s[2] == r["sto"] for s in match(r)))
        print(f"\n== {t}")
        print(f"  included + strand: {len(inc)} hits, {len({r['acc'] for r in inc})} accessions; "
              f"minus-strand rows: {sum(1 for r in R if r['strand'] == '-')}")
        print(f"  match a seed sequence (start within {a.tol} nt): {len(inc) - len(unmatched)} "
              f"(identical coordinates: {exact})")
        print(f"  hits matching no seed sequence: {len(unmatched)}")
        for r in unmatched:
            print(f"    {r['target']} {r['sfrom']}-{r['sto']} {r['bits']} bits E {r['E']}")
        print(f"  seed sequences with no hit: {len(missed)}")
        for s in missed:
            print(f"    {s[3]}")
        if inc:
            print(f"  weakest included: E {max(float(r['E']) for r in inc):.2g}")
        for r in R:
            if r["inc"] != "!":
                print(f"  sub-threshold: {r['target']} cm {r['mcols']} {r['sfrom']}-{r['sto']} {r['strand']} "
                      f"{r['bits']} bits E {r['E']}")
    for k in range(1, len(tables)):
        d = []
        for r in tables[0]:
            m = [q for q in tables[k] if q["acc"] == r["acc"] and abs(q["sfrom"] - r["sfrom"]) <= a.tol]
            if m:
                d.append((m[0]["bits"] - r["bits"], r["target"], r["sfrom"]))
        up, down = sum(x[0] > 0 for x in d), sum(x[0] < 0 for x in d)
        print(f"\n== bit scores, {a.tbl[0]} -> {a.tbl[k]}: matched {len(d)}, higher {up}, lower {down}, "
              f"unchanged {len(d) - up - down}")
        for x in sorted(d)[:5]:
            print(f"    {x[0]:+.1f}  {x[1]} {x[2]}")


if __name__ == "__main__":
    main()
