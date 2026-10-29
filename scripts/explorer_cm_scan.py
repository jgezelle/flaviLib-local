#!/usr/bin/env python3
"""Scan the flavi150 explorer's sites with a CM and summarise the frozen clusters.

The explorer HTML (plots/flaviLib/flavi150_explorer.html, from build_flavi150_explorer.py) embeds
all of its data in one line, `const DATA = {...};`: `nodes` (one per deduplicated pooled site:
id = FEATURE|stall, acc, sp, genus, cls, sf, det, conc, fz = frozen cluster, seq = the
downstream_seq window, <= 80 nt) and `edges` (LocARNA similarity). This script reads that line
directly; nothing is scraped from the rendered page.

  extract  HTML OUTDIR
      -> OUTDIR/data.json, OUTDIR/nodes.fa (headers n<index>), OUTDIR/nodes.tsv
  annotate OUTDIR TBL MODEL [--call-bits 30]
      best plus-strand hit per node from a `cmsearch --tblout` run on nodes.fa
      -> OUTDIR/nodes_<MODEL>.tsv, and prints the per-cluster composition with MODEL calls
  fetch    OUTDIR CLUSTER NAME [--up 20] [--down 150] [--ref REFERENCE.fa]
      -> OUTDIR/<NAME>.fetchlist for `esl-sfetch -Cf <reference.fa>`: stall -UP .. +DOWN in
         feature coordinates, clipped to the feature length (from --ref, else end - start)

Typical run (2026-10-29):
  explorer_cm_scan.py extract flavi150_explorer.html scan/
  cmsearch --toponly -T 10 --tblout scan/class1c.tbl class1c.cm scan/nodes.fa > /dev/null
  explorer_cm_scan.py annotate scan/ scan/class1c.tbl class1c
  explorer_cm_scan.py fetch scan/ 41 FJJI_fz41
"""
import argparse
import collections as C
import json
import os
import re
import sys


def load(outdir):
    return json.load(open(os.path.join(outdir, "data.json")))


def extract(a):
    line = next((l for l in open(a.html) if l.lstrip().startswith("const DATA =")), None)
    if line is None:
        sys.exit("no `const DATA =` line in " + a.html)
    d = json.loads(line.split("=", 1)[1].strip().rstrip(";"))
    os.makedirs(a.outdir, exist_ok=True)
    json.dump(d, open(os.path.join(a.outdir, "data.json"), "w"))
    N = d["nodes"]
    with open(os.path.join(a.outdir, "nodes.fa"), "w") as fa, open(os.path.join(a.outdir, "nodes.tsv"), "w") as t:
        t.write("node\tid\tspecies\tgenus\tcls\tfz\tsf\tdet\tseq_len\n")
        for i, n in enumerate(N):
            fa.write(f">n{i}\n{n['seq']}\n")
            t.write(f"n{i}\t{n['id']}\t{n['sp']}\t{n['genus']}\t{n['cls']}\t{n['fz']}\t{n['sf']}\t{n['det']}\t{len(n['seq'])}\n")
    print(f"{len(N)} nodes, {len(d['edges'])} edges")
    print("cls:", dict(C.Counter(n["cls"] for n in N)))
    print("frozen clusters:", len({n['fz'] for n in N if n['fz'] is not None}))


def annotate(a):
    N = load(a.outdir)["nodes"]
    best = {}
    for l in open(a.tbl):
        if l.startswith("#") or not l.strip():
            continue
        f = l.split()
        if f[9] != "+":
            continue
        i, sc = int(f[0][1:]), float(f[14])
        if i not in best or sc > best[i]["bits"]:
            best[i] = {"bits": sc, "cm": f"{f[5]}-{f[6]}", "seq": f"{f[7]}-{f[8]}", "trunc": f[10], "E": f[15]}
    out = os.path.join(a.outdir, f"nodes_{a.model}.tsv")
    with open(out, "w") as fh:
        fh.write(f"node\tid\tspecies\tgenus\tcls\tfz\tsf\t{a.model}_bits\tcm_cols\tseq_span\ttrunc\tcall\n")
        for i, n in enumerate(N):
            b = best.get(i)
            call = "" if b is None else (a.model if b["bits"] >= a.call_bits else "sub")
            fh.write(f"n{i}\t{n['id']}\t{n['sp']}\t{n['genus']}\t{n['cls']}\t{n['fz']}\t{n['sf']}\t"
                     + ("\t".join([str(b['bits']), b['cm'], b['seq'], b['trunc']]) if b else "\t\t\t") + f"\t{call}\n")
    called = {i for i, b in best.items() if b["bits"] >= a.call_bits}
    print(f"nodes with a hit >= {a.call_bits} bits: {len(called)}; by existing cls:",
          dict(C.Counter(N[i]['cls'] for i in called)))
    print("weaker hits:")
    for i, b in sorted(best.items(), key=lambda x: -x[1]["bits"]):
        if b["bits"] < a.call_bits:
            n = N[i]
            print(f"  {b['bits']:5.1f} cm {b['cm']:6s} trunc {b['trunc']:3s} {n['id']} {n['sp']} sf={n['sf']} fz={n['fz']}")
    nf = [i for i, n in enumerate(N) if n["cls"] == "None found" and i not in called]
    print(f"'None found' left: {len(nf)}", dict(C.Counter(N[i]['genus'] for i in nf).most_common()))
    print("frozen clusters, composition with this model's calls:")
    comp = C.defaultdict(C.Counter)
    for i, n in enumerate(N):
        if n["fz"] is not None:
            comp[n["fz"]][a.model if i in called else n["cls"]] += 1
    for k, c in sorted(comp.items(), key=lambda x: -sum(x[1].values())):
        sp = {N[i]['sp'] for i in range(len(N)) if N[i]['fz'] == k}
        print(f"  fz {k}: n={sum(c.values())} species={len(sp)} {dict(c)}")
    print("wrote", out)


def ref_lengths(fa):
    L, name, n = {}, None, 0
    for line in open(fa):
        if line.startswith(">"):
            if name is not None:
                L[name] = n
            name, n = line[1:].split()[0], 0
        else:
            n += len(line.strip())
    if name is not None:
        L[name] = n
    return L


def fetch(a):
    N = load(a.outdir)["nodes"]
    lens = ref_lengths(a.ref) if a.ref else {}
    out = os.path.join(a.outdir, f"{a.name}.fetchlist")
    n_out = 0
    with open(out, "w") as fh:
        for n in N:
            if str(n["fz"]) != str(a.cluster):
                continue
            feat, stall = n["id"].rsplit("|", 1)
            fs, fe = map(int, re.search(r"\|(\d+)-(\d+)", feat).groups())
            p = int(stall) - fs + 1                      # 1-based position in the feature
            # Feature length: from the reference when --ref is given. Without it, end - start:
            # the reference records are one shorter than end - start + 1 (esl-sfetch
            # "Subsequence end 263 is greater than length 262", 2026-10-29).
            if lens:
                if feat not in lens:
                    sys.exit(f"{feat} not in {a.ref}")
                L = lens[feat]
            else:
                L = fe - fs
            lo, hi = max(1, p - a.up), min(L, p + a.down)
            fh.write(f"{feat}/{lo}-{hi} {lo} {hi} {feat}\n")
            n_out += 1
    print(f"{n_out} sites -> {out}")


ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
sp = ap.add_subparsers(dest="cmd", required=True)
p = sp.add_parser("extract"); p.add_argument("html"); p.add_argument("outdir"); p.set_defaults(f=extract)
p = sp.add_parser("annotate"); p.add_argument("outdir"); p.add_argument("tbl"); p.add_argument("model")
p.add_argument("--call-bits", type=float, default=30); p.set_defaults(f=annotate)
p = sp.add_parser("fetch"); p.add_argument("outdir"); p.add_argument("cluster"); p.add_argument("name")
p.add_argument("--up", type=int, default=20); p.add_argument("--down", type=int, default=150)
p.add_argument("--ref", help="reference FASTA; feature lengths are read from it (recommended)"); p.set_defaults(f=fetch)
a = ap.parse_args(); a.f(a)
