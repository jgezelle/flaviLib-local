#!/usr/bin/env python3
"""E5: which frozen clusters are the main Class_1b ones, and the cluster of every B1/B2 site.

Usage: python3 explorer_class1b_clusters.py <flavi150_explorer.html>

Reads the explorer's embedded `const DATA = {...};` line as JSON, the same way
explorer_cm_scan.py extract does. Writes nothing; print output goes in the run log.
Note the explorer's `cls` is the superseded 4-MODEL annotation (1a, 1b, 2, dumbbell),
so "None found" there is not "no CM in cm_set_261021".
"""
import sys, json, collections

# B1/B2 sites, from CM_CANDIDATES.md Part 1. accession (no version) -> expected label
SITES = {
    # B1, in class1b_plusFJIS_cluster5_inf112
    'NC_008604': 'B1 cluster5 CXFV 5th copy',
    'NC_012671': 'B1 cluster5 QBV (no explorer node expected: 2/4 reps)',
    'NC_021069': 'B1 cluster5 mosquito flavivirus',
    'NC_024299': 'B1 cluster5 NIEV (3-copy array)',
    'AB981186':  'B1 cluster5 mosquito flavivirus (genome absent from seed)',
    'MH827524':  'B1 cluster5 QBV (genome absent from seed)',
    'NC_027817': 'B1 recovered PaRV xr4',
    'NC_027819': 'B1 recovered MECDV xr1',
    'LR694076':  'B1 recovered CFAV xr3',
    'MH237596':  'B1 recovered CFAV xr3, 2nd isolate',
    # B2, tested and not included
    'NC_034017': 'B2 cluster106 Xishuangbanna',
    'NC_034204': 'B2 cluster106 Menghai MFV_xr1',
    'ON949931':  'B2 cluster106 Kilpisjarvi',
    'NC_005064': 'B2 Kamiti',
    'MW897328':  'B2 phaiomys',
    'OM030319':  'B2 novel-hit gain',
    'MN587651':  'B2 novel-hit gain',
    'MN587661':  'B2 novel-hit gain',
    'OP860412':  'B2 novel-hit gain / count conflict',
}


def load_nodes(path):
    # The explorer writes DATA as one long line, but parse it position-wise rather than
    # line-wise so a reformatted or wrapped file still works.
    text = open(path, encoding='utf-8', errors='replace').read()
    i = text.find('const DATA')
    if i < 0:
        sys.exit('no `const DATA` in ' + path)
    j = text.find('{', i)
    if j < 0:
        sys.exit('`const DATA` found but no opening brace after it')
    try:
        data, _ = json.JSONDecoder().raw_decode(text, j)
    except json.JSONDecodeError as e:
        sys.exit(f'DATA is not parseable JSON at char {j}: {e}')

    def find(o):  # the node list is the list of dicts carrying 'fz'
        if isinstance(o, list) and o and isinstance(o[0], dict) and 'fz' in o[0]:
            return o
        if isinstance(o, dict):
            for v in o.values():
                r = find(v)
                if r:
                    return r
        return None

    nodes = find(data)
    if nodes:
        return nodes, 'fz'

    # The field is not called 'fz' in this explorer. Look for any list of dicts that carries a
    # plausible cluster field, then fall back to printing the structure so it can be named.
    CLUSTER_KEYS = ('fz', 'frozen', 'frozen_cluster', 'fzcluster', 'fz_cluster', 'cluster',
                    'clust', 'cl', 'comp', 'component', 'group', 'grp', 'fz20261028')

    def lists_of_dicts(o, path='DATA', out=None):
        out = out if out is not None else []
        if isinstance(o, list) and o and isinstance(o[0], dict):
            out.append((path, o))
        if isinstance(o, dict):
            for k, v in o.items():
                lists_of_dicts(v, f'{path}.{k}', out)
        elif isinstance(o, list):
            for i, v in enumerate(o[:3]):
                lists_of_dicts(v, f'{path}[{i}]', out)
        return out

    cands = lists_of_dicts(data)
    for path, lst in cands:
        for ck in CLUSTER_KEYS:
            if ck in lst[0]:
                print(f'note: cluster field is "{ck}", not "fz" (node list at {path})\n')
                return lst, ck

    print('Could not identify the node list. Structure of DATA:\n')
    if isinstance(data, dict):
        for k, v in data.items():
            kind = type(v).__name__
            extra = ''
            if isinstance(v, list):
                extra = f', {len(v)} items'
                if v and isinstance(v[0], dict):
                    extra += f'; first item keys: {sorted(v[0])}'
                elif v:
                    extra += f'; first item: {str(v[0])[:80]}'
            elif isinstance(v, dict):
                extra = f'; keys: {sorted(v)[:20]}'
            print(f'  DATA.{k}: {kind}{extra}')
    else:
        print(f'  DATA is a {type(data).__name__}')
    print('\nEvery list-of-dicts found, with its first item\'s keys:')
    for path, lst in cands[:20]:
        print(f'  {path}  ({len(lst)} items)  keys: {sorted(lst[0])}')
    print('\nTell me which list holds the sites and which key is the frozen cluster,')
    print('or pass them: --nodes <path> --cluster-key <key> --class-key <key>')
    sys.exit(2)


def main():
    argv = sys.argv[1:]
    ck_override = cls_override = None
    if '--cluster-key' in argv:
        ck_override = argv[argv.index('--cluster-key') + 1]
    if '--class-key' in argv:
        cls_override = argv[argv.index('--class-key') + 1]
    path = [a for a in argv if not a.startswith('--') and
            not (argv.index(a) and argv[argv.index(a) - 1].startswith('--'))][0]

    nodes, ck = load_nodes(path)
    if ck_override:
        ck = ck_override
    # which key holds the class label
    CLS_KEYS = ('cls', 'class', 'klass', 'cm', 'model', 'label', 'ann', 'annotation')
    clsk = cls_override or next((k for k in CLS_KEYS if k in nodes[0]), None)
    if clsk is None:
        print(f'no class-label key found. A node looks like: {sorted(nodes[0])}')
        print('pass --class-key <key>')
        sys.exit(2)
    print(f'{len(nodes)} nodes; cluster key "{ck}", class key "{clsk}"\n')

    # which value means Class_1b in this explorer
    vals = collections.Counter(str(n.get(clsk)) for n in nodes)
    oneb = next((v for v in vals if v.lower() in ('1b', 'class_1b', 'class1b')), None)
    if oneb is None:
        print(f'class labels present: {dict(vals)}')
        print('none of them looks like Class_1b; pass the right --class-key, or tell me the label.')
        sys.exit(2)
    print(f'treating "{oneb}" as Class_1b ({vals[oneb]} nodes); all labels: {dict(vals)}\n')

    by_fz = collections.defaultdict(collections.Counter)
    for n in nodes:
        by_fz[n[ck]][str(n.get(clsk))] += 1
    total_1b = sum(c[oneb] for c in by_fz.values())

    print('== Class_1b nodes per frozen cluster (4-model annotation), descending')
    print('fz\tnodes\t1b\tcum_1b\tcum_%\tother')
    cum = 0
    for fz, c in sorted(by_fz.items(), key=lambda kv: -kv[1][oneb]):
        if c[oneb] == 0:
            break
        cum += c[oneb]
        other = {k: v for k, v in c.items() if k != oneb}
        print(f"{fz}\t{sum(c.values())}\t{c[oneb]}\t{cum}\t{100*cum/total_1b:.0f}\t{other}")
    print(f'total 1b nodes: {total_1b}')
    print('MAIN Class_1b clusters = those down to ~80 % cumulative. A B1/B2 site in one of')
    print('them is `core`; in any other cluster it is `transition:<cluster>`.\n')

    print('== every explorer node in the B1/B2 genomes (core copies of those genomes included)')
    print('acc\tstall\tfz\tcls\tsf\tnote')
    seen = set()
    for n in sorted(nodes, key=lambda n: n['id']):
        acc = n['id'].split('|')[0].split('.')[0]
        if acc in SITES:
            seen.add(acc)
            stall = n['id'].split('|')[-1]
            print(f"{acc}\t{stall}\t{n[ck]}\t{n.get(clsk)}\t{n.get('sf')}\t{SITES[acc]}")
    missing = sorted(set(SITES) - seen)
    if missing:
        print('\nno explorer node at all (stall failed the >=3-replicate gate, or not in the 416):')
        for acc in missing:
            print(f'  {acc}\t{SITES[acc]}')
        print('  -> these take the group of a relative stalling at the same element;')
        print('     record that in class1b_groups.tsv `source` (Part 9).')


if __name__ == '__main__':
    main()
