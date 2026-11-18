#!/usr/bin/env python3
"""E5: which frozen clusters are the main Class_1b ones, and the cluster of every B1/B2 site.

    explorer_class1b_clusters.py <nodes.tsv>            # preferred: explorer_cm_scan.py output
    explorer_class1b_clusters.py <explorer.html>        # fallback: derive from DATA directly
    explorer_class1b_clusters.py <explorer.html> --list-sets
    explorer_class1b_clusters.py <explorer.html> --set-index N

PREFER THE TSV. `explorer_cm_scan.py extract "$EXPLORER" "$OUTDIR"` is the validated parser --
it is what produced the cluster memberships recorded in CM_CANDIDATES.md Part 3 (cluster 41
12/12, 44 8/8, 5 5/5, 106 3/3, 39 4/4, 110 3/3), and the doc states that it derives the frozen
cluster `fz` per node. Run it and pass its node table here.

The HTML fallback exists only because `fz` is NOT a field on DATA.nodes. The explorer stores
per-site cluster assignments in DATA.sets: a list of saved clusterings, each
{view, mode, date, cl, clusters, inmsa} where `cl` is a list of ints PARALLEL TO DATA.nodes
(-1 = unassigned). The frozen clustering of 2026-10-28 is one of those entries. Selecting the
wrong entry silently gives the wrong clusters, which is why --list-sets prints them all.
"""
import sys, json, csv, collections

# B1/B2 sites, from CM_CANDIDATES.md Part 1. accession (no version) -> note
SITES = {
    'NC_008604': 'B1 cluster5 CXFV 5th copy (NOT a gain -- already an included hit, E3)',
    'NC_012671': 'B1 cluster5 QBV (no explorer node expected: 2/4 reps, SF 0.311)',
    'NC_021069': 'B1 cluster5 mosquito flavivirus',
    'NC_024299': 'B1 cluster5 NIEV (3-copy array)',
    'AB981186':  'B1 cluster5 mosquito flavivirus (genome absent from seed)',
    'MH827524':  'B1 cluster5 QBV (genome absent from seed)',
    'NC_027817': 'B1 recovered PaRV xr4',
    'NC_027819': 'B1 recovered MECDV xr1',
    'LR694076':  'B1 recovered CFAV xr3',
    'MH237596':  'B1 recovered CFAV xr3, 2nd isolate',
    'NC_034017': 'B2 cluster106 Xishuangbanna',
    'NC_034204': 'B2 cluster106 Menghai MFV_xr1',
    'ON949931':  'B2 cluster106 Kilpisjarvi',
    'NC_005064': 'B2 Kamiti',
    'MW897328':  'B2 phaiomys',
    'OM030319':  'B2 novel-hit gain',
    'MN587651':  'B2 novel-hit gain',
    'MN587661':  'B2 novel-hit gain',
    'OP860412':  'B2 novel-hit gain / E3: a genuine cluster-5 gain, 23.2 b',
}

CLUSTER_COLS = ('fz', 'frozen_cluster', 'frozen', 'cluster', 'cl')
CLASS_COLS   = ('cls', 'class', 'cm', 'model', 'call')
ONEB         = ('1b', 'class_1b', 'class1b')


def load_data(path):
    text = open(path, encoding='utf-8', errors='replace').read()
    i = text.find('const DATA')
    if i < 0:
        sys.exit('no `const DATA` in ' + path)
    j = text.find('{', i)
    return json.JSONDecoder().raw_decode(text, j)[0]


def describe_sets(data):
    sets = data.get('sets') or []
    print(f'{len(sets)} clustering sets in DATA.sets:\n')
    print(f"{'idx':>3} {'view':>8} {'mode':>10} {'date':>10} {'clusters':>9} {'assigned':>9} {'max id':>7}")
    for k, st in enumerate(sets):
        cl = st.get('cl') or []
        vals = [c for c in cl if isinstance(c, int) and c >= 0]
        print(f"{k:>3} {str(st.get('view')):>8} {str(st.get('mode')):>10} {str(st.get('date')):>10}"
              f" {len(set(vals)):>9} {len(vals):>9} {(max(vals) if vals else -1):>7}")
    print('\nThe frozen clustering of 2026-10-28 is the finest one (CM_CANDIDATES Part 9 records')
    print('cluster ids up to at least 137), cut at 0.55 with the largest component recut at 0.57.')
    return sets


def pick_set(sets):
    """frozen + all view if present, else the finest clustering."""
    def n_clusters(st):
        cl = st.get('cl') or []
        return len({c for c in cl if isinstance(c, int) and c >= 0})
    pref = [k for k, st in enumerate(sets)
            if 'frozen' in str(st.get('mode', '')).lower() and str(st.get('view')) in ('all', 'All')]
    if pref:
        return pref[0], 'mode contains "frozen" and view is "all"'
    pref = [k for k, st in enumerate(sets) if 'frozen' in str(st.get('mode', '')).lower()]
    if pref:
        return pref[0], 'mode contains "frozen"'
    k = max(range(len(sets)), key=lambda k: n_clusters(sets[k]))
    return k, f'no set is marked frozen; chose the finest ({n_clusters(sets[k])} clusters)'


def rows_from_html(path, set_index=None):
    data = load_data(path)
    nodes = data.get('nodes')
    if not nodes:
        sys.exit('DATA has no "nodes" list')
    sets = data.get('sets') or []
    if not sets:
        sys.exit('DATA has no "sets" list, so there is no cluster assignment to read')
    if set_index is None:
        set_index, why = pick_set(sets)
    else:
        why = 'given with --set-index'
    st = sets[set_index]
    cl = st.get('cl') or []
    if len(cl) != len(nodes):
        sys.exit(f'set {set_index} has {len(cl)} assignments for {len(nodes)} nodes -- not parallel; '
                 'use the explorer_cm_scan.py node table instead')
    print(f'using DATA.sets[{set_index}]  view={st.get("view")} mode={st.get("mode")} '
          f'date={st.get("date")}  ({why})')
    print(f'{len(nodes)} nodes, {len({c for c in cl if c >= 0})} clusters, '
          f'{sum(1 for c in cl if c < 0)} unassigned\n')
    out = []
    for n, c in zip(nodes, cl):
        nid = str(n.get('id', ''))
        out.append({'id': nid,
                    'acc': str(n.get('acc') or nid.split('|')[0]),
                    'stall': nid.split('|')[-1],
                    'fz': c,
                    'cls': str(n.get('cls')),
                    'sf': n.get('sf')})
    return out


def rows_from_tsv(path):
    with open(path, newline='') as fh:
        rdr = csv.DictReader(fh, delimiter='\t')
        cols = rdr.fieldnames or []
        ck = next((c for c in CLUSTER_COLS if c in cols), None)
        clsk = next((c for c in CLASS_COLS if c in cols), None)
        if not ck or not clsk:
            sys.exit(f'{path} columns are {cols}; need one of {CLUSTER_COLS} and one of {CLASS_COLS}')
        print(f'reading {path}: cluster column "{ck}", class column "{clsk}"\n')
        out = []
        for r in rdr:
            nid = r.get('id') or r.get('node') or ''
            try:
                fz = int(r[ck])
            except (TypeError, ValueError):
                continue
            out.append({'id': nid,
                        'acc': r.get('acc') or nid.split('|')[0],
                        'stall': r.get('stall') or nid.split('|')[-1],
                        'fz': fz, 'cls': r[clsk], 'sf': r.get('sf')})
        return out


def report(rows):
    oneb = None
    labels = collections.Counter(r['cls'] for r in rows)
    for v in labels:
        if v.strip().lower() in ONEB:
            oneb = v
            break
    if oneb is None:
        print(f'class labels present: {dict(labels)}')
        sys.exit('none looks like Class_1b')
    print(f'class labels: {dict(labels)}\ntreating "{oneb}" as Class_1b\n')

    by = collections.defaultdict(collections.Counter)
    for r in rows:
        if r['fz'] >= 0:
            by[r['fz']][r['cls']] += 1
    total = sum(c[oneb] for c in by.values())

    print('== Class_1b nodes per frozen cluster, descending')
    print('fz\tnodes\t1b\tcum_1b\tcum_%\tother classes in the same cluster')
    cum = 0
    for fz, c in sorted(by.items(), key=lambda kv: -kv[1][oneb]):
        if c[oneb] == 0:
            break
        cum += c[oneb]
        other = {k: v for k, v in c.items() if k != oneb}
        print(f'{fz}\t{sum(c.values())}\t{c[oneb]}\t{cum}\t{100*cum/total:.0f}\t{other or "-"}')
    print(f'total Class_1b nodes: {total}')
    print('MAIN Class_1b clusters = those down to ~80 % cumulative. A B1/B2 site in one of them is')
    print('`core`; in any other cluster it is `transition:<cluster>` (Part 1 B3).\n')

    print('== every explorer node in the B1/B2 genomes (other copies of those genomes included)')
    print('acc\tstall\tfz\tcls\tsf\tnote')
    seen = set()
    for r in sorted(rows, key=lambda r: (r['acc'], r['stall'])):
        a = r['acc'].split('|')[0].split('.')[0]
        if a in SITES:
            seen.add(a)
            print(f"{a}\t{r['stall']}\t{r['fz']}\t{r['cls']}\t{r['sf']}\t{SITES[a]}")
    missing = sorted(set(SITES) - seen)
    if missing:
        print('\nno explorer node at all (stall failed the >=3-replicate gate, or not among the 416):')
        for a in missing:
            print(f'  {a}\t{SITES[a]}')
        print('  -> these take the group of a relative stalling at the same element;')
        print('     record that in class1b_groups.tsv `source` (Part 9).')


def main():
    argv = sys.argv[1:]
    if not argv:
        sys.exit(__doc__)
    path = next(a for a in argv if not a.startswith('--') and
                not (argv.index(a) > 0 and argv[argv.index(a) - 1] == '--set-index'))
    if '--list-sets' in argv:
        describe_sets(load_data(path))
        return
    si = int(argv[argv.index('--set-index') + 1]) if '--set-index' in argv else None
    rows = rows_from_tsv(path) if path.endswith(('.tsv', '.txt')) else rows_from_html(path, si)
    report(rows)


if __name__ == '__main__':
    main()
