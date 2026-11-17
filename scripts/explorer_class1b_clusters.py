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
    if not nodes:
        sys.exit('DATA parsed but no node list with an `fz` field')
    return nodes


def main():
    nodes = load_nodes(sys.argv[1])
    print(f'{len(nodes)} nodes\n')

    by_fz = collections.defaultdict(collections.Counter)
    for n in nodes:
        by_fz[n['fz']][n['cls']] += 1
    total_1b = sum(c['1b'] for c in by_fz.values())

    print('== Class_1b nodes per frozen cluster (4-model annotation), descending')
    print('fz\tnodes\t1b\tcum_1b\tcum_%\tother')
    cum = 0
    for fz, c in sorted(by_fz.items(), key=lambda kv: -kv[1]['1b']):
        if c['1b'] == 0:
            break
        cum += c['1b']
        other = {k: v for k, v in c.items() if k != '1b'}
        print(f"{fz}\t{sum(c.values())}\t{c['1b']}\t{cum}\t{100*cum/total_1b:.0f}\t{other}")
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
            print(f"{acc}\t{stall}\t{n['fz']}\t{n['cls']}\t{n.get('sf')}\t{SITES[acc]}")
    missing = sorted(set(SITES) - seen)
    if missing:
        print('\nno explorer node at all (stall failed the >=3-replicate gate, or not in the 416):')
        for acc in missing:
            print(f'  {acc}\t{SITES[acc]}')
        print('  -> these take the group of a relative stalling at the same element;')
        print('     record that in class1b_groups.tsv `source` (Part 9).')


if __name__ == '__main__':
    main()
