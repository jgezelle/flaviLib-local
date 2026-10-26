# PLLG (Pestivirus–LGF) clade xrRNA analysis

## 0. Merge output Xrn1 accessions with that from original Mifsud et al. metadata (containing abbrev. like PLLG for flavi subclades)

All outputs below come from `build_pllg_outputs.py`, which joins two independent
sheets on **GenBank accession, version-stripped** (`NC_024077.1` → `NC_024077`).
This is the only field spelled consistently in both sources — genus/species
naming differs in formatting between the two pipelines, so it's not usable as
a join key.

Steps, in order:

1. **Load Mifsud's clade lookup.** From the `Metadata` sheet of
   `Mifsud_2024_Supplementary_table_1_EDIT_NO3UTRseqs.xlsx`, build
   `{base_accession → (tree_tip_label, clade, virus_taxa)}` from the
   `tree_tip_label` / `clade` / `virus_taxa` / `nucl_sequence_accession` columns.
   Also load the `Clade Acronym Definitions` sheet (4-letter code → plain-English
   definition, e.g. `PLLG` → "Pestivirus–Large Genome Flavivirus clade; Large
   Genome Flavivirus").

2. **Crosswalk (`unclassified_genus_with_mifsud_clade.csv`).** Collapse the
   peaks CSV to one `(family, genus, species)` per accession (each accession
   has many peak rows — one per tile/stall site), filter to
   `genus == 'Unannotated' OR family == 'Unannotated'`, then left-join against
   the Mifsud lookup. Unmatched accessions are flagged `NOT IN MIFSUD
   (novel/Simmonds-only accession)` rather than dropped.

3. **PLLG landscape (`PLLG_LGF_clade_xrRNA_landscape.csv`).** Filter the Mifsud
   lookup to `clade == 'PLLG'` to get the set of base accessions in that clade.
   For every peak-sheet row belonging to one of those accessions, keep only the
   row with the **lowest `meta_pvalue` per accession** — i.e. each virus's
   single strongest stall site — along with its CM-hit status across all four
   known classes (`CL_Class_1a`, `CL_Class_1b`, `CL_Class_2`, `dumbbell_RF00525`).

4. **Alignment FASTA (`PLLG_LGF_unclassified_for_mlocarna.fa`).** Same
   best-peak-per-accession set as step 3, minus the one accession that already
   hits a known CM (`any_hit == 'True'`, Xiangshan flavi-like virus 2 →
   Class 1b), writing out `downstream_seq` for the rest.

**Known caveat (not yet addressed):** "best peak" in step 3/4 is chosen purely
by lowest p-value, without checking whether that peak's `stall_position` is the
biologically equivalent site across viruses. If a virus has two comparably
strong but structurally distinct stalls, only the lower-p one is included. If a
clade's structure turns out to sit at a different relative position than its
top peak in some members, revisit this — e.g. by taking all peaks above a
p-value threshold per accession rather than a single best one, and letting
mlocarna's alignment sort out which peaks are homologous.

Full script: `build_pllg_outputs.py` (verified to reproduce the CSV/FASTA
outputs below byte-for-byte).

## 1. Crosswalk: `unclassified_genus_with_mifsud_clade.csv`
116 rows in the peaks sheets have `genus = Unannotated` (or `family = Unannotated`).
- **101** of these *do* have a real phylogenetic home in Mifsud's original clade scheme
  (matched on GenBank accession → `tree_tip_label` / `clade` from the Metadata sheet).
  Clades represented: FJAF, FJFL, FJIS, FJJI, FJMB, FJUN, HPPV, PLLG, PLUN.
- **15** have no match in Mifsud's 593-accession set at all (e.g. the cyst-nematode
  Jingmen-related viruses, `BK071925.1` etc.) — these are novel/Simmonds-only or
  post-publication additions and will need their own placement (see §4).

So the "Unannotated" bucket in `Unannotated.fasta` is really a mix of at least
9 different phylogenetic groups — worth re-splitting before any per-clade
structural work, since lumping e.g. insect-specific orthoflaviviruses (FJIS) with
LGFs (PLLG) in one alignment will hurt mlocarna/Infernal signal.

## 2. Soybean cyst nematode virus 5 sits in clade **PLLG**
PLLG = "Pestivirus–Large Genome Flavivirus clade; Large Genome Flavivirus (LGF)"
sub-lineage. Mifsud/Simmonds place 74 taxa here; **61 are present in *XR / flaviLib* library**,
and NC_024077.1 (Soybean cyst nematode virus 5) is one of the top hits by p-value.

## 3. `PLLG_LGF_clade_xrRNA_landscape.csv` 
Best (lowest-p) stall peak per PLLG accession, with CM-hit status:
- **60/61** PLLG members have a strong, significant stall (p-values from ~1e-47 to
  ~1e-2, most <1e-8) with **no hit** to any existing CM (Class 1a/1b/2, dumbbell).
- Only **one** member — Xiangshan flavi-like virus 2 (`OK491478.1`) — already hits
  `CL_Class_1b_xrRNA_final`. Worth checking by eye whether it's a real 1b match or
  a spurious/partial hit, since it's the outlier in an otherwise CM-blind clade.
- This is a strong signal that the PLLG/LGF clade carries a **conserved, currently
  uncharacterized xrRNA structure** — a good candidate for a new CM.

`PLLG_LGF_unclassified_for_mlocarna.fa` contains the 60 unclassified members'
`downstream_seq` (the exo-stall-anchored window, 42–80 nt), ready to align. NC_024077.1
is included.

## 4. Suggested local workflow (mlocarna + Infernal exist in conda env *viromelib*)

```bash
conda activate viromelib 
ROOT=/Users/jeaninegezelle/Desktop/viromelib/flaviLib/work/infernal
cd $ROOT


# 1. Structural multiple alignment with LocARNA
STOCKDIR="$ROOT/alignments/PLLG_mlocarna_out"
mlocarna --stockholm --consensus-structure=alifold --tgtdir "$STOCKDIR" "$ROOT/alignments/PLLG_LGF_unclassified_for_mlocarna.fa"


```
### on first pass - no consensus structure. likely even though this fasta is all PLLG, they actual expand multiple different xr types. look for similarities within the first mlocarna output, and separate into subalignments 

## 5. Cluster splitting after mlocarna's flat consensus

First-pass `alifold` output on the full 60-member PLLG set came back empty —
all dots, score `(0.00 = 0.00 + 0.00)`. Zero confident base pairs across the
pooled consensus. That's a real result, not a failed run, and it's diagnosable
directly from the alignment mlocarna already produced.

### Method
`cluster_mlocarna_alignment.py` (included in this repo) takes mlocarna's plain-text
alignment output and:
1. Parses each aligned row into `(header, sequence)`, skipping the trailing
   `alifold` consensus line.
2. Computes pairwise sequence identity for every pair, restricted to columns
   where **neither** sequence has a gap (`pct_identity()` — matches / compared
   non-gap columns).
3. Runs union-find clustering: any pair at ≥80% identity over ≥15 compared
   columns gets merged into the same cluster.
4. For each resulting cluster (size >1), writes an ungapped FASTA
   (`cluster{A,B,C,...}_n{size}.fa`, gaps simply stripped from the aligned
   sequence — no need to go back to the original unaligned FASTA) plus a
   `cluster_summary.tsv` listing membership and stall-position range per
   cluster.

Core of the identity function:
```python
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
```
Full script: `cluster_mlocarna_alignment.py`.

```bash
python3 cluster_mlocarna_alignment.py PLLG_mlocarna_out.aln \
    --identity-threshold 0.80 --min-columns 15 -o clusters/
```

### Result
34 of 60 sequences (57%) have no partner at ≥80% identity to anything else in
the set — the pooled alifold consensus collapsed because the input was mostly
unrelated sequences plus a handful of small, internally-consistent
sub-clusters, not one clade-wide alignable group.

| cluster | n | stall position range | taxa involved |
|---|---|---|---|
| **A** | 12 | 444–462 (18 nt spread) | Bole tick virus 4 (4 isolates), Camel tick virus, Dermacentor reticulatus pestivirus-like virus 1, Rhipicephalus sanguineus assoc. flavi-like virus, Trinbago virus, 4× unclassified "Flaviviridae sp." (TIGMIC isolates) |
| **B** | 6 | 260–354 | Bole tick virus 4 (1 isolate) + 5× "Flaviviridae sp." (TIGMIC) |
| **C** | 4 | 558–571 (13 nt spread) | Bole tick virus 4 (2 isolates) + 2× "Flaviviridae sp." (TIGMIC) |
| D | 2 | 56 (exact) | the two Bemisia tabaci PLLG members |
| E | 2 | 217–218 | Bole tick virus 4 + Haseki tick virus |
| singletons | 34 | scattered (11–895, no consistent value) | everything else |

**Cluster A is the strongest candidate.** 12 sequences, tight 18 nt
stall-site window, and — critically — not one species resequenced: it spans
6 distinct named taxa, all tick-associated. That's cross-species conservation
at a consistent genomic locus, a materially cleaner signal than the pooled
60-member set. Clusters B and C follow the same pattern (tight stall windows,
Bole tick virus 4 + unclassified relatives) but their stall positions don't
overlap with A's or each other's — treated as separate candidate motifs
rather than merged in.

Soybean cyst nematode virus 5 (`NC_024077.1`) is one of the 34 singletons — no
≥80%-identity partner in this set. Doesn't rule out shared RNA structure at
low sequence identity, but explains why pooling it into the original
60-member run didn't help, and means it shouldn't be expected to land in
cluster A/B/C by primary sequence.

Output files: `clusterA_n12.fa`, `clusterB_n6.fa`, `clusterC_n4.fa`,
`clusterD_n2.fa`, `clusterE_n2.fa`, `cluster_summary.tsv`.

### Result: cluster A produced a real consensus structure
Re-ran with `--probabilistic --consistency-transformation` on `clusterA_n12.fa`:
```bash
mlocarna --stockholm --consensus-structure=alifold --probabilistic \
    --consistency-transformation --tgtdir "$STOCKDIR/clusterA_out" clusterA_n12.fa
```
`alifold` consensus (12/12 sequences retained, no dropouts):
```
....((((((((..(((((.(........))))))..)))))))).....................................
```
Score `(-33.73 = -21.10 + -12.63)` — average free energy −21.10 kcal/mol,
covariance term −12.63 (RNAalifold convention: total = avg. energy +
covariance contribution; a negative covariance term means compensatory
mutations across the alignment support the predicted pairs, not just
single-sequence folding energy). Non-zero, thermodynamically favorable, and
covariation-supported — this did not happen on the pooled 60-member run.

14 base pairs total, parsed from the dot-bracket:
- outer stem, 8 bp: positions 5–12 paired with 38–45
- inner stem, 5 bp: positions 15–19 paired with 31–35
- 1 bp closing a short hairpin loop: position 21 paired with 30 (8 nt loop, 22–29)

All three stems are properly nested (no crossing pairs, no overlap between
the outer/inner stems and the hairpin-closing pair) — a straightforward
double-stem-loop, no pseudoknot called (RNAalifold's default `()` output
doesn't call pseudoknots; the separate "max. reliability" per-sequence lines
mlocarna also printed use extra bracket types (`{}`, `` ` ``, `'`) for
reliability-threshold structure, not a called pseudoknot — worth checking with
a pseudoknot-aware folder (e.g. shape-directed or `--pseudoknot` motif search)
before ruling one in or out, since known xrRNA folds typically close their
ring with a pseudoknot that plain alifold won't report).

Per-sequence structures mostly match the consensus for the core stems; several
of the longer members (`ON811701`, `ON811702`, `ON262323`, `ON684360`,
`BK067815`, `MN025505`) additionally fold a downstream stem-loop
(`(((........)))` / `{{....}}`) not present in the consensus — plausibly a
second structural element only visible in sequences with enough retained
downstream sequence, since the shorter cluster members simply don't extend
far enough to show it. Worth re-examining with a wider `downstream_seq`
window per accession (see §0 caveat) rather than assuming it's absent in the
shorter members.

### Next
`cmbuild`/`cmcalibrate` on the resulting Stockholm alignment (check the exact
output filename first — LocARNA's `--stockholm --tgtdir` writes into a
`results/` subdirectory, name not confirmed here):
```bash
ROOT=/Users/jeaninegezelle/Desktop/viromelib/flaviLib/work/infernal
cd $ROOT
STOCKDIR="$ROOT/alignments/PLLG_mlocarna_out"
CMDIR="$ROOT/cm/PLLG_260915"
mkdir -p $CMDIR 

ls "$STOCKDIR/clusterA_out/results/"
cmbuild "$CMDIR/clusterA_candidate.cm" "$STOCKDIR/clusterA_out/results/result.stk"   
cmcalibrate "$CMDIR/clusterA_candidate.cm"    
```
Then `cmsearch` back against all 60 PLLG members (and the full library) to
check specificity — does the resulting model stay confined to tick-associated
PLLG members, or hit others too:
```bash
REFDATA=/Users/jeaninegezelle/Desktop/viromelib/flaviLib/data
TBLOUT="$ROOT/tblout/PLLG_260915"
mkdir -p $TBLOUT

cmsearch --tblout "$TBLOUT/clusterA_within_PLLG.tbl" "$CMDIR/clusterA_candidate.cm"   "$ROOT/alignments/PLLG_LGF_unclassified_for_mlocarna.fa"
cmsearch --tblout "$TBLOUT/clusterA_library_wide.tbl" "$CMDIR/clusterA_candidate.cm"   "$REFDATA/flavi_library_20260228pretile20260818_TRUEordered_uniqueIDs.fa"
```
## 8. cmsearch result: clusterA_candidate.cm against PLLG (60) and full library (439)

Within-PLLG search: 24 hits from 60 target sequences (includes 6 truncated).
Library-wide search: 48 hits from 439 target sequences, splitting cleanly into
two groups with no intermediate E-values:

- **Ranks 1–24**: E-value 1.7e-27 to 1.7e-22, all `!` (pass inclusion), all
  full-length model matches (`cm 1–76`, complete 76-position model).
- **Ranks 25–48**: E-value 1.4e-04 to 0.034, several `?` (below default
  inclusion threshold, --incE 0.01), all partial (`cm 4–44`, core stem only,
  40 of 76 positions), all on the **minus strand** at a position a few bases
  upstream of each rank-1–24 accession's own hit — same 24 accessions,
  reverse-complement self-hits. Consistent with the model's own stem being
  partially self-complementary rather than a second independent site.

The 24 strong hits are exactly clusterA (12) + clusterB (6) + clusterC (4) +
2 accessions that were singletons in the original identity-based clustering
(`MZ964986.1`, `ON811742.1`) — confirmed by direct set comparison, zero
missing, zero unexpected beyond those two additions.

**This changes the earlier interpretation.** Clusters A/B/C were split apart
because their stall-position ranges didn't overlap (444–462 / 260–354 /
558–571) — but a CM built from cluster A alone recovers B and C in full at
E<2e-22. They're the same structural element, not three distinct ones; the
differing stall positions reflect where each isolate's exonuclease stalled
locally, not different RNA structures. 22/61 PLLG members (36%) carry this
motif: the original 12 + 10 from B/C + 2 more.

**E-value cutoff going forward:** default `--incE 0.01` is too permissive
here — it admits several rank 25–42 self-hits. The data itself draws a clean
line: nothing falls between 1.7e-22 and 1.4e-04. Recommend re-running with
`--incE 1e-10` (or filtering the existing `.tbl` post-hoc at that threshold)
for any downstream reporting, and dropping same-accession reverse-strand hits
in a filtering step regardless of threshold, since they're not independent
evidence.

###  `cmsearch` PLLG; New cutoff for e-value for now
```bash
cmsearch \
    --incE 1e-10 \
    --tblout "$TBLOUT/clusterA_within_PLLG_E1e-10.tbl" \
    "$CMDIR/clusterA_candidate.cm" \
    "$ROOT/alignments/PLLG_LGF_unclassified_for_mlocarna.fa"

cmsearch \
    --incE 1e-10 \
    --tblout "$TBLOUT/clusterA_library_wide_E1e-10.tbl" \
    "$CMDIR/clusterA_candidate.cm" \
    "$REFDATA/flavi_library_20260228pretile20260818_TRUEordered_uniqueIDs.fa"
```
### esl-sfetch and cmalign 

Conservative filter, then extract hit sequences by GDF coordinates
(`esl-sfetch` reverse-complements automatically when `from > to`, so
strand is handled without extra logic):

```bash
python3 ../../scripts/tblout_to_gdf.py "$TBLOUT/clusterA_library_wide.tbl" \
    --max-evalue 1e-10 -o clusterA_hits.gdf

esl-sfetch --index "$REFDATA/flavi_library_20260228pretile20260818_TRUEordered_uniqueIDs.fa"
esl-sfetch -Cf "$REFDATA/flavi_library_20260228pretile20260818_TRUEordered_uniqueIDs.fa" \
    clusterA_hits.gdf > clusterA_hits_conservative.fa
```

`cmalign` against `clusterA_candidate.cm` (the 12-member model), aligning the
full conservative hit set — 24 sequences (12 original + 10 from clusters B/C
+ 2 extra) rather than the original 12:

```bash
ROOT=/Users/jeaninegezelle/Desktop/viromelib/flaviLib/work/infernal
CMALIGNDIR="$ROOT/alignments/PLLG_cmalign_out"
mkdir -p $CMALIGNDIR
mv clusterA_hits_conservative.fa "$CMALIGNDIR/clusterA_hits_conservative.fa"
cmalign --outformat Stockholm -o "$CMALIGNDIR/clusterA_expanded.stk" \
    "$CMDIR/clusterA_candidate.cm" "$CMALIGNDIR/clusterA_hits_conservative.fa"
```

`clusterA_expanded.stk` is the input for a refined `cmbuild` — same command
as before, pointed at the new alignment instead of the original 12-member
mlocarna output, now backed by 2× the training sequences:

```bash
cmbuild "$CMDIR/clusterA_refined.cm" clusterA_expanded.stk
cmcalibrate "$CMDIR/clusterA_refined.cm"
cmsearch --tblout "$TBLOUT/clusterA_refined_library_wide.tbl" \
    "$CMDIR/clusterA_refined.cm" \
    "$REFDATA/flavi_library_20260228pretile20260818_TRUEordered_uniqueIDs.fa"
```

### need to go back to the beginning, so far these sequences are way too conserved: 
```bash
cmstat "$CMDIR/clusterA_refined.cm"
```
```
# cmstat :: display summary statistics for CMs
# INFERNAL 1.1.5 (Sep 2023)
# Copyright (C) 2023 Howard Hughes Medical Institute.
# Freely distributed under the BSD open source license.
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#                                                                                              rel entropy
#                                                                                             ------------
# idx   name                  accession      nseq  eff_nseq   clen      W   bps  bifs  model     cm    hmm
# ----  --------------------  ---------  --------  --------  -----  -----  ----  ----  -----  -----  -----
     1  clusterA_expanded     -                24      1.55     75     91    15     0     cm  0.753  0.596
```

eff_nseq: Infernal's entropy-weighting scheme shows this 24-sequence alignment carries about as much independent statistical information as one and a half sequences.... 

serious overfitting, need more sequence diversity and a better approach 

# RETURN LATER  with better sequence alignments. 
## refer to `class1b_expansion.md`





-------




### Note to double check the PLLG fishing from the Mifsud sheet was actually successful... 

*For the 34 singletons (including soybean cyst nematode virus 5): don't pool
them again as-is. Either (a) run structural comparison (e.g. Foldseek-style)
instead of sequence identity, since shared structure can exist without shared
sequence, or (b) revisit the §0 caveat — take all significant peaks per
accession rather than just the single best one, in case the true homologous
site isn't each virus's top-ranked stall.*

# 6. new tree from Mifsud + Simmonds

Accession accounting so far:
- Library: 439 unique source accessions.
- **409** match a Mifsud tree_tip_label directly (base accession match).
- **30** don't match anything in Mifsud's 593-accession metadata sheet — these are
  either Simmonds-et-al-only additions, or independently added sequences
  (several of the unmatched are the BK071xxx cyst-nematode jingmen-related
  accessions and a few other recent GenBank entries).

Since Mifsud's repo publishes the underlying NS5b alignment and IQ-TREE tree
(their Zenodo: `10.5281/zenodo.11092288`, and the Simmonds et al. GitHub:
`GroveLab/Flavi_RdRp_Structures_Simmonds_2025`), the cleanest path is usually:
1. Pull their NS5b amino-acid alignment (not the 3'UTR — accessions without
   3'UTR are already excluded, which is a different filter from what's in the
   RdRp alignment).
2. Prune it to just the 409 matched tip labels (drop everything else) so the
   tree only shows taxa actually present in the oligo library.
3. For the 30 unmatched accessions, pull/align their NS5b region and use
   `mafft --add --keeplength` against the pruned reference alignment (or
   `hmmalign` if building an HMM from the reference), then re-infer the tree
   (IQ-TREE/FastTree) so the new taxa get placed rather than guessed at.
4. Re-attach clade acronyms (FJAF/FJJI/PLLG/etc.) to the added tips manually
   based on where they land, and flag them as "added" in the final figure
   (e.g. different tip color) since they weren't part of the original
   bootstrap-supported topology.

This won't be a perfect 1:1 match to either paper's tree, but it keeps every
placement decision traceable and avoids re-deriving the whole RdRp phylogeny
from scratch — the CM/structure-class layer being built really only needs
"correct clade neighborhood," not sub-species branch order.
