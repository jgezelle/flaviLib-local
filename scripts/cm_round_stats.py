#!/usr/bin/env python3
"""Helpers for cm_iterate.sh. Pure Python, no dependencies.

  stk2fa   SEED.stk OUT.fa              ungapped FASTA from a (multi-block) Stockholm file
  fetch    TBL CLEN MINFRAC OUT         esl-sfetch -C fetchlist from `!` plus-strand hits
                                        covering >= MINFRAC of the model
  novel    HITS.fa KNOWN.fa [K] [MAXC]  hits whose K-mer containment in KNOWN is < MAXC
                                        (defaults K=15, MAXC=0.80) -> prints count, writes
                                        HITS.novel.tsv
  compare  OLD.tbl NEW.tbl [TOL]        per-hit bit-score change for `!` hits, matched on
                                        target + seq-from within TOL nt (default 10)
                                        -> prints summary, writes NEW.tbl.compare.tsv
  cmstat   CMSTAT.txt                   one line: nseq eff_nseq clen bps bifs
  overlap  A.tbl B.tbl [NAME_A NAME_B]  every plus-strand hit of A that overlaps a plus-strand hit
                                        of B on the same target (any inclusion), with both scores;
                                        `better` = lower E-value (models differ in length and
                                        entropy, so calibrated E, not raw bits, is compared), as
                                        in Rfam clan competition
"""
import sys
from collections import defaultdict


def read_fa(path):
    seqs, name, buf = {}, None, []
    with open(path) as fh:
        for line in fh:
            line = line.rstrip()
            if line.startswith(">"):
                if name is not None:
                    seqs[name] = "".join(buf)
                name, buf = line[1:].split()[0], []
            elif line:
                buf.append(line)
    if name is not None:
        seqs[name] = "".join(buf)
    return seqs


def norm(s):
    return s.upper().replace("U", "T")


def tbl_rows(path):
    with open(path) as fh:
        for line in fh:
            if line.startswith("#") or not line.strip():
                continue
            f = line.split()
            yield {
                "target": f[0], "mfrom": int(f[5]), "mto": int(f[6]), "sfrom": int(f[7]),
                "sto": int(f[8]), "strand": f[9], "score": float(f[14]), "evalue": float(f[15]),
                "inc": f[16],
            }


def stk2fa(stk, out):
    seqs = defaultdict(list)
    order = []
    with open(stk) as fh:
        for line in fh:
            if not line.strip() or line.startswith("#") or line.startswith("//"):
                continue
            f = line.split()
            if len(f) != 2:
                continue
            if f[0] not in seqs:
                order.append(f[0])
            seqs[f[0]].append(f[1])
    with open(out, "w") as fh:
        for n in order:
            s = "".join(seqs[n])
            s = "".join(c for c in s if c.isalpha())
            fh.write(f">{n}\n{s}\n")
    print(len(order))


def fetch(tbl, clen, minfrac, out):
    clen, minfrac = int(clen), float(minfrac)
    n = 0
    with open(out, "w") as fh:
        for r in tbl_rows(tbl):
            if r["inc"] != "!" or r["strand"] != "+":
                continue
            if (r["mto"] - r["mfrom"] + 1) < minfrac * clen:
                continue
            fh.write(f"{r['target']}/{r['sfrom']}-{r['sto']} {r['sfrom']} {r['sto']} {r['target']}\n")
            n += 1
    print(n)


def kmers(s, k):
    return {s[i:i + k] for i in range(len(s) - k + 1)}


def novel(hits_fa, known_fa, k=15, maxc=0.80):
    k, maxc = int(k), float(maxc)
    known = set()
    for s in read_fa(known_fa).values():
        known |= kmers(norm(s), k)
    hits = read_fa(hits_fa)
    out = hits_fa.rsplit(".", 1)[0] + ".novel.tsv"
    n_novel = 0
    with open(out, "w") as fh:
        fh.write("hit\tlength\tkmer_containment_in_known\tnovel\n")
        for name, s in hits.items():
            km = kmers(norm(s), k)
            c = len(km & known) / len(km) if km else 1.0
            nov = c < maxc
            n_novel += nov
            fh.write(f"{name}\t{len(s)}\t{c:.3f}\t{int(nov)}\n")
    print(n_novel)


def compare(old_tbl, new_tbl, tol=10):
    tol = int(tol)
    old = [r for r in tbl_rows(old_tbl) if r["inc"] == "!" and r["strand"] == "+"]
    new = [r for r in tbl_rows(new_tbl) if r["inc"] == "!" and r["strand"] == "+"]
    by_t = defaultdict(list)
    for r in new:
        by_t[r["target"]].append(r)
    rows, lost, used = [], [], set()
    for o in old:
        cand = [r for r in by_t[o["target"]] if abs(r["sfrom"] - o["sfrom"]) <= tol and id(r) not in used]
        if not cand:
            lost.append(o)
            continue
        m = min(cand, key=lambda r: abs(r["sfrom"] - o["sfrom"]))
        used.add(id(m))
        rows.append((o, m, m["score"] - o["score"]))
    gained = [r for r in new if id(r) not in used]
    out = new_tbl + ".compare.tsv"
    with open(out, "w") as fh:
        fh.write("target\told_from\tnew_from\told_bits\tnew_bits\tdelta\told_mcols\tnew_mcols\n")
        for o, m, d in sorted(rows, key=lambda x: x[2]):
            fh.write(f"{o['target']}\t{o['sfrom']}\t{m['sfrom']}\t{o['score']}\t{m['score']}\t{d:+.2f}\t"
                     f"{o['mfrom']}-{o['mto']}\t{m['mfrom']}-{m['mto']}\n")
        for o in lost:
            fh.write(f"{o['target']}\t{o['sfrom']}\tLOST\t{o['score']}\t\t\t{o['mfrom']}-{o['mto']}\t\n")
        for m in gained:
            fh.write(f"{m['target']}\tNEW\t{m['sfrom']}\t\t{m['score']}\t\t\t{m['mfrom']}-{m['mto']}\n")
    worst = min((d for _, _, d in rows), default=0.0)
    n_down = sum(1 for _, _, d in rows if d < 0)
    print(f"matched={len(rows)} lost={len(lost)} gained={len(gained)} lower_bits={n_down} worst_delta={worst:+.2f}")


def cmstat(path):
    with open(path) as fh:
        for line in fh:
            if line.startswith("#") or not line.strip():
                continue
            f = line.split()
            # idx name acc nseq eff_nseq clen W bps bifs model cm hmm
            print(f"nseq={f[3]} eff_nseq={f[4]} clen={f[5]} bps={f[7]} bifs={f[8]} relent_cm={f[10]}")
            return
    sys.exit("cmstat output had no model line")


def overlap(a_tbl, b_tbl, na="A", nb="B"):
    A = [r for r in tbl_rows(a_tbl) if r["strand"] == "+"]
    B = defaultdict(list)
    for r in tbl_rows(b_tbl):
        if r["strand"] == "+":
            B[r["target"]].append(r)
    print(f"target\t{na}_span\t{na}_bits\t{na}_E\t{na}_inc\t{nb}_span\t{nb}_bits\t{nb}_E\t{nb}_inc\tbetter")
    n = wa = wb = 0
    for a in sorted(A, key=lambda r: (r["target"], r["sfrom"])):
        ov = [b for b in B[a["target"]] if min(a["sto"], b["sto"]) >= max(a["sfrom"], b["sfrom"])]
        if not ov:
            continue
        b = min(ov, key=lambda r: r["evalue"])
        better = na if a["evalue"] < b["evalue"] else nb
        n += 1; wa += better == na; wb += better == nb
        print(f"{a['target']}\t{a['sfrom']}-{a['sto']}\t{a['score']}\t{a['evalue']}\t{a['inc']}\t"
              f"{b['sfrom']}-{b['sto']}\t{b['score']}\t{b['evalue']}\t{b['inc']}\t{better}")
    print(f"# overlapping hits: {n}; {na} better (lower E): {wa}; {nb} better: {wb}")


if __name__ == "__main__":
    if len(sys.argv) < 2:
        sys.exit(__doc__)
    cmd, args = sys.argv[1], sys.argv[2:]
    {"stk2fa": stk2fa, "fetch": fetch, "novel": novel, "compare": compare, "cmstat": cmstat,
     "overlap": overlap}[cmd](*args)
