# CM expansion: candidates, accounting, and procedure

**The single current document for CM discovery.** Every conclusion lives here; the files below are
dated records of what was run on those days and are not maintained.

- `flaviLib/workflows/260914-260917_cm_expansion.md` (856 lines) — hepaci/pesti/pegi triage →
  class1c, and the class1b expansion at §142–328. Formerly named `class1b_expansion.md`, which
  other documents still cite.
- `flaviLib/workflows/260915_pllg_analysis.md` (407 lines) — PLLG clade, clusterA.
- `viromelib/workflows/260720-260824_cm_class4_development.md` (434 lines) — class4 v1→v9. Kept in
  the viromelib tree because class4 is viromelib-derived; its **procedure** is consolidated here
  under the iteration recipe, since both candidates need it.
- `viromelib/workflows/infernal.md`, `251009_infernal_hpc_classsorting.md`, `CMdist.md` — the
  retired class-sorting pipeline, summarised here under what is in `archive/`.
- `work/infernal/README.md` — CM library parts A–D.

`261026_cm_expansion_orthoflavivirus.md` is **superseded** — fully absorbed here, delete it.

Model md5s belong in `~/Desktop/viromelib/work/infernal/cm/MANIFEST.tsv` (not yet created).

Last updated 2026-10-29.

### How this file is kept current

The **Run log** tables at the end are written by the scripts, not by hand. Everything above them is
interpretation and is edited by hand when a run changes a conclusion.

| script (`flaviLib/scripts/`) | md5 | writes to this file |
|---|---|---|
| `cm_iterate.sh` | `7f05a0c316dca558370f955c318d2992` | one row per search round and per rebuild, under `### \`<name>\`` |
| `cm_round_stats.py` | `f010ece4117261f72d057d39269ce5d7` | helper for `cm_iterate.sh` (novelty, per-hit bit-score comparison, cmstat parse) |
| `cm_log.py` | `e64c4d3d69b6aa3d8d117c3a21ccec94` | any single row; use it for manual steps (MATER, CaCoFold, decisions) |
| `make_pool_fastas.py` | `f363267accdfc27a9b03e4c061779e3d` | nothing; builds the pool FASTAs and `pool_summary.tsv` |
| `cm_add_borderline.sh` | `a330c754f27244edeabb2e69e0d1a718` | step 17: one run-log row per variant (v0 + each `--add`) |
| `seed_vs_hits.py` | `c5ac6aea20b4045c63c4c02f0ae5f875` | nothing; seed vs tblout comparison (saturation and lineage checks) |
| `explorer_cm_scan.py` | `d336a48ea39614a4b7ddcb5be93f3f73` | nothing; scans the flavi150 explorer's sites with a CM, writes per-cluster fetch lists |

```bash
DOC=~/Desktop/viromelib/flaviLib/workflows/CM_CANDIDATES.md
FLAVISCRIPTS=~/Desktop/viromelib/flaviLib/scripts
python3 $FLAVISCRIPTS/cm_log.py "$DOC" --model cand_FJJI_261029 \
    --step "MATER hand-edit" --result "PK added cols 21-23/38-40; SS_cons P2 extended 2 bp"
```

`cm_log.py` creates the subsection if it does not exist, escapes `|` in the text, and updates the
`Last updated` line. See **Live workflow** for the full per-pool procedure.

**Where the live copy is, and how edits move** (agreed 2026-10-29). There are two writers — the
scripts, which append run-log rows on the laptop, and Claude, which edits the interpretive
sections in a session — so there must be one master and a fixed hand-off, or rows get lost:

- **Master: the laptop file, `flaviLib/workflows/CM_CANDIDATES.md`, committed in the flaviLib
  submodule** after every change (`git -C ~/Desktop/viromelib/flaviLib add workflows/CM_CANDIDATES.md
  && git -C ~/Desktop/viromelib/flaviLib commit -m "CM_CANDIDATES: <what>"`). A commit before
  replacing the file means nothing can be overwritten unrecoverably, and `git diff` shows exactly
  what a returned copy changed.
- **To Claude: attach the current laptop file** at the start of any request that should change the
  document, so edits are made on top of the rows the scripts wrote. Claude returns the whole file.
- **Back: commit, replace, `git diff`, commit.** If the diff removes run-log rows, the returned copy
  was based on a stale version — restore from the previous commit and re-attach.
- Alternative: if the flaviLib-local GitHub repository is attached to a session, Claude can commit
  the edit directly and the laptop `git pull`s — no file copying.

#### How the scripts fit together

They are **separate files, not nested**. The two shell scripts call the Python helpers as
ordinary commands, by path, from the directory the shell script itself is in
(`HERE=$(dirname "$0")`, then `python3 $HERE/cm_round_stats.py …` and
`python3 $HERE/cm_log.py …`). So all of them must sit in the same `scripts/` directory; the shell
scripts check this at start-up and stop if a helper is missing.

```
cm_iterate.sh ─────────┬─> cm_round_stats.py  stk2fa | fetch | novel | compare | cmstat | overlap
cm_add_borderline.sh ──┤
                       └─> cm_log.py          one row -> this file
make_pool_fastas.py     standalone (no helpers, writes nothing here)
explorer_cm_scan.py     standalone (no helpers, writes nothing here)
seed_vs_hits.py         standalone (no helpers, writes nothing here)
```

**`cm_log.py DOC --model M --step S --result R [--date D]`.** Reads the whole file, finds the
`## Run log` heading, and inside that section the subsection `### \`M\`` (backticks optional).
If the subsection exists, the row `| D | S | R |` is inserted after its last table row; if not, a
new subsection with the table header is created at the end of `## Run log`, before the next `## `
heading. `|` inside S or R is escaped as `\|` and newlines become spaces, so a row never breaks the
table. The first `Last updated YYYY-MM-DD.` line in the first 40 lines is set to D (default today).
The file is written to a temporary file in the same directory and then renamed over the original,
so an interrupted run cannot leave a half-written document. It stops if there is no
`## Run log` heading. Nothing else in the file is touched — the interpretive sections are edited
by hand.

**`cm_round_stats.py <subcommand>`** — pure Python, no dependencies; each subcommand prints one
line that the shell script embeds in its log row:

| subcommand | input → output | rule |
|---|---|---|
| `stk2fa SEED.stk OUT.fa` | ungapped FASTA of a Stockholm file; prints the count | concatenates multi-block rows per name; keeps letters only |
| `fetch TBL CLEN MINFRAC OUT` | `esl-sfetch -C` list of included hits; prints the count | `!`, plus strand, `mdl_to − mdl_from + 1 ≥ MINFRAC × CLEN` |
| `novel HITS.fa KNOWN.fa [K] [MAXC]` | count of novel hits; `HITS.novel.tsv` | a hit is novel if < MAXC (0.80) of its 15-mers occur in KNOWN |
| `compare OLD.tbl NEW.tbl [TOL]` | `matched= lost= gained= lower_bits= worst_delta=`; `NEW.tbl.compare.tsv` | `!` plus-strand hits; same target, start within TOL (10) nt, nearest wins, each used once |
| `cmstat CMSTAT.txt` | `nseq= eff_nseq= clen= bps= bifs= relent_cm=` | first model line of `cmstat` output |
| `overlap A.tbl B.tbl [NA NB]` | one row per A hit overlapping a B hit, both scores, `better`; summary line | plus strand, same target, spans overlap by ≥ 1 nt, any inclusion; `better` = lower E-value. Run by hand (step 17 check 2), not by the shell scripts |

Which script uses which: `cm_iterate.sh` uses all five; `cm_add_borderline.sh` uses `compare` and
`cmstat` (the borderline spans and PP are computed inside the shell script with `awk` and a
one-line Python call).

---

## Naming

`cand_<CLADE>_<yymmdd>` while a candidate; `class<N>` once accepted.

vsearch cluster indices (`cluster_2`, `clusterA`) are not names — they depend on the input FASTA,
the `--id` threshold and the run date. Record them as provenance.

Helices are `P1`, `P2`, `P3` and pseudoknots `PK`, following the flavivirus xrRNA literature. An
`H1`/`H2` appear in older notes and mean `P1`/`P2`.

### Mifsud / Simmonds sub-clade codes

Structure and sequence names in the Mifsud Zenodo deposit (`10.5281/zenodo.11092288`) are prefixed
with a four-letter code. Simmonds et al.: `GroveLab/Flavi_RdRp_Structures_Simmonds_2025`.

| Flavi-Jingmen | | Pesti-LGF | | Hepaci-Pegi | |
|---|---|---|---|---|---|
| FJTB | Tick-Borne | PLLG | Large Genome Flavivirus | HPPV | Pegivirus |
| FJMB | Mosquito-Borne | PLPV | Pestivirus | HPHV | Hepacivirus |
| FJNV | No Known Vector | PLUN | Unclassified | HPUN | Unclassified |
| FJIS | Insect Only | | | | |
| FJAF | Aquatic Flavivirus | | | TOMB | Tombusvirus out group |
| FJFL | Flavi-Like | | | | |
| FJJI | Jingmenvirus | | | | |
| FJUN | Unclassified | | | | |

## Directory layout

Three rules:

1. A `.cm` lives in the **shared** `cm/` — the same finished models annotate both datasets, and two
   copies is what produced the `Class_1a` vs `class1a` `NAME` divergence found 2026-10-27.
2. A **build** lives with the dataset whose stalls produced it.
3. A **seed alignment for a model that was provided** rather than built here lives in `cm/seeds/`.

```
~/Desktop/viromelib/work/infernal/           shared CM library + VIROMELIB-dataset builds
  cm/                  every .cm, one copy each, + MANIFEST.tsv
    cm_set_<yymmdd>/     the dated set used to annotate a run (git-tracked)
    seeds/               seeds of provided models: 1a, 1b, 2, 3, dumbbell
  build/<model>/       viromelib-derived: class4, picorna, cl5
    seed/ iter_vN/ rscape/ tblout/ NOTES.md
  fa/                  FASTAs, incl. RNAvirus_CompleteAssem_No_CoV-2.fa + .ssi
  archive/             retired work, kept for provenance

~/Desktop/viromelib/flaviLib/work/infernal/  FLAVILIB-dataset builds only
  build/<model>/       cand_FJTB_261026, cand_PLLG_260915, class1b, class1c
    seed/ iter_vN/ rscape/ tblout/ NOTES.md
  fa/                  per-genus pools, the TRUE-ordered library reference
  archive/             Sept working trees, retired annotation outputs

cluster $ROOT/work/06_infernal/              APPLICATION only: finished models searched
                                               against the library. Not reorganised.
```

`iter_vN/` is one directory per build round. For `cand_FJTB_261026`, `iter_v0_15seq/` is the
15-sequence attempt and `iter_v1/` the 16-sequence one after KT224356 was added.

Reorganised by `scripts/infernal_layout_261027.sh` (md5 `ebe32ddf8c621fdeccfdae36e0119825`),
check-only by default, `--apply` to move, `--stage bydataset|models|perbuild|archive|empties|report`
to run one part. It never overwrites or deletes, with one exception under `--apply`:
`cm/_from_cluster_261027`, a staging copy verified byte-identical to `cm/cm_set_261021`.

It supersedes `migrate_cm_organization_261027.sh`, which grew stage by stage and put flaviLib
builds in the viromelib tree.

### Paths as written in the source documents → now

| as written | now |
|---|---|
| `cm/PLLG_260915/clusterA_candidate.cm` | `cm/cand_PLLG_260915.cm` |
| `cm/PLLG_260915/clusterA_refined.cm` | `cm/cand_PLLG_260915_cmalign.cm` |
| `alignments/PLLG_mlocarna_out` † | `build/cand_PLLG_260915/iter_v1/mlocarna` |
| `alignments/PLLG_cmalign_out` † | `build/cand_PLLG_260915/iter_v2/cmalign` |
| `alignments/PLLG_LGF_unclassified_for_mlocarna.fa` † | `build/cand_PLLG_260915/seed/PLLG_LGF_unclassified_60.fa` |
| `PLLG_LGF_clade_xrRNA_landscape.csv` (no path given) | `build/cand_PLLG_260915/seed/` |
| `tblout/PLLG_260915/` | `build/cand_PLLG_260915/tblout/` |
| `flaviLib_20260917/candidate_class1a/orthoflavi/cluster2/` | `build/cand_FJTB_261026/iter_v0_15seq/` |
| `…/orthoflavi/element_261026/` | `build/cand_FJTB_261026/iter_v1/` |
| `…/pesti_cmalign/class1c20260917/class1c.cm` | `cm/class1c.cm` (and `cm/cm_set_261021/`) |

† The `alignments/` paths in `260915_pllg_analysis.md` were already wrong when written — those
files were in `stockholm/`. Not an effect of the migration.

All paths above are relative to `~/Desktop/viromelib/work/infernal/` (new) or
`~/Desktop/viromelib/flaviLib/work/infernal/` (old).

### What is in git

`.gitignore` excludes `work/infernal/*`; Infernal working files are not versioned. Force-added for
posterity only: `cm/cm_set_261021/*` (the 7 models that annotated the 261021 tables),
`cm/cand_PLLG_260915*.cm`, and each candidate's `seed/` FASTA plus the final `.stk` of each
iteration. mlocarna intermediates, PostScript and R-scape plots stay out. Git descends into
`work/infernal/cm/` to reach the tracked set, so loose models beside it appear untracked unless a
narrower rule is added.

### The 7 annotating models — `cm_set_261021`

Two of the seven were built in this project. The candidates below are **not** in this set, so every
"no CM hit" count in this file is against these seven only.

| `NAME` | file | origin |
|---|---|---|
| class1a | `CL_Class_1a_xrRNA_final.cm` | provided |
| class1b | `CL_Class_1b_xrRNA_final.cm` | provided |
| class2 | `CL_Class_2_xrRNA_final.cm` | provided |
| class3 | `cl3_NAR_2025.align.mpkadded.edited.confident.dedup.IDcurated.SS_cons.cm` | NAR 2025 alignment |
| **class1c** | `class1c.cm` | **built 2026-09-17**, `pesti_20260917_edit.stk`, 46 seqs, CLEN 84. Mixed-genus: 22 hand-edited pestis plus Hepacivirus hits from its own library search (see Accounting) |
| **cl4_v9** | `class4_cl4_v9_20260824.cm` | **built here**: v1 from Dilweg 2023 *Sci Rep* seeds → v3 cmalign of v1 hits → v4 added diverse known members → v5–v7 on `!` hits → v8 R-scape CaCoFold → v9 cmalign `--hand`, converged at 30 significant hits |
| Flavivirus_DB | `dumbbell_RF00525.cm` | Rfam RF00525 seed, `cmbuild` + `cmcalibrate` |

### Model identity, confirmed 2026-10-27

- `cm_set_261021`'s 7 models are **byte-identical to the cluster's** `work/06_infernal/cm/`. That
  set is what annotated the 261021 tables.
- Their `NAME` fields: `class1a class1b class2 class3 class1c cl4_v9 Flavivirus_DB`. `cmsearch`
  writes `NAME` into the tblout, so a model's name matters independently of its filename.
- The three `CL_Class_*` copies formerly in the flaviLib tree differed **only** in `NAME`
  (`Class_1a` vs `class1a`). They annotated nothing; removed.
- `cl4_v9.cm` = `class4_cl4_v9_20260824.cm` = `cm_set_261021/class4_cl4_v9_20260824.cm`
  (`37cd10be`), one model under three names. `cl4.cm` is a different model (`2128e2db`).
  **flaviLib annotates with v9**; the viromelib column is `cl4.cm_hit`, so which class 4 model
  annotates is open for viromelib only.
- `cl5.cm` and `picorna.cm` are the same file (`a5fa7bae`).
- Calibration lives **inside** the `.cm` (`ECM*` lines from `cmcalibrate`); `.i1*` files are
  `cmpress` output for `cmscan` and are not needed by `cmsearch`. All 7 set models and both PLLG
  candidates are calibrated. No `.i1*` files exist on either machine.

---

### Coordinate and column conventions

- discovery-pool FASTA header:
  `ACCESSION|FEATURE_COORDS|STALL_IN_FEATURE|TILE_RANGE genus= species= n_reps_passing=`
- **genomic = feature_start + stall_in_feature** (not `− 1`; the offset is 0-based)
- `accession` in `peaks_annotated.csv` is the full feature ID
  (`NC_001672.1|10327-11141_inferred_3UTR`): `.split("|")[0]`, then strip the version
- per-model columns: `{model}.cm_hit` holds the **E-value** (presence = `notna()`, not a boolean),
  plus `_start`, `_end`, and `_tile_truncated` which holds **nt truncated**, not a flag
- `any_hit` is a bool, per **stall row**, not per accession
- peak calling places the same site at adjacent positions (455/456); merge within ~5 nt
- `downstream_stall_at_offset` is ≤ 0 always: the window normally starts at the stall, occasionally
  up to 62 nt after it

### How the CM columns are produced

Source: `flaviLib.md`, and steps 10 and 11b of `README_261021_flaviLib_150x150.md`.
The producing script is `post_process_peaks.py`.

```bash
# step 10 -- cmsearch against the reference FASTA only, never sample data.
# A .tbl belongs to the REFERENCE, not to a run: the 1a/1b/2/dumbbell tables were made for the
# 75x75 run and reused unchanged; only the three new models were searched.
for CM in $CMS; do
    [ -f "$TBLOUT/${CM}.tbl" ] && { echo "exists, skipping: $CM"; continue; }
    cmsearch --tblout "$TBLOUT/${CM}.tbl" --cpu 8 "$CMDIR/$CM" "$FA"
done

# step 11b -- re-annotate, seven --infernal-tbl arguments
INFERNAL_ARGS=$(for CM in $CMS; do printf -- "--infernal-tbl $TBLOUT/%s.tbl " "$CM"; done)
python3 $ROOT/scripts/post_process_peaks.py \
    "$PEAK_DIR/$MG/1234_peaks_combined_with_seqs.csv" \
    --out-raw "$OUT/${DS}_${MG}.peaks_annotated.csv" ... $INFERNAL_ARGS
```

- `$TBLOUT` = `work/06_infernal/260807_trueRef/` — named for the 75×75 run but holding
  reference-based results used by every run against that reference.
- `$CMS` comes from `scripts/env_261021_flaviLib.sh`, which is the single definition of the CM set.
- Seven `cm_hit` columns out, against four in the superseded annotation.
- Column names are the `.tbl` basenames including `.cm`, hence `CL_Class_1a_xrRNA_final.cm_hit`.
  Rename a `.cm` and every downstream column moves with it.

**The search target is the pre-tile reference**, stated in both documents and confirmed by hit
lengths, which exceed any 80 nt window: Class_1a reaches 140 nt, Class_1b 124, Class_2 97 with
**all 810** hits over 80. So a "no hit" at a position is a real negative, not an artefact of a
restricted search target.

No `--evalue` is passed in step 11b, so `post_process_peaks.py`'s own default applies. It is
looser than 0.001: Class_1b hits at 3.7e-03 appear in the tables. Its threshold and overlap rule
are otherwise unread; read them before relying on any threshold or geometry claim about these
columns. See "Archived and ignored scripts".

`flaviLib.md` specifies the required follow-up step: "collapse peaks across overlapping tiles at
the same stall position per accession". Measured effect: 56 % of no-hit rows at 10 mM, 49 % at
1 mM, are tile duplicates of another row.

## Candidates

| name | clade | nseq | eff_nseq | clen | bps | bifs | status |
|---|---|---:|---:|---:|---:|---:|---|
| `cand_FJTB_261026` | FJTB | 16 | 1.63 | 80 | **23** | **2** | built, searched; +1 accession only |
| `cand_PLLG_260915` | PLLG | 12 | 1.90 | 76 | 15 | 0 | built, searched; 24 of 60 |
| `cand_PLLG_260915_cmalign` | PLLG | 24 | 1.55 | 75 | 15 | 0 | built; stopped, too conserved |

For context: Class_1a 75/9.31/74/19bp/2bifs · Class_1b 88/48.62/81/19/2 · Class_2 38/3.58/93/22/1 ·
class1c 46/9.54/84/15/1 · hepaci_hits_v2 55/19.93/78/18/1.

`bifs` is the count of bifurcations — branch points, needed for a multi-way junction. Every
established class has at least one. `cand_FJTB_261026` has two and 23 base pairs, more than any
established model. Both PLLG models have zero: each is a single nested helix.

### `cand_FJTB_261026`

Found 2026-10-26/27, this document. Third stall site ~176 nt downstream of the annotated tandem xrRNA pair, tick-borne encephalitis
serocomplex. No hit from any of the 7 models in `cm_set_261021` at these positions.

Members (gap = nt downstream of the last CM-annotated stall in that accession):

| accession | species | gap | | accession | species | gap |
|---|---|---:|---|---|---|---:|
| MH688511 | *royalense* | 168 | | MT354614 | *omskense* | 179 |
| NC_003687 | *powassanense* | 169 | | NC_003690 | *langatense* | 179 |
| MN830233 | *gadgetsense* | 171 | | PQ788270 | *powassanense* | 181 |
| NC_005062 | *omskense* | 173 | | KT224356 | *tyuleniyense* | 191 |
| NC_027709 | Spanish goat enceph. | 173 | | JF416957 | — | `aug2reps` |
| NC_001672 | *encephalitidis* (TBEV) | 176 | | JF416967 | — | `aug2reps` |
| MK007540 | *loupingi* | 176 | | | | |
| NC_001809 | *loupingi* | 177 | | | | |
| AB507800 | *omskense* | 177 | | | | |
| MF774565 | *encephalitidis* | 178 | | | | |

Both Mg conditions; 4/4 replicates except NC_027709 at 10 mM (3/4). JF416957 and JF416967 reach
only `n_reps_passing` 2 in 261021 (0 at 10 mM) and are tagged `aug2reps` — they passed in the
August table and are members by sequence.

Conserved blocks: `CCCCC…GGGGGGGCGG` (helix 1), `TTCTTGTTCTCCC`, `CCACCATCACC`,
`AGACACAGATAGTCTGACAAGGAGGTGA`. KT224356 (seabird-tick-borne) keeps the stem motifs with a drifted
loop and 3′ end — the most divergent member.

R-scape on 15 sequences: avgid **86.29**, 24 bpairs, **4 covarying**, 0 FP, PPV 100, Sen 16.67,
expected 0.4 ± 0.6; `power` 0.00 for 19 of 24 pairs. CaCoFold found no crossing helices on any of
three refinement rounds, and the statistics are identical across all of them — the MATER
refinement is converged. alifold: 15 seqs −44.53 (−29.02 + −13.99… see note), 16 seqs −40.87
(−26.88 + −13.99).

**One divergent sequence roughly doubled the power**: expected-to-covary 0.4 ± 0.6 at 15 → 0.8 ± 0.8
at 16, from adding KT224356 alone. Observed stayed at 4. Sequence diversity is important for the
power.

Library-wide `cmsearch --toponly --incE 1e-10`: **39 rows, 17 distinct accessions** — built from 16,
recovers 17. Few hits beyond the training set is the overfitting signature, and eff_nseq 1.63 is
lower per sequence than clusterA's 1.90 at 12.

- model: `cm/cand_FJTB_261026.cm`; development tblout `build/cand_FJTB_261026/cand_FJTB_261026.tbl`
- **blocker**: generalization. Needs sequences from outside the 439-member library.

#### The assay evidence, measured 2026-10-27

The strongest evidence this candidate has, and it is assay data rather than alignment inference.
At 10 mM the eleven sites give SF 0.355–0.500, 4 of 4 replicates, p 3.3e-17 to 3.6e-22, 30–635
reads per replicate.

**An SF near 0.46 is normal for class 2, not weak.** Medians over well-powered rows
(≥100 summed stall reads, ≥2 replicates), 10 mM / 1 mM:

| class | n (10 mM) | median SF |
|---|---:|---|
| dumbbell | 58 | 0.379 / 0.401 |
| cl3 | 11 | 0.448 / — |
| **no hit** | **885** | **0.449 / 0.435** |
| **Class_2** | **117** | **0.459 / 0.397** |
| class1c | 275 | 0.693 / 0.710 |
| Class_1b | 518 | 0.720 / 0.737 |
| Class_1a | 451 | 0.766 / 0.809 |

Class 2 is indistinguishable from `no hit` and far below class 1a/1b/1c. So judge a candidate
against the class its host genomes carry, not against class 1a. (Also: **885 well-powered,
replicate-passing, CM-unannotated sites at median SF 0.449** in the 10 mM condition — the
discovery frontier as a site count rather than an accession count.)

**The Mg behaviour is inverted relative to class 2, which is the distinguishing property.**
Within the same accessions and libraries:

| | 1 mM | 10 mM |
|---|---|---|
| class 2 sites | mostly collapse: 1–2 reads, 0 passing reps, nominal SF 1.000 from a single read | SF 0.44–0.85, 4/4 reps, 378–4,406 reads |
| these sites | SF 0.288–0.703, 4/4 reps, p to 2.8e-32, 36–694 reads | SF 0.355–0.500, 4/4 reps |

NC_027709's site is SF 0.703 at p 2.8e-32 with 106–370 reads at 1 mM, in the same library where
its class 2 site has one read. Within-accession and within-sample, so not a depth artefact. Class
2's ring needs Mg²⁺; this element apparently does not.

#### Depth caveat on the SF figures, measured 2026-10-28

The depth question was put to the 1 mM table (`figures/pvalue_sf_vs_depth_flaviLib_01mM_20261028.png`,
panels D and E of `sf_vs_depth_20261027.Rmd`). Two results bear on this candidate:

- **The gates already enforce a depth floor of 38 summed stall reads**, far above G1's 10. Of
  1,277 sites with q < 0.05 and ≥ 3 passing replicates, none is thinner than that, and no row at
  1–2 reads reaches q < 0.05 at all (0 of 8,818). The meta p-value is self-protecting where the
  stall fraction is not, so the candidate's p values are not an artefact of thin coverage.
- **But the candidate sits in the one suspect band.** Among passing sites the median SF is not
  monotonic in depth: 31–100 reads gives 0.763, against 0.500 at 101–300 and 0.457 at 301–1k,
  rising again to 0.755 above 1k. The 31–100 band holds only 26 sites and is where a ~30-read
  site falls. That bump is what residual inflation would look like. **Until it is explained,
  treat the candidate's SF as provisional** — the ruling-out of the 3′ stem-loop hypothesis above
  rests on SF 0.355–0.500 being comparable to validated class 2 sites, and that comparison is
  only safe if the thin-band SF is not inflated.

Resolve by locating the candidate's eleven sites in the depth distribution and checking whether
the 31–100 bump survives removing them.

#### The stall sits at a fixed distance from the 3′ terminus

Feature lengths run 394–815 nt, yet the stall is 103–109 nt from the feature end in ten of eleven
(five at exactly 106; MN830233 is the outlier at 81). So the element is anchored to the 3′
terminus, not to the 3′UTR start — a tighter observation than the 168–191 nt gap from the last
CM-annotated stall.

**The 3′ stem-loop hypothesis is ruled out.** The ~100 nt at a flavivirus 3′ terminus is the 3′SL,
and Xrn1 halting at its base would explain the fixed distance, the lack of resemblance to class
1a/1b/2, P1 being the only reproducible helix, and the extreme conservation. But Xrn1 unwinds
simple duplexes: SF 0.355–0.500 at p 1e-17 to 3e-32, comparable to validated class 2 sites in the
same genomes, is not something a stem-loop produces. KT224356's site (0.478) exceeds its own class
2 site (0.442).

#### Open hypothesis: a third, diverged member of the class 2 tandem array

The element occurs only in FJTB genomes that already carry a tandem class 2
pair, and sits 168–191 nt downstream of the second copy. A third diverged copy of that array is
a simpler explanation than a new class, and it accounts for two otherwise awkward observations:

- **Thin covariation.** R-scape validates 4 of 24 pairs at avgid 86.29. A recent paralog within
  one serocomplex has not accumulated compensating substitutions; an element sampled
  independently across a clade would have.
- **Why `Class_2.cm` misses these positions.** Class_2 is built on 38 sequences at eff_nseq 3.58
  spanning the clade. A degenerate copy missing one helix falls below `incE 0.01` while still
  being homologous.

The assayed behaviour is consistent but does not discriminate: median SF for Class_2 is 0.459,
and the candidate's 0.355–0.500 sits inside that — but `no hit` is 0.449, so SF separates neither.

Against:

- **No pseudoknot.** Class 2 is defined by one. The predicted structure is entirely nested pairs;
  CaCoFold proposed no crossing pairs. The only pseudoknot on the table is the manual MATER
  assignment (21↔40, 22↔39, 23↔38, `GGG`:`CCC`), which is invariant across all 11 sequences, so
  covariation can never support or refute it, and cmbuild discards crossing pairs regardless.
- **Inverted Mg dependence.** This is the strongest counter-evidence and it is measured, not
  inferred. Class 2 sites in these same genomes collapse at 1 mM (1–2 reads, 0 passing
  replicates) while the candidate holds — SF to 0.703, p 2.8e-32, 4/4 replicates — within
  accession and within sample. A diverged paralog of class 2 would be expected to share its Mg
  requirement, not invert it.
- **Bifurcation count unsettled.** The candidates table records 2 bifurcations and 23 bp, which
  would support the hypothesis, but the P2-removal variant (bps 23→16, bifs 2→1) means the model
  in `cm/` may not be the one that table describes. Run `cmstat` on the model actually in `cm/`
  and fix the table before drawing anything from the count either way.

**Covariation is exhausted as a route.** At 86.29 % avgid over 11–16 sequences from one
serocomplex, 4 of 24 pairs is near the ceiling of what R-scape can recover, and the one pair that
matters most is invariant. More alignment rounds will not resolve the structure. The remaining
routes are a more divergent sequence set — blocked, the RNA-virus database returns only this
clade — or compensatory mutagenesis of the `GGG`:`CCC` pair, which is an experiment rather than a
computation.

Test, step 14a. Searches `Class_2` against the candidate windows at a permissive threshold and
reads the **alignment**, not the E-value:

```bash
# step 14a — is cand_FJTB_261026 a sub-threshold Class_2 match?
INFERNAL_BASE=~/Desktop/viromelib/flaviLib/work/infernal
CM_DIR=~/Desktop/viromelib/work/infernal/cm          # shared cm/, confirm
CAND_DIR=$INFERNAL_BASE/build/cand_FJTB_261026
CAND_FA=$CAND_DIR/iter_v1/dedup.fa                   # confirm filename
OUT_DIR=$CAND_DIR/iter_v1/class2_relaxed_261027
mkdir -p "$OUT_DIR"
cmstat "$CM_DIR/cand_FJTB_261026.cm"                 # settle the bifurcation count first
cmsearch --toponly -E 100 \
  --tblout "$OUT_DIR/class2_vs_candidate.tbl" \
  "$CM_DIR/CL_Class_2_xrRNA_final.cm" "$CAND_FA" \
  > "$OUT_DIR/class2_vs_candidate.aln" 2>&1
awk '$1!~/^#/' "$OUT_DIR/class2_vs_candidate.tbl" | sort -k16,16g | head -20
```

```bash
# step 14b — all seven models against the candidate windows, best hit each, for comparison
for CM in "$CM_DIR"/CL_*.cm; do
  printf '%s\t' "$(basename "$CM" .cm)"
  cmsearch --toponly -E 100 --tblout /dev/stdout "$CM" "$CAND_FA" 2>/dev/null \
    | awk '$1!~/^#/' | sort -k16,16g | head -1 | awk '{print $16"\t"$8"-"$9}'
done
```

Reading it: if Class_2 is the best sub-threshold match **and** the alignment in
`class2_vs_candidate.aln` places the candidate's reproducible P1 on class 2's P1, the junction is
where to look, and the next mlocarna round should be seeded with Class_2's `SS_cons` rather than
predicted de novo. If the best relaxed match is class 1a, or nothing aligns coherently across the
11, the resemblance is positional and phenotypic only and the clade-code name stands.

### `cand_PLLG_260915`

Source: `260915_pllg_analysis.md` §§2–8. Mifsud/Simmonds place 74 taxa in PLLG; **61 are in the library**.

The pooled 60-member alifold consensus was **flat** — all dots, `(0.00 = 0.00 + 0.00)`. Diagnosis:
**34 of 60 (57 %) have no partner at ≥80 % identity** to anything else in the set, so the input was
mostly unrelated sequences plus a few internally consistent sub-clusters.

| cluster | n | stall range | taxa |
|---|---:|---|---|
| **A** | 12 | 444–462 (18 nt) | Bole tick virus 4 (4 isolates), Camel tick virus, *Dermacentor reticulatus* pestivirus-like virus 1, *Rhipicephalus sanguineus* assoc. flavi-like virus, Trinbago virus, 4× Flaviviridae sp. (TIGMIC) |
| B | 6 | 260–354 | Bole tick virus 4 (1) + 5× Flaviviridae sp. |
| C | 4 | 558–571 (13 nt) | Bole tick virus 4 (2) + 2× Flaviviridae sp. |
| D | 2 | 56 (exact) | the two *Bemisia tabaci* PLLG members |
| E | 2 | 217–218 | Bole tick virus 4 + Haseki tick virus |
| singletons | 34 | scattered 11–895 | everything else |

Cluster A is **6 distinct named taxa, all tick-associated** — cross-species conservation at a
consistent locus, not one species resequenced. The pooled 60-member alignment had no such group.

clusterA alifold, `--probabilistic --consistency-transformation`, 12/12 retained:

```
....((((((((..(((((.(........))))))..)))))))).....................................
(-33.73 = -21.10 + -12.63)
```

14 bp: outer stem 8 bp (5–12 / 38–45), inner 5 bp (15–19 / 31–35), 1 bp closing an 8 nt hairpin
loop (21 / 30). All nested, no crossing pairs — consistent with `bifs 0`. Structure occupies columns
5–45 of 81; the rest is unpaired.

Library-wide search recovered **24 of 60** PLLG members at E 1.7e-27 to 1.7e-22, full-length
`cm 1–76`: exactly clusterA (12) + B (6) + C (4) + MZ964986 + ON811742, zero missing, zero
unexpected. **So A, B and C are one element, not three** — their differing stall ranges reflect
where each isolate's exonuclease stalled, not different structures. 22/61 PLLG members (36 %).

`_cmalign` rebuilt on those 24 via `esl-sfetch` + `cmalign`. eff_nseq **fell** 1.90 → 1.55. The
note recorded in the document where work stopped: *"need to go back to the beginning, so far these sequences are way too
conserved"*.

Recorded alongside:

- **minus-strand artefact** — ranks 25–48 were partial (`cm 4–44` of 76), minus strand, a few bases
  upstream of each accession's own plus-strand hit: reverse-complement self-hits, the model's stem
  being partly self-complementary. Use `--toponly`.
- **`--incE 1e-10`** — nothing falls between 1.7e-22 and 1.4e-04, so the default 0.01 admits
  self-hits.
- **a possible second element** — six longer members (`ON811701`, `ON811702`, `ON262323`,
  `ON684360`, `BK067815`, `MN025505`) fold an extra downstream stem-loop absent from the consensus.
  Plausibly only visible in sequences with enough retained downstream sequence. Needs a wider window
  per accession, not an assumption of absence in the shorter members.
- **SbCNV-5** (`NC_024077.1`) is one of the 34 singletons — no ≥80 % partner, so it should not be
  expected in A/B/C by primary sequence. Shared structure at low sequence identity is not ruled out.
- **for the 34 singletons**, the document's own recommendation: do not pool them again as-is. Either
  structural comparison (Foldseek-style) rather than sequence identity, or take **all** significant
  peaks per accession instead of the single best one, in case the homologous site is not each
  virus's top-ranked stall.
- **the one PLLG member that already has a CM hit** is Xiangshan flavi-like virus 2
  (`OK491478.1`) → `CL_Class_1b`. Flagged in the source document as needing checking by eye,
  "since it's the outlier in an otherwise CM-blind clade", and never checked. A partial or spurious
  1b hit would make the clade 61/61 rather than 60/61.

**How the pool and clusters were derived.** `build_pllg_outputs.py` filters the Mifsud lookup to
`clade == 'PLLG'`, then keeps **the lowest `meta_pvalue` row per accession** — one stall per virus —
with CM-hit status across the four classes known at the time. `PLLG_LGF_unclassified_for_mlocarna.fa`
is that set minus `OK491478.1`, written from `downstream_seq` (42–80 nt).
`cluster_mlocarna_alignment.py` then computes pairwise identity over columns where **neither**
sequence has a gap and union-find merges any pair at ≥80 % identity over ≥15 compared columns.
`tblout_to_gdf.py` converts the tblout to GDF coordinates for `esl-sfetch`, which
reverse-complements automatically when `from > to`.

**The §0 caveat, in the document's own terms:** "best peak" is chosen purely by lowest p-value,
without checking whether that peak's `stall_position` is the biologically equivalent site across
viruses. If a virus has two comparably strong but structurally distinct stalls, only the lower-p one
is included.

**Usable without further refinement.** A 76-column model recovering 36 % of a clade with zero false
positives can be added to the annotation set as a candidate, so those 24 are no longer counted as
unannotated in later discovery pools. Caveat: with `bifs 0` and 15 pairs it may be recovering them
partly on sequence similarity rather than structure.

### Shared blocker

Both candidates are limited by sequence conservation, not structure, and both were searched only
against the 439-sequence library that produced the seed — which can return nothing but the seed's
own clade.

The procedure used for class4 (`work/infernal/README.md`, v1 → v9): build, search a **wider**
target, `cmalign` the `!` hits, rebuild, repeat; R-scape CaCoFold at the end. The covariation came
from sequences the search recovered, not from refining the seed alignment.

The wider target is `work/infernal/fa/RNAvirus_CompleteAssem_No_CoV-2.fa` (2.66 GB, `.ssi` built).
Searched 2026-10-27 with
`--toponly --incE 1e-10 --cpu 4`, output in each candidate's `tblout/RNAvirusDB_261027.tbl`.

### Selecting which clusters are worth aligning

Sequence count does not predict success:

| pool | seqs | distinct taxa | outcome |
|---|---:|---:|---|
| clusterA (PLLG) | 12 | 6 named, all tick-associated | real consensus −33.73, recovered 24 |
| `cand_FJTB_261026` | 16 | 1 serocomplex | built, recovers +1 accession only |
| Pegivirus | 16 | — | −3.56, set aside |
| pooled PLLG | 60 | many, unrelated | flat, `0.00 = 0.00 + 0.00` |

clusterA had fewer sequences than the pegivirus pool and worked; the pooled 60 had the most and
failed. **Distinct taxa**, not size, separated them. Rank candidate clusters by distinct accessions
and distinct named taxa, with a tight stall-position spread (clusterA 18 nt; `cand_FJTB_261026`
168–191 nt).

**Group by Mifsud clade code, not genus.** PLLG was grouped that way; the orthoflavivirus pool was
grouped by genus, which puts insect-specific and tick-borne flaviviruses in one alignment — the
source document warns against exactly this ("lumping e.g. FJIS with PLLG in one alignment will hurt
mlocarna/Infernal signal").

---

## Corrections

Conclusions reached and then overturned, recorded so they are not repeated.

- **Cluster 2 is not class 2.** A full-feature `cmsearch` of Class_2 hits all 15 `cand_FJTB_261026`
  accessions (E 8.2e-22 to 6.2e-15, `cm 1–93`, most twice) — that is accession-level membership at
  the tandem pair. At the element positions no model hits. **Accession-level presence is not a
  position-level test**; conflating them is what produced the wrong call.
- **The August discovery pool was correctly filtered.** `extract_genus_fastas.py` selects
  `any_hit == False` and `n_reps_passing in (3,4)`.
- **The 80 nt window did not cause the no-hit label** for `cand_FJTB_261026`, and does not truncate
  that element — its structure closes by column 82.
- **The 150–200 nt gap band is not genus-spanning.** It also catches NC_027817 (Parramatta River),
  NC_001655 (GB virus B), NC_020902 (*Pegivirus caballi*) and KY370100, none of which share
  sequence with the FJTB set. Null control: 16 of 48 sites fall in 150–200 against ~11 expected,
  the modal bin only. The tight 168–181 range is one clade, so phylogenetically confounded rather
  than 15 independent observations.
- **`{model}.cm_start` is where model column 1 aligns, not where the structure begins.** Medians:
  Class_1a +3, class1c 0, Class_1b −1, cl3 −1, dumbbell −6, Class_2 −13. Not a bookkeeping
  artefact — the medians are identical for `downstream_stall_at_offset == 0` and `< 0` rows. The
  mechanism is stall → pseudoknot → nested core, with the pseudoknot as the model's leading
  single-stranded columns; those carry little information, so cmsearch's 5′ boundary floats.
  Untested. The test is the leading unpaired run in each model's SS_cons (prediction: Class_2 and
  dumbbell longest, Class_1a and class1c shortest).
- **Struck**: "the 261021 table carries Class_2 E-values for 628 of 1,915 candidate rows". The
  table has 34,102 rows at 10 mM; those figures came from an unidentified subset.
- **`db/` was never a directory.** It appeared only in `viromelib_infernal_README.md`'s layout
  block; the search database has always been in `fa/`. Corrected 2026-10-27.
- **Builds were briefly moved into the wrong tree.** They belong with the dataset whose stalls
  produced them, not in one shared build directory.

## Accounting: stalls with no CM home

### Counts of what is not covered

The progress table below says what has been done. This one says how much is left, with counts.
**`unit` is not decoration** — accession-level and site-level counts answer different questions and
were conflated once already (see Corrections).

| group | n | unit | scope | where |
|---|---:|---|---|---|
| the 7 accepted models | 4,699 hits | hit rows | 261021, 10 mM | `cm/`, `cm_set_261021` |
| `cand_FJTB_261026` | 15 | stall sites | FJTB, both conditions | `build/cand_FJTB_261026/` |
| `cand_PLLG_260915` | 24 of 60 | PLLG members | PLLG | `build/cand_PLLG_260915/` |
| the 13 hepaci partial matches to class 1b | 13 | hits | Hepacivirus | forced alignments, fail past column ~74 |
| PLLG not covered by `cand_PLLG_260915` | 36 of 60 | PLLG members | PLLG | never aligned separately |
| Orthoflavivirus clusters never examined | 29 of 30 | clusters | Orthoflavivirus | `archive/flaviLib_20260917/.../orthoflavi_cluster_*` |
| Pestivirus trimmed 30 → 22 during pseudoknot inspection | 8 | sequences | Pestivirus | `archive/flaviLib_20260914/.../pesti_mlocarna/results/result-dedup.stk` |
| dropped from the class1b merge at bit score ≥ 25 | 9 | sequences | Hepacivirus | listed under "The class1b merge attempt" |
| Hepacivirus unclassified after class1b **and** class1c | 9 | accessions | Hepacivirus | listed under "Known uncovered" |
| accessions with no CM hit on any row | 242 of 439 | accessions | 261021, 10 mM, 7 models | `find_downstream_unannotated_stalls.py` |
| **well-powered, replicate-passing sites with no CM hit** | **885 / 415** | stall sites | 10 mM / 1 mM | the site-level discovery frontier |

### Progress table

One row per Mifsud sub-clade and per cluster. `—` means not checked, which is different from "no".

| row | how it was made | aligned? | CM candidate? | CM determined? |
|---|---|---|---|---|
| **FJTB** Tick-Borne | clade code | yes | `cand_FJTB_261026` | no |
| **FJMB** Mosquito-Borne | clade code | — | — | — |
| **FJNV** No Known Vector | clade code | — | — | — |
| **FJIS** Insect Only | clade code | — | — | — |
| **FJAF** Aquatic Flavivirus | clade code | — | — | — |
| **FJFL** Flavi-Like | clade code | — | — | — |
| **FJJI** Jingmenvirus | clade code | — | — | — |
| **FJUN** Unclassified | clade code | — | — | — |
| **PLLG** Large Genome Flavivirus | clade code | yes | `cand_PLLG_260915` | no |
| **PLPV** Pestivirus | clade code | yes | → `class1c` | yes, but `class1c` is **not** a PLPV class — see below |
| **PLUN** Unclassified | clade code | — | — | — |
| **HPPV** Pegivirus | clade code | yes | no, set aside at −3.56 | no |
| **HPHV** Hepacivirus | clade code | yes | `hepaci_unclas.cm`, rejected | partly — some HPHV sequences are `class1c` seed members |
| **HPUN** Unclassified | clade code | — | — | — |
| **TOMB** Tombusvirus out group | clade code | — | — | — |
| clusterA | vsearch on PLLG no-hit stalls, split by clade code | yes | `cand_PLLG_260915` | no |
| pooled PLLG, all 60 | no clustering, whole clade in one alignment | yes, flat | no | no |
| PLLG remainder, 36 of 60 | not clustered | no | no | no |
| orthoflavi `cluster_2` | vsearch on Orthoflavivirus no-hit stalls, split **by genus** | yes | `cand_FJTB_261026` | no |
| orthoflavi clusters 1, 3–30 | same genus split | no | no | no |
| `pesti_mlocarna` | Pestivirus no-hit stalls, split by genus | yes | → `class1c` | yes |
| `hepaci_unclas` | Hepacivirus no-hit stalls, split by genus | yes | built, rejected | no |
| Pegivirus pool | Pegivirus no-hit stalls, split by genus | yes | no | no |
| the 885 / 415 no-hit sites | not split at all | no | no | no |

**A clade code is not a partition of the CM classes, and `class1c` is the proof.** Its 46-sequence
seed is 22 hand-edited **Pestivirus** sequences plus the **Hepacivirus** accessions that
`pesti_short1b.cm`'s library search pulled in (MN587xxx, MN564793, OM203121, BK067807), fetched
with `esl-sfetch`, realigned with `cmalign`, and refined through CaCoFold as
`pesti_20260917_edit.stk`. So `class1c` spans PLPV and HPHV, and no single clade row can carry it.
Read the clade rows as "has this clade been worked on", not as "which class covers this clade".
MN564793 sits on both sides of that line: dropped from the class1b merge for weakening the model,
then entered `class1c` by the other route.

The genus-split rows are marked because the recorded rule is to split by clade code: a genus split
puts insect-specific and tick-borne flaviviruses in one alignment. Re-split the orthoflavivirus
pool before working through clusters 1 and 3–30.

### The unmatched pool, derived 2026-10-28 (both conditions)

Definition, matching `extract_genus_fastas.py`: **`any_hit == False` and `n_reps_passing` in
(3, 4)**. `any_hit` was checked against a recomputation from the seven `.cm_hit` columns on every
row of both tables and agrees exactly.

**749 no-hit sites at 10 mM, 351 at 1 mM, over 213 distinct accessions.**

| genus | sites 10 mM | accessions | sites 1 mM | accessions |
|---|---:|---:|---:|---:|
| **unassigned genus** | **250** | **67** | 95 | 35 |
| Orthoflavivirus | 185 | 53 | 121 | 36 |
| Pegivirus | 102 | 20 | 33 | 12 |
| **Jingmenvirus** | **74** | **23** | 21 | 9 |
| Orthohepacivirus | 66 | 24 | 58 | 16 |
| Orthopestivirus | 57 | 11 | 20 | 7 |
| Boletivirus | 14 | 6 | 2 | 1 |
| Guaicovirus | 1 | 1 | 1 | 1 |

Written to `work/nohit_pool/nohit_sites_flaviLib_both_20261028.tsv` (1,100 rows) and
`nohit_accessions_flaviLib_both_20261028.tsv` (213 rows), both carrying an empty `mifsud_clade`
column to be filled by the crosswalk.

**Neither previously recorded count reproduces.** The record carried 885 at 10 mM and 415 at
1 mM; the same definition now gives 749 and 351. Strike the old pair rather than carrying both.

Three observations:

1. **The largest group has no genus at all** — 250 sites over 67 accessions at 10 mM. A genus
   split cannot place them. This is the group the Mifsud crosswalk exists for.
2. **Jingmenvirus has no CM coverage** — 74 sites over 23 accessions at 10 mM, nothing from any
   of the seven models.
3. **Depth is not the limitation.** Median summed stall reads by genus run 699–6,737 (1 mM).
   These are well-powered sites.

**The clade assignment is a join, not new work.** `build_pllg_outputs.py` already does it:
load the `Metadata` sheet of `Mifsud_2024_Supplementary_table_1_EDIT_NO3UTRseqs.xlsx`, join on
version-stripped GenBank accession (`NC_024077.1` → `NC_024077`) — the only field spelled
consistently across both sources, since genus and species formatting differs. The existing
crosswalk `unclassified_genus_with_mifsud_clade.csv` covers only the 116 `genus = Unannotated`
rows (101 matched, 15 absent from Mifsud's 593-accession set). The Metadata sheet covers all 593,
so the same join extends to every no-hit accession, not only the unassigned ones.

#### Split by Mifsud clade, 2026-10-28

Join done as `build_pllg_outputs.py` does it: `Metadata` sheet of
`Mifsud_2024_Supplementary_table_1_EDIT_NO3UTRseqs.xlsx`, version-stripped accession. 593 rows
over 535 distinct accessions; 53 accessions appear more than once but **never with conflicting
clades**, so de-duplicating on accession is safe. Lookup written to
`work/nohit_pool/mifsud_clade_lut.tsv`; the joined pool to `nohit_sites_by_clade_20261028.tsv`.

**197 of 213 no-hit accessions get a clade. 16 are not in Mifsud's set at all.**

Ranked by **distinct taxa**, which is the recorded criterion — clusterA worked on 12 sequences
from 6 named taxa while the 60-member pooled PLLG failed:

| clade | sites 10 mM | accessions | distinct taxa | median SF | stall position spread (p10–p90) |
|---|---:|---:|---:|---:|---:|
| **PLLG** | 140 | 35 | **35** | 0.420 | 6,756 |
| **HPHV** | 66 | 24 | **24** | 0.581 | 1,566 |
| **FJJI** | 147 | 50 | 21 | 0.514 | **181** |
| HPPV | 116 | 21 | 21 | 0.603 | 1,521 |
| FJIS | 83 | 20 | 20 | 0.584 | 505 |
| FJMB | 25 | 12 | 12 | 0.409 | 364 |
| PLPV | 51 | 9 | 9 | 0.636 | 739 |
| FJTB | 28 | 8 | 8 | 0.425 | 404 |
| FJAF | 28 | 6 | 6 | 0.668 | 858 |
| FJUN | 18 | 3 | 3 | 0.505 | 1,786 |
| FJNV | 3 | 1 | 1 | 0.449 | 0 |
| FJFL | 1 | 1 | 1 | 0.317 | 0 |
| not in Mifsud | 43 | 15 | — | 0.408 | 7,941 |

The clade join resolves the unassigned-genus group. The 250 sites at 10 mM with no genus split
into PLLG 115, FJJI 72, FJIS 24, HPPV 14, FJUN 11, FJAF 4, FJFL 1, with 9 left
unmatched. Clade and genus are genuinely different axes: PLLG alone spans Boletivirus (14 sites),
Orthopestivirus (6), Orthoflavivirus (5) and 115 with no genus.

Reading the ranking:

- **PLLG and HPHV are the two best pools by the recorded criterion** — 35 and 24 distinct taxa,
  one taxon per accession in both. PLLG is also the clade `cand_PLLG_260915` already failed to
  cover (24 of 60 members), so these 140 sites are the direct continuation of that work.
- **FJJI has the most sites but is not the best pool**: 147 sites over 50 accessions but only 21
  distinct taxa, so it is the most redundant. Its **position spread of 181 nt is by far the
  tightest**, which by the clusterA precedent (18 nt) is the other half of the criterion. Worth
  aligning despite the redundancy.
- **PLLG's 6,756 nt spread and the unmatched group's 7,941 argue against aligning either whole.**
  Cluster within them first.
- **FJTB still has 28 uncovered sites at 10 mM and 43 at 1 mM** — more at the lower magnesium,
  the same inversion seen for `cand_FJTB_261026` itself.

#### Two corrections to the counts and the SF comparison, 2026-10-28

**Every site count above was tile-inflated.** The same stall appears once per overlapping tile.
Deduplicating on accession + `stall_site_genomic_position`: **749 rows → 327 distinct sites at
10 mM (56 % duplicates), 351 → 178 at 1 mM (49 %)**. This is the same effect that turned 42
cluster-2 "members" into 15 sites. Deduplicated pool in
`work/nohit_pool/nohit_sites_dedup_10mM_20261028.tsv`.

| clade | distinct sites | accessions | species | median SF |
|---|---:|---:|---:|---:|
| PLLG | 66 | 35 | 18 | 0.421 |
| FJJI | 57 | 50 | 13 | 0.549 |
| HPPV | 40 | 21 | 17 | 0.567 |
| FJIS | 34 | 20 | 14 | 0.620 |
| HPHV | 34 | 24 | 12 | 0.595 |
| not in Mifsud | 29 | 15 | 11 | 0.408 |
| FJTB | 17 | 8 | 7 | 0.438 |
| FJMB | 17 | 12 | 11 | 0.409 |
| PLPV | 15 | 9 | 8 | 0.671 |
| FJAF | 9 | 6 | 6 | 0.703 |
| FJUN | 7 | 3 | 3 | 0.424 |
| FJNV | 1 | 1 | 1 | 0.536 |
| FJFL | 1 | 1 | 1 | 0.317 |

**SF of 0.9 is the top decile of a class, not its median.** Measured at 10 mM over 4-of-4 rows:

| class | n | median | p75 | p90 | max | % ≥ 0.9 |
|---|---:|---:|---:|---:|---:|---:|
| Class_1a | 420 | 0.778 | 0.859 | 0.905 | 0.947 | 11.4 |
| class1c | 238 | 0.741 | 0.839 | 0.889 | 0.960 | 5.9 |
| Class_1b | 471 | 0.732 | 0.816 | 0.867 | 0.983 | 2.5 |
| **no hit** | 645 | 0.535 | 0.700 | 0.813 | 0.962 | 2.0 |
| Class_2 | 89 | 0.504 | 0.601 | 0.671 | 0.846 | 0 |
| cl3 | 10 | 0.495 | 0.527 | 0.627 | 0.779 | 0 |
| dumbbell | 32 | 0.479 | 0.596 | 0.664 | 0.770 | 0 |

Only 11.4 % of Class_1a sites reach 0.9; its median is 0.778. So the no-hit clade medians of
0.41–0.70 are below the class 1 medians, as expected — a site with a strong conserved element is
exactly the kind that already has a CM — but they are **not** below a 0.9 benchmark, because no
class has a 0.9 median.

**The tail is where the targets are.** Deduplicated, **46 of 278 no-hit 4-of-4 sites at 10 mM
reach or exceed the Class_1a median of 0.778**, across 39 accessions, concentrated in FJIS, HPPV,
PLPV, FJAF and HPHV. Several sit at very high depth: NC_034017 (Xishuangbanna aedes flavivirus,
FJIS) at 0.962 and 63k reads, MN564793 (rodent hepacivirus, HPHV) at 0.943 and 127k reads,
KY370101 (*Orthopestivirus niviventris*, PLPV) at 0.924 and 42k reads. These behave like class 1a
sites and have no model at all. Listed in `work/nohit_pool/nohit_highSF_10mM_20261028.tsv`.

#### Model co-occurrence

Method: distinct sites (deduplicated on accession + genomic position), 10 mM, `n_reps_passing` in
(3,4), presence taken from each `.cm_hit` column being non-NA.

- **No stall anywhere is annotated by two models.** Zero same-site co-occurrence across all seven,
  in every pairwise combination. The models are mutually exclusive at the position level.
- **Co-occurrence within one genome is rare and specific.** Only two pairs occur at all:
  `Class_1a + dumbbell` in **13 accessions** (of 56 Class_1a and 15 dumbbell — so 13 of 15
  dumbbell genomes also carry a class 1a), and `Class_1b + class1c` in **exactly one**, MN564793.

**This argues against merging class1c into class1b, more strongly than the earlier model test
did.** If they were one family split by a modelling artefact, the models would double-annotate
sites or co-occur widely. Neither happens: 0 shared sites, 1 shared genome out of 439. In that one
genome the two hits do not even overlap — Class_1b spans genomic 9565–9658 and class1c 9670–9740,
12 nt apart, so they are two adjacent elements in tandem, not one element called twice. The
earlier result that merging cost AB021287.1 coverage (18.17 → 14.12 bits) to gain one
classification is consistent with this.

One caveat on that single co-occurrence: the Class_1b hit at 9566 has **E = 3.6e-04**, close to
`annotate_infernal_hits.py`'s 0.001 cutoff, while the class1c hit is E = 5.1e-14. The only genome
carrying both rests on a marginal Class_1b call. Worth re-checking at a stricter threshold before
treating it as a real tandem.

Separately, **13 of 15 dumbbell genomes also carry Class_1a** — the dumbbell element almost always
accompanies a class 1a xrRNA. Not previously recorded.

#### Class_1b is a weak model library-wide, not only here

Method: distinct sites, 10 mM, E-values as annotated.

| model | hits | best | p25 | median | p75 | worst |
|---|---:|---:|---:|---:|---:|---:|
| `class1c` | 53 | 7.1e-23 | 2.2e-19 | **2.0e-17** | 2.1e-16 | 3.4e-11 |
| `Class_1b` | 119 | 9.0e-10 | 1.9e-07 | **4.0e-06** | 3.8e-05 | 3.7e-03 |

**Eleven orders of magnitude separate the two medians.** class1c's *worst* hit (3.4e-11) is
stronger than Class_1b's *best* (9.0e-10). So "the Class_1b hit barely makes it" describes the
model generally: 23 of 119 Class_1b hits sit within 10× of the 0.001 mark, and 16 are weaker than
MN564793's 3.6e-04, which is therefore not even unusual for Class_1b.

This reframes the class1b/class1c question. The issue is not that one genome has a marginal call;
it is that **Class_1b assigns weak scores across the library while class1c is highly specific**.
That is consistent with the class1b merge history — 59 confident hits that cost coverage when
merged, 13 hits that match the N-terminal region and fail past column ~74 — and suggests Class_1b
may be under-specified rather than that class1c should absorb it.

Hit geometry is near-identical for both, so it does not separate them: class1c `_start` median 0
(range −1..2), length 79; Class_1b `_start` median −1, length 86. Both begin at the stall.

**The library-wide class1c search already covered this genome.** Every MN564793 row, gates
ignored, records exactly one class1c span (9670–9740) and one Class_1b span (9565–9658, attached
to stalls 9566, 9584 and 9590). So class1c does not reach 9440 at the run's threshold, and the
strong unannotated element there is not a class1c copy. What remains open is narrower: whether
class1c scores at **9566** sub-threshold, better than Class_1b's 3.6e-04. Step 15:

```bash
# step 15 -- does class1c score MN564793's other stalls, sub-threshold?
CM_DIR=~/Desktop/viromelib/work/infernal/cm          # confirm
esl-sfetch <reference.fa> MN564793.1 > /tmp/MN564793.fa
for CM in "$CM_DIR"/class1c.cm "$CM_DIR"/CL_Class_1b_xrRNA_final.cm; do
  echo "== $(basename "$CM")"
  cmsearch --toponly -E 100 --tblout /dev/stdout "$CM" /tmp/MN564793.fa 2>/dev/null \
    | awk '$1!~/^#/ {print $8"-"$9, $16}' | sort -k2,2g | head
done
```

Read the spans against the known stalls. If class1c scores at 9566 better than Class_1b's
3.6e-04, the assignment there is wrong and the only Class_1b + class1c co-occurrence in the
library disappears.

### Step 16 — does MN564793's Class_1b sequence strengthen or weaken class1c?

The decisive test, and the same shape as the class1b merge attempt that failed. Extract the
Class_1b-annotated span, align it into the class1c seed, rebuild, and check both directions.

```bash
# step 16 -- try MN564793:9565-9658 as a class1c seed member
CM_DIR=~/Desktop/viromelib/work/infernal/cm              # confirm
STOCKDIR=~/Desktop/viromelib/flaviLib/work/infernal/flaviLib_20260914/candidate_short1b/pesti_cmalign
SEED=$STOCKDIR/pesti_20260917_edit.stk                   # the 46-seq class1c seed
WORK=~/Desktop/viromelib/flaviLib/work/infernal/build/class1c/iter_v2_mn564793
mkdir -p "$WORK"

esl-sfetch -c 9565..9658 <reference.fa> MN564793.1 > "$WORK/mn564793_1b_span.fa"
cmalign -o "$WORK/mn564793.stk" "$STOCKDIR/class1c20260917/class1c.cm" "$WORK/mn564793_1b_span.fa"
esl-alimerge -o "$WORK/class1c_v2.stk" "$SEED" "$WORK/mn564793.stk"
cmbuild -F -n class1c_v2 "$WORK/class1c_v2.cm" "$WORK/class1c_v2.stk"
cmstat "$CM_DIR/class1c.cm" "$WORK/class1c_v2.cm"
```

`esl-alimerge` is column-consistent here because both inputs carry `#=GC RF` from the same CM's
match-state definition — the same reason it worked for the class1b merge.

Then the part the class1b attempt got wrong by checking only hit counts. Calibrate, search, and
compare **per-sequence bit scores for the existing 53 class1c hits**, not just totals:

```bash
cmcalibrate --cpu 4 "$WORK/class1c_v2.cm"
for CM in "$CM_DIR/class1c.cm" "$WORK/class1c_v2.cm"; do
  cmsearch --toponly --incE 1e-10 --cpu 4 \
    --tblout "$WORK/$(basename "$CM" .cm).tbl" "$CM" <library.fa> > /dev/null
done
join -j1 \
  <(awk '$17=="!"{print $1"_"$8, $15}' "$WORK/class1c.tbl"    | sort) \
  <(awk '$17=="!"{print $1"_"$8, $15}' "$WORK/class1c_v2.tbl" | sort) \
  | awk '{d=$3-$2; printf "%-44s %8.2f %8.2f %+8.2f\n", $1, $2, $3, d}' | sort -k4,4g | head -20
```

**Accept the merge only if no existing hit loses bit score and the alignment does not truncate.**
That is the criterion the class1b merge failed: it cost AB021287.1 18.17 → 14.12 bits with the
alignment cut at column 62 instead of 81, to gain one classification. Record `nseq`, `eff_nseq`,
`clen`, `bps`, `bifs` before and after, and the worst per-sequence delta.

#### MN564793

Distinct passing stalls, both conditions, with hit spans where annotated:

| position | SF 10 mM | SF 1 mM | annotation |
|---:|---:|---:|---|
| 9439 | 0.776 | 0.770 | — |
| 9440 | 0.943 | 0.955 | — |
| 9566 | 0.878 | 0.889 | Class_1b, 9565–9658, E 3.6e-04 |
| 9670 | 0.861 | 0.476 | class1c, 9670–9740, E 5.1e-14 |
| 9723 | — | 0.424 | — |
| 9762 | — | 0.373 | — |
| 9763 | — | 0.531 | — |

Reading:

- 9439 and 9440 are 1 nt apart and are one stall split by peak calling (decision 4, unresolved).
- The Class_1b and class1c spans do not overlap; they are two adjacent elements, not one element
  called twice.
- The accession carries an unannotated element ~126 nt upstream of that tandem.
- 9723 falls inside the class1c span, so it is a stall within an annotated element.
- Three additional unannotated sites appear at 1 mM but not 10 mM, the same magnesium inversion
  recorded for `cand_FJTB_261026`.

NC_034017 has the same arrangement without annotated partners: 10510 (0.861) and 10511 (0.962),
1 nt apart, nothing else in the accession.

#### Is the clade SF skewed by sites that only just passed?

`median_treated_sf` is the median across **all four** replicates, including any that failed their
own peak gate. Two separate effects, measured separately:

**Within a row: small.** Taking the median over passing replicates only changes nothing for
`n_reps_passing == 4` rows, by construction. For the 3-of-4 rows it raises the 10 mM median from
0.343 to 0.368 (1 mM: 0.346 to 0.365), and moves 100 of 749 rows at 10 mM. No clade median shifts
by more than 0.024, and HPHV's moves **down**. This does not explain the differences between
clades.

**Across rows: substantial, and it does.** Sites passing 3 of 4 have much lower SF than those
passing 4 of 4 — 0.343 against 0.535 at 10 mM — and they are unevenly distributed across clades.
The correlation between a clade's share of 3-of-4 sites and its median SF is **−0.642**.

| clade | % at 3 of 4 | median SF, all | median SF, 4 of 4 only |
|---|---:|---:|---:|
| FJMB | 28.0 | 0.409 | 0.450 |
| not in Mifsud | 23.3 | 0.408 | 0.428 |
| PLLG | 19.3 | 0.420 | 0.471 |
| FJJI | 17.0 | 0.514 | 0.548 |
| FJTB | 10.7 | 0.425 | 0.437 |
| HPPV | 10.3 | 0.603 | 0.627 |
| FJIS | 9.6 | 0.584 | 0.627 |
| HPHV | 9.1 | 0.581 | 0.590 |
| FJAF | 7.1 | 0.668 | 0.684 |
| PLPV | 3.9 | 0.636 | 0.652 |

**Quote the 4-of-4 median when comparing clades.** The low-SF clades are partly low because they
carry more marginal sites, not only because their elements are weaker. PLLG moves 0.420 → 0.471
and FJMB 0.409 → 0.450 under the restriction; the ranking by distinct taxa above is unaffected,
but any statement comparing clade SF should use the restricted figure.

**`downstream_seq` is still the blocker for aligning any of this**: at 1 mM, 209 of 351 rows are
exactly 80 nt, the column's cap, while hit ends elsewhere reach 143. Pools built from this column
hand mlocarna truncated sequences. Windows must be re-extracted from the reference at a larger
width before clustering.

The last row is the largest group and the only one never examined: stalls no model annotates at
any position, never clustered. Median SF 0.449 at 10 mM, against Class_2's 0.459.

Three conditions on these counts, to settle before quoting them outside this document:

1. **The 885 / 415 were counted against 7 models.** Both candidates must be added to
   `annotate_infernal_hits.py` and the count re-derived against 9.
2. **The three hepaci tiers (8, 9, 13) may overlap.** They were derived by three different
   comparisons; MN564793 is known to appear in two. Closing this means one comparison over the
   original genus pool, not three partial ones.
3. **The depth band is unresolved.** Among passing sites median SF is non-monotonic in depth
   (31–100: 0.763 against 0.457 at 301–1k). Any site-level count in the thin band inherits that.

A stacked bar of site counts by stage requires items 1 and 2 settled first: the counts are
currently in four different units and two are provisional.


### class1c lineage and where every file is

Source: `260914-260917_cm_expansion.md`. The `cmalign` round precedes class1c; no realignment or
rebuild follows the class1c library scan. Chain, with paths as written:

```
INFERNAL=~/Desktop/viromelib/flaviLib/work/infernal
STOCKDIR=$INFERNAL/flaviLib_20260914/candidate_short1b/pesti_cmalign
```

| step | command | output |
|---|---|---|
| 1 | `cmbuild` from 22 hand-edited Pestivirus seqs | `candidate_short1b/pesti_cm/pesti_short1b.cm` |
| 2 | `cmsearch` library-wide | `tblout/pesti_short1b.tbl` |
| 3 | fetch list from `$17=="!"`, `esl-sfetch -Cf` | `$STOCKDIR/hits.fetchlist`, `$STOCKDIR/hits.fa` (**46 seqs**, incl. the Hepacivirus ones) |
| 4 | **`cmalign` with `pesti_short1b.cm`** | `$STOCKDIR/hits_aligned.stk` |
| 5 | `dedup_stockholm.py` | `$STOCKDIR/hits_aligned_dedup.stk` |
| 6 | manual MATER + CaCoFold | `pesti-add-PKs-edit20260917-MATER-wiggle-refined-MATER-wiggle-refined.stk`, renamed **`$STOCKDIR/pesti_20260917_edit.stk`** |
| 7 | `cmbuild -F -n class1c` + `cmcalibrate` | **`$STOCKDIR/class1c20260917/class1c.cm`** |
| 8 | `cmsearch` class1c library-wide | `$INFERNAL/tblout/class1c_20260917.tbl`; hits in `$STOCKDIR/class1c20260917/class1c_hits.txt` |

**Nothing follows step 8.** The document moves straight to the genus breakdown of the class1c
hits and then to the orthoflavivirus pool. So **class1c was never realigned on its own hits and
never rebuilt** — one round only, no self-refitting. (2026-10-29: and on the library there is
nothing to realign — step 8 returns exactly the seed of step 6. See "class1c is saturated on the
library".)

That is worth stating positively. Decision 35 flags `class4_cl4_v9_20260824` for **nine** rounds
of taking a model's own hits, realigning and rebuilding, the same procedure that drove
`clusterA_refined.cm` to eff_nseq 1.55. class1c did not go through that, which is part of why its
nseq 46 / eff_nseq 9.54 is legitimate rather than a converged artefact.

**Two borderline Pestivirus hits were never resolved.** The source records KY370101 and NC_025677
as borderline class1c hits, with "deciding whether to formally include them" left open, and notes
the seven Pestivirus accessions still unclassified after class1b and class1c: KY370100, KY370101,
MW256672, NC_025677, OM030319, ON684360, OX394178.

**KY370101 also carries a high-SF unannotated stall — SF 0.924 at 42k reads, PLPV, among the strongest in the whole no-hit pool. So
an accession recorded as a *borderline class1c hit* also carries a strong stall that no model
annotates. Resolving the borderline call and examining that stall are the same question.

**Correction to the uncovered Hepacivirus count below: it is nine, not eight.** The source lists
BK013349, MG599987, MG599989, MN535729, MN691105, MZ393517, NC_028377, NC_038432 **and
OX394189**; the entry in "Known uncovered" omits OX394189.

### The borderline pestivirus hits, and a pattern behind them

Checked against the 261021 tables.

**The "still unclassified after class1b and class1c" pestivirus list is stale.** All three of the
accessions involved carry a Class_1b hit in the 261021 annotation:

| accession | 10 mM passing sites |
|---|---|
| KY370101 | 12621 SF 0.929 **Class_1b** · 12807 SF 0.924 no hit · 13029 SF 0.834 no hit |
| NC_025677 | 12527 SF 0.907 **Class_1b** · 12635 SF 0.842 · 12710 SF 0.871 · 12867 SF 0.671, all no hit |
| KY370100 | 12385 SF 0.842 **Class_1b** · 12573 SF 0.736 no hit |

The Sept 2026 list came from a different search and model set, so "unclassified" there does not
mean unannotated now. Re-derive it before using it.

**The shape is the same in all three: one annotated element, then strong unannotated stalls
downstream.** Same as MN564793. Tested library-wide, distinct sites, 10 mM:

- 173 accessions carry at least one annotated passing site
- **74 of them also carry an unannotated passing site**
- **56 carry one downstream of their last annotated site**

| genus | accessions | with any unannotated | with unannotated downstream |
|---|---:|---:|---:|
| Orthoflavivirus | 83 | 41 | 36 |
| Orthohepacivirus | 37 | 13 | 4 |
| Pegivirus | 19 | 12 | 8 |
| Orthopestivirus | 14 | 6 | 6 |
| unassigned | 19 | 2 | 2 |

**A third of annotated accessions carry an unannotated element downstream of the modelled one.**
That is a different discovery target from the clade pools: these are not orphan stalls in
unstudied viruses but *additional copies in genomes already known to have an xrRNA*, where the
flanking annotated element gives a positional anchor and a structural prior. ON949931 has four,
NC_001672 three, NC_025677 three, NC_027709 three.

This is the same arrangement as `cand_FJTB_261026`, which sits downstream of a class 2 tandem
pair. It is apparently the common case rather than that candidate's peculiarity.

### class1c is saturated on the library — found 2026-10-29

Checked from `build/class1c/tblout/class1c_20260917.tbl` and `build/class1c/seed/pesti_20260917_edit.stk`.
Method, commands and caveats: "Methods for the 2026-10-29 checks", M1–M2.

**The 46 included (`!`) hits of class1c's library search are the 46 seed sequences.** Same 19
accessions, every hit span within 5 nt of a seed span, all full-model (`cm 1–84`), all plus strand,
E 7.1e-23 to 3.4e-11. `cmbuild -F -n class1c` on the seed reproduces the `cmstat` line exactly
(46 / 9.54 / 84 / 15 bp / 1 bif / 0.676), so the seed in `build/class1c/seed/` is the one the model
was built from.

This follows from the lineage: the seed **is** a `cmalign` of `pesti_short1b.cm`'s library hits
(lineage steps 3–4 below). The search → `cmalign` → rebuild round has therefore already been done
once, one model earlier, and class1c's own library search returns that set and nothing else.
Consequences:

- **Step 18 against the library is a no-op.** It would realign the 46 seed sequences to the model
  built from them. The "one more library-wide search" after it would return the same 46.
- **Further growth needs a wider target**: `RNAvirus_CompleteAssem_No_CoV-2.fa`, as for class4
  (Shared blocker). Run `cm_iterate.sh` with that as `--target`; it stops at round 0 if the result
  is also seed-only.
- **The only library-level change still possible is step 17**, the sub-threshold hits.

Below inclusion in the same search (none of these is a seed member):

| target | bits | E | model cols | feature span | genomic span |
|---|---:|---:|---|---|---|
| KY370101.1 `12448-13220` | 14.9 | 0.016 | 1–84 | 361–453 | 12808–12900 |
| ON949931.1 `10190-10948` | 13.4 | 0.052 | 1–84 | 419–499 | 10608–10688 |
| NC_025677.1 `12480-12983` | 10.7 | 0.42 | 1–84 | 252–324 | 12731–12803 |
| OP860412.1 `10502-11076` | 7.3 | 5.4 | 30–46 | 325–341 | fragment, ignore |

Genomic = feature start + feature position − 1.

**KY370101's sub-threshold class1c hit starts 1 nt after its unannotated stall at 12807** (SF 0.924,
42k reads, one of the strongest no-hit sites in the library). class1c `_start` sits at −1..2 of the
stall in every annotated case, so this is the same geometry. That answers the question left under
step 17 ("check whether the borderline span coincides with either"): it coincides with 12807, not
with 13029. Step 17 decides whether that site gets a class1c annotation.

NC_025677's span begins 21 nt after its stall at 12710 — outside the class1c geometry, so not the
same call. ON949931 (*Kilpisjarvi flavivirus*, FJIS, four unannotated sites) is full-length at
E 0.052, and **10608 is one of its stalls** (SF 0.900; found 2026-10-29 in the flavi150 explorer),
so it has the same geometry as KY370101. See "Seeds from the flavi150 explorer".

**The empty `iter_v2_cmalign/hits.fetchlist` and `hits.fa`** (0 bytes, 2026-10-28 20:03, in the
class1c archive) are a failed start of step 18b, not a result. The 18b filter yields 46 rows on the
tblout as it stands, so the input was not found: 18a's `TBL` and `CM` point at
`$INFERNAL/tblout/` and `flaviLib_20260914/...`, which `infernal_layout_261027.sh` moved to
`build/class1c/tblout/` and `cm/class1c.cm`. `grep` on a missing file prints to stderr and leaves
the redirect empty. Delete the two files. Paths below are corrected.

### Step 18 — rebuild class1c from its library-wide hits (`cmalign` round)

**Status 2026-10-29: not needed against the library (saturated, above).** Kept for the wider target.
`cm_iterate.sh` runs 18a–18e as one command, with the saturation check first:

```bash
INFERNAL=~/Desktop/viromelib/flaviLib/work/infernal
VIR_INF=~/Desktop/viromelib/work/infernal
$FLAVISCRIPTS/cm_iterate.sh --name class1c \
  --cm "$VIR_INF/cm/class1c.cm" \
  --seed "$INFERNAL/build/class1c/seed/pesti_20260917_edit.stk" \
  --target "$VIR_INF/fa/RNAvirus_CompleteAssem_No_CoV-2.fa" --label RNAvirusDB \
  --workdir "$INFERNAL/build/class1c/iter_v2_RNAvirusDB" --doc "$DOC" --check-only
```

`--check-only` stops after the first search and logs hits, accessions and novel hits. Drop it to
let the rounds run.

The manual procedure, as recorded before the saturation check:

Takes class1c's own library hits, realigns them to the model and rebuilds. Same procedure as the
`pesti_cmalign` round that produced class1c, applied one level up.

**This is self-refitting, which has a recorded failure mode.** Decision 35: `class4_cl4_v9` went
through nine such rounds, and `clusterA_refined.cm` reached eff_nseq 1.55 — "about as much
independent statistical information as one and a half sequences". One round is normal
(`hepaci_hits_v2` did one and reached eff_nseq 19.93 from 55 sequences); the test is whether
eff_nseq holds up, not whether the hit count grows. Current baseline: **nseq 46, eff_nseq 9.54,
clen 84, 15 bps, 1 bif, rel. entropy 0.676.**

```bash
# step 18a -- paths (corrected 2026-10-29 to the post-reorganisation layout)
INFERNAL=~/Desktop/viromelib/flaviLib/work/infernal
CM=~/Desktop/viromelib/work/infernal/cm/class1c.cm
TBL=$INFERNAL/build/class1c/tblout/class1c_20260917.tbl
for f in "$CM" "$TBL"; do [ -s "$f" ] || echo "MISSING: $f"; done
FA=$INFERNAL/fa/flavi_library_20260228pretile20260818_TRUEordered_uniqueIDs.fa
WORK=$INFERNAL/build/class1c/iter_v2_cmalign; mkdir -p "$WORK"

cmstat "$CM" | grep -v '^#'          # record the baseline before changing anything
```

```bash
# step 18b -- fetch list from the existing tblout
# $10=="+" : the September search did not use --toponly, so minus-strand rows are
#            reverse-complement self-hits and must be dropped (decision 36)
# $17=="!" : Infernal's own inclusion flag
# ($7-$6)>=70 : at least 70 of class1c's 84 model columns, dropping single-stem fragments.
#               This is the filter used for the hepaci round; adjust or remove deliberately.
grep -v '^#' "$TBL" \
  | awk '$10=="+" && $17=="!" && ($7-$6)>=70 {print $1"/"$8"-"$9, $8, $9, $1}' \
  > "$WORK/hits.fetchlist"
wc -l < "$WORK/hits.fetchlist"
awk '{print $4}' "$WORK/hits.fetchlist" | cut -d'|' -f1 | sort -u | wc -l   # distinct accessions

esl-sfetch --index "$FA"
esl-sfetch -Cf "$FA" "$WORK/hits.fetchlist" > "$WORK/hits.fa"
grep -c '^>' "$WORK/hits.fa"
```

Count check before going further: the 261021 annotation carries **53 distinct class1c-annotated
sites** at 10 mM. A fetchlist far larger than that means the strand or length filter is not doing
its job; far smaller means the column filter is too strict.

```bash
# step 18c -- align to the current model, then dedup
cmalign --cpu 4 --outformat Stockholm -o "$WORK/hits_aligned.stk" "$CM" "$WORK/hits.fa"
python "$ROOT/flaviLib/scripts/dedup_stockholm.py" \
  "$WORK/hits_aligned.stk" "$WORK/hits_aligned_dedup.stk"
grep -c '^[^#]' "$WORK/hits_aligned_dedup.stk"
```

`dedup_stockholm.py` removes exact duplicate **aligned** sequences. It will not collapse
near-identical ones; `cd-hit-est -c 0.98` on `hits.fa` before `cmalign` is the alternative, and is
what the hepaci round used (55 sequences from 59 hits). Tandem paralogs within one accession are
distinct sequences and are kept by both — the pesti round kept them deliberately.

```bash
# step 18d -- build both ways and compare; the choice changes clen
cmbuild --hand -F -n class1c_v2hand "$WORK/class1c_v2hand.cm" "$WORK/hits_aligned_dedup.stk"
cmbuild        -F -n class1c_v2     "$WORK/class1c_v2.cm"     "$WORK/hits_aligned_dedup.stk"
cmstat "$CM" "$WORK/class1c_v2hand.cm" "$WORK/class1c_v2.cm"
```

`cmalign` output carries `#=GC RF` from the model, so `--hand` holds the consensus columns at
clen 84 and only `eff_nseq` and relative entropy move. Plain `cmbuild` re-infers match columns by
occupancy and may change clen, bps and bifs. The original class1c was built **without** `--hand`
from a CaCoFold-refined alignment, so neither is "the" convention here — pick one and record it.

**Accept or reject on these, in order:**

1. `eff_nseq` must not collapse. Baseline 9.54 from 46 sequences (ratio 0.207). The rejection
   case on record is eff_nseq 1.55. A large nseq with a flat eff_nseq means the new sequences are
   redundant with the seed.
2. No existing hit may lose bit score. This is the class1b lesson: that merge gained one
   classification and cost AB021287.1 18.17 → 14.12 bits with the alignment truncated at column
   62 instead of 81.
3. `clen`, `bps`, `bifs` should be stable under `--hand`. If they move, the alignment is not
   column-consistent with the seed.

```bash
# step 18e -- calibrate and compare per-sequence, not by hit count
for V in v2hand v2; do cmcalibrate --cpu 4 "$WORK/class1c_$V.cm"; done
cmsearch --toponly --incE 1e-10 --cpu 4 --tblout "$WORK/v0.tbl" "$CM" "$FA" > /dev/null
for V in v2hand v2; do
  cmsearch --toponly --incE 1e-10 --cpu 4 --tblout "$WORK/$V.tbl" "$WORK/class1c_$V.cm" "$FA" > /dev/null
  echo "== $V: worst per-sequence bit-score changes against v0"
  join -j1 <(awk '$17=="!"{print $1"_"$8, $15}' "$WORK/v0.tbl" | sort) \
           <(awk '$17=="!"{print $1"_"$8, $15}' "$WORK/$V.tbl" | sort) \
    | awk '{printf "%-46s %8.2f %8.2f %+7.2f\n", $1, $2, $3, $3-$2}' | sort -k4,4g | head -8
  echo "   accessions: $(awk '$17=="!"{print $1}' "$WORK/$V.tbl" | cut -d'|' -f1 | sort -u | wc -l)"
done
```

Record in the run log: `nseq`, `eff_nseq`, `clen`, `bps`, `bifs` for all three models, the worst
per-sequence delta, and the accession count before and after.

**Relation to step 17.** Step 17 tests two specific borderline sequences; step 18 takes every
passing hit. ~~Run 18 first and use its model as the baseline for 17.~~ Superseded 2026-10-29: on
the library, 18 returns the seed, so the original `class1c.cm` is the baseline for 17. If 18 is run
against the RNAvirus database and produces a new model, re-run 17 against that model.

### Step 17 — class1c with and without the borderline hits

**Run it as one command (2026-10-29), `cm_add_borderline.sh`.** It replaces the manual block
further down, which used `esl-alimanip` + `esl-alimerge` and `cmbuild --hand` on the baseline.
Two things were wrong with that recipe, both found testing the script on a synthetic library:

- `cmbuild --hand` on the **seed itself** gives clen **83**, not 84: the seed's own `#=GC RF` line
  is not the model's match-column set (class1c was built *without* `--hand`, by occupancy). A
  `--hand` baseline therefore differs from class1c before anything is added.
- Plain `cmbuild` on a `cmalign --mapali` output gives clen **85**: cmalign re-lays out the
  seed's insert columns and one crosses the 50 % occupancy line.

So the script builds **v0 = plain `cmbuild` on the seed** (reproduces class1c exactly: 46 / 9.54
/ 84 / 15 / 1 / 0.676) and each **variant = `cmalign --mapali SEED` + `cmbuild --hand`**, whose RF
is the model's own 84 match columns. Both checked to give clen 84; the script warns if any
variant's clen differs from v0's. `--mapali` appends the added sequences to the seed unchanged,
so the MATER / CaCoFold edits are kept.

```bash
cd ~/Desktop/viromelib/flaviLib
$FLAVISCRIPTS/cm_add_borderline.sh --name class1c \
  --cm "$CMSET/class1c.cm" --seed "$C1C/seed/pesti_20260917_edit.stk" \
  --tbl "$C1C/tblout/class1c_20260917.tbl" --target "$FA" \
  --workdir "$C1C/iter_v2_borderline" --cpu 4 --doc "$DOC" \
  --add ky=KY370101 --add on=ON949931 --add nc=NC_025677 --add ky_on=KY370101,ON949931
```

Five full calibrations, ~5–8 min each. The borderline spans are read from the tblout's `?` rows
that cover ≥ 85 % of the model (so OP860412, `cm 30–46`, is excluded automatically). Each
variant's log row carries: `cmstat`; included hits and accessions; against v0 —
`matched / lost / gained / lower_bits / worst_delta` (per hit in
`<variant>/search.tbl.compare.tsv`); each added sequence's own score and mean alignment PP;
and any **other** new included hit. Read them in that order of weight: **lost > 0 or a large
worst_delta rejects** the variant; an added sequence's own score proves nothing; a new hit
elsewhere is the interesting outcome, and its span should start at a stall.

Synthetic test (two seed sequences mutated ~22 %, forced to `?`): v0 reproduced class1c;
variants kept clen 84, lost 0, worst delta −0.7 to −2.0 bits, added sequences at PP 0.86.
Calibration was shortened for the test only.

#### `cm_add_borderline.sh` — mechanics

What the script does, in order. Rules marked † are choices made in the script, not Infernal
defaults; change them in the script if they do not suit.

1. **Checks.** Required arguments; input files non-empty; `cm_round_stats.py` and `cm_log.py`
   beside the script (added after a first laptop run died at the first log row because
   `cm_log.py` had not been copied); `cmalign`, `cmbuild`, `cmcalibrate`,
   `cmsearch`, `cmstat`, `esl-sfetch` on PATH; at least one `--add`. Indexes `--target` with
   `esl-sfetch --index` if there is no `.ssi`. Reads the model's clen from `cmstat`.
2. **Candidate spans.** From `--tbl` (the model's own library search) takes every row with
   inclusion `?`, plus strand, and model coverage `(mdl_to − mdl_from + 1) ≥ 0.85 × clen` †
   (`--minfrac`). Writes them as an `esl-sfetch -C` list, `subthreshold.fetchlist`
   (`TARGET/from-to from to TARGET`). For class1c that gives KY370101 361–453, ON949931
   419–499, NC_025677 252–324; OP860412 (`cm 30–46`) fails the coverage rule.
3. **v0.** `cmbuild -F -n <name>_v0` on `--seed`, no `--hand` — the way class1c was built — then
   `cmcalibrate --cpu N`, then `cmsearch --toponly --cpu N --tblout v0/search.tbl` against
   `--target`, then `cmstat`. **Search thresholds are Infernal's defaults** (report E ≤ 10,
   include E ≤ 0.01) †, not the `--incE 1e-10` used for discovery searches, so that the
   borderline hits stay visible as `?` and a variant can move them across the default line.
   Counts of `!` hits here are therefore not comparable with `--incE 1e-10` counts elsewhere.
   v0 is a fresh calibration, so its E-values (not bit scores) differ slightly from the
   September tblout; a hit near E 0.01 can change inclusion. First laptop run: v0 gave **47 `!`
   hits over 20 accessions** against the September tblout's 46 over 19 — one sub-threshold hit
   crossed the line under the new calibration (which one: see the run log).
4. **Each `--add NAME=ACC[,ACC]`.**
   - takes that accession's line(s) from `subthreshold.fetchlist` (prefix match on the
     accession; stops with an error if one is missing), `esl-sfetch -Cf` → `NAME/add.fa`;
   - `cmalign --cpu N --mapali SEED -o NAME/merged.stk CM add.fa`. `--mapali` prints the seed
     alignment unchanged with the new sequences aligned to the model and appended. **Infernal
     requires the CM to have been built from that exact seed** (it checks a checksum); with the
     `cm_set_261021` class1c and `pesti_20260917_edit.stk` this holds, since `cmbuild` on that
     seed reproduces the model's `cmstat` line;
   - `cmbuild --hand -F -n <name>_NAME` on `merged.stk`. `--hand` takes the consensus columns
     from the `#=GC RF` line that `cmalign` wrote, i.e. the model's own 84 match columns;
   - calibrate, search, `cmstat` exactly as for v0.
   - **Re-runs reuse finished builds**: a variant directory whose `search.tbl` ends in `# [ok]` and
     has `cmstat.txt` is not rebuilt or recalibrated. Delete the directory to force a rebuild.
5. **Per-variant measures**, logged as one row:
   - `cmstat`: nseq, eff_nseq, clen, bps, bifs, relative entropy;
   - `!` hits and distinct accessions (accession = target name before the first `|`);
   - **comparison with v0** (`cm_round_stats.py compare`): each `!` plus-strand hit of v0 is
     matched to the variant's `!` hit on the same target whose start is within 10 nt † (nearest
     wins, each used once). `matched`, `lost` (v0 `!` hit with no `!` partner — either gone or
     now `?`), `gained` (variant `!` hits with no v0 partner, which includes the added
     sequences themselves), `lower_bits` (matched hits whose score fell), `worst_delta`
     (largest fall, bits). Per hit: `NAME/search.tbl.compare.tsv`;
   - **each added sequence**: its own row in the variant's search (same target, start within
     10 nt †) as `bits/E/inclusion`, and its **mean posterior probability** in `merged.stk`:
     the `#=GR <name> PP` characters, `0`–`9` → digit/10 + 0.05, `*` → 0.975, averaged over
     aligned residues †. A low mean (well under ~0.8) means the model's structure was forced
     onto the sequence;
   - **other new `!` hits**: variant `!` hits that are neither a v0 `!` hit nor an added
     sequence (both within 10 nt †), printed as `ACCESSION:start`. These are the only
     non-circular gains.
6. **Consistency checks at the end.** Warns if v0's clen differs from the input model's (v0
   does not reproduce the model) or any variant's clen differs from v0's (comparison not
   column-consistent).

What it does **not** do: decide. Accept a variant only if `lost` is 0, `worst_delta` is small
relative to the hits' scores (the class1b merge's rejected case was −4.05 bits with a truncated
alignment), clen / bps / bifs equal v0's, and each added sequence aligns at high PP. Then record
the decision with `cm_log.py`. It also does not run `--incE 1e-10` or the RNAvirus database; for
an accepted variant, run `cm_iterate.sh --check-only` on it with those settings next.

Outputs, under `--workdir`: `subthreshold.fetchlist`; `v0/` and one directory per variant, each
with the `.cm`, `search.tbl`, `cmstat.txt`, `cmbuild.log`, `cmcalibrate.log`; variants also
`add.fetchlist`, `add.fa`, `merged.stk`, `cmalign.log`, `search.tbl.compare.tsv`.


#### Step 17 results, laptop run 2026-10-29

Default inclusion (E ≤ 0.01) throughout. Each new hit's start was checked against the explorer's
stall positions (feature position = stall − feature start + 1); `0` = the hit starts exactly at a
stall.

| variant | eff_nseq | `!` hits / acc. | lost | lower / 47 | worst Δ bits | added: own score, PP | other new `!` hits → stall? |
|---|---:|---|---:|---:|---:|---|---|
| v0 | 9.54 | 47 / 20 | | | | | (KY370101 361 already `!` under the fresh calibration — the 47th) |
| ky | 9.59 | 51 / 24 | 0 | 42 | −5.6 | KY370101 58.6 b, PP 0.77 | ON949931 419 → stall 10608 (0); NC_025677 252 → 21 nt after stall 12710; **BK013349 75 → stall 9018, a Class_1b site**; **MN587695 77 → stall 8912, a Class_1b site** |
| **on** | **11.06** | 51 / 24 | **0** | 29 | **−1.3** | ON949931 38.1 b, **PP 0.90** | **NC_034017 177 → stall 10511 (0)**; **NC_034204 170 → stall 10523 (0)**; **BK013349 75 → Class_1b site** |
| nc | 10.34 | 49 / 21 | **1** | 40 | −2.7 | NC_025677 28.8 b, PP 0.74 | KY370101 388 → 28 nt after stall 12807; MN587678 88 → 12 nt after stall 9958 |
| ky_on | 10.46 | 52 / 25 | 0 | 44 | −5.7 | KY 58.4 b PP 0.77; ON 35.0 b PP 0.90 | NC_034204 170 (0); NC_025677 252; BK013349 75 (1b); MN587695 77 (1b) |

Reading:

- **nc is rejected**: it loses a v0 hit (most likely KY370101 361 moving to 388, outside the
  10 nt match window), its added sequence scores only 28.8 bits inside its own seed at PP 0.74,
  and neither new hit starts at a stall.
- **`on` is the strongest variant on every criterion**: no loss, smallest damage (worst −1.3
  bits), highest PP (0.90), largest eff_nseq gain (9.54 → 11.06, so ON949931 adds real diversity),
  and its two other new hits start **exactly** on the stalls of the other two members of
  explorer cluster **fz 106** — *Xishuangbanna aedes flavivirus* NC_034017 10511 (SF 0.942) and
  *Menghai flavivirus* NC_034204 10523 (SF 0.840). Adding one FJIS sequence recovers the whole
  FJIS fz 106 cluster at stall positions, which a forced fit would not do.
- **ky** costs more (42 of 47 hits lower, worst −5.6) at PP 0.77; its non-circular gains are
  ON949931 (at its stall) and two Class_1b sites.
- **Every variant containing KY370101 or ON949931 picks up BK013349 75, and the KY variants also
  MN587695 77 — both start exactly on stalls that Class_1b already annotates.** No stall in the
  261021 tables is annotated by two models (Model co-occurrence), so these are the first
  class1c / Class_1b overlaps. Class_1b is the weak model library-wide (median E 4.0e-06), so the
  question is which model scores the span better, not just whether class1c reaches it.
- **All of this is at E ≤ 0.01.** None of it is established until it holds at `--incE 1e-10`.

**Not yet accepted.** Before deciding on `on`:

1. Do the new hits hold at the discovery threshold?
   ```bash
   B=$C1C/iter_v2_borderline
   for V in v0 on ky; do echo "== $V"
     awk '$1!~/^#/' "$B/$V/search.tbl" | grep -E 'NC_034017|NC_034204|BK013349|MN587695|ON949931|KY370101' \
       | awk '{split($1,a,"|"); print a[1], "cm "$6"-"$7, $8"-"$9, $15" bits", "E "$16, $17, ($16<=1e-10 ? "holds@1e-10" : "")}'
   done
   ```
2. **Class_1b against the same library, and every class1c hit that overlaps a Class_1b hit**
   (`cm_round_stats.py overlap`; any inclusion, plus strand, same target, overlapping spans;
   `better` = lower E-value, the rule Rfam uses between related families in a clan — raw bits
   are not comparable between models of different length and entropy):
   ```bash
   CL1B="$CMSET/CL_Class_1b_xrRNA_final.cm"; mkdir -p "$B/vs_class1b"
   cmsearch --toponly --cpu 4 --tblout "$B/vs_class1b/class1b.tbl" "$CL1B" "$FA" > /dev/null
   for V in v0 on ky; do
     python3 $FLAVISCRIPTS/cm_round_stats.py overlap "$B/$V/search.tbl" "$B/vs_class1b/class1b.tbl" \
       "class1c_$V" class1b > "$B/vs_class1b/${V}_overlap.tsv"
     echo "$V: $(tail -1 "$B/vs_class1b/${V}_overlap.tsv")"
   done
   grep -E 'BK013349|MN587695' "$B/vs_class1b/"{v0,on,ky}_overlap.tsv
   ```
   Read v0 first: it is the baseline for how much the **current** class1c already overlaps
   Class_1b (sub-threshold included). What matters is the change from v0 to `on`, and, at
   BK013349 75 and MN587695 77, which model has the lower E.
3. If `on` holds: `cm_iterate.sh --check-only` on `on/class1c_on.cm` against the library with
   `--incE 1e-10`, then the RNAvirus database. Accepting it makes class1c span Pestivirus,
   Hepacivirus and FJIS — record that as a decision, since it widens the class's definition, and
   re-derive the explorer and pool-queue rows for FJIS fz 106.

#### Merge class1b and class1c, or keep both? (2026-10-29)

The evidence so far is against **merging the models** and for **keeping both and resolving
overlaps per site**:

- The one merge attempted (hepaci hits into class1b, Sept) cost AB021287.1 18.17 → 14.12 bits and
  truncated its alignment at column 62 of 81, to gain one classification.
- In the 261021 tables no stall is annotated by both, and they co-occur in one genome only
  (MN564793), as adjacent, non-overlapping elements.
- class1c is far more specific (median E 2.0e-17 against Class_1b's 4.0e-06), so a merged model
  would inherit Class_1b's breadth and lose that.
- The 13 hepaci sequences that match Class_1b's 5′ half and fail past column ~74 suggest shared
  architecture in part of the fold, not one family.

The `on` / `ky` overlaps do not change that by themselves: class 1a, 1b and 1c are all class 1
xrRNAs, so a broadened model reaching some sites of a sibling class is expected. The standard way
to handle related families is Rfam's **clan competition** — keep both models, and where hits
overlap, assign the site to the one with the lower E-value. That needs no change to either model,
only a rule in the annotation step, and it is what `overlap` measures.

What would reopen a merge: if `on` (or any class1c variant) has the **lower E at most Class_1b
sites** it overlaps, not just at BK013349 and MN587695. Then the two models are describing one
family at different breadths, and a merged build should be tested — judged the same way as every
merge here: per-sequence bit scores of both models' existing hits, no losses, no truncation.

The original manual description follows for reference.

Build three models and compare, isolating each accession's effect. Rebuild the baseline with the
**same commands** so differences come from the sequences, not the flags.

Since step 18 is a no-op on the library (saturation, above), step 17 runs against the original
model as its baseline. The spans are known: KY370101 361–453, NC_025677 252–324, both plus strand,
both `cm 1–84`. KY370101's coincides with its unannotated stall 12807; NC_025677's does not match
a stall. Consider ON949931 419–499 as a third variant.

```bash
# step 17 -- does adding the borderline pestivirus hits improve class1c?
# paths corrected 2026-10-29 to the post-reorganisation layout
INFERNAL=~/Desktop/viromelib/flaviLib/work/infernal
SEED=$INFERNAL/build/class1c/seed/pesti_20260917_edit.stk   # 46 seqs
CM=~/Desktop/viromelib/work/infernal/cm/class1c.cm
FA=$INFERNAL/fa/flavi_library_20260228pretile20260818_TRUEordered_uniqueIDs.fa
WORK=$INFERNAL/build/class1c/iter_v2_borderline; mkdir -p "$WORK"

# the borderline hit spans come from class1c's own library scan, not from a new search
grep -v '^#' "$INFERNAL/build/class1c/tblout/class1c_20260917.tbl" \
  | awk '($1 ~ /KY370101/ || $1 ~ /NC_025677/) {print $1"/"$8"-"$9, $8, $9, $1}' \
  > "$WORK/borderline.fetchlist"
cat "$WORK/borderline.fetchlist"        # confirm one span each, and which strand

esl-sfetch -Cf "$FA" "$WORK/borderline.fetchlist" > "$WORK/borderline.fa"
cmalign --cpu 4 -o "$WORK/borderline.stk" "$CM" "$WORK/borderline.fa"
```

Then split into the three variants and build all four models identically:

```bash
esl-alimanip --seq-k <(echo KY370101...) "$WORK/borderline.stk" > "$WORK/ky.stk"    # one accession
esl-alimanip --seq-k <(echo NC_025677...) "$WORK/borderline.stk" > "$WORK/nc.stk"
for V in ky nc borderline; do
  esl-alimerge -o "$WORK/class1c_$V.stk" "$SEED" "$WORK/$V.stk"
  cmbuild --hand -F -n "class1c_$V" "$WORK/class1c_$V.cm" "$WORK/class1c_$V.stk"
done
cmbuild --hand -F -n class1c_v0 "$WORK/class1c_v0.cm" "$SEED"      # baseline, same flags
cmstat "$WORK"/class1c_v0.cm "$WORK"/class1c_ky.cm "$WORK"/class1c_nc.cm "$WORK"/class1c_borderline.cm
```

`--hand` keeps the consensus columns fixed by `#=GC RF`, so `clen`, `bps` and `bifs` should not
move; only `eff_nseq` and relative entropy should. If `clen` changes, the merge was not
column-consistent and the comparison is invalid.

**Judge on per-sequence bit scores, not hit counts.** That is what the class1b merge got wrong:
it gained one classification and lost AB021287.1 from 18.17 to 14.12 bits with the alignment
truncated at column 62 instead of 81.

```bash
for V in v0 ky nc borderline; do
  cmcalibrate --cpu 4 "$WORK/class1c_$V.cm"
  cmsearch --toponly --incE 1e-10 --cpu 4 --tblout "$WORK/$V.tbl" "$WORK/class1c_$V.cm" "$FA" > /dev/null
done
for V in ky nc borderline; do
  echo "== $V vs v0, worst per-sequence bit-score changes"
  join -j1 <(awk '$17=="!"{print $1"_"$8, $15}' "$WORK/v0.tbl" | sort) \
           <(awk '$17=="!"{print $1"_"$8, $15}' "$WORK/$V.tbl" | sort) \
    | awk '{printf "%-44s %8.2f %8.2f %+7.2f\n", $1, $2, $3, $3-$2}' | sort -k4,4g | head -5
  echo "   accessions recovered: $(awk '$17=="!"{print $1}' "$WORK/$V.tbl" | cut -d'|' -f1 | sort -u | wc -l)"
done
```

Accept a variant only if no existing hit loses bit score. Three outcomes are informative: both
help, one helps and the other does not (include only that one), or either costs coverage — in
which case the borderline calls stay out and those accessions belong in the unmatched pool.

**KY370101's unannotated stalls are a separate question from its borderline class1c hit.** The
borderline hit is at whatever span the class1c scan reported; the unannotated stalls are at 12807
and 13029, downstream of the Class_1b element at 12621. Check whether the borderline span
coincides with either before assuming they are the same feature.

### class1c is a mixed-genus class

Source: `260914-260917_cm_expansion.md` §677 ff.

`pesti_short1b.cm` was built from 22 hand-edited **Pestivirus** sequences. Its library-wide search
pulled **Hepacivirus** hits (MN587xxx, MN564793, OM203121, BK067807); those were fetched with
`esl-sfetch`, re-aligned with `cmalign`, and became part of the 46-sequence set that went through
CaCoFold refinement as `pesti_20260917_edit.stk` → `class1c`. **So class1c has Hepacivirus
sequences as actual seed members** — a mixed-genus class, not a pestivirus CM. This belongs in the
methods.

### Known uncovered

| set | n | where |
|---|---:|---|
| Hepacivirus unclassified after class1b **and** class1c | 9 | BK013349, MG599987, MG599989, MN535729, MN691105, MZ393517, NC_028377, NC_038432, OX394189 (9, not 8; source lists OX394189) |
| dropped from the class1b merge by the bit-score ≥ 25 cutoff | 9 | listed below; MN564793 is also a class1c seed member |
| Pestivirus trimmed from the original 30 → 22 during pseudoknot inspection, never revisited | 8 | `flaviLib_20260914/candidate_short1b/by_genus/pesti_mlocarna/results/result-dedup.stk` |
| 13 hepaci hits that never got confidently into class1b | 13 | see below |
| PLLG not covered by `cand_PLLG_260915` | 36 of 60 | never aligned separately |
| Orthoflavivirus vsearch clusters never examined | 29 of 30 | `flaviLib_20260917/.../orthoflavi/orthoflavi_cluster_*` |
| Accessions with no CM hit on any row, 7 models, 261021 10 mM | 242 of 439 | `find_downstream_unannotated_stalls.py` |

**The accounting gap is flagged in the source document and still open**: everything tracked as
"hepaci" went through narrowing filters at each step, and the full original pool was never counted
against what is now covered.

The three hepaci tiers are separately derived and **may overlap** — the 8 came from comparing
`genus_check/*_accessions_noversion.txt` against `all_1b_1c_noversion.txt`, the 9 from the
confident-ID lists, and the 13 are what survived into `class1b_v3`. A sequence can appear in more
than one. Closing the gap means one comparison over the original genus pool, not three partial ones.

### The class1b merge attempt, and why it stopped

Source: `260914-260917_cm_expansion.md` §§62–333 (formerly `class1b_expansion.md`).

Lineage: the `genus_fastas` pool (all `n_reps_passing` 4 rows with no CM hit, split by genus) →
mlocarna on `Hepacivirus.fasta` → hand-edited Stockholm → `hepaci_unclas.cm` → library-wide
`cmsearch` → **59 confident hits** (filter `$10=="+" && $17=="!" && ($7-$6)>=70`, i.e. Infernal's
own E ≤ 0.01 plus ≥70 of the 82 model columns, to drop single-stem fragments) → `cd-hit-est -c 0.98`
→ 55 → `hepaci_hits_v2.cm` (55 / eff_nseq 19.93 / clen 78 / 18 bp / 1 bif). Content was mostly
rodent pestiviruses and rodent hepaciviruses, which is why merging into class1b looked plausible.

**The merge cost more than it gained.** Forcing the 55 against `class1b.cm` and taking bit score
≥ 15 gave 22 sequences; merging those via `esl-alimerge` (both inputs carrying `#=GC RF` from the
same CM's match-column definition, so the merge is column-consistent) produced `class1b_v2`. That
merge caused a confirmed loss of full-model coverage for **AB021287.1: 18.17 → 14.12 bits, alignment
truncated at cm column 62 instead of 81**, in exchange for gaining **one** new classification
(`KC796073.1`).

A stricter rebuild at bit score ≥ 25 (`class1b_v3`) cut the set from 22 to **13**, so **nine** were
dropped, not the "roughly seven" the source document lists. Counted 2026-10-27 from
`archive/flaviLib_20260914/cm_compare/confident_ids.txt` against `confident_ids_v2.txt`:

```
MG600414.1|8656-8928_inferred_3UTR/73-148
MN564789.1|8602-8905_inferred_3UTR/89-172
MN564793.1|9364-9853_inferred_3UTR/203-267
NC_021154.1|10804-11279_3UTR/18-74
NC_030291.1|9367-9630_3UTR/7-73
OM030327.1|8864-9111_inferred_3UTR/77-149
OM451124.1|8662-8941_inferred_3UTR/73-146
OM480528.1|8720-8998_inferred_3UTR/73-150
ON391060.1|8737-8963_3UTR/23-96
```

The document's list omits **MN564793** and **OM030327**.

**MN564793 connects the two lineages.** It is one of the Hepacivirus accessions that
`pesti_short1b.cm`'s library search pulled in and that became a **class1c seed member** — so it was
dropped from the class1b merge for weakening that model, then entered class1c by the other route.
Worth checking whether any of the other eight did the same.

**13 hits were never resolved.** They show a real, consistent partial match to class 1b's
N-terminal/mid region and fail past about column 74. Padding tests extended one hit
(`NC_040815.1|8469-8684_3UTR`) by +40 and +80 nt to see whether the model extends its match given
more sequence, rather than being cut off. The structural information is real but the class 1b
pairing scheme may be wrong for whatever follows column ~74, so neither keeping the forced
alignment nor discarding the hits is right. This is what led to pooling the pegi/pesti candidates
and letting mlocarna find the structure from scratch — which produced class1c.

### Limits of the current annotation

- **class4 has zero hits across all 439 flaviLib accessions.** Derived from viromelib; no
  Flaviviridae member in this library carries it.
- **36 % of CM hits are tile-truncated** (1,669 of 4,699 at 10 mM): Class_2 47 %, class1c 43 %,
  Class_1a 40 %, Class_1b 35 %, cl3 26 %, dumbbell 23 %, max 77 nt. The annotation itself comes
  from `$TBLOUT`, a full-reference search, so it is unaffected; anything cut from a tile is not.
- **Hit ends run past the 80 nt `downstream_seq` window**: median `_end` 75–82, p90 ~100, max 143.
  Any discovery window taken from that column truncates the longer elements.
- **The 9 `not_assayed` accessions cannot contribute to any pool** (8 Orthohepacivirus + 1
  Guaicovirus, flaviLib run log step 13c), since cluster FASTAs come from windows around *called*
  stalls. For HCV this is permanent: 43–84 nt homopolymer in the 3′UTR, oligos recovered ~1,000×
  low.

## Clade assignment — a separate axis from CM coverage

Source: `260915_pllg_analysis.md` §§0, 1, 6.

These are different questions and the counts are not comparable. **Clade assignment** is whether a
virus has a Mifsud/Simmonds label at all; **CM coverage** is whether its stall has a structural
annotation. A virus can lack either independently.

Source: `Mifsud_2024_Supplementary_table_1_EDIT_NO3UTRseqs.xlsx`, sheets `Metadata` (→
`{base_accession: (tree_tip_label, clade, virus_taxa)}`) and `Clade Acronym Definitions`. Built by
`build_pllg_outputs.py`, which joins on **GenBank accession with the version stripped**
(`NC_024077.1` → `NC_024077`) — the only field spelled consistently in both sources, since
genus/species formatting differs between the two pipelines. Verified to reproduce its CSV and FASTA
outputs byte-for-byte.

Two scopes, not a discrepancy:

| scope | total | clade-matched | unmatched |
|---|---:|---:|---:|
| rows with `genus` or `family` = Unannotated | 116 | **101** | **15** |
| all library accessions | 439 | **409** | **30** |

The 116 "Unannotated" accessions resolve into **nine** Mifsud clades — FJAF, FJFL, FJIS, FJJI,
FJMB, FJUN, HPPV, PLLG, PLUN. So `Unannotated.fasta` was never one group, which is the direct
argument for grouping by clade code: the source document's own warning is that "lumping e.g.
insect-specific orthoflaviviruses (FJIS) with LGFs (PLLG) in one alignment will hurt
mlocarna/Infernal signal."

Unmatched rows are flagged `NOT IN MIFSUD (novel/Simmonds-only accession)` in
`unclassified_genus_with_mifsud_clade.csv` rather than dropped. They are *unassigned*, not
misassigned.

Route recorded for a library-pruned tree: pull the Mifsud NS5b amino-acid alignment (not the 3′UTR —
accessions without a 3′UTR are already excluded, a different filter from the RdRp alignment), prune
to the 409, add the 30 with `mafft --add --keeplength` or `hmmalign`, re-infer with IQ-TREE or
FastTree, re-attach clade acronyms manually and flag added tips as "added" since they were not part
of the bootstrap-supported topology. Only "correct clade neighborhood" is needed for the CM layer,
not sub-species branch order.

## Not candidates

| set | why not |
|---|---|
| KY370101 + NC_025677 | share `AAGCGACTCGCA(C/T)CACC`, `GGGAGTGACGCCCC`, `GTTCAT` with each other only. Two sequences. Also the two borderline class1c pestivirus hits left undecided in the Sept doc |
| NC_027817, NC_001655, NC_020902, KY370100 | fell in the `cand_FJTB_261026` positional band but share no sequence with it |
| Pegivirus | 16 candidates, single weak stem-loop (−3.56). Underpowered, not structureless. The original pool was 27 before cd-hit-est at 90 % collapsed it to 16 — worth re-running at 0.95 to preserve sequences for covariance detection |
| PLLG clusters D, E | 2 sequences each |

---

## Live workflow: pools without a CM

Added 2026-10-29. One procedure for every Mifsud clade and genus pool that has no CM, with each
step either logging itself (`cm_iterate.sh`) or logged by one `cm_log.py` line. The pool queue
below is the hand-maintained summary; the run-log tables are the record.

### Pool queue

Distinct sites, 10 mM, deduplicated on accession + genomic position, counted against the **7**
models of `cm_set_261021` (2026-10-28 table). Ordered by distinct species, the recorded criterion.
`—` = not done.

| pool | sites | acc. | spp. | median SF | existing work | pool FASTA | clustered | alifold | CM | library | RNAvirusDB |
|---|---:|---:|---:|---:|---|---|---|---|---|---|---|
| **PLLG** | 66 | 35 | 18 | 0.421 | `cand_PLLG_260915` covers clusters A/B/C; exclude its hits first | — | — | — | — | — | _(running 10-27)_ |
| **HPPV** | 40 | 21 | 17 | 0.567 | Sept genus pool set aside at −3.56, built from `downstream_seq` | — | explorer fz 39 (4 rodent pegiviruses); FASTA 4/4 | — | — | — | — |
| **FJIS** | 34 | 20 | 14 | 0.620 | none. Dereplicate *Quang Binh virus* (4 accessions). fz 106 has a sub-threshold class1c match (ON949931) | — | explorer fz 5 (5), fz 106 (3); FASTA fz 106 3/3, fz 5 re-fetch | — | — | — | — |
| **FJJI** | 57 | 50 | 13 | 0.549 | none; Jingmenvirus genus has no CM coverage at all. Spread 181 nt | — | explorer fz 41 (12), fz 44 (8); FASTA fz 44 8/8, fz 41 re-fetch | — | — | — | — |
| **HPHV** | 34 | 24 | 12 | 0.595 | `hepaci_unclas` rejected; part of `class1c` seed | — | — | — | — | — | — |
| FJMB | 17 | 12 | 11 | 0.409 | none | — | — | — | — | — | — |
| not in Mifsud | 29 | 15 | 11 | 0.408 | none; no clade, so use `--group-by genus` | — | — | — | — | — | — |
| PLPV | 15 | 9 | 8 | 0.671 | `class1c`; KY370101 / NC_025677 = step 17 | — | — | — | — | — | — |
| FJTB | 17 | 8 | 7 | 0.438 | `cand_FJTB_261026`; exclude its hits first | — | — | — | — | — | _(running 10-27)_ |
| FJAF | 9 | 6 | 6 | 0.703 | none | — | — | — | — | — | — |
| FJUN | 7 | 3 | 3 | 0.424 | none | — | — | — | — | — | — |
| FJNV, FJFL | 1 each | | | | below `--min-sites` | | | | | | |

PLUN, HPUN and TOMB have no unannotated passing sites in the 2026-10-28 table.

The `clustered` entries come from the flavi150 explorer's frozen clusters (next section). Clade is
inferred there from species, pending the `mifsud_clade_lut.tsv` join.

### Seeds from the flavi150 explorer, 2026-10-29

`~/Desktop/viromelib/flaviLib/figures/clustering/flavi150_explorer.html` (built by `build_flavi150_explorer.py` from
`cluster_flaviLib_150x150.R`) holds 416 deduplicated pooled sites (01mM + 10mM), LocARNA
similarity edges, and the frozen clusters of 2026-10-28 (cut at 0.55, component 1 recut at 0.57).
**Its `cls` field is the superseded 4-model annotation** (1a, 1b, 2, dumbbell): 208 nodes are
"None found". Of the three models missing from it, what to expect in those 208:

- **class1c**: 45 nodes (scan below).
- **cl4_v9: none.** class4 has zero hits across all 439 flaviLib accessions ("Limits of the
  current annotation"); it is viromelib-derived.
- **cl3: few** — 10–11 well-powered sites at 10 mM in the 261021 table; **3 explorer nodes, all
  *Loquat jingmen-related virus 1*** (scanned 2026-10-29, below). *Loquat jingmen-related virus 1*
  was expected to be class 3: its three sites form their own frozen cluster, **fz 110** — OL344024 3003 (SF 0.514),
  OL344026 2862 (0.610), OL344028 1907 (0.511), one per segment accession, all 10 mM only, genus
  Unannotated, "None found" under the 4 models. If cl3 hits them, fz 110 leaves the no-hit pool and
  becomes a class 3 data point for a jingmen-related plant virus; if it does not, it is a
  candidate for expanding cl3 rather than a new class. Check the 261021 `cl3….cm_hit` column for
  these three accessions as well — the reference search is not limited by the 80 nt window.

**cl3 against the explorer nodes, 2026-10-29 (JG, laptop, `cm_set_261021` model): the
expectation holds.** cl3 hits all three loquat sites and nothing else at ≥ 10 bits:

| node | stall | SF | cl3 bits | model cols | window span | trunc |
|---|---:|---:|---:|---|---|---|
| OL344028.1 `1844-2216` | 1907 | 0.511 | 36.8 | 1–52 | 1–46 | no |
| OL344024.1 `2940-3323` | 3003 | 0.514 | 34.2 | 1–52 | 1–45 | no |
| OL344026.1 `2803-3193` | 2862 | 0.610 | 26.0 | 3–52 | 1–46 | 5′ |

- **fz 110 is class 3, not a new class.** It leaves the no-hit pool. One cl3 site per segment
  accession, each at the stall (window position 1), so the element is repeated across segments.
- **The 30-bit call cut does not apply to cl3.** It was read off the class1c score gap. cl3's gap is
  26.0 → nothing ≥ 10, so all three are cl3; `annotate` labelled OL344026 `sub` only because of the
  default `--call-bits 30`. Use `--call-bits 20` for cl3.
- OL344026's 5′ truncation (`cm 3–52`) means the window starts 2 model columns into the element,
  consistent with cl3's `_start` median −1 relative to the stall.
- **Open:** whether 52 columns is the whole cl3 model or a partial match — run
  `cmstat "$CL3"` for its clen. And the 261021 table carries 10–11 cl3 sites at 10 mM against 3
  here: check which accessions those are (`cl3….cm_hit` notna) — the explorer's pooled
  deduplication, or the 80 nt windows, may account for the difference.
- So loquat is the first jingmen-related (plant-host) member with a class 3 call in this library,
  and the three segment copies are seed material if cl3 is ever expanded.

**class1c against all 416 node sequences** (`cmsearch --toponly -T 10`, model rebuilt from
`pesti_20260917_edit.stk`, identical `cmstat`; bit scores, since E-values on 416 short windows are
not comparable with the library search):

- **45 nodes at 37–73 bits, all "None found"** — the class1c seed sites. So 45 of the 208 are
  class1c, and **163 "None found" nodes remain** (Orthoflavivirus 46, Unannotated 34, Jingmenvirus
  29, Pegivirus 22, Hepacivirus 21, Pestivirus 11).
- Frozen **fz 137** (19 nodes, Pangolin pestiviruses) is entirely class1c. **fz 130** is 8 class1c +
  7 Class_1b + 1 none. **fz 131** is 48 Class_1b + 10 class1c + 11 none, and holds KY370101 12807
  and NC_025677 12710. The LocARNA clustering does not separate class1b from class1c, so cluster
  membership is not evidence for either in step 17.
- Below 30 bits: MN587659 10202 (20.9, `cm 1–34`, 3′-truncated by the 80 nt window),
  **ON949931 10608 (13.3, `cm 1–84`)**, KY370101 12807 (13.1, `cm 9–53` — partial in the
  80 nt window, full-length on the reference), NC_025677 12710 (10.2, `cm 31–46`).
- **ON949931's sub-threshold class1c span begins exactly at its stall 10608** (SF 0.900), the same
  geometry as KY370101. Its cluster **fz 106** is three FJIS sites, all high SF: *Xishuangbanna
  aedes flavivirus* NC_034017 10511 (0.942), *Menghai flavivirus* NC_034204 10523 (0.840),
  *Kilpisjarvi flavivirus* ON949931 10608 (0.900). Neither of the other two scores ≥ 10 bits.
  So fz 106 is an FJIS element with weak class1c resemblance in one member — a candidate of its
  own first, and a class1c relative only if the FJIS model and class1c score each other's seeds.

Node table with the class1c call: `explorer_nodes_class1c_20261029.tsv`.

**No-hit frozen clusters by inferred subclade** (≥ 3 nodes; 80 nt windows, so re-extract from the
reference before aligning):

| fz | n | inferred clade | members | SF | detected | note |
|---|---:|---|---|---|---|---|
| 41 | 12 | FJJI | Jingmen tick virus ×7, Takachi, Heilongjiang tick, Alongshan, Yanggou tick | 0.55–0.86 | 10 mM only | stall 2493–2672 |
| 44 | 8 | FJJI | Jingmen tick virus ×6, Rhipicephalus assoc. flavi-like | 0.50–0.65 | mostly both | stall 2448–2563; different segment accessions from fz 41 — align 41 + 44 together once, to test one element across segments |
| 3 | 8 | FJTB | TBEV serocomplex | 0.51–0.70 | 1 mM only | = `cand_FJTB_261026` |
| 5 | 5 | FJIS | Culex flavivirus, Quang Binh, Mosquito flavivirus ×2, Nienokoue | 0.69–0.90 | 10 mM only | |
| 39 | 4 | HPPV | rodent pegiviruses | 0.73–0.84 | 10 mM only | |
| 106 | 3 | FJIS | NC_034017, NC_034204, ON949931 | 0.84–0.94 | both | sub-threshold class1c in ON949931 |
| 110 | 3 | FJJI-related (plant host) | *Loquat jingmen-related virus 1*, one site per segment | 0.51–0.61 | 10 mM only | **class 3** — cl3 26.0–36.8 bits on all three (2026-10-29); out of the no-hit pool |
| 64, 117 | 3 each | — | | | | not yet looked at |

**How the cluster sequences were extracted** (full detail and commands: Methods M3 and the
Regenerate / Aligning blocks):

1. `explorer_cm_scan.py extract` parses the explorer's embedded `const DATA = {...};` line as JSON.
   Each node gives the feature ID, the stall (genomic, after the last `|` of the node ID) and the
   frozen cluster `fz`.
2. `explorer_cm_scan.py fetch OUTDIR <fz> <name> --ref $FA` takes every node with that `fz` and
   converts the stall to a 1-based position in the feature, `stall − feature_start + 1`, the same
   convention under which class1c's hit starts fall on ON949931's and KY370101's stalls. The
   window is −20 / +150 nt, clipped to the feature's real length from the reference (the
   records are `end − start` long; clipping to `end − start + 1` made two fetches fail on the
   first run). Output: one `esl-sfetch -C` line per site, `FEATURE/from-to from to FEATURE`.
3. `esl-sfetch -Cf $FA <name>.fetchlist > <name>.fa` cuts the windows from the reference
   (`flavi_library_20260228pretile20260818_TRUEordered_uniqueIDs.fa`), so sequences are not
   limited to the 80 nt `downstream_seq` the explorer holds.
4. In the Aligning block each candidate's seed FASTA is one cluster's `.fa`, or two concatenated
   for the pooled runs.

Results of the laptop run: fz 41 12/12, fz 44 8/8, fz 5 5/5, fz 106 3/3, fz 39 4/4, fz 110 3/3
(fz 41 and fz 5 after the `--ref` fix). Files in
`build/class1c/explorer_scan_261029/<name>.{fetchlist,fa}`.

### Methods for the 2026-10-29 checks

How the class1c saturation, lineage and explorer results above were obtained, so they can be
re-run or challenged. All on Infernal 1.1.5. The ad hoc Python used on the day was rewritten as
`seed_vs_hits.py` and `explorer_cm_scan.py` and re-run; both reproduce the recorded numbers, and
the fetch lists are byte-identical.

**Inputs**

| file | where it came from |
|---|---|
| `pesti_20260917_edit.stk` | class1c seed, from the class1c archive (`build/class1c/seed/`) |
| `class1c_20260917.tbl` | class1c library search, 2026-09-17 (`build/class1c/tblout/`). Default `--incE`, both strands, no `--toponly` |
| `pesti_short1b.tbl` | `archive/flaviLib_20260914/tblout/`, 2026-09-15, same settings, query `pesti_short1b.cm` |
| `flavi150_explorer.html` | `~/Desktop/viromelib/flaviLib/figures/clustering/`, built by `build_flavi150_explorer.py` |
| `class1c.cm` | **rebuilt**, not the copy in `cm/`: `cmbuild -F -n class1c` on the seed, then `cmcalibrate --cpu 2` (7 min 22 s). `cmstat` identical to `cm_set_261021/class1c.cm` (46 / 9.54 / 84 / 122 / 15 / 1 / 0.676 / 0.521). md5 of the rebuild `7e94ee7c…`; the md5 was **not** compared with `cm/class1c.cm`, and calibration is stochastic, so E-values can differ slightly from the set model. Bit scores do not depend on calibration — confirmed: a run with a 0.04 Mb test calibration gave identical bit scores for all hits |

**M1 — saturation: is class1c's library search more than its seed?**

```bash
python3 $FLAVISCRIPTS/seed_vs_hits.py build/class1c/seed/pesti_20260917_edit.stk \
    build/class1c/tblout/class1c_20260917.tbl
```

A hit matches a seed sequence when the accession is the same and the hit start is within 5 nt of
the seed sequence's start. Seed names carry their coordinates (`MN587651_1_9712-10198_inferred_3UTR_177-254`);
the accession is parsed as `<ID>_<version>` before the feature coordinates, so underscores in
`NC_` accessions are kept (a first parse that split on the first `_` mis-read `NC_023176_1` as
`NC.023176`; corrected).

Result: 46 included plus-strand hits over 19 accessions; all 46 match a seed sequence (32 with
identical coordinates, the rest within 5 nt); 0 hits outside the seed; 0 seed sequences unmatched.
4 sub-threshold rows (KY370101, ON949931, NC_025677, OP860412). Weakest included E 3.4e-11.
Also checked: `cmbuild` on the seed reproduces `cmstat` exactly, so this seed is the model's.

Genomic span of a sub-threshold hit = feature start + feature position − 1 (the convention under
"Coordinate and column conventions"). KY370101 361–453 in `12448-13220` → 12808–12900, against
its stall 12807 from the 261021 table.

**M2 — lineage: where did the seed come from?**

```bash
python3 $FLAVISCRIPTS/seed_vs_hits.py build/class1c/seed/pesti_20260917_edit.stk \
    archive/flaviLib_20260914/tblout/pesti_short1b.tbl build/class1c/tblout/class1c_20260917.tbl
```

Result: `pesti_short1b`'s 46 included hits match the 46 seed sequences with **identical
coordinates (46 of 46)**, so the seed is exactly the `esl-sfetch -Cf` + `cmalign` of that search
(lineage steps 3–4). Bit scores of the same 46 spans, `pesti_short1b` → class1c: 25 higher,
20 lower, 1 unchanged; largest drop ON024101 385 (−7.5). Weakest included E 1.1e-06 → 3.4e-11.
Sub-threshold KY370101, NC_025677, ON949931 were `cm 29–46`, `28–46`, `11–46` under
`pesti_short1b` and `cm 1–84` under class1c.

Not determinable from these files: whether all 22 hand-edited pestivirus sequences that built
`pesti_short1b` are among the 46. Check against the names in `result-dedup-pesti_mlocarna_edit.stk`.

**M3 — class1c across the explorer's sites**

```bash
S=$FLAVISCRIPTS/explorer_cm_scan.py; X=$INFERNAL/build/class1c/explorer_scan_261029
python3 $S extract ~/Desktop/viromelib/flaviLib/figures/clustering/flavi150_explorer.html $X
cmsearch --toponly -T 10 --tblout $X/class1c.tbl class1c.cm $X/nodes.fa > /dev/null
python3 $S annotate $X $X/class1c.tbl class1c            # --call-bits 30
while read -r fz name; do                                 # zsh does not split "$c"; read does
  python3 $S fetch $X "$fz" "$name" --ref "$FA"          # stall -20 .. +150, clipped
done <<'EOF'
41 FJJI_fz41
44 FJJI_fz44
5 FJIS_fz5
106 FJIS_fz106
39 HPPV_fz39
EOF
```

- **Data source.** The explorer embeds its data as one JavaScript line, `const DATA = {...};`,
  which `extract` parses as JSON: 416 nodes (deduplicated pooled 01mM + 10mM sites; fields `id` =
  `FEATURE|stall`, `sp`, `genus`, `cls`, `sf`, `det`, `fz` = frozen cluster, `seq`) and 15,576
  LocARNA edges (unused here). Nothing is read from the rendered page.
- **The explorer's `cls` is the 4-model annotation**: values are only 1a (78), 1b (106), 2 (17),
  dumbbell (7) and "None found" (208). So "None found" there is not "no CM in `cm_set_261021`".
- **Search target.** Each node's `seq`, i.e. `downstream_seq`: 41–80 nt, 375 of 416 exactly 80
  (the cap). Hits longer than the window are cut — MN587659 10202 (`cm 1–34`, 3′ truncated) and
  KY370101 12807 (`cm 9–53` here, `cm 1–84` on the reference). Absence of a hit in a node is
  therefore weaker evidence than absence in the reference search.
- **Threshold.** `-T 10` reports every hit ≥ 10 bits; a node is called class1c at ≥ 30 bits.
  The 30 is read off the data, not a standard: the scores split into 37.6–72.8 (45 nodes) and
  ≤ 20.9 (4 nodes) with nothing between. E-values are not used — with 416 × ≤ 80 nt as the
  database they are not comparable with the library search.
- **Per node**, the best plus-strand hit is kept (`--toponly` already excludes the minus strand).
- **Cluster composition** counts each frozen cluster's nodes by `cls`, replacing `cls` with
  `class1c` for called nodes. Distinct species from `sp`.
- **Clade labels are inferred from species names** (Jingmen tick virus and relatives → FJJI,
  mosquito / insect-specific flaviviruses → FJIS, rodent pegiviruses → HPPV, TBEV serocomplex →
  FJTB), not from the Mifsud join. Replace with `mifsud_clade_lut.tsv` before any count goes
  outside this document.
- **Fetch lists.** Stall position in the feature = stall − feature start + 1; window −20 / +150,
  clipped to the feature length. First run clipped at end − start + 1 from the ID and two
  fetches failed (`Subsequence end 263 is greater than length 262`, `720 … 719`): **the reference
  records are end − start long**, one shorter than an inclusive range. `fetch --ref "$FA"` now
  reads lengths from the reference (fallback end − start). Stall → position mapping is unaffected;
  it is the one that puts class1c's hit start on ON949931's and KY370101's stalls.

Observations, with the step that produced each:

| obs. | from |
|---|---|
| 45 nodes ≥ 30 bits, all "None found", all class1c seed sites; 163 "None found" remain | `annotate` |
| fz 137 all class1c; fz 130 8 class1c / 7 Class_1b / 1 none; fz 131 48 Class_1b / 10 class1c / 11 none | `annotate`, cluster composition |
| ON949931 10608: 13.3 bits, `cm 1–84`, node = stall 10608, SF 0.900, fz 106 | `annotate`, weaker hits; node `id` |
| fz 106 = NC_034017 10511 (0.942), NC_034204 10523 (0.840), ON949931 10608 (0.900); the other two < 10 bits | node listing by `fz` |
| no-hit clusters fz 41, 44, 3, 5, 39, 106, 64, 110, 117 and their members, SF, detection | node listing by `fz` |
| fz 41 and fz 44 are different Jingmen tick virus segment accessions at stalls 2493–2672 and 2448–2563 | node `id`s; segment identity from the accessions, not checked against GenBank |
| fz 110 = *Loquat jingmen-related virus 1*, OL344024 / 026 / 028, self-clustering; expected class 3 | node listing by species; expectation from JG |
| fz 110 is class 3: cl3 36.8 / 34.2 / 26.0 bits, `cm 1–52` (3–52), at the stall; no other node ≥ 10 bits | `annotate` with the cl3 tblout (laptop run) |
| class1c scan with the `cm_set_261021` model is identical to the rebuilt-model scan | laptop run |

#### Regenerate

Laptop paths. `DOC`, `EXPLORER` and the cl3 model confirmed on disk 2026-10-29. The explorer block stops if the file is missing. The set models are used directly
(already calibrated), so this also removes the rebuilt-model md5 caveat above.

```bash
conda activate viromelib
FLAVISCRIPTS=~/Desktop/viromelib/flaviLib/scripts
INFERNAL=~/Desktop/viromelib/flaviLib/work/infernal
CMSET=~/Desktop/viromelib/work/infernal/cm/cm_set_261021
DOC=~/Desktop/viromelib/flaviLib/workflows/CM_CANDIDATES.md
EXPLORER=~/Desktop/viromelib/flaviLib/figures/clustering/flavi150_explorer.html
FA=$INFERNAL/fa/flavi_library_20260228pretile20260818_TRUEordered_uniqueIDs.fa
C1C=$INFERNAL/build/class1c
X=$C1C/explorer_scan_261029

# M1 + M2: seed vs library hits, pesti_short1b -> class1c
python3 $FLAVISCRIPTS/seed_vs_hits.py "$C1C/seed/pesti_20260917_edit.stk" \
    $INFERNAL/archive/flaviLib_20260914/tblout/pesti_short1b.tbl \
    "$C1C/tblout/class1c_20260917.tbl" | tee "$C1C/seed_vs_hits_261029.txt"

# M3: explorer data out of the HTML -- stop here if the file is not found
[ -s "$EXPLORER" ] || { echo "EXPLORER not found: $EXPLORER"; find ~/Desktop/viromelib -name flavi150_explorer.html; }
[ -s "$EXPLORER" ] && python3 $FLAVISCRIPTS/explorer_cm_scan.py extract "$EXPLORER" "$X"

# M3: class1c, and cl3 (loquat, fz 110), against the explorer's windows
cmsearch --toponly -T 10 --cpu 4 --tblout "$X/class1c.tbl" "$CMSET/class1c.cm" "$X/nodes.fa" > /dev/null
cmsearch --toponly -T 10 --cpu 4 --tblout "$X/cl3.tbl" "$CMSET/cl3_NAR_2025.align.mpkadded.edited.confident.dedup.IDcurated.SS_cons.cm" "$X/nodes.fa" > /dev/null
python3 $FLAVISCRIPTS/explorer_cm_scan.py annotate "$X" "$X/class1c.tbl" class1c | tee "$X/class1c_summary.txt"
python3 $FLAVISCRIPTS/explorer_cm_scan.py annotate "$X" "$X/cl3.tbl" cl3 | tee "$X/cl3_summary.txt"
grep -E 'OL3440(24|26|28)' "$X/nodes_cl3.tsv"          # the loquat sites

# M3: fetch lists for the no-hit clusters, then windows from the reference
# zsh (the macOS default) does not word-split an unquoted "$c", so a `for c in "41 FJJI_fz41"`
# loop passes one argument and fetch fails ("required: name") -- seen 2026-10-29. Use read:
while read -r fz name; do
  python3 $FLAVISCRIPTS/explorer_cm_scan.py fetch "$X" "$fz" "$name" --ref "$FA"
done <<'EOF'
41 FJJI_fz41
44 FJJI_fz44
5 FJIS_fz5
106 FJIS_fz106
39 HPPV_fz39
110 loquat_fz110
EOF
[ -f "$FA.ssi" ] || esl-sfetch --index "$FA"
for L in FJJI_fz41 FJJI_fz44 FJIS_fz5 FJIS_fz106 HPPV_fz39 loquat_fz110; do
  [ -s "$X/$L.fetchlist" ] || { echo "$L: no fetchlist"; continue; }
  esl-sfetch -Cf "$FA" "$X/$L.fetchlist" > "$X/$L.fa"; echo "$L $(grep -c '^>' "$X/$L.fa")"
done                                                     # expect 12 8 5 3 4 3

# record
python3 $FLAVISCRIPTS/cm_log.py "$DOC" --model class1c --step "explorer rescan with cm_set_261021 models" \
    --result "<n class1c nodes>; cl3: <n nodes>, loquat fz 110 <hit / no hit>"
```

`annotate` calls a node at ≥ 30 bits by default (`--call-bits`); that cut was read off the class1c
scores. For cl3 use `--call-bits 20` (gap 26.0 → < 10, 2026-10-29).

#### Aligning the no-CM explorer clusters (step 3 of the procedure)

Re-fetch the two that failed (fz 41 returned 1 of 12, fz 5 0 of 5), then align. Candidates by
clade and date; the frozen cluster index goes in the first log row as provenance. FJJI fz 41 +
fz 44 and FJIS fz 5 + fz 106 are also aligned pooled, to test one element across segments
(FJJI) and across the two FJIS groups. fz 110 (loquat) is class 3 and is not aligned here.

```bash
for L in FJJI_fz41 FJIS_fz5; do
  python3 $FLAVISCRIPTS/explorer_cm_scan.py fetch "$X" "${L##*_fz}" "$L" --ref "$FA"
  esl-sfetch -Cf "$FA" "$X/$L.fetchlist" > "$X/$L.fa"; echo "$L $(grep -c '^>' "$X/$L.fa")"
done                                                     # expect 12, 5

while read -r C SRC; do
  B=$INFERNAL/build/$C; mkdir -p "$B/seed" "$B/iter_v1"
  : > "$B/seed/$C.fa"
  for L in $(echo "$SRC" | tr , ' '); do cat "$X/$L.fa" >> "$B/seed/$C.fa"; done
  n=$(grep -c '^>' "$B/seed/$C.fa")
  mlocarna --stockholm --consensus-structure=alifold --probabilistic --consistency-transformation \
    --tgtdir "$B/iter_v1/mlocarna" "$B/seed/$C.fa" > "$B/iter_v1/mlocarna.log" 2>&1 \
    || { echo "$C: mlocarna failed, see $B/iter_v1/mlocarna.log"; continue; }
  python3 $FLAVISCRIPTS/dedup_stockholm.py "$B/iter_v1/mlocarna/results/result.stk" \
    "$B/iter_v1/mlocarna/results/result-dedup.stk"
  ALI=$(grep -E '^alifold' "$B/iter_v1/mlocarna.log" | tail -1 | sed -E 's/^alifold[[:space:]]+//')
  echo "$C ($n seqs): ${ALI:-no alifold line}"
  python3 $FLAVISCRIPTS/cm_log.py "$DOC" --model "$C" \
    --step "mlocarna --probabilistic --consistency-transformation, $n seqs from explorer $SRC (stall -20/+150 from the reference)" \
    --result "alifold ${ALI:-not found in log}"
done <<'EOF'
cand_FJJI_fz41_261029 FJJI_fz41
cand_FJJI_fz44_261029 FJJI_fz44
cand_FJJI_261029 FJJI_fz41,FJJI_fz44
cand_FJIS_fz5_261029 FJIS_fz5
cand_FJIS_fz106_261029 FJIS_fz106
cand_FJIS_261029 FJIS_fz5,FJIS_fz106
cand_HPPV_fz39_261029 HPPV_fz39
EOF
```

GATE 1 is read from the logged alifold line: the **covariance term** (last number) decides, as
for pegivirus (−1.55, set aside) against hepaci (−9.95) and clusterA (−12.63). If the line is not
found in `mlocarna.log`, take it from mlocarna's terminal output by hand; the format differs
between versions (one of the recorded `build_candidate_cm.sh` defects). fz 106 (3 sequences) and
fz 39 (4) are small for covariation; read their pooled runs first. Then the manual MATER /
CaCoFold step (procedure step 4) on whichever pass.

### Procedure

```bash
conda activate viromelib
VIR_INF=~/Desktop/viromelib/work/infernal
INFERNAL=~/Desktop/viromelib/flaviLib/work/infernal
FLAVISCRIPTS=~/Desktop/viromelib/flaviLib/scripts
DOC=~/Desktop/viromelib/flaviLib/workflows/CM_CANDIDATES.md
FA=$INFERNAL/fa/flavi_library_20260228pretile20260818_TRUEordered_uniqueIDs.fa
DB=$VIR_INF/fa/RNAvirus_CompleteAssem_No_CoV-2.fa
NOHIT=<dir>/work/nohit_pool                                              # confirm
D=$(date +%y%m%d)
POOLS=$INFERNAL/pools/$D; mkdir -p "$POOLS"
```

**1. Pools from the reference** (NEXT item 13 — not from `downstream_seq`). Window stall −20 to
+150, clipped to the feature; windows under 40 nt are skipped. Sites inside an included hit of a
candidate model not yet in the annotation are dropped, which stands in for the 9-model recount
(item 14) for pool-building purposes:

```bash
python3 $FLAVISCRIPTS/make_pool_fastas.py \
  "$NOHIT/nohit_sites_by_clade_20261028.tsv" "$FA" "$POOLS/by_clade" \
  --group-by mifsud_clade --four-of-four \
  --exclude-tbl "$INFERNAL/build/cand_PLLG_260915/tblout/clusterA_library_wide_E1e-10.tbl" \
  --exclude-tbl "$INFERNAL/build/cand_FJTB_261026/cand_FJTB_261026.tbl"     # confirm both names
#   add --where <condition column>=<value> if the table holds both Mg conditions
python3 $FLAVISCRIPTS/make_pool_fastas.py \
  "$NOHIT/nohit_sites_by_clade_20261028.tsv" "$FA" "$POOLS/not_in_mifsud" \
  --group-by genus --four-of-four --where mifsud_clade=
#   `mifsud_clade=` keeps rows with an EMPTY clade; if the join wrote a label instead
#   (e.g. NOT IN MIFSUD), put that after the =
cat "$POOLS/by_clade/pool_summary.tsv"
```

The script stops with the column list if a column name differs from what it expects; pass
`--col-acc`, `--col-pos`, `--col-sf`, `--col-species` to override. `skipped.tsv` gives the reason for
every dropped site.

**2. Cluster within a pool** when the p10–p90 stall spread is large or the pool spans many genera
(PLLG, not-in-Mifsud). FJJI at 181 nt can go to step 3 whole first.

```bash
P=PLLG
vsearch --cluster_fast "$POOLS/by_clade/$P.fa" --id 0.5 --notrunclabels \
  --clusters "$POOLS/by_clade/${P}_c" --uc "$POOLS/by_clade/$P.uc"
# rank clusters by distinct species, not size
for f in "$POOLS/by_clade/${P}_c"*; do
  printf '%s\t%s\t%s\n' "$(basename "$f")" "$(grep -c '^>' "$f")" \
    "$(grep -o 'species=[^ ]*' "$f" | sort -u | wc -l)"
done | sort -k3,3nr | head
```

Name the cluster that goes forward `cand_<CLADE>_<yymmdd>`; record the vsearch index and `--id`
as provenance in its first log row.

**3. Align** (GATE 1). Builds live with the flaviLib dataset:

```bash
C=cand_${P}_$D; B=$INFERNAL/build/$C; mkdir -p "$B/seed" "$B/iter_v1"
cp "$POOLS/by_clade/${P}_c<N>" "$B/seed/$C.fa"
mlocarna --stockholm --consensus-structure=alifold --probabilistic --consistency-transformation \
  --tgtdir "$B/iter_v1/mlocarna" "$B/seed/$C.fa" | tee "$B/iter_v1/mlocarna.log"
python3 $FLAVISCRIPTS/dedup_stockholm.py "$B/iter_v1/mlocarna/results/result.stk" \
  "$B/iter_v1/mlocarna/results/result-dedup.stk"
python3 $FLAVISCRIPTS/cm_log.py "$DOC" --model "$C" --step "mlocarna, $(grep -c '^>' "$B/seed/$C.fa") seqs, vsearch c<N> --id 0.5 of $P" \
  --result "alifold <structure> (<total> = <energy> + <covariance>)"
```

Stop here if the covariance term is weak (pegivirus −1.55 was set aside); split further or add
sequences rather than hand-editing it into shape.

**4. Manual**: MATER pseudoknots → hand-edit `SS_cons` → wiggle-refine → R-scape `-s --cacofold`.
Log what changed (the gap noted under Build procedure — missing for class1c and clusterA):

```bash
python3 $FLAVISCRIPTS/cm_log.py "$DOC" --model "$C" --step "MATER + CaCoFold" \
  --result "PK <cols>; SS_cons edits <cols>; R-scape <n> bpairs, <n> covarying, avgid <x>"
```

**5. Build** (GATE 2) — `cmbuild --hand` only on R-scape output or an alignment carrying RF:

```bash
cmbuild --hand -F -n "$C" "$VIR_INF/cm/$C.cm" "$B/rscape/<name>.cacofold.sto"
cmcalibrate --cpu 4 "$VIR_INF/cm/$C.cm"
```

**6. Search → saturation → cmalign → rebuild → search**, logged automatically. Library first
(cheap; a seed-only result there is expected and is the overfitting signal), then the database:

```bash
$FLAVISCRIPTS/cm_iterate.sh --name "$C" --cm "$VIR_INF/cm/$C.cm" \
  --seed "$B/rscape/<name>.cacofold.sto" --target "$FA" --label library \
  --workdir "$B/iter_v2_library" --doc "$DOC" --check-only
$FLAVISCRIPTS/cm_iterate.sh --name "$C" --cm "$VIR_INF/cm/$C.cm" \
  --seed "$B/rscape/<name>.cacofold.sto" --target "$DB" --label RNAvirusDB \
  --workdir "$B/iter_v2_RNAvirusDB" --doc "$DOC" --rounds 3
```

Each round logs `cmstat` (nseq, eff_nseq, clen, bps, bifs), included hits, accessions, hits passing
≥ 85 % model coverage, novel hits, and from round 1 on the per-hit bit-score change against the
previous round (`matched / lost / gained / lower_bits / worst_delta`; per-hit table in
`r<N>/search.tbl.compare.tsv`). It stops on **0 novel hits** (saturated) or at `--rounds`.
`--toponly` and `--incE 1e-10` are fixed by default, per the search settings below.

**Accept a rebuilt round only if** eff_nseq does not collapse (reject case: 1.55), no previously
included hit is `lost` or loses bit score, and `clen`/`bps`/`bifs` are stable under `--hand`.
`cm_iterate.sh` reports these but does not enforce them; the decision is a `cm_log.py` row.

**7. Overlap with the annotation set** — positions, not accessions (Corrections): search the
new model against `$FA` with `--toponly --incE 1e-10`, convert spans to genomic, and compare with
the `.cm_hit` spans of the 7 models. Then update the pool-queue row above.

### Novelty, as `cm_iterate.sh` computes it

A hit is novel if fewer than 80 % of its 15-mers occur in the sequences the current model was built
from (round 0: the seed). 0.80 tolerates a hit span running ~10 nt past the seed span, which is
normal; a new strain at 95 % identity shares only ~45 % of 15-mers and counts as novel.
Per-hit containment is in `r<N>/hits.novel.tsv`. Change with `--novel-c`.

Validated 2026-10-29 on a synthetic target (each class1c seed sequence embedded in random
flanks, plus 200 random decoys): the class1c model rebuilt from its seed reports 0 novel at round 0
(saturated); a model built from the 6 ON0240xx seed sequences alone reports 11 novel, rebuilds on
17, and saturates at round 1. Calibration was shortened for the test only.

---

## Build procedure and gates

`flaviLib/scripts/build_candidate_cm.sh` (md5 `264fd3ef7cf2efcdc8da6a0102975426`), two stages split
at the manual step:

```
--stage align  -> mlocarna --probabilistic --consistency-transformation, alifold consensus, dedup
MANUAL         -> pseudoknots in MATER (C. Langeberg) -> hand-edit SS_cons -> wiggle-refine -> CaCoFold
--stage build  -> cmbuild (--hand if SS_cons was edited) -> cmcalibrate -> cmsearch
```

cmbuild reads only the primary `SS_cons` line, so crossing pairs (`AAAA…aaaa`) are annotation for
the analyst, not for the model. Feed the CaCoFold `.sto` to `--stage build` with `cmbuild --hand`.

**GATE 1 — alifold consensus energy.** References: hepaci −24.24, pesti −11.61, pegivirus −3.56
(set aside), pooled 59-sequence attempt −3.25 (split by genus instead). Weak means add sequences or
split; not hand-edit it into shape. The **covariance term** is the part to read, not the total:
pegivirus was set aside on a weak covariance term.

**GATE 2 — `cmstat` eff_nseq.** Reported, not enforced. Class_2 is a curated model at 3.58.
`cand_PLLG_260915_cmalign` was 24/1.55 and work stopped there. class1c 46/9.54,
hepaci_hits_v2 55/19.93. A low eff_nseq matters only together with what the model then does: few
hits beyond the training set is the overfitting signature.

**Search settings.** `--toponly` — the library is +ssRNA, so a minus-strand hit is never
biological, and a model whose stem is partly self-complementary matches its own reverse complement.
`--incE 1e-10` — the default 0.01 is too permissive on this reference; the PLLG data show a clean
gap with nothing between 1.7e-22 and 1.4e-04.

**Overlap check with the existing set.** Compare on **full features**, and compare **positions**,
not accession membership. Zero overlap means a new class; heavy overlap means it should be merged —
and a merge that degrades the parent argues for keeping them separate. The class1b merge attempt
cost AB021287.1 18.17 → 14.12 bits for one gained classification, which is why class1c is its own
class.

**Not recorded anywhere, and should be:** what the manual MATER step does per candidate — which
pseudoknots were found, which SS_cons columns changed by hand, what CaCoFold returned. Missing for
class1c and clusterA too, so neither is reproducible.

### The iteration recipe, from class4 v1 → v9

Source: `viromelib/workflows/260720-260824_cm_class4_development.md` (434 lines; the development
record, kept there because class4 is viromelib-derived). This is the procedure both candidates need,
since both are stuck on sequence diversity and this is how class4 acquired it.

```bash
DB=fa/RNAvirus_CompleteAssem_No_CoV-2.fa
esl-sfetch --index "$DB"                 # once per database

# 1. seed
mlocarna --stockholm --consensus-structure=alifold <seed.fa>
cmbuild <cm>.cm <seed.stk>               # hand-add base pairs here if needed
cmcalibrate --cpu 4 <cm>.cm
cmsearch --tblout <cm>.tbl --cpu 4 <cm>.cm "$DB"

# 2. one iteration: CM_IN -> CM_OUT
grep -v "^#" <CM_IN>.tbl | grep -v "^$" | \
  awk '$10=="+" && $17=="!" {print $1"/"$8"-"$9, $8, $9, $1}' > iter/<v>_sig_hits.fetchlist
esl-sfetch -Cf "$DB" iter/<v>_sig_hits.fetchlist > iter/<v>_sig_hits.fa
cmalign --cpu 4 -o iter/<v>_sig_aligned.stk <CM_IN>.cm iter/<v>_sig_hits.fa
cmbuild -F -n <CM_OUT> <CM_OUT>.cm iter/<v>_sig_aligned.stk
cmcalibrate --cpu 4 <CM_OUT>.cm
cmsearch --tblout <CM_OUT>.tbl --cpu 4 <CM_OUT>.cm "$DB"
# repeat until the hit count stops changing

# 3. finish with covariation
R-scape -s --cacofold --outdir rscape/<v> --outname <v>_improve iter/<v>_sig_aligned.stk
cmbuild --hand -F <final>.cm rscape/<v>/<v>_improve.cacofold.sto
cmcalibrate --cpu 4 <final>.cm
```

Column filter: `$10` is strand, `$17` the inclusion flag. The first class4 iteration used
`$16<=2` (E ≤ 2) because the seed model was weak and `!` hits were too few; later iterations
tightened to `$17=="!"`. Use `--toponly` instead of filtering `$10` on new searches.

`cmbuild --hand` means "use `#=GC RF` to define which alignment columns are consensus match
states" — **not** "respect `SS_cons`", which cmbuild does by default. It works on a CaCoFold `.sto`
because R-scape writes an RF line. A raw mlocarna or MATER-edited Stockholm has no RF, and
`--hand` on one fails with `--hand used, but alignment #1 has no reference coord annotation`
(confirmed 2026-10-27). So use `--hand` only on R-scape output, or on an alignment that carries RF
from a previous `cmalign`.

**R-scape modes**, from its manual, since the names are not self-explanatory:

| invocation | meaning |
|---|---|
| `-s` | evaluate the **given** structure — two-set test against the existing `SS_cons` |
| `--cacofold` | predict a **new** structure, ignoring `SS_cons` |
| `-s --cacofold` | **improve** the given structure: two-set test, `SS_cons` as the starting point, CaCoFold incorporating all significant pairs from both tests. This is the web server's "Improve" mode. |

**class4's trajectory**, as the count that defines convergence:

| version | built from | significant hits |
|---|---|---:|
| v1 (`cl4_20260720-2`) | Dilweg 2023 seeds, mlocarna, one bp added by hand in stem 2 | 17 (E ≤ 2) |
| v3 | `cmalign` of v1 hits | 42 |
| v4 | + "xrRNAs everywhere" accessions via `efetch`, `!` only | 28 |
| v5 → v7 | `!` hits only | 18, converging |
| v8-rscape | R-scape CaCoFold on the v7 alignment: stem 2 extended 4 bp, 5 significant covarying bp | 29 |
| v9 | `cmalign` of v8 hits, `cmbuild --hand` | 30, converged |

Two things recorded there that bear on reading a class4 result: the **`UUAAACUAC` motif dominates
the search**, with an open idea to pre-filter the database on it and build the CM on the flanking
structure only; and **v7 found no hits in the Secoviridae peak windows** from the 2025 run.

Practical: `esl-sfetch` and the other `esl-*` tools are not in the Infernal install —
`conda install -n viromelib -c bioconda hmmer`. R-scape was built from source into `~/local`,
which is why the `RFview` path under `~/local/lib/RFview/` is broken.

## What is in archive/, and why

Sources: `viromelib/workflows/infernal.md`, `251009_infernal_hpc_classsorting.md`, `CMdist.md`.

Before the peaks tables carried per-model columns, CM class assignment ran as its own pipeline:

```
cmsearch per model per run  ->  tblout/
  buildInfernalRunMap.py      -> csv/<date>_infernal_runs.csv   one row per tblout, with
                                 dataset and fasta_path. CM mapping order: explicit --cm-map
                                 pairs (case-insensitive) -> optional CSV map -> heuristic
  sortclasses.py              -> groups_out/<dataset>/window_level/multiclass.csv
                                 groups_out/window_hits_long.csv
                                 groups_out/window_counts_by_class.csv
                                 groups_out/summary.csv
  joinPASScsv_Infernal.py     -> merges the class info into the PASS table, matched on
                                 accession + peak_position
```

All of it is replaced by `{model}.cm_hit` / `_start` / `_end` / `_tile_truncated` and `any_hit` in
`peaks_annotated.csv`, written by `annotate_infernal_hits.py` from a full-reference `$TBLOUT`
search. So `archive/` holds:

| in archive/ | was |
|---|---|
| `csv_runmaps/` | the run-map CSVs that fed `sortclasses.py` |
| `groups_out/`, `groups_out_R/` | its window-level outputs, per 2025 run |
| `tblout_2025runs/` | the per-model searches against r366all / r368 / r0371 / r0373 |
| `260602/` | the 2026-06-02 151 SE run |
| `flaviLib/archive/flaviLib_20260914`, `_20260917` | the Sept CM-expansion and discovery-pool working trees, cited by the path table above |

Nothing in `archive/` should be read as current. The one reason to go back into it is provenance —
the two Sept trees hold the vsearch clusters and per-genus pools that the candidates came from.

## Run log

### `cand_FJTB_261026`

| date | step | result |
|---|---|---|
| 2026-10-26 | `--stage align`, 15 seqs (August windows) | alifold −44.53 = −29.02 + −15.51. Dedup removed 0 of 15. `.(((((((.....)))))))((.(((((...........))))).))..(((((((((.......)))))........)))).` |
| 2026-10-26 | MATER hand-edit ×3 rounds | CaCoFold → wiggle-refine → CaCoFold. No added layers, no pseudoknot annotation on any round |
| 2026-10-26 | R-scape on all three rounds | identical: 24 bpairs, 4 covarying, 0 FP, PPV 100, Sen 16.67, avgid 86.29, expected 0.4 ± 0.6. No crossing helices |
| 2026-10-27 | seed rebuilt at 16 from the 261021 tables | +KT224356; JF416957/JF416967 from August, tagged `aug2reps` |
| 2026-10-27 | `--stage align`, 16 seqs | alifold −40.87 = −26.88 + −13.99. Expected-to-covary 0.8 ± 0.8, observed 4 |
| 2026-10-27 | `--stage build` | nseq 16, eff_nseq 1.63, clen 80, bps 23, **bifs 2** |
| 2026-10-27 | `cmsearch` library-wide, `--toponly --incE 1e-10` | 39 rows, **17 distinct accessions** — built from 16 |
| 2026-10-27 | `cmsearch` vs RNAvirus_CompleteAssem_No_CoV-2.fa | _(running / fill in)_ |

### `class1c`

| date | step | result |
|---|---|---|
| 2026-09-17 | `cmbuild -F -n class1c` + `cmcalibrate` on `pesti_20260917_edit.stk` | nseq 46, eff_nseq 9.54, clen 84, 15 bp, 1 bif, rel. entropy 0.676 |
| 2026-09-17 | `cmsearch` library-wide (default `--incE`, both strands) | 50 rows, all plus strand; 46 `!` over 19 accessions (E 7.1e-23 to 3.4e-11); 4 `?`: KY370101 0.016, ON949931 0.052, NC_025677 0.42, OP860412 5.4 (fragment) |
| 2026-10-28 | step 18b started | `iter_v2_cmalign/hits.fetchlist` and `hits.fa` written empty: paths pre-date the reorganisation. No result |
| 2026-10-29 | saturation check, 46 `!` hits vs 46 seed sequences | **identical set**: 19/19 accessions, every span within 5 nt of a seed span. Saturated on the library; step 18 there is a no-op. `cmbuild` from the seed reproduces the `cmstat` line exactly |
| 2026-10-29 | sub-threshold spans vs unannotated stalls | KY370101 hit 12808–12900 starts 1 nt after stall 12807 (SF 0.924) → step 17. NC_025677 hit starts 21 nt after stall 12710, not the class1c geometry |
| 2026-10-29 | lineage check: archive/flaviLib_20260914/tblout/pesti_short1b.tbl (2026-09-15) vs seed vs class1c_20260917.tbl | pesti_short1b library search: 46 ! hits / 19 accessions (E 2.7e-23 to 1.1e-06). These 46 spans are the class1c seed exactly (46/46, identical coordinates) and class1c's own 46 ! hits (within 5 nt). Confirms: seed = cmalign of library-wide hits; the new hits (21 Hepacivirus: MN587xxx, MN564793, OM203121, BK067807) came from the pesti_short1b search; the class1c search added none. Bit scores class1c vs pesti_short1b: 25 higher, 20 lower (worst -7.5, ON024101 385), weakest hit 1.1e-06 -> 3.4e-11. Sub-threshold: KY370101, NC_025677, ON949931 were fragments under pesti_short1b (cm 29-46, 28-46, 11-46) and are full-model (cm 1-84) under class1c. |
| 2026-10-29 | class1c vs 416 flavi150-explorer nodes (cmsearch --toponly -T 10) | 45 nodes at 37-73 bits, all 'None found' in the 4-model explorer annotation: the seed sites. fz 137 all class1c; fz 130 8 class1c + 7 Class_1b; fz 131 48 Class_1b + 10 class1c + 11 none. Sub-threshold: ON949931 10608 13.3 bits cm 1-84, span starts at the stall (SF 0.900, FJIS fz 106); KY370101 12807 13.1 (cm 9-53, 80 nt window); NC_025677 12710 10.2. 163 None-found nodes remain |
| 2026-10-29 | methods recorded | M1-M3 under 'Methods for the 2026-10-29 checks'; seed_vs_hits.py and explorer_cm_scan.py reproduce the recorded numbers. Correction: class1c hits match seed spans with identical coordinates in 32 of 46, within 5 nt in all 46; pesti_short1b hits identical in 46 of 46 |
| 2026-10-29 | note: models missing from the explorer annotation | cl4_v9 expected 0 in flaviLib; cl3 few (10-11 sites 10 mM) but wanted: Loquat jingmen-related virus 1 (fz 110, OL344024/026/028) expected class 3. Regenerate block added under Methods |
| 2026-10-29 | M1 + M2 re-run on the laptop (seed_vs_hits.py, Regenerate block) | reproduced exactly: pesti_short1b 46/46 seed matches, identical coordinates 46; class1c 46/46, identical 32; bit scores 25 higher / 20 lower / 1 unchanged, worst -7.5 ON024101 385. Output build/class1c/seed_vs_hits_261029.txt. M3 not run: EXPLORER path not found |
| 2026-10-29 | M3 re-run on the laptop with cm_set_261021/class1c.cm | identical to the rebuilt-model scan: 45 nodes >= 30 bits, same 4 weaker hits and bit scores, same cluster composition. Set model and rebuild agree, so the md5 caveat on the rebuild does not affect any recorded number |
| 2026-10-29 | explorer cluster fetch from the reference (laptop) | fz 44 8/8, fz 106 3/3, fz 39 4/4, fz 110 3/3; fz 41 1/12 and fz 5 0/5 failed: clipped at end-start+1 but reference records are end-start long. Fixed with fetch --ref; re-fetch pending |
| 2026-10-29 | step 17 script written and tested | cm_add_borderline.sh: v0 = plain cmbuild on the seed (reproduces 46/9.54/84/15/1/0.676), variants = cmalign --mapali + cmbuild --hand (clen 84). A --hand v0 gives clen 83 and a plain-cmbuild variant 85, so the earlier manual recipe was not column-consistent. Synthetic test: lost 0, worst delta -0.7 to -2.0 bits. Not yet run on the library |
| 2026-10-29 | step 17 v0 (seed only, plain cmbuild), laptop | nseq=46 eff_nseq=9.54 clen=84 bps=15 bifs=1 relent_cm=0.676; 47 ! hits / 20 accessions (fresh calibration: KY370101 361 now !) |
| 2026-10-29 | step 17 ky (+KY370101) | eff_nseq 9.59, clen 84; 51 ! / 24 acc; vs v0 matched 47 lost 0 gained 4 lower 42 worst -5.6; KY370101 58.6 b PP 0.77; new: NC_025677 252, ON949931 419, BK013349 75 (Class_1b site), MN587695 77 (Class_1b site) |
| 2026-10-29 | step 17 on (+ON949931) | eff_nseq 11.06, clen 84; 51 ! / 24 acc; vs v0 matched 47 lost 0 gained 4 lower 29 worst -1.3; ON949931 38.1 b PP 0.90; new: NC_034017 177 and NC_034204 170 (both exactly at the fz 106 stalls), BK013349 75 (Class_1b site) |
| 2026-10-29 | step 17 nc (+NC_025677) | eff_nseq 10.34, clen 84; 49 ! / 21 acc; vs v0 matched 46 lost 1 gained 3 lower 40 worst -2.7; NC_025677 28.8 b PP 0.74; new: KY370101 388, MN587678 88 (neither at a stall). Rejected |
| 2026-10-29 | step 17 ky_on (+KY370101, ON949931) | eff_nseq 10.46, clen 84; 52 ! / 25 acc; vs v0 matched 47 lost 0 gained 5 lower 44 worst -5.7; KY 58.4 b PP 0.77, ON 35.0 b PP 0.90; new: NC_034204 170, NC_025677 252, BK013349 75, MN587695 77 |
| 2026-10-29 | step 17 reading | 'on' strongest: no loss, worst -1.3, PP 0.90, eff_nseq +1.5, recovers all of FJIS fz 106 at exact stalls. BK013349 75 / MN587695 77 are Class_1b sites: first class1c/Class_1b overlaps. All at E<=0.01; not accepted until checked at --incE 1e-10 and against Class_1b scores |
| 2026-10-29 | merge vs clan decision framing | Keep class1b and class1c separate; resolve overlapping hits per site by lower E (Rfam clan competition). Reopen a merge only if class1c_on has the lower E at most Class_1b sites it overlaps. Test: cm_round_stats.py overlap vs a Class_1b library search (step 17 check 2) |

### The unmatched pool

| date | step | result |
|---|---|---|
| 2026-10-28 | SF and p against read depth, 1 mM | median SF flat below the floor and rising with depth; no row at 1–2 reads reaches q < 0.05 (0 of 8,818). Gated set's lowest-depth site carries **38 summed stall reads**, so G1 at 10 removes nothing |
| 2026-10-28 | no-hit pool, `any_hit == False` and `n_reps_passing` in (3,4) | 749 rows at 10 mM, 351 at 1 mM, 213 accessions. Recorded 885 / 415 do **not** reproduce |
| 2026-10-28 | dedup on accession + genomic position | **749 → 327 sites (10 mM), 351 → 178 (1 mM)**; 56 % and 49 % were tile duplicates |
| 2026-10-28 | Mifsud clade join, Metadata sheet, version-stripped accession | 593 rows / 535 accessions, 53 repeated but never with conflicting clades. **197 of 213 no-hit accessions get a clade; 16 absent from Mifsud** |
| 2026-10-28 | pool ranking by distinct taxa | PLLG 35 taxa, HPHV 24, FJJI 21 but tightest position spread (181 nt) |
| 2026-10-28 | SF by CM class, distinct sites, 4 of 4 | Class_1a median **0.778**, p90 0.905, only 11.4 % ≥ 0.9. `no hit` median 0.535. No class has a median near 0.9 |
| 2026-10-28 | 3-of-4 vs 4-of-4 composition | 3-of-4 sites have SF 0.343 against 0.535; share of them correlates −0.642 with clade median SF. Quote the 4-of-4 median when comparing clades |
| 2026-10-28 | model co-occurrence test | **no stall is annotated by two models**, any pair, any site. Within a genome only `Class_1a + dumbbell` (13 accessions, 13 of 15 dumbbell genomes) and `Class_1b + class1c` (1 accession, MN564793, on a marginal E = 3.6e-04 Class_1b call) |
| 2026-10-28 | E-value distributions by model | `class1c` median **2.0e-17** (worst 3.4e-11) against `Class_1b` median **4.0e-06** (worst 3.7e-03). class1c's worst hit beats Class_1b's best. Also settles that the 261021 run used a threshold looser than the 0.001 default |
| 2026-10-28 | annotation provenance, from `flaviLib.md` and the 261021 run log steps 10 / 11b | `post_process_peaks.py --infernal-tbl` × 7, `$TBLOUT` = `06_infernal/260807_trueRef`, `$CMS` from `env_261021_flaviLib.sh`, search against the pre-tile reference only. **No `--evalue` is passed**, so that script's own default governs — `annotate_infernal_hits.py` did not make these columns and its defaults do not apply |
| 2026-10-28 | annotated accessions carrying unannotated stalls | 74 of 173 accessions with an annotated site also have an unannotated passing site; **56 have one downstream of the last annotated one**. Orthoflavivirus 36 of 83, Pegivirus 8 of 19, Orthopestivirus 6 of 14 |
| 2026-10-28 | high-SF unannotated sites | **46 of 278** deduplicated 4-of-4 no-hit sites at 10 mM reach the Class_1a median, over 39 accessions, concentrated in FJIS, HPPV, PLPV, FJAF, HPHV |

### `cand_PLLG_260915`

| date | step | result |
|---|---|---|
| 2026-09-15 | mlocarna on all 60 PLLG members | flat consensus, `0.00 = 0.00 + 0.00` |
| 2026-09-15 | `cluster_mlocarna_alignment.py` | 5 clusters + 34 singletons; 57 % have no ≥80 % partner |
| 2026-09-15 | mlocarna on clusterA (12) | −33.73 = −21.10 + −12.63, 14 bp, three nested stems |
| 2026-09-15 | `cmbuild`/`cmcalibrate` | nseq 12, eff_nseq 1.90, clen 76, bps 15, bifs 0 |
| 2026-09-15 | `cmsearch` library-wide (default `--incE`, both strands) | 48 rows: ranks 1–24 real (E 1.7e-27 to 1.7e-22, `cm 1–76`), ranks 25–48 minus-strand self-hits |
| 2026-09-15 | `esl-sfetch` + `cmalign` + rebuild on 24 | nseq 24, eff_nseq **1.55** — fell. Work stopped: "way too conserved" |
| 2026-10-27 | `cmsearch` vs RNAvirus_CompleteAssem_No_CoV-2.fa | _(running / fill in)_ |

### `cl3`

| date | step | result |
|---|---|---|
| 2026-10-29 | cl3 vs 416 flavi150-explorer nodes (cmsearch --toponly -T 10), cm_set_261021 model | 3 hits, all Loquat jingmen-related virus 1 (fz 110): OL344028 1907 36.8 bits, OL344024 3003 34.2, OL344026 2862 26.0 (cm 3-52, 5' trunc); all cm ..-52, at the stall. Nothing else >= 10 bits. fz 110 = class 3, as expected; out of the no-hit pool. Open: cl3 clen (cmstat), and 10-11 cl3 sites in the 261021 table vs 3 nodes here |

## NEXT

Rewritten 2026-10-28. Grouped by what blocks what, not by priority alone.

### Ready to run now

1. ~~**Step 18 — rebuild class1c from its library-wide hits.**~~ **Closed for the library
   2026-10-29: class1c is saturated there** — its 46 included hits are its 46 seed sequences, so
   the round would re-fit the seed. Run it against the RNAvirus database instead, with
   `cm_iterate.sh --check-only` first (command under Step 18). Delete the empty
   `build/class1c/iter_v2_cmalign/hits.{fetchlist,fa}`.
2. **Step 17 — class1c with and without the borderline hits.** Now the only library-level change
   to class1c, and it decides one of the strongest unannotated sites: KY370101's sub-threshold
   class1c hit (E 0.016, full model) starts 1 nt after its stall 12807 (SF 0.924, 42k reads).
   Baseline is the original `class1c.cm`. Variants +KY370101, +NC_025677, +both, optionally
   +ON949931. Judge on per-sequence bit scores across the 46 existing hits, never on hit counts.
   Commands under "Step 17".
3. **Steps 15 and 16 — is MN564793's Class_1b assignment wrong?** Relaxed `-E 100` search of
   class1c at position 9566, then merge the 9565–9658 span into the class1c seed and test the same
   way. If class1c wins, the library's only Class_1b + class1c co-occurrence disappears.
4. **Step 14a/14b — is `cand_FJTB_261026` a diverged class 2 copy?** Run `cmstat` on the model
   actually in `cm/` first: the candidates table says 2 bifurcations, the P2-removal variant says
   1, and the argument depends on which.
5. **Read `post_process_peaks.py`'s annotation defaults.** It made every `.cm_hit` column, step 11b
   passes it no `--evalue`, and its thresholds and overlap rule are unknown. The defaults recorded
   for `annotate_infernal_hits.py` belong to a different script and demonstrably do not apply —
   hits at 3.7e-03 survive in these tables.
6. **Re-derive the "still unclassified" lists.** The Sept 2026 pestivirus and hepacivirus lists
   predate the 261021 annotation: KY370100, KY370101 and NC_025677 all carry Class_1b hits now.
   The hepacivirus count is nine, not eight — OX394189 was omitted.
7. **Resolve `cand_FJTB_261026`'s +1 accession.** Which accession hit that is not in the seed, and
   do all 16 recover themselves? 39 rows from 17 accessions is ~2.3 each — check for tandem copies.
8. **`cand_PLLG_260915` library-wide with `--toponly --incE 1e-10`.** September used the default
   and both strands. If 48 rows drop to 24, decision 36 closes for this model.

### Discovery, in order of what the evidence supports

All of items 8–12 now run through **Live workflow** (pool FASTAs from the reference with
`make_pool_fastas.py`, then `cm_iterate.sh`), which also removes blocker 13 for them. Track each
pool in the pool-queue table there.

8. **Downstream paralogs in already-annotated genomes.** 56 of 173 accessions carry an
   unannotated passing site downstream of their last annotated one — Orthoflavivirus 36 of 83,
   Pegivirus 8 of 19, Orthopestivirus 6 of 14. These have a positional anchor and a structural
   prior from the neighbouring element, which no clade pool does. Richest: ON949931 (4),
   NC_001672, NC_025677, NC_027709 (3 each). Start here.
9. **FJIS.** 34 distinct no-hit sites over 20 accessions and 14 species, median SF 0.620 — the
   highest of any clade with real diversity — at high depth. NC_034017 *Xishuangbanna aedes
   flavivirus* 0.911, AB981186 *Quang Binh virus* 0.890, NC_027817 *Parramatta River virus* 0.873,
   ON949931 *Kilpisjarvi flavivirus* 0.871. *Quang Binh virus* appears in four accessions —
   weight or dereplicate before aligning.
10. **PLLG and HPHV**, the two best pools by distinct taxa (35 and 24). PLLG's position spread is
    6,756 nt, so cluster within it rather than aligning the clade whole. PLLG remainder is 36 of
    60; `cand_PLLG_260915` covers 24.
11. **The 29 unexamined orthoflavivirus clusters — but re-split by clade code first.** They came
    out of a genus split, which mixes insect-specific and tick-borne flaviviruses in one
    alignment, against the recorded rule.
12. **The remaining no-hit stalls** — 327 distinct sites at 10 mM, 178 at 1 mM.

### Blockers these depend on

13. **Build the mlocarna pools by `esl-sfetch` from the reference, not from `downstream_seq`.**
    The cmalign route already does this (`esl-sfetch -Cf` of hit spans from
    `flavi_library_...TRUEordered_uniqueIDs.fa`), and it is the only step that reads
    `downstream_seq` at all — `cmsearch`, the `.cm_hit` annotation and `cmalign` are all
    full-reference and unaffected. Suggested span `stall − 20` to `stall + 150`. This is what
    decision 37 is about. **Blocks items 8–12**, and needs no change to `post_process_peaks.py`.
    **Implemented 2026-10-29** as `make_pool_fastas.py` (Live workflow, step 1); tested on synthetic
    input only — first real run should spot-check a few windows against `esl-sfetch -c`.
14. **Recount the no-hit pool against 9 models.** Add both candidates to the annotation run — the
    `.tbl` files are passed as arguments, so no code change. Current counts are against 7.
    **Blocks item 12.**
15. **Collapse peaks across overlapping tiles at the same stall position**, as `flaviLib.md`
    already flags. Measured at 56 % of no-hit rows at 10 mM and 49 % at 1 mM. Every per-site count
    in this document is deduplicated ad hoc; it belongs in the pipeline. Related: decision 4,
    merge distance 0 vs 3 nt, still open — MN564793's 9439/9440 and NC_034017's 10510/10511 are
    one stall each, not two.

### Record-keeping

16. **Record the 261021 annotation command** in `flaviLib.md`. Steps 10 and 11b of the run log have
    it; the workflow document stops at the four-model 150x150 annotation.
17. **Decision 37 needs re-deriving, not patching.** Four problems: the no-hit call used 4 models
    not 7; the analysis took the lowest-p peak per accession, so one stall per accession; the peak
    calls come from the superseded August postproc; and the source flags *"double check the PLLG
    fishing from the Mifsud sheet was actually successful"*. Accessions in
    `build/cand_PLLG_260915/seed/PLLG_LGF_unclassified_60.fa` headers.
18. **Close the hepaci accounting gap** — one comparison over the original genus pool, not three
    partial ones. The 9 / 9 / 13 tiers may overlap; MN564793 is known to sit in two.

## Open

- `260915_pllg_analysis.md` ends with "RETURN LATER with better sequence alignments, refer to
  `class1b_expansion.md`". That file was **renamed to `260914-260917_cm_expansion.md`** — its
  §142–328 is the class1b expansion (merge attempt, forced alignment against `class1b.cm`,
  `esl-alimerge` with the original seed, stricter-subset rebuild, the 13 hits that never went in).
  Stale filename reference, not a missing document.
- `LAYOUT.txt` lists both laptop infernal directories as "CM DISCOVERY", contradicting
  `flaviLib_infernal_README.md`. Narrow it.
- `cm/MANIFEST.tsv` does not exist. Build from `cd $VIR_INF/cm && md5 *.cm`, with `NAME` as a column.
- The orthoflavivirus campaign file's `CMDIR` points under `flaviLib/`; the set is at
  `work/infernal/cm/cm_set_261021`.
- Which class 4 model annotates the **viromelib** peaks (`cl4.cm` is not v9).
- `dumbbell_RF00525.cm` and `cl3*.cm` also exist in `trash/retired_261026/06_infernal/cm/`.
- `stockholm/` holds the seed alignments for every established CM (`cl1a…cl5_manual_jgg.stk`,
  `CL_Class_*.sto`). Build artifacts by the convention, but the run logs cite these paths. Not moved.
- `build_candidate_cm.sh` defects: GATE 1 passes on an energy parse failure; the alifold regex misses
  mlocarna's line format (`alifold<ws><structure> (…)`); mlocarna's exit status is unchecked; dedup
  can produce no output while the manual-step banner still prints; R-scape is left to the manual step
  and its outdir is not created; the tblout path is not printed.
- `gnuplot` missing in the `viromelib` env (R-scape skips its plots);
  `conda install -y -c conda-forge gnuplot`. `RFview` path under `~/local/lib/RFview/` is broken.

---

## Archived and ignored scripts

Things that exist somewhere but are not part of the current pipeline. Listed so that finding one
does not start the question over.

| script | what it is | status |
|---|---|---|
| `annotate_infernal_hits.py` | Adds `{stem}_hit` / `_start` / `_end` / `_tile_truncated` per `.tbl` plus `any_hit` — the same column convention the tables use. **Is** in cluster `scripts/`, absent from the local repo copy and from every workflow document and run log. | **ignore.** `post_process_peaks.py --infernal-tbl` made the 261021 columns (run log steps 10 and 11b). Its defaults are its own and do not describe these tables |
| `buildInfernalRunMap.py` → `infernal_runs.csv` → `sortclasses.py` | The earlier annotation route, against `*_PASS_peak_windows.fa`, output to `groups_out/` | superseded by `post_process_peaks.py` |
| `cm_build_variants.sh` | Six `cmbuild` weighting variants of one alignment | retracted 2026-10-27 — six commands do not need a script. **Still present in `scripts/`; delete** |
| `migrate_cm_organization_261027.sh` | First attempt at the infernal tree reorganisation | superseded by `infernal_layout_261027.sh`. **Still present in `scripts/`; delete** |

Also superseded, not scripts but worth the same note: `hepaci_unclas.cm` and `hepaci_hits_v2.cm`
are intermediates in the chain that ended at `class1c` (decision 33), and `cl*_manual_jgg.stk` are
outdated seeds belonging in `archive/manual_jgg_superseded/`.

### Superseded versions in cluster `scripts/`

Source: cluster `ls scripts/` (152 files). No member of any family below is in the local repo's
`scripts/` (38 files), so the local repo is the curated set and this list applies to the cluster
copy.

"Current" is taken from what the pipeline actually invokes, not from the highest version number.
`call_peaks_v73.sbatch`, `postprocess_peaks.sbatch`, `combine_reps.sbatch`,
`make_fragments_se.sbatch` and `run_viromelib_pipeline.sh` between them name only:
`filterPeaks_normtoCTRL_v7.3.py`, `calibratePeakNull.py`, `combine_replicates.py`,
`post_process_peaks.py`, `make_fragment_file.py`, `fragments_to_tracks.py`,
`make_release_tracks.py`.

| family | members | current | superseded |
|---|---:|---|---|
| `filterPeaks_normtoCTRL` | 13 | **`_v7.3.py`** — named in `call_peaks_v73.sbatch`, and "v7.3 gates" throughout the figures | v1, v2, v3, v4, v4_1, v4_2, v4_2.1, v5, v7, v7.1, v7.2, and **v7.4, abandoned** — see below |
| `extractPeakSeq` | 11 | **none — obsolete.** `downstream_seq` and the peak sequences now come from the post-processing workflow | all eleven |
| `filterPeaks` / `filterPeaks_v6_scipy` | 6 | none — predates the normtoCTRL rewrite | `filterPeaksv3`, `filterPeaksv5`, `filterPeaks_v6_scipy` and its `.1`, `.2`, `.3` |
| `annot_counts_taxo` | 9 | **none — obsolete.** Annotation is done by the post-processing workflow (`post_process_peaks.py` with `--family-csv` and `--infernal-tbl`) | all nine |
| `rank_plot_v7*.py` | 5 | **none** — the rank plots are now Rmd notebooks (`rank_plot_v9_20261019.Rmd`, `rank_plot_flaviLib_v1_20261021.Rmd`) | all five `.py` |
| `make_fragment_file` | 3 | **`make_fragment_file.py`** (single-end, named in the sbatch); `_pe_v2.py` for paired-end | `_pe.py` |
| `sortclasses` | 3 | none — old annotation route | `sortclasses.py`, `sortclasses_eval.py`, `sortclasses_eval.py.bak` |

`filterPeaks_normtoCTRL_v7.4.py` is abandoned, not a newer version: it altered behaviour beyond
the intended change, so the intended change was applied directly in v7.3. A higher version number
in this family means superseded. Delete v7.4.

`annot_counts_taxo` is obsolete in full; taxonomy annotation is part of the post-processing
workflow.

`extractPeakSeq` is obsolete in full. `downstream_seq` is written by `post_process_peaks.py`.

