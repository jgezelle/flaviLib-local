#!/usr/bin/env python3
"""Enumerate each genome's Class_1b tandem array and test whether the satellite
cluster is always the array's 3'-most copy.

Two independent views of the same arrays:

  nodes <nodes.tsv>        the explorer's clustering. CM-independent: it knows
                           nothing about any covariance model, so agreement with
                           the tbl view is a real cross-check.
  tbl <search.tbl> ...     a cmsearch tblout. Model-dependent, but it is the only
                           view that carries bit scores and inclusion, and so the
                           only one that can name POSITIONAL candidates: hits that
                           are the 3'-most copy of an array and are NOT included.

The point of both is the hypothesis from the 2026-11-17 E5 satellite finding:
the odd copy that lands in a satellite cluster (5, 21, 135) is the array's
downstream-most copy, which is the P1-deviant subtype of PMC7527734 (xr3/xr4).
If that holds, the unit to seed is positional -- "the 3'-most copy of every ISF
array" -- and not any one frozen cluster.

MAIN = the main Class_1b clusters from E5. Everything else is a satellite.
"""

import re
import sys
from collections import defaultdict

MAIN = {"130", "131", "133"}

# fz values that mean "no frozen cluster", NOT "a satellite cluster". The 2026-10-28
# clustering left 151 of 416 nodes unassigned, so this set is large and conflating it
# with the satellites invents counterexamples.
UNASSIGNED = {"", "-", "None", "none", "NA", "nan", "-1"}

# cls values that are a DIFFERENT element, not another copy of this array.
# Class_1a and Class_2 copies occur in the same genomes (NC_027819 carries an
# fz 7 / cls 1a node at 10587) and are not array members.
NOT_THIS_ARRAY = {"1a", "2", "dumbbell"}

# accession like NC_027817.1 / AB981186.1 / LR694076, then an optional |start-end
ACC = re.compile(r"\b([A-Z]{1,2}_?\d{5,8})(?:\.\d+)?\b")
OFFSET = re.compile(r"\|(\d+)-(\d+)")


def accession_of(text):
    m = ACC.search(text)
    return m.group(1) if m else None


def offset_of(name):
    """Genomic start of a library sequence, from its own name. 1 if unoffset."""
    m = OFFSET.search(name)
    return int(m.group(1)) if m else 1


def is_odd(copy, show_bits):
    """The copy under investigation. In the clustering view that is an assigned
    satellite cluster; in the tbl view it is a sub-threshold hit. The two are
    different labels for the same question."""
    if show_bits:
        return copy["label"] == "sub"
    return copy["label"] not in MAIN and copy["label"] not in UNASSIGNED


def report(arrays, what, show_bits):
    """arrays: acc -> list of dicts with pos, label, and optionally bits/incl."""
    multi = {a: v for a, v in arrays.items() if len(v) > 1}
    print("%s: %d accessions, %d with more than one copy"
          % (what, len(arrays), len(multi)))
    if not multi:
        return [], []

    confirms, counters = [], []
    for acc in sorted(multi):
        copies = sorted(multi[acc], key=lambda c: c["pos"])
        last = copies[-1]
        odd = [c for c in copies if is_odd(c, show_bits)]
        # does the odd copy sit at the 3' end of the array?
        if odd:
            verdict = "3'-most" if all(c is last for c in odd) else "NOT 3'-most"
            (confirms if verdict == "3'-most" else counters).append(acc)
        elif not show_bits and last["label"] in UNASSIGNED:
            verdict = "3'-most copy is UNCLUSTERED -- still a candidate"
            counters.append(acc + "(uncl)")
        else:
            verdict = "no sub-threshold copy" if show_bits else "no satellite copy"
        name = next((c.get("species") for c in copies if c.get("species")), "")
        print("\n  %s%s  (%d copies)  %s"
              % (acc, "  " + name if name else "", len(copies), verdict))
        for c in copies:
            mark = " <-- 3'-most" if c is last else ""
            if show_bits:
                print("    %9d  %-6s  %6.1f b  %s%s"
                      % (c["pos"], c["label"], c["bits"], c["incl"], mark))
            else:
                print("    %9d  cluster %-6s cls %-11s%s"
                      % (c["pos"], c["label"], c["cls"], mark))
    return confirms, counters


def from_nodes(path):
    """Explorer node table: node id species genus cls fz sf det seq_len."""
    arrays = defaultdict(list)
    kept = skipped = 0
    with open(path) as fh:
        header = fh.readline().rstrip("\n").split("\t")
        try:
            i_id, i_cls, i_fz = header.index("id"), header.index("cls"), header.index("fz")
        except ValueError:
            sys.exit("nodes.tsv lacks id/cls/fz columns; got: %s" % header)
        # species/genus are in the node table and are what this project calls these
        # elements. Reporting bare accessions makes the output unreadable and hides
        # that some of these genomes appear nowhere in CM_CANDIDATES.md.
        i_sp = header.index("species") if "species" in header else None
        i_gen = header.index("genus") if "genus" in header else None
        for line in fh:
            f = line.rstrip("\n").split("\t")
            if len(f) <= max(i_id, i_cls, i_fz):
                continue
            # DO NOT filter to cls == "1b". The explorer's cls is CM-DERIVED, so a
            # copy the Class_1b model misses is labelled "None found" -- which is
            # every satellite copy, by construction. Filtering on it deletes the
            # question. Keep 1b and unclassified; drop the other elements.
            if f[i_cls] in NOT_THIS_ARRAY:
                continue
            acc = accession_of(f[i_id])
            stall = [int(t) for t in re.findall(r"\b(\d{3,6})\b", f[i_id].split("|")[-1])]
            if acc is None or not stall:
                skipped += 1
                continue
            kept += 1
            arrays[acc].append({
                "pos": stall[0], "label": f[i_fz] or "-", "cls": f[i_cls] or "-",
                "species": (f[i_sp] if i_sp is not None and len(f) > i_sp else "") or "",
                "genus": (f[i_gen] if i_gen is not None and len(f) > i_gen else "") or ""})
    print("rows kept %d, unparseable %d" % (kept, skipped))
    # only genomes with at least one confirmed Class_1b copy have an "array" here
    have1b = {a for a, v in arrays.items() if any(c["cls"] == "1b" for c in v)}
    dropped = len(arrays) - len(have1b)
    print("accessions with >=1 cls 1b copy: %d (dropped %d with none)"
          % (len(have1b), dropped))
    return {a: v for a, v in arrays.items() if a in have1b}


def from_tbl(paths):
    """cmsearch --tblout. Converts each hit to genomic coordinates via the
    sequence name's own offset, the same conversion flavi_env.sh hits_at_stall
    uses -- an accession alone cannot say where in the array a hit sits."""
    arrays = defaultdict(list)
    for path in paths:
        with open(path) as fh:
            for line in fh:
                if line.startswith("#"):
                    continue
                f = line.split()
                if len(f) < 17:
                    continue
                name, start, bits, incl = f[0], int(f[7]), float(f[14]), f[16]
                acc = accession_of(name)
                if acc is None:
                    continue
                arrays[acc].append({"pos": offset_of(name) + start - 1,
                                    "label": "incl" if incl == "!" else "sub",
                                    "bits": bits, "incl": incl, "raw": line})
    return arrays


def seed_members(path):
    """Accession + position of every sequence already in the accepted seed, so a
    candidate that is ALREADY seeded is not added a second time."""
    members = []
    if not path:
        return members
    with open(path) as fh:
        for line in fh:
            if line.startswith("#") or not line.strip() or line.startswith("//"):
                continue
            name = line.split()[0]
            acc = accession_of(name)
            if not acc:
                continue
            # Seed names carry the LIBRARY sequence name plus a relative subsequence
            # range, e.g. ACC.1|10000-11000/708-788. Matching raw numbers against a
            # genomic position therefore fails: 708 is not 10707. Convert first,
            # exactly as the tbl view does.
            base = offset_of(name)
            nums = [int(t) for t in re.findall(r"(\d{2,7})", name)]
            rel = re.search(r"/(\d+)-(\d+)", name)
            cand = list(nums)
            if rel:
                cand += [base + int(rel.group(1)) - 1, base + int(rel.group(2)) - 1]
            members.append((acc, cand))
    return members


def already_seeded(acc, pos, members, window=120):
    for m_acc, nums in members:
        if m_acc == acc and any(abs(n - pos) <= window for n in nums):
            return True
    return False


def read_satellites(path):
    """acc, pos of every assigned-satellite copy found in the clustering view.
    Written by `nodes` mode. The clustering is CM-independent, so a candidate it
    supports is NOT subject to the bit floor: a low score is what the model does,
    and the clustering is the evidence that the element is real anyway."""
    sats = []
    if not path:
        return sats
    with open(path) as fh:
        for line in fh:
            if line.startswith("#") or not line.strip():
                continue
            f = line.split()
            if len(f) >= 2:
                sats.append((f[0], int(f[1])))
    return sats


def positional_candidates(arrays, floor=20.0, members=(), sats=()):
    """The 3'-most copy of a multi-copy array that is NOT included.

    This is the set no step has tested. E2 tested a bit-score cut (strong) and a
    novelty cut (newvirus); 2026-11-03 tested sub-threshold sites one at a time.
    None of those is this set, and E5 is the reason to think this one is real.
    """
    out, below, seeded = [], [], []
    for acc, copies in arrays.items():
        if len(copies) < 2:
            continue
        copies = sorted(copies, key=lambda c: c["pos"])
        last = copies[-1]
        if last["incl"] == "!" or not any(c["incl"] == "!" for c in copies[:-1]):
            continue
        backed = any(a == acc and abs(p - last["pos"]) <= 120 for a, p in sats)
        last["backed"] = backed
        if already_seeded(acc, last["pos"], members):
            seeded.append((acc, last))
        elif last["bits"] < floor and not backed:
            below.append((acc, last))
        else:
            out.append((acc, last))
    return (sorted(out, key=lambda t: -t[1]["bits"]),
            sorted(below, key=lambda t: -t[1]["bits"]), seeded)


def main():
    if len(sys.argv) < 3:
        sys.exit(__doc__)
    mode, paths = sys.argv[1], sys.argv[2:]
    floor, seed, satfile = 20.0, None, None
    kept = []
    i = 0
    while i < len(paths):
        if paths[i] == "--floor":
            floor = float(paths[i + 1]); i += 2
        elif paths[i] == "--seed":
            seed = paths[i + 1]; i += 2
        elif paths[i] == "--satellites":
            satfile = paths[i + 1]; i += 2
        else:
            kept.append(paths[i]); i += 1
    paths = kept

    if mode == "nodes":
        arrays = from_nodes(paths[0])
        confirms, counters = report(arrays, "explorer nodes", show_bits=False)
        n = 0
        with open("satellites.tsv", "w") as fh:
            fh.write("#accession\tpos\tcluster\tspecies\tgenus\tn_copies\tis_3prime_most\n")
            for acc in sorted(arrays):
                copies = sorted(arrays[acc], key=lambda c: c["pos"])
                for c in copies:
                    if is_odd(c, False):
                        fh.write("%s\t%d\t%s\t%s\t%s\t%d\t%s\n"
                                 % (acc, c["pos"], c["label"], c.get("species", ""),
                                    c.get("genus", ""), len(copies),
                                    "yes" if c is copies[-1] else "no"))
                        n += 1
        bycl = defaultdict(list)
        for acc in arrays:
            copies = sorted(arrays[acc], key=lambda c: c["pos"])
            for c in copies:
                if is_odd(c, False):
                    nm = c.get("species") or acc
                    where = "3'-most" if c is copies[-1] else (
                        "5'-most" if c is copies[0] else "mid-array")
                    bycl[c["label"]].append((nm, acc, c["pos"], where))
        print("\n%s\nSATELLITES BY CLUSTER, named -- which end of the array each sits at"
              % ("=" * 70))
        for cl in sorted(bycl, key=lambda k: (-len(bycl[k]), k)):
            print("\n  cluster %s  (%d copies)" % (cl, len(bycl[cl])))
            for nm, acc, pos, where in sorted(bycl[cl]):
                print("    %-34s %-12s %8d  %s" % (nm[:34], acc, pos, where))

        print("\nwrote satellites.tsv (%d assigned-satellite copies) in $PWD"
              "\n  -> pass it to tbl mode as --satellites, which exempts a"
              "\n     cluster-backed candidate from the bit floor" % n)
    elif mode == "tbl":
        arrays = from_tbl(paths)
        confirms, counters = report(arrays, "cmsearch tbl", show_bits=True)
    else:
        sys.exit("mode must be nodes or tbl")

    print("\n%s" % ("=" * 70))
    print("HYPOTHESIS: the satellite / sub-threshold copy is the array's 3'-most")
    print("  holds for  %2d: %s" % (len(confirms), " ".join(confirms)))
    print("  fails for  %2d: %s" % (len(counters), " ".join(counters) or "none"))
    if counters:
        print("  -> a counterexample does not sink the idea, but it means the set"
              "\n     cannot be defined as 'last copy' alone; read those arrays by eye.")

    if mode == "tbl":
        members = seed_members(seed)
        if seed:
            print("\nseed read: %s (%d sequences)" % (seed, len(members)))
        else:
            print("\nNO --seed GIVEN: candidates already in the accepted seed cannot"
                  "\nbe excluded, and re-adding one inflates eff_nseq for nothing.")
        sats = read_satellites(satfile)
        if satfile:
            print("clustering view: %d assigned-satellite copies read from %s"
                  % (len(sats), satfile))
        cands, below, seeded = positional_candidates(arrays, floor, members, sats)

        print("\nPOSITIONAL CANDIDATES (3'-most copy, not included, array has an"
              "\nincluded copy upstream, >= %.1f b) -- %d:" % (floor, len(cands)))
        for acc, c in cands:
            print("  %-12s %9d  %6.1f b  %s%s"
                  % (acc, c["pos"], c["bits"], c["incl"],
                     "   <-- also a satellite in the clustering view"
                     if c.get("backed") else ""))
        if seeded:
            print("\nEXCLUDED, already in the seed -- %d. A sub-threshold hit at a"
                  "\nseeded locus is a finding in its own right, not a candidate:" % len(seeded))
            for acc, c in seeded:
                print("  %-12s %9d  %6.1f b  %s" % (acc, c["pos"], c["bits"], c["incl"]))
        if below:
            print("\nEXCLUDED, below %.1f b -- %d. The band this file argues over is"
                  "\n23.4-27.8 b; these are not marginal members, and no satellite"
                  "\ncluster backs them:" % (floor, len(below)))
            for acc, c in below:
                print("  %-12s %9d  %6.1f b  %s" % (acc, c["pos"], c["bits"], c["incl"]))

        with open("positional_candidates.fetchlist", "w") as fh:
            for _, c in cands:
                f = c["raw"].split()
                fh.write("%s/%s-%s %s %s %s\n" % (f[0], f[7], f[8], f[7], f[8], f[0]))
        print("\nwrote positional_candidates.fetchlist (%d lines) in $PWD" % len(cands))


if __name__ == "__main__":
    main()
