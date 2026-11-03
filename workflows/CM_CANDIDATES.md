# CM expansion: candidates, accounting, and procedure

**The single current document for CM discovery.** Start at Part 1 (Status). Every conclusion lives here; the files below are
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

Last updated 2026-11-03 (sub-threshold Class_1b additions rejected; the triple read with windows and PP; seed-shift question answered; explicit Class_1b membership table; cluster 106 plan). Reorganised into dated parts on 2026-11-02; no content removed
(superseded passages are kept and marked).

## How to read this file

The file is in parts, most current first. Every dated section says when the work was done; the
**Run log** (Part 10) has one row per step, written by the scripts or by `clog`.

| part | what | dates |
|---|---|---|
| 1 | **Status: goal, where each workstream stands, next steps** | 2026-11-02 |
| 2 | The 7 annotating models, their limits, Infernal versions | 2026-10-21 – 10-30 |
| 3 | **Gap filling** — the **gap register** (every gap in one table), candidate cards, the work per gap | 2026-10-28 – 11-02 |
| 4 | **Model statistics** (all models and candidates); earlier candidates `cand_FJTB_261026`, `cand_PLLG_260915` | 2026-09-15 – 11-02 |
| 5 | class1c review: saturation, borderline hits (step 17) | 2026-10-28 – 10-30 |
| 6 | class1b and class1c: overlap, merge question, class1b expansion attempt | 2026-09 – 10-30 |
| 7 | Accounting: how many stalls have no CM, by clade | 2026-10-28 |
| 8 | Methods: scripts, how this file is updated, shell notes, build gates | 2026-10-26 – 11-02 |
| 9 | Reference: naming, layout, coordinate conventions | 2026-10-26 – 10-30 |
| 10 | Run log | all |
| 11 | Open items, and the superseded NEXT list of 2026-10-28 | |
| 12 | History: corrections, archive, retired scripts | |

### Which table is authoritative

There are many tables; these four are the ones to read, and the rest are dated measurements or
superseded snapshots kept for provenance.

| question | table |
|---|---|
| what is still uncovered, and what is being worked on | **gap register**, Part 3 |
| what each candidate is, and which gates it has passed | **candidate cards**, Part 3 |
| which models annotate the data | **the 7 annotating models**, Part 2 |
| model statistics side by side (nseq, eff_nseq, clen, bps, bifs) | **model statistics**, Part 4 |
| what was measured on a given day | the dated tables in Parts 3, 6 and 7, and the **run log**, Part 10 |

Superseded by the gap register, kept as the derivation: the **progress table** and **counts of what
is not covered** (Part 7), **known uncovered** (Part 5). The **pool queue** (Part 3) is not
superseded — it holds the per-clade site counts and the pipeline stage of each clade.

---

# Part 1. Status — 2026-11-02

## Goal

Find covariance models for Xrn1 stall sites that none of the 7 annotating models explains (the
"no CM" sites), working through them cluster by cluster, grouped by Mifsud sub-clade. Each new
model starts as a candidate, `cand_<CLADE>_<yymmdd>`, and is accepted only after it passes the
gates in Part 8.

Along the way two existing models were checked for whether they could be **extended** to cover
sites they narrowly miss: class1c and Class_1b. That matters for gap filling because a site an
extended model can claim is not a gap. Neither extension has been accepted, so the gap list is
unchanged by them.

## Where each workstream stands

| # | workstream | dates | question | outcome | status |
|---|---|---|---|---|---|
| 1 | class1c: another cmalign round + library search | 10-28 – 10-29 | would realigning class1c's library hits and searching again add anything? | No. Its 46 included library hits are its own 46 seed sequences; the realignment round was already done one model earlier (`pesti_short1b`). Part 5 | **closed** — only an RNAvirus-database search could add sequences |
| 2 | class1c: borderline hits (step 17) | 10-29 – 10-30 | add KY370101, ON949931 or NC_025677 to class1c? | No variant accepted: gains do not reach E 1e-10, and the broadened models reach Class_1b sites, where Class_1b wins every time. Part 5 | **closed** |
| 3 | merge class1b and class1c? | 10-29 – 10-30 | one model or two? | Two. class1c had the lower E-value at none of its 16 overlaps with Class_1b (1, 4 and 11 across the three class1c models tested). Overlaps are resolved per site by lower E-value. Part 6 | **closed** |
| 4 | Class_1b expansion | 10-30 | Class_1b has 68 library hits not in its seed; add them? | Every rebuild loses at least one existing hit (AB021287). The original model was built with Infernal 1.1.2, which changed how comparisons must be made. Part 6 | **paused** — AB021287 `--max` check outstanding |
| 5 | explorer scan with the missing models | 10-29 | how many explorer "None found" sites are already class1c / cl3? | 45 class1c, 3 cl3 (loquat, cluster 110). 163 no-CM sites remain; 6 no-CM clusters of ≥ 3 sites. Part 3 | **done** |
| 6 | **gap filling: FJIS clusters 5 and 106** | 10-30 – 11-02 | new candidate | **`cand_FJIS_261029`**: pooled cluster 5 + cluster 106, 80-nt windows, MATER edit (2 pseudoknots). Covariation gate passed (4 covarying vs 0.2 expected); separate from class1c and Class_1b site by site; saturated on library and RNAvirus DB. Part 3 | **decision pending** — Class_1b-subgroup rebuild test, targeted ISF search |
| 7 | **gap filling: FJJI 41 / 44, HPPV 39, FJTB 64, PLLG 117** | 11-02 | new candidates | FJJI aligned: two separate elements; cluster 41 stalls at 10 mM only. Others not aligned | **in progress** — FJJI MATER |
| 8 | earlier candidates `cand_FJTB_261026`, `cand_PLLG_260915` | 09-15 – 10-27 | | built; blocked on sequence diversity; RNAvirus-database searches started 10-27, results not recorded | **results pending** |
| 9 | Mifsud-clade pools beyond the explorer clusters | 10-28 | | pool queue ranked (Part 3); pool FASTAs not built | **queued** |

## Next steps, in order

The full list of gaps, with state and where each is described, is the **gap register** at the top of
Part 3.

1. **FJIS `cand_FJIS_261029`**: the Class_1b-subgroup rebuild test (Part 3, FJIS section); check
   whether the RNAvirus DB lacks the 4 missing seed genomes and read its weaker hits by position;
   then decide: separate class, Class_1b subgroup, or keep as candidate.
2. **FJJI 41 + 44**: MATER edit of cluster 41, then cluster 44, separately; R-scape, first model,
   library search. Then HPPV 39; look at FJTB 64 and PLLG 117 (check PLLG 117 against
   `cand_PLLG_260915` first).
3. **`cand_FJTB_261026` / `cand_PLLG_260915`**: record the 10-27 RNAvirus-database results for `cand_FJTB_261026` and
   `cand_PLLG_260915`.
4. **Class_1b + novel hits**: the AB021287 `--max` check, then accept or close.
5. **Clade pools** (PLLG remainder, HPHV, PLPV, FJMB, FJAF, FJUN, not-in-Mifsud) with `make_pool_fastas.py`.

---

# Part 2. The annotating CM set — `cm_set_261021` (2026-10-21; checked 2026-10-27 – 10-30)

## The models

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

### Infernal versions of the annotating models — found 2026-10-30

`CL_Class_1b_xrRNA_final.cm` was built with **Infernal 1.1.2** (header `INFERNAL1/a [1.1.2 | July
2016]`, build line `cmbuild Class_1b_xrRNA_final.cm Class_1b_xrRNA_final.sto`, no options). The
laptop has 1.1.5.

| build of `cm/seeds/CL_Class_1b_xrRNA_final.sto` | nseq | eff_nseq | clen | bps | bifs |
|---|---:|---:|---:|---:|---:|
| provided model | 88 | 48.62 | 81 | 19 | 2 |
| plain `cmbuild`, Infernal 1.1.5 | 88 | 87.08 | 78 | 18 | 2 |
| plain `cmbuild`, Infernal 1.1.2 | 88 | 48.62 | 81 | 19 | 2 |

The seed is the right file: `cmalign --mapali` accepts it, and `--mapali` refuses an alignment
that differs from the model's own (`checksum mismatch` — tested 2026-10-29 with one changed
residue). So the same seed and command give a different model under 1.1.5.

**Rule:** a rebuilt provided model is compared only with a baseline built by the same Infernal
version. Two ways:

- build the variants with 1.1.2 and compare with the provided model (Part 6 does this);
- or build a 1.1.5 baseline from the seed alone with the model's columns: take a
  `cmalign --mapali` output, keep only the seed sequences (`esl-alimanip --seq-k`), and
  `cmbuild --hand`.

Infernal 1.1.2 on Apple Silicon: bioconda has no `osx-arm64` build, so install the Intel one
under Rosetta and call it with `conda run`:

```bash
CONDA_SUBDIR=osx-64 conda create -y -n infernal112 -c bioconda -c conda-forge infernal=1.1.2
conda run -n infernal112 cmbuild ...        # likewise cmcalibrate, cmstat
```

Not yet checked for the other provided models (1a, 2, 3, dumbbell):

```bash
for f in "$CMSET"/*.cm; do printf '%-70s %s\n' "$(basename "$f")" "$(head -1 "$f")"; done
```

class1c and cl4_v9 were built here with 1.1.5; class1c rebuilds exactly from its seed. 

**`cm_iterate.sh` rebuilds from the hits alone**, dropping the seed. That is right for a model
whose seed is library hits (class1c), and wrong for a provided model whose seed comes from
outside the library (Class_1b's 88 sequences). On provided models use it with `--check-only`
only, and extend them by appending to the seed with `cmalign --mapali` (Part 6).

---

# Part 3. Gap filling: clusters with no CM (2026-10-28 – 11-02)

## Gap register — 2026-11-02

**The one list of every gap**: sites or groups of sites that no annotating model explains, plus
the extensions of existing models that were tried. Each row says where the work is described and
which run-log table holds its steps. A gap nobody has worked on has no run-log rows, so this table
is the only place it shows as pending. Update the row when its state changes.

Rows are named by what they are, not by a code (the one-letter `G`/`E` ids used on 2026-11-02 are
dropped — `G1`–`G7` already mean the peak-caller gates elsewhere in this project). Explorer clusters
("cluster N" = frozen cluster N, Part 9 → Naming) are subsets of the clade pools below them: FJIS
clusters ⊂ FJIS, FJJI 41 + 44 ⊂ FJJI, HPPV 39 ⊂ HPPV, FJTB 64 and `cand_FJTB_261026` ⊂ FJTB,
PLLG 117 and `cand_PLLG_260915` ⊂ PLLG. Pool counts include their clusters' sites; do not add the two.

### Gaps

| gap | what it is | source | size | state | last | described in | run log |
|---|---|---|---|---|---|---|---|
| **FJIS cluster 5** | insect-specific flaviviruses, explorer cluster 5 (+ NC_012671) | explorer | 6 sites | **closed 2026-11-02: joined Class_1b.** The published P1-deviant ISF subtype; carries the base triple; `class1b_plusFJIS_cluster5_inf112` accepted. See the Class_1b extension row | 11-03 | Part 3, FJIS section | `class1b`, `cand_FJIS_261029` |
| **FJIS cluster 106** | NC_034017 *Xishuangbanna aedes flavivirus*, NC_034204 *Menghai flavivirus*, ON949931 *Kilpisjarvi flavivirus* | explorer | 3 sites | **open.** Not class1c (guided seed 1.55 / 1.33 / −2.14 bits), not Class_1b (PP 0.38–0.47, 5′-truncated, 11–17 hits lost). The triple's pair reads as deleted, but at overall PP 0.465 that is not evidence. **Next: align cluster 106 alone at 80 nt** for a consensus structure in its own coordinates, then a provisional model to search the RNAvirus DB and a targeted NCBI ISF set — 3 near-identical sequences cannot support a model or pass the covariation gate | 11-03 | Part 3, cluster 106 section | `cand_FJIS_cluster106_261103` |
| **FJJI 41 + 44** | Jingmen tick viruses and relatives, explorer clusters 41 and 44 | explorer | 12 + 8 sites | **two separate candidates** (pooling fails): `cand_FJJI_cluster41_261029` (10 mM only), `cand_FJJI_cluster44_261029`. Next: MATER per cluster | 11-02 | Part 3, FJJI section | `cand_FJJI_cluster41_261029`, `…cluster44…`, `…cluster41-44_pooled…` |
| **HPPV 39** | rodent pegiviruses, explorer cluster 39 | explorer | 4 sites | queued (Sept pegivirus genus pool set aside at −3.56) | 10-29 (fetched) | Part 3 | — |
| **FJTB 64** | TBEV serocomplex, explorer cluster 64 (MT354614 10670, NC_001672 10912, NC_027709 10641) | explorer | 3 sites | not looked at. A second FJTB site besides `cand_FJTB_261026`; check its position against the class 2 pair and G6 first | — | — | — |
| **PLLG 117** | Bole tick virus 4 / Flaviviridae sp., explorer cluster 117 (ON408075 15841, ON811709 16053, ON811731 16056) | explorer | 3 sites | not looked at. Same taxa as `cand_PLLG_260915`: check whether G7's model already hits these | — | — | — |
| **cand_FJTB_261026** | third FJTB stall, explorer cluster 3 | Sept vsearch / explorer | 16 seqs | model built 10-27; diversity-blocked; RNAvirus DB search started 10-27, **result not recorded** | 10-27 | Part 4 | `cand_FJTB_261026` |
| **cand_PLLG_260915** | tick-associated PLLG, clusters A/B/C | PLLG clade pool | 24 of 60 PLLG | model built 09-15; refit stopped (too conserved); RNAvirus DB **result not recorded** | 10-27 | Part 4 | `cand_PLLG_260915` |
| **PLLG remainder** | PLLG members not covered by `cand_PLLG_260915` | PLLG clade pool | 36 of 60 members; pool 66 sites / 35 acc | not started; cluster within (spread 6,756 nt) | — | Part 3 pool queue; Part 7 | — |
| **HPHV pool** | hepaciviruses | clade pool + Sept lists | pool 34 sites / 24 acc; lists: 9 unclassified accessions, 13 partial Class_1b matches, 9 dropped from the class1b merge (may overlap) | not started; reconcile the three lists in one comparison first | — | Part 3 pool queue; Part 5 "Known uncovered"; Part 6 | — |
| **PLPV pool** | pestiviruses | clade pool + Sept list | pool 15 sites / 9 acc; 8 sequences trimmed from the Sept seed | not started | — | Part 3 pool queue; Part 5 "Known uncovered" | — |
| **FJMB pool** | mosquito-borne flaviviruses | clade pool | 17 sites / 12 acc | not started | — | Part 3 pool queue | — |
| **FJAF pool** | aquatic flaviviruses | clade pool | 9 sites / 6 acc | not started | — | Part 3 pool queue | — |
| **FJUN pool** | unclassified flavi-jingmen | clade pool | 7 sites / 3 acc | not started | — | Part 3 pool queue | — |
| **not-in-Mifsud pool** | accessions absent from Mifsud's set | clade pool (by genus) | 29 sites / 15 acc | not started | — | Part 3 pool queue | — |
| **sub-threshold Class_1b** | stalls where Class_1b scores just under inclusion: explorer cluster 21 (CFAV LR694076 10565, Kamiti River NC_005064 11245), cluster 135 (MW897328 10653) | explorer | 3 sites | **closed 2026-11-03 as a Class_1b question; 2 sites remain open on their own.** LR694076 10565 was 19.9 b / E 0.067 `?` and the cluster-5 expansion includes it at 23.4 b. The other two were tested as seed additions and **all three variants were rejected** — every one loses `OP860412 297`, and the two with MW897328 also lose two cluster-5 member sites. NC_005064 1079 (18.5 b, E 0.079) and MW897328 66 (19.3 b, E 0.057) are not Class_1b; they need their own model or sequences from outside this library | 11-03 | Part 3, FJIS section | `class1b` |
| **downstream copies** | unannotated site downstream of the last annotated one in the same genome | 261021 tables | 56 of 173 annotated accessions | target list only | 10-28 | Part 7 | `The unmatched pool` |
| — | Sept orthoflavivirus vsearch clusters 1, 3–30 | genus pool | 29 clusters | **superseded** by the explorer clusters and clade pools (recorded rule: split by clade, not genus) | — | Part 7 | — |

### Extensions of existing models (not gaps; recorded so they are not retried)

| extension | what | state | last | described in | run log |
|---|---|---|---|---|---|
| **class1c library refit** | step 18: realign class1c's library hits and rebuild | **closed**: library hits = seed | 10-29 | Part 5 | `class1c` |
| **class1c borderline** | step 17: add KY370101 / ON949931 / NC_025677 | **closed**: no variant accepted | 10-30 | Part 5 | `class1c` |
| **1b/1c merge** | one model or two | **closed**: keep both, lower E wins per site | 10-30 | Part 6 | `class1c` |
| **Class_1b + novel hits** | add the 68 library hits absent from its seed | **paused**: AB021287 `--max` check; re-run on the accepted cluster-5 baseline, not the original | 11-03 | Part 6 | `class1b` |
| **loquat 110** | explorer cluster 110, Loquat jingmen-related virus 1 | **closed**: cl3 hits all three sites | 10-29 | Part 3 | `cl3` |

## Candidate cards — 2026-11-02

One card per live candidate: what it is, where its files are, which gates it has passed.
Gates are in Part 8 (Build procedure and gates).

#### `cand_FJIS_261029` — insect-specific flavivirus element (FJIS clusters 5 + 106)

| | |
|---|---|
| members | cluster 106: ON949931 10608, NC_034017 10511, NC_034204 10523; cluster 5: AB981186 10732, MH827524 10759, NC_008604 10707, NC_021069 10735, NC_024299 10747 |
| seed | `build/cand_FJIS_261029/iter_v2_explorer80/mlocarna/results/result-oneblock_edit261102-MATER-wiggle-refined.stk` (explorer 80-nt windows, hand-edited, MATER wiggle-refined) |
| structure | P1 7–10/60–63, P2 11–17/23–29, P3 36–39/48–51, PK A 4–6/53–55, PK B 42–45/67–70 (22 bp); class 1-like layout |
| model | `build/cand_FJIS_261029/iter_v2_explorer80/cm/cand_FJIS_261029.cm` — 8 / 4.44 / clen 82 / 13 bp / 1 bif, calibrated |
| GATE 1 alifold | pooled 80-nt: see run log (the 80-nt pooled alifold row lacks energies) |
| covariation | **passed**: 4 covarying vs 0.2 ± 0.5 expected, avgid 53.1, every nested helix supported; both PKs untested (power 0) |
| library search | 9 hits / 9 accessions at 1e-10, 0 novel: saturated. Extra hit NC_012671 10735 (weak stall, 2/4 reps) |
| relation to class1c | reciprocal: weak one way, moderate the other → sibling family |
| relation to Class_1b | reciprocal moderate both ways (closer than class1c); library sites split cleanly (FJIS 5/5 own, Class_1b 14/14 own); subgroup rebuild test open |
| position overlap, 7 models | not yet checked; in the library no FJIS hit overlaps a Class_1b stall (tandem, downstream) |
| RNAvirus DB | 5 hits at 1e-3, all library viruses: saturated; 4 seed genomes apparently absent from the DB |
| name | `cand_` until accepted; a class 1 name (e.g. class1d) is consistent with the layout but implies the pseudoknots, which are untested |

#### `cand_FJTB_261026` — third FJTB stall downstream of the class 2 pair

| | |
|---|---|
| members | 16 sequences, TBEV serocomplex (explorer cluster 3) |
| model | `cm/cand_FJTB_261026.cm` — 16 / 1.63 / 80 / 23 bp / 2 bifs |
| covariation | 4 covarying of 24, expected 0.4 ± 0.6, avgid 86.29: conserved, low power |
| library search | 17 accessions from 16 |
| open | RNAvirus DB result (10-27); step 14a (diverged class 2 copy?) |

#### `cand_PLLG_260915` — clusterA, tick-associated PLLG

| | |
|---|---|
| members | 12 (clusterA) → recovers 24 of 60 PLLG members |
| model | `cm/cand_PLLG_260915.cm` — 12 / 1.90 / 76 / 15 bp / 0 bifs; refit on 24 fell to eff_nseq 1.55 |
| open | RNAvirus DB result (10-27); `--toponly --incE 1e-10` rerun; whether it already hits PLLG 117 |

#### Superseded candidates

`cand_FJIS_fz106_261029` and `cand_FJIS_fz5_261029` (single-cluster, 171-nt windows, 10-30) are
superseded by `cand_FJIS_261029` (pooled, 80-nt, 11-02). Their run-log tables are kept.


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
| **HPPV** | 40 | 21 | 17 | 0.567 | Sept genus pool set aside at −3.56, built from `downstream_seq` | — | explorer cluster 39 (4 rodent pegiviruses); FASTA 4/4 | not yet | — | — | — |
| **FJIS** | 34 | 20 | 14 | 0.620 | none. Dereplicate *Quang Binh virus* (4 accessions). cluster 106 has a sub-threshold class1c match (ON949931) | — | explorer cluster 5 + cluster 106 → `cand_FJIS_261029` | 80-nt pooled + MATER: 4 covarying (11-02) | built 11-02 | 9 hits, saturated | — |
| **FJJI** | 57 | 50 | 13 | 0.549 | none; Jingmenvirus genus has no CM coverage at all. Spread 181 nt | — | explorer cluster 41 (12), cluster 44 (8); FASTA 12/12, 8/8 | not yet | — | — | — |
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
  was expected to be class 3: its three sites form their own frozen cluster, **cluster 110** — OL344024 3003 (SF 0.514),
  OL344026 2862 (0.610), OL344028 1907 (0.511), one per segment accession, all 10 mM only, genus
  Unannotated, "None found" under the 4 models. If cl3 hits them, cluster 110 leaves the no-hit pool and
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

- **cluster 110 is class 3, not a new class.** It leaves the no-hit pool. One cl3 site per segment
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
- Frozen **cluster 137** (19 nodes, Pangolin pestiviruses) is entirely class1c. **cluster 130** is 8 class1c +
  7 Class_1b + 1 none. **cluster 131** is 48 Class_1b + 10 class1c + 11 none, and holds KY370101 12807
  and NC_025677 12710. The LocARNA clustering does not separate class1b from class1c, so cluster
  membership is not evidence for either in step 17.
- Below 30 bits: MN587659 10202 (20.9, `cm 1–34`, 3′-truncated by the 80 nt window),
  **ON949931 10608 (13.3, `cm 1–84`)**, KY370101 12807 (13.1, `cm 9–53` — partial in the
  80 nt window, full-length on the reference), NC_025677 12710 (10.2, `cm 31–46`).
- **ON949931's sub-threshold class1c span begins exactly at its stall 10608** (SF 0.900), the same
  geometry as KY370101. Its cluster **cluster 106** is three FJIS sites, all high SF: *Xishuangbanna
  aedes flavivirus* NC_034017 10511 (0.942), *Menghai flavivirus* NC_034204 10523 (0.840),
  *Kilpisjarvi flavivirus* ON949931 10608 (0.900). Neither of the other two scores ≥ 10 bits.
  So cluster 106 is an FJIS element with weak class1c resemblance in one member — a candidate of its
  own first, and a class1c relative only if the FJIS model and class1c score each other's seeds.

Node table with the class1c call: `explorer_nodes_class1c_20261029.tsv`.

**No-hit frozen clusters by inferred subclade** (≥ 3 nodes; 80 nt windows, so re-extract from the
reference before aligning):

| cluster | n | inferred clade | members | SF | detected | note |
|---|---:|---|---|---|---|---|
| 41 | 12 | FJJI | Jingmen tick virus ×7, Takachi, Heilongjiang tick, Alongshan, Yanggou tick | 0.55–0.86 | 10 mM only | stall 2493–2672 |
| 44 | 8 | FJJI | Jingmen tick virus ×6, Rhipicephalus assoc. flavi-like | 0.50–0.65 | mostly both | stall 2448–2563; different segment accessions from cluster 41 — align 41 + 44 together once, to test one element across segments |
| 3 | 8 | FJTB | TBEV serocomplex | 0.51–0.70 | 1 mM only | = `cand_FJTB_261026` |
| 5 | 5 | FJIS | Culex flavivirus, Quang Binh, Mosquito flavivirus ×2, Nienokoue | 0.69–0.90 | 10 mM only | pooled with cluster 106 as **`cand_FJIS_261029`**, 2026-11-02 |
| 39 | 4 | HPPV | rodent pegiviruses | 0.73–0.84 | 10 mM only | |
| 106 | 3 | FJIS | NC_034017, NC_034204, ON949931 | 0.84–0.94 | both | sub-threshold class1c in ON949931; pooled with cluster 5 as **`cand_FJIS_261029`**, 2026-11-02 |
| 110 | 3 | FJJI-related (plant host) | *Loquat jingmen-related virus 1*, one site per segment | 0.51–0.61 | 10 mM only | **class 3** — cl3 26.0–36.8 bits on all three (2026-10-29); out of the no-hit pool |
| 64 | 3 | FJTB | MT354614 10670, NC_001672 10912, NC_027709 10641 | 0.51–0.63 | one condition each | gap FJTB 64, not looked at |
| 117 | 3 | PLLG | ON408075 15841, ON811709 16053, ON811731 16056 (Bole tick virus 4, Flaviviridae sp.) | 0.54–0.59 | mostly 1 mM | gap PLLG 117; check against `cand_PLLG_260915` |

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

Results of the laptop run: cluster 41 12/12, cluster 44 8/8, cluster 5 5/5, cluster 106 3/3, cluster 39 4/4, cluster 110 3/3
(cluster 41 and cluster 5 after the `--ref` fix). Files in
`build/class1c/explorer_scan_261029/<name>.{fetchlist,fa}`.

### FJIS candidates: cluster 106 and cluster 5 — 2026-10-30 to 11-02

The first two no-CM explorer clusters taken to alignment. Both are insect-specific flaviviruses
(FJIS), both high stall fraction, and neither has any CM hit at these positions.

| candidate | members (stall, SF) |
|---|---|
| `cand_FJIS_fz106_261029` | ON949931 *Kilpisjarvi flavivirus* 10608 (0.900), NC_034017 *Xishuangbanna aedes flavivirus* 10511 (0.942), NC_034204 *Menghai flavivirus* 10523 (0.840) |
| `cand_FJIS_fz5_261029` | AB981186 mosquito flavivirus 10732, MH827524 *Quang Binh virus* 10759, NC_008604 *Culex flavivirus* 10707, NC_021069 mosquito flavivirus 10735, NC_024299 *Nienokoue virus* 10747 (SF 0.69–0.90) |

Not to be confused with *Aedes flavivirus* (KC181923, KJ741266, LC536088): Class_1b sites, cluster 133.

**Why cluster 106 is its own candidate and not part of class1c.** ON949931 10608 is a *sub-threshold*
class1c match (13.4 bits, E 0.052), not a class1c hit. Adding it to class1c's seed (step 17
variant `on`, Part 5) lifted the other two cluster 106 members exactly at their stalls (NC_034017 25.3
bits, E 5.1e-06; NC_034204 23.0 bits, E 2.8e-05), so the three share an element that resembles
class1c. But those hits do not reach E 1e-10, and the same model starts reaching Class_1b sites.

**class1c-guided seed — tried 2026-10-30, abandoned.** The three spans from the `on` search,
`cmalign`ed to the original `class1c.cm`:

| span | model cols | trunc | bits | avg PP |
|---|---|---|---:|---:|
| ON949931 419–499 | 1–84 | no | 1.55 | 0.892 |
| NC_034017 177–250 | 1–75 | 3′ | 1.33 | 0.846 |
| NC_034204 170–244 | 1–74 | 3′ | −2.14 | 0.790 |

Extended to hit start + 99 nt, the fit got worse instead of reaching column 84: `cm 1–35`,
`17–66`, `1–70`, −12 to −15 bits. Whatever resemblance there is ends near class1c column 75 and
is weak; class1c's structure does not describe these sequences. Files:
`build/cand_FJIS_fz106_261029/iter_v1_class1c_guided/`.

**De novo alignment, 2026-10-30.** mlocarna `--probabilistic --consistency-transformation` on the
reference windows (stall −20 / +150), fetched by `explorer_cm_scan.py fetch --ref`:

| candidate | seqs | cols | alifold (total = energy + covariance) | bp | covariance / bp |
|---|---:|---:|---|---:|---:|
| `cand_FJIS_fz106_261029` | 3 | 185 | −69.58 = −35.17 + −34.42 | 50 | −0.69 |
| `cand_FJIS_fz5_261029` | 5 | 156 | −80.63 = −54.10 + −26.53 | 50 | −0.53 |
| `cand_FJIS_261029` (pooled) | 8 | 194 | −50.10 = −27.19 + −22.91 | 43 | −0.53 |

Totals from ~170 nt windows are not comparable with the earlier ≤ 80 nt references; per base
pair, cluster 106 and cluster 5 are comparable to hepaci (≈ −0.5, kept) and below clusterA (−0.90).
**Pooling is worse than either cluster alone**, so cluster 5 and cluster 106 stay separate candidates. The
consensus structures span the whole window; the stall is near column 21.

**R-scape `-s`, 2026-11-02**, on the mlocarna alignment after joining LocARNA's two blocks
(`stk_oneblock`, Part 8 — R-scape refused the raw file with `duplicate seq name`):

| | cluster 106 | cluster 5 |
|---|---|---|
| base pairs tested | 49 | 50 |
| significant (E < 0.05) in structure | 1: 128–149 | 2: 87–141, 88–140 |
| significant, not in structure | 1: 22–181 | 0 |
| helix with covariation | 126–133 / 144–151 (1 of 8 bp) | 80–88 / 140–150 (2 of 9 bp) |
| power of tested pairs | 0.00–0.10 | 0.00–0.10 |

Underpowered: most pairs have 0–2 substitutions, the stall-proximal region (columns ~1–75) almost
none. The few supported helices lie ~60–130 nt downstream of the stall, so they may belong to a
downstream structure rather than to the element at the stall. Outputs:
`build/<candidate>/rscape/result-oneblock_1.{cov,power,helixcov,R2R.sto.pdf}`.

**Next (as written 10-30; done 11-02 for the pooled candidate, below).** MATER: trim each alignment to the element that starts at the stall and decide whether
the downstream helices belong to it; record R-scape / trimming / pseudoknot / CaCoFold changes with
`clog`. Then a preliminary model (plain `cmbuild` — no `--hand`, the mlocarna alignment has no RF),
`cm_iterate.sh --check-only` against the library and then the RNAvirus database. Once an cluster 106
model exists, score it on class1c's seed and class1c on its seed: strong both ways = one family,
weak both ways = siblings sharing an architecture.

#### Superseded reading of the 171-nt runs (2026-11-02)

The R-scape support in the 171-nt alignments sat 60–130 nt past the stall, in a downstream
stem-loop that is not part of the element; the stall-proximal region was untested. The
single-cluster candidates above are superseded by the pooled 80-nt candidate below.

#### `cand_FJIS_261029`: pooled, 80-nt windows, MATER edit — 2026-11-02

**Windows.** The explorer's own `downstream_seq` (starts at the stall, 80 nt for all 8), written by
`explorer_cm_scan.py seqs` into `build/class1c/explorer_scan_261029/FJIS_{fz106,fz5}_explorer80.fa`.

**mlocarna, 80-nt** (`build/<candidate>/iter_v2_explorer80/`):

| candidate | alifold (total = energy + covariance) |
|---|---|
| cluster 106 (3) | −25.65 = −13.97 + −11.68 |
| cluster 5 (5) | −28.97 = −15.96 + −13.01 |
| pooled (8) | not captured (row has the structure only) |

R-scape on the raw 80-nt alignments: cluster 106 2 of 18 pairs (13–24, 16–21), cluster 5 none in structure,
pooled 2 of 11 (33–46, 35–44); all underpowered. Support now sits near the stall.

**Manual edit and MATER** (both in `iter_v2_explorer80/mlocarna/results/`):

- `result-oneblock_edit261102.stk` — hand edit of the pooled alignment;
- `result-oneblock_edit261102-MATER-wiggle-refined.stk` — wiggle-refined; **the seed**.

| element | columns | canonical, cluster 106 | canonical, cluster 5 |
|---|---|---:|---:|
| P1 | 7–10 / 60–63 | | |
| P2 | 11–17 / 23–29 | (P1–P3) 39/45 | 63/75 |
| P3 | 36–39 / 48–51 | | |
| PK A (5′ end) | 4–6 / 53–55 | 9/9 | 15/15 |
| PK B (P3 loop → downstream) | 42–45 / 67–70 | 12/12 | 13/20 |
| all 22 bp | | 91 % (edit 82 %) | 83 % (edit 79 %) |

**R-scape** (MATER, `-s --onemsa`; output in
`…/results/result-oneblock_edit261102-MATER-wiggle-refined-MATER-R-scape/`, `.zip` beside it;
command-line run in `iter_v2_explorer80/rscape_refined/` gives identical results):
avgid 53.08, 22 bp, **4 covarying vs 0.2 ± 0.5 expected**, FP 0, PPV 100; covarying P1 9–61,
P2 17–23, P3 37–50 and 39–48 (E 0.010–0.049). PK A and PK B: 0–2 substitutions, power 0.
Covariation between cluster 5 and cluster 106 sequences is the evidence that the two clusters share one
structure.

**Model**: plain `cmbuild` (no RF), `cmcalibrate` → `iter_v2_explorer80/cm/cand_FJIS_261029.cm`,
8 / 4.44 / clen 82 / 13 bp / 1 bif. cmbuild drops the two letter-pair pseudoknots, as for all
classes, and placed 2 of the 15 bracket pairs in insert columns.

**Library search** (`cm_iterate.sh --check-only`, `--incE 1e-10`; `iter_v2_explorer80/search_library/`):
9 hits / 9 accessions, 0 novel — the 8 seed sites (each starting at its stall; MH827524 594 =
stall 10759) plus **NC_012671** (Quang Binh virus) 544–623, 78.6 bits, genomic 10735. In the
261021 10 mM table that position has a stall at 2 of 4 replicates, SF 0.311 — it failed the
≥ 3-replicate gate; nothing passing at 1 mM. Element present, stall weak. In Culex flavivirus and
Quang Binh virus the element lies downstream of the Class_1b stalls (feature 544–709 vs 114–466).

**Reciprocal test with class1c** (`iter_v2_explorer80/cm/{class1c_on_fjis_seed,fjis_on_class1c_seed}.tbl`):
class1c on the 8 FJIS seeds — only ON949931, 13.3 bits. FJIS model on the 46 class1c seeds — 12
hits: 8 pangolin pestiviruses full-length, 12.5–21.9 bits (ON024090 E 6.8e-06); 4 hepaciviruses
partial (cm 11–42 / 26–42), 7.6–10.9 bits. Weak one way, moderate the other: **siblings, not one
family.**

**Before acceptance** (card above): Class_1b reciprocal + library overlap; RNAvirus DB search and
`cmalign --mapali` of novel hits; R-scape on the expanded alignment (pseudoknot power); position
overlap with all 7 models; name; deployment (cm/, MANIFEST, new cm_set, cluster steps 10–13).

```bash
# Class_1b comparison (not yet run)
SEED1B=~/Desktop/viromelib/work/infernal/cm/seeds/CL_Class_1b_xrRNA_final.sto
FJIS_TBL=$ITER/search_library/r0/search.tbl
python3 $FLAVISCRIPTS/cm_round_stats.py overlap "$FJIS_TBL" "$C1C/iter_v2_borderline/vs_class1b/class1b.tbl" FJIS class1b | tail -4
python3 $FLAVISCRIPTS/cm_round_stats.py overlap "$FJIS_TBL" "$C1C/tblout/class1c_20260917.tbl" FJIS class1c | tail -4
esl-reformat fasta "$SEED1B" > "$ITER/cm/class1b_seed_ungapped.fa"
cmsearch --toponly -T 0 -o /dev/null --tblout "$ITER/cm/class1b_on_fjis_seed.tbl" "$CMSET/CL_Class_1b_xrRNA_final.cm" "$ITER/cm/fjis_seed_ungapped.fa"
cmsearch --toponly -T 0 -o /dev/null --tblout "$ITER/cm/fjis_on_class1b_seed.tbl" "$ITER/cm/$CAND.cm" "$ITER/cm/class1b_seed_ungapped.fa"

# RNAvirus database (long)
DB=~/Desktop/viromelib/work/infernal/fa/RNAvirus_CompleteAssem_No_CoV-2.fa
$FLAVISCRIPTS/cm_iterate.sh --name "$CAND" --cm "$ITER/cm/$CAND.cm" --seed "$REFINED" \
  --target "$DB" --label RNAvirusDB --workdir "$ITER/search_RNAvirusDB" --doc "$DOC" --check-only
```

#### Class_1b comparison and the RNAvirus database — 2026-11-02

**Reciprocal scoring with Class_1b** (`iter_v2_explorer80/cm/{class1b_on_fjis_seed,fjis_on_class1b_seed}.tbl`):

- FJIS model on the 88 Class_1b seeds: 13 hit, the best being insect-specific flavivirus (ISF)
  copies — Mercadeo virus NC_027819 xr1 24.3 bits (E 2.6e-06), Nienokoue virus NC_024299 xr1 21.5 /
  xr2 19.6, Parramatta River virus NC_027817 xr4 18.9 / xr1 12.3, Aedes flavivirus NC_012932 xr3 13.2.
- Class_1b on the 8 FJIS seeds: 4 hit, all cluster 5 (NC_024299 19.1 bits, E 1.7e-04; NC_021069,
  MH827524, AB981186 10.7–12.7 bits); cluster 106 none.

Moderate both ways, so **closer to Class_1b than to class1c**. Cluster 5's element looks like a
further, diverged downstream copy in the ISF class 1b tandem array.

**Per-site split in the library** (`cm_round_stats.py overlap`, rows where either hit is included;
`iter_v2_explorer80/cm/fjis_vs_class1b_library_overlap.tsv`):

| sites | FJIS | Class_1b | lower E |
|---|---|---|---|
| FJIS's own: AB981186, MH827524, NC_012671, NC_021069, NC_024299 629–709 | included, 61.5–78.7 bits | not included, 10.7–20.4 bits | FJIS, 5 of 5 |
| Class_1b's own: BK013349, KC181923, KJ741266, LC536088, NC_021154, NC_024299 92–185 and 230–315, NC_040815, OM030328/9 ×2, OX394158 | not included, 8.5–23.0 bits | included, 26.0–53.8 bits | Class_1b, 14 of 14 |

No site is included by both; at every overlap the including model has the lower E. Nienokoue virus
(NC_024299) carries three copies in a row: Class_1b at 92–185 and 230–315, FJIS at 629–709.

**RNAvirus database** (`iter_v2_explorer80/search_RNAvirusDB/r0/search.tbl`): 3 hits at 1e-10, 5 at
1e-5 and 5 at 1e-3 — NC_021069, NC_012671, NC_008604, NC_034204, NC_034017, all library viruses.
Four seed viruses (AB981186, MH827524, NC_024299, ON949931) score 52–79 bits in the library but do
not appear at all, so the database most likely lacks those genomes. Next: confirm with `esl-sfetch`,
read the hits down to E 10 by position (a real member sits downstream of the genome's Class_1b
copies), and if the database is too narrow, search a targeted set of complete ISF genomes from NCBI.

**Open question: is it a Class_1b subgroup?** The clean split says the two current models own
separate sites, but Class_1b is a weak, broad model (median E 4.0e-06), so the split could reflect
the model rather than the RNA. The decisive test is the one used for every merge here: append the
FJIS sequences to the Class_1b seed with `cmalign --mapali`, rebuild with Infernal 1.1.2
(`--hand`), and compare per hit with the original Class_1b (Part 6, the novel-hits method). Class_1b subgroup
if: the added sequences align to Class_1b's structure with high posterior probability across the
model, no existing Class_1b hit is lost or drops much, and the FJIS sites become included.
Separate family if: they align with low PP or truncate, or existing hits are lost. Block below
(`build/class1b/iter_v3_plusFJIS/`).

```bash
SEED1B=~/Desktop/viromelib/work/infernal/cm/seeds/CL_Class_1b_xrRNA_final.sto
CL1B=$CMSET/CL_Class_1b_xrRNA_final.cm
CLASS1B_SATURATION=$INFERNAL/build/class1b/iter_v1_saturation/r0
PLUS=$INFERNAL/build/class1b/iter_v3_plusFJIS; mkdir -p "$PLUS"
awk '$1!~/^#/ && $17=="!" {print $1"/"$8"-"$9, $8, $9, $1}' "$ITER/search_library/r0/search.tbl" > "$PLUS/fjis_all.fetchlist"
grep -vE '^(ON949931|NC_034017|NC_034204)' "$PLUS/fjis_all.fetchlist" > "$PLUS/fjis_cluster5.fetchlist"
wc -l "$PLUS"/*.fetchlist                                   # expect 9 and 6
for SUBSET in cluster5 all; do
  MODEL=class1b_plusFJIS_${SUBSET}_inf112; OUT=$PLUS/$SUBSET; mkdir -p "$OUT"
  esl-sfetch -Cf "$FA" "$PLUS/fjis_$SUBSET.fetchlist" > "$OUT/${MODEL}_added.fa"
  cmalign --cpu 4 --mapali "$SEED1B" -o "$OUT/$MODEL.stk" "$CL1B" "$OUT/${MODEL}_added.fa" > "$OUT/${MODEL}_cmalign.log"
  echo "== $SUBSET: added sequences aligned to Class_1b (cm from-to, trunc, bits, avg PP)"
  grep -v '^#' "$OUT/${MODEL}_cmalign.log" | awk 'NF>=8 {print $2, $4"-"$5, $6, $7, $8}'
  conda run -n infernal112 cmbuild --hand -F -n "$MODEL" "$OUT/$MODEL.cm" "$OUT/$MODEL.stk" > "$OUT/${MODEL}_cmbuild.log"
  conda run -n infernal112 cmcalibrate --cpu 4 "$OUT/$MODEL.cm" > "$OUT/${MODEL}_cmcalibrate.log"
  cmsearch --toponly --incE 0.01 --cpu 4 -o /dev/null --tblout "$OUT/${MODEL}_library.tbl" "$OUT/$MODEL.cm" "$FA"
  conda run -n infernal112 cmstat "$OUT/$MODEL.cm" | grep -v '^#'
  python3 $FLAVISCRIPTS/cm_round_stats.py compare "$CLASS1B_SATURATION/search.tbl" "$OUT/${MODEL}_library.tbl"
  grep -E 'AB021287|MH307700|NEW|LOST' "$OUT/${MODEL}_library.tbl.compare.tsv"
done
```

#### The element is the published P1-deviant ISF subtype — and part of it is already in the Class_1b seed (2026-11-02)

**Literature.** [Ochsenreiter *et al.* / Villordo-type survey, PMC7527734](https://pmc.ncbi.nlm.nih.gov/articles/PMC7527734/)
describes a subset of putative ISF xrRNA sequences that "deviated from the covariance model at the
base of P1", found in the **more-downstream copies** (xr3, xr4, …), and names four:

| published name | accession here | where it turns up in this work |
|---|---|---|
| PaRV_xr4 (Parramatta River virus 92-B115745) | NC_027817 | **new hit at feature 544** (stall 10757, SF 0.873) in the `cluster5` rebuild |
| CFAV_xr3 (cell fusing agent virus Galveston) | NC_001564 (seed); LR694076 / MH237596 in the library | **already a Class_1b seed sequence** (below); library sites 10565 / 10555 |
| MECDV_xr1 (Mercadeo virus ER-M10) | NC_027819 | new hit at feature 561 in the `cluster5` rebuild |
| MFV_xr1 (Menghai flavivirus MHAedFV1) | NC_034204 | **cluster 106** member (stall 10523) |

Their question was left open: "whether they possibly form a subtype within subclass 1b". The
rebuild (above) is evidence for that reading — adding these sequences to the Class_1b seed loses no
existing hit and gains their sites. Only a 2-bp P1 could be proposed for PaRV_xr4 in that work;
the MATER edit of the pooled 80-nt alignment gives P1 as 4 bp (columns 7–10 / 60–63), one of which
(9–61) covaries.

**Three of their four are in cluster 5; the fourth, Menghai flavivirus, is in cluster 106** — the
part that broke the Class_1b rebuild (PP 0.45–0.49, 5′-truncated, 11 hits lost). So cluster 106 may
be the diverged end of the same subtype rather than a separate family. Test it on its own: add only
NC_034204 to the Class_1b seed and judge by the same rule.

**CFAV xr3 is already a Class_1b seed sequence.** The seed contains all three CFAV copies —
`CFAV_NC_001564-2_10173-10247_xr1`, `…_10260-10335_xr2`, `…_10555-10632_xr3`. So the original
Class_1b model already hits the library's CFAV xr3 sites, and the expansion only strengthens them:

| CFAV site (genomic) | Class_2 | Class_1b | `class1b_plusFJIS_cluster5` |
|---|---|---|---|
| LR694076 10184 / MH237596 10172 (xr1) | 13.5 / 12.7 bits, E 2.2e-03 / 3.6e-03, **cm 17–63** | 33.8 / 35.8 bits, E 3.1e-07 / 1.2e-07, cm 1–81 | 34.1 / 36.2 bits |
| LR694076 10270 / MH237596 10258 (xr2) | 12.4 / 10.9 bits, E 4.3e-03 / 1.1e-02, cm 18–62 | 32.8 / 30.8 bits, cm 1–81 | 33.2 / 31.2 bits |
| LR694076 10565 / MH237596 10555 (xr3) | no hit | **19.9 bits, E 2.2e-04, cm 1–81** | 23.4 bits, E 5.6e-05 |

- **CFAV is not a Class_2 exception here.** Class_2 reaches xr1 and xr2 only partially (cm 17–63 of
  93) and ~4 orders of magnitude weaker in E than Class_1b, which matches the whole model full
  length. That is the same weak partial cross-family pattern seen throughout (the FJIS model
  reached Class_1b sites at 8–23 bits), so **on its own it is not evidence that CFAV bridges
  class 1b and class 2.** Whether CFAV is special needs the comparison below: does Class_2 reach
  other Class_1b sites equally?
- **A published class-2 attribution for CFAV would be a labelling difference, not a conflict**: the
  provided `CL_Class_1b` seed claims all three CFAV copies by name.

**No annotation discrepancy — resolved 2026-11-03.** A first reading claimed the original Class_1b
hit LR694076 stall 10565 above threshold while the annotation called it unannotated. That was an
error: the E 2.2e-04 came from a `cmsearch` of a **2-sequence file**, which is not comparable with a
full-library search. The annotation tblout (`06_infernal/260807_trueRef`) does contain the rows, as
`?` below inclusion, with identical bit scores:

| site | annotation tblout | `class1b_plusFJIS_cluster5` |
|---|---|---|
| LR694076 476–553 (stall 10565) | 19.9 bits, E 0.067, `?` | 23.4 bits, `!` |
| MH237596 478–555 (stall 10555) | 19.9 bits, E 0.067, `?` | 23.4 bits, `!` |
| NC_027817 543–636 (PaRV xr4) | 22.3 bits, E 0.021, `?` | 28.3 bits, `!` |
| NC_027819 561–637 (MECDV xr1) | 22.3 bits, E 0.021, `?` | 27.7 bits, `!` |

So the annotation is correct, those stalls are genuinely below inclusion, and **the Part 7 counts are
not inflated.** What the tblout does show is sharper: **the original Class_1b leaves four of its own
seed sequences' loci just under the line.** NC_027817 has three Class_1b rows included at 30.7–38.1
bits and then its xr4 at `?`; MECDV's only seed copy, xr1, is also `?`. The expansion raises exactly
these above inclusion. That is what it fixes — a recovery failure on its own P1-deviant members, not
a new family.

#### The base triple, located from the paper's own exception sequences (2026-11-03)

All class 1 xrRNAs need a base triple for the functional fold: U…A-U in MBFV, isosteric C…G-C in
TABV. [PMC7527734](https://pmc.ncbi.nlm.nih.gov/articles/PMC7527734/) reports >97 % conservation for
the G and >97 % and >90 % for the two Cs, and names the only two sequences with the alternative
U…A-U: **CXFV xr1 and xr4**. Both are in the Class_1b seed
(`CXFV_NC_008604-2_10246-10326_xr1`, `…_10598-10675_xr4`), so the triple's columns can be read off
directly as the positions where those two depart from the consensus. They differ at exactly three
well-conserved columns:

| cm column | seed consensus | CXFV xr1 / xr4 | `SS_cons` |
|---:|---|---|---|
| **7** | C 0.97 | U | unpaired, 5′ region |
| **29** | G 0.97 | A | **paired to 43** |
| **43** | C 0.86 | U | **paired to 29** |

**The triple is cm 7 … 29-43.** Two of the three conservation figures match the paper exactly
(>97 % G at 29, >97 % C at 7); their >90 % for the second C reads 0.86 here, consistent with a
different sequence set or gap handling.

A first attempt guessed 30–42 from a "≥90 % conserved G or C" filter plus `SS_cons`. That was wrong:
cm 43, the real partner, sits at 0.86 and the filter excluded it. Conservation level alone cannot
locate a triple — the paper's exception sequences could.

**Membership test on the candidates.** `cmbuild` cannot represent a base triple, so it is invisible
to every model here and has to be read from the alignment:

| sequences | cm 7 | cm 29 | cm 43 | |
|---|---|---|---|---|
| all six cluster-5 | C | G | C | **C…G-C intact** |
| NC_034204 (Menghai, cluster 106) | – | – | – | absent |

cm 29 and 43 lie **inside** Menghai's aligned span (cm 17–78), so those are genuine deletions of the
triple's pair; cm 7 is outside its span, so missing data rather than demonstrated absence, though
`cmalign` placing its 5′ end at column 17 rather than aligning to columns 1–16 is itself
informative. This shows Menghai is not a **Class_1b** member; it could still be a class 1 xrRNA with
a triple at positions this model cannot align, which would need its own structure work.

This is structural evidence independent of every score, and it is the firmest ground under both
decisions: cluster 5 joins Class_1b, cluster 106 does not.

```bash
# (step 1, the annotation tblout check, was run on the cluster 2026-11-03 -- see above)
# 2. is CFAV special, or does Class_2 reach many Class_1b sites?
CL2=$CMSET/CL_Class_2_xrRNA_final.cm
cmsearch --toponly --incE 0.01 --cpu 4 -o /dev/null --tblout "$PLUS/cfav/class2_library.tbl" "$CL2" "$FA"
python3 $FLAVISCRIPTS/cm_round_stats.py overlap "$PLUS/cfav/class2_library.tbl" \
  "$CLASS1B_SATURATION/search.tbl" class2 class1b > "$PLUS/cfav/class2_vs_class1b_overlap.tsv"
tail -1 "$PLUS/cfav/class2_vs_class1b_overlap.tsv"
awk -F'\t' 'NR==1 || ($5=="!" && $9=="!")' "$PLUS/cfav/class2_vs_class1b_overlap.tsv" | column -t
```

Read 2 as: if Class_2 partially reaches many Class_1b sites, CFAV is unremarkable and the
"bridge" idea has no support here. If CFAV's xr1/xr2 are among the few sites Class_2 reaches at
all, the idea is worth recording as a hypothesis — with the caveat that a partial match over
cm 17–63 is weak evidence either way, and the published structures, not these models, would
settle it.

#### Membership of the expanded Class_1b: what went in, what was kept out (2026-11-03)

Added here on request, because the six added sequences were previously recorded only in pieces —
the gap register, the candidate card, the reciprocal-scoring table and four run-log rows — with no
single list. **This table is authoritative for the composition of
`class1b_plusFJIS_cluster5_inf112`.**

**Added to the seed: 6 sequences.** All six are the `!` library hits of the FJIS candidate model
(`cand_FJIS_261029`), minus the three cluster-106 accessions — the `fjis_cluster5.fetchlist`
built by the block above. They entered by `cmalign --mapali`, so the 88 original Class_1b seed
sequences are untouched: 88 + 6 = 94 (`cmstat` 94 / 50.24 / clen 81 / W 255 / 19 bp / 2 hairpins).

| # | accession | virus | explorer stall | how it relates to the original Class_1b seed |
|---:|---|---|---:|---|
| 1 | `NC_008604.2` | *Culex flavivirus* (CXFV) | 10707 | **fifth array copy**, just downstream of the seed's own xr4 (ends 10675). The seed holds xr1–xr4 of this genome, including the two U…A-U triple exceptions |
| 2 | `NC_012671.1` | *Quang Binh virus* (QBV, reference) | 10735 | **fifth array copy** (seed xr4 ends 10703). **Not an explorer cluster-5 member** — see the caveat below |
| 3 | `NC_021069.1` | mosquito flavivirus | 10735 | **fifth array copy** (seed xr4 ends 10704) |
| 4 | `NC_024299.2` | *Nienokoue virus* (NIEV) | 10747 | **fifth array copy** (seed xr4 ends 10716). This genome ends up with a **three-copy array**: Class_1b at features 92–185 and 230–315, FJIS at 629–709 |
| 5 | `AB981186.1` | mosquito flavivirus | 10732 | **genome absent from the seed entirely** |
| 6 | `MH827524.1` | *Quang Binh virus* | 10759 | **genome absent from the seed entirely** |

So the expansion does two things: it **extends the ISF tandem array by one copy** at a consistent
position (10707–10759) in four genomes the seed already covered, and it **brings in two genomes the
seed never had**.

**Caveat on NC_012671.** It is a *sixth* sequence beyond the five explorer cluster-5 sites, picked
up because the FJIS model hits it at 78.6 bits (feature 544–623, genomic 10735) and the fetchlist
was built from hits, not from cluster membership. Its stall is real but **failed the ≥3-replicate
gate** (10 mM: 2 reps, SF 0.311; 1 mM: nothing within 40 nt), which is why the explorer shows no
stall there. Its relative MH827524 stalls at the same element at SF 0.863. The gap register
therefore says "cluster 5 (+ NC_012671)" and counts 6 sites, not 5.

**What the expansion gained in the library: 10 hits, 0 lost.** Six are the added sequences' own
sites. The other four are **loci of the seed's own sequences that the original model failed to
recover**:

| gained hit | what it is | original Class_1b | expanded |
|---|---|---|---|
| `NC_027817` 543 | Parramatta River virus **xr4** (PaRV_xr4) | 22.3 b, E 0.021, `?` | 28.3 b, `!` |
| `NC_027819` 561 | Mercadeo virus **xr1** (MECDV_xr1) — its only seed copy | 22.3 b, E 0.021, `?` | 27.7 b, `!` |
| `LR694076` 476 | cell fusing agent virus **xr3** (CFAV_xr3), isolate in the library | 19.9 b, E 0.067, `?` | 23.4 b, `!` |
| `MH237596` 478 | the same CFAV xr3 copy, second isolate | 19.9 b, E 0.067, `?` | 23.4 b, `!` |

Those four are exactly the P1-deviant sequences PMC7527734 named. **The expansion closes a recovery
failure on the model's own members rather than defining a new family.**

> **Open inconsistency to resolve.** The rejection of the further additions is stated in terms of
> losing `OP860412 297`, "the hit cluster 5 gained", but `OP860412 297` (stall 10802) is recorded in
> Part 6 as a gain of the **`strong` 1.1.2 variant**, and six own sites + four recovered loci
> already account for all 10 gains. Either the count is 11 or the attribution is wrong. Settle it
> from `cluster5/class1b_plusFJIS_cluster5_inf112_library.tbl.compare.tsv` (`grep NEW`) and correct
> whichever row is wrong. It does not change any decision — every rejected variant lost other hits
> too — but the number should be right.

**Kept out, with the reason in each case.** Nothing here was excluded on judgement; each was tested
and failed the same rule (no included hit may be lost).

| accession | virus | why it was kept out | where |
|---|---|---|---|
| `NC_034017` | *Xishuangbanna aedes flavivirus* | **cluster 106.** The `all` variant (cluster 5 + cluster 106) aligned these at PP 0.38–0.47, truncated at the 5′ end, and lost 11–17 included hits | Part 3, FJIS section |
| `NC_034204` | *Menghai flavivirus* (MFV_xr1) | same variant. Also reads as missing the triple's pair, but its overall PP is 0.465, so that reading is not reliable — the rejection rests on the lost hits | same |
| `ON949931` | *Kilpisjarvi flavivirus* | same variant | same |
| `NC_005064` | *Kamiti River virus* | sub-threshold Class_1b site (stall 11245, 18.5 b, E 0.079). Tested alone as `kamiti` 2026-11-03: aligns best of any addition tried (cm 1–81, PP 0.853) but still loses `OP860412 297` and raises nothing | this Part, above |
| `MW897328` | — (`phaiomys` subset) | sub-threshold Class_1b site (stall 10653, 19.3 b, E 0.057). Tested as `phaiomys`: 3′-truncated, PP 0.622, loses `AB981186 590` and `NC_012671 545` — two of the sequences just added — plus `OP860412 297` | this Part, above |
| the 68 novel library hits | 51 accessions, 45 absent from the seed | the separate `Class_1b + novel hits` extension, a different question from cluster 5. `strong`/`newvirus` lose `AB021287 65`; `all` loses five annotated Class_1b sites. **Still paused** on the AB021287 `--max` check, and that check must now be re-run against the cluster-5 baseline, not the original model | Part 6 |

**Three accessions not to confuse with the above:** `KC181923`, `KJ741266`, `LC536088` are *Aedes
flavivirus*, explorer cluster 133, and were already Class_1b sites before any of this.

#### Adding the two remaining sub-threshold sites to the cluster-5 seed — rejected 2026-11-03

The gap-register row **sub-threshold Class_1b** left two sites: NC_005064 1079 (Kamiti River virus,
= stall 11245) at 18.5 bits / E 0.079 `?`, and MW897328 66 (stall 10653) at 19.3 bits / E 0.057 `?`.
Both start at their stall, so both have Class_1b geometry. Tested by the same rule as cluster 5 —
`cmalign --mapali` onto the accepted cluster-5 seed, `cmbuild --hand`, `cmcalibrate`, library
`cmsearch --toponly --incE 0.01` under Infernal **1.1.2**, compared per hit against the cluster-5
baseline.

Build directory: `build/class1b/iter_v3_plusFJIS/plus_subthreshold/{kamiti,phaiomys,both}/`,
models `class1b_plusSub_<subset>_inf112.{stk,cm,_library.tbl,_library.tbl.compare.tsv}`.

| subset | added | nseq / eff_nseq | clen / W | alignment of the added sequence | lost | gained | lower / worst Δ |
|---|---:|---|---|---|---|---|---|
| `kamiti` | NC_005064 | 95 / 51.72 | 81 / 254 | cm 1–81, not truncated, 7.06 b, **avg PP 0.853** | **OP860412 297** | none | 41 / −0.70 |
| `phaiomys` | MW897328 | 95 / 50.87 | 81 / 251 | cm 1–80, **3′-truncated**, 8.57 b, **avg PP 0.622** | **AB981186 590, NC_012671 545, OP860412 297** | MW897328 itself (23.5 b) | 85 / −1.10 |
| `both` | both | 96 / 52.03 | 81 / 251 | as above | the same three | MW897328 itself (23.4 b) | 83 / −0.90 |

Reading:

- **All three are rejected.** Every variant loses `OP860412 297` — the same hit the cluster-5
  expansion gained — and the two containing MW897328 also lose `AB981186 590` and `NC_012671 545`,
  both of them **cluster-5 member sites**. So adding MW897328 undoes part of the expansion that was
  just accepted.
- **`kamiti` is the near miss.** One hit lost, nothing gained, and its own sequence aligns full
  length at PP 0.853 — the best-aligning addition tried on this model. It still fails the rule
  (no loss is tolerated), and it buys nothing: NC_005064 1079 is not raised to inclusion by its own
  addition.
- **The losses are small in magnitude** (worst Δ −0.70 to −1.10 bits) but they cross the inclusion
  line, which is what the rule is about. 41–85 hits score lower in every variant.
- Together with step 17 and the three earlier rebuild variants, this is the fourth independent
  demonstration that **the expansion is at capacity at cluster 5**. `OP860412 297` is the marginal
  hit in every direction: it is gained by cluster 5 and lost by every further addition.
- The two sites stay open as sites. Neither is Class_1b; both would need either a looser model of
  their own or sequences from outside this library.

#### Reading the triple with alignment windows and posterior probability — 2026-11-03

The flat cm 7 / 29 / 43 readout answers "which residue sits in that column", which is not the same
question as "does this sequence have the triple". It cannot distinguish three different situations,
and all three occur here. The fix is to print the ±2-column **window** around each of the three
positions together with the sequence's `#=GR … PP` row, so insertions and alignment confidence are
visible:

```bash
# windows and posterior probability around the triple columns
python3 - "$PLUS/cluster5/plus_subthreshold/both/class1b_plusSub_both_inf112.stk" <<'PY'
import sys, collections
rf=''; seqs=collections.OrderedDict(); pp=collections.OrderedDict()
for line in open(sys.argv[1]):
    if line.startswith('#=GC RF'): rf += line.split()[2]; continue
    if line.startswith('#=GR'):
        f=line.split()
        if f[2]=='PP': pp[f[1]] = pp.get(f[1],'') + f[3]
        continue
    if line.startswith('#') or line.startswith('//') or not line.strip(): continue
    f=line.split()
    if len(f)==2: seqs[f[0]] = seqs.get(f[0],'') + f[1]
cons=[i for i,c in enumerate(rf) if c.isalpha()]       # uppercase AND lowercase RF = match columns
for n in seqs:
    print(n)
    for k in (7,29,43):
        lo, hi = cons[max(k-3,0)], cons[min(k+1,len(cons))-1]
        print(f"  cm {k-2}-{k+2}  RF {rf[lo:hi+1]}  seq {seqs[n][lo:hi+1]}"
              + (f"  PP {pp[n][lo:hi+1]}" if n in pp else "  PP (none)"))
PY
```

Note on `cons`: Infernal's `RF` line marks match columns with the consensus residue — **uppercase
when well conserved, lowercase when not** — and insert columns with `.`. So `c.isalpha()` is the
correct test and it returns exactly `clen` = 81 columns. An earlier worry that lowercase meant
insert was unfounded; the column count confirms it.

What the three cases look like:

| sequence | windows | PP at cm 7 / 29 / 43 | verdict |
|---|---|---|---|
| the six cluster-5 | no insertions; dots line up with RF dots | **no PP row** | C…G-C, confidence unmeasured |
| NC_005064 (Kamiti) | no insertions | ≈0.97 / ≈0.97 / **≈0.65** | **genuine non-canonical pair** |
| MW897328 | **inserted G beside cm 29 and beside cm 43** | ≈0.55 at cm 29, 0.3 at the insert; 0.5–0.6 at cm 43 | **misalignment; no conclusion** |

- **MW897328 — the flat readout was wrong.** At cm 27–31 the `RF` pattern is `c.G.GGG` and its
  sequence reads `C.GGCGG`: it carries an extra **G in the insert column next to cm 29**, with a C
  in cm 29 itself. `PP *.83566` means ≈0.55 at cm 29 and 0.3 at the insert — a coin flip. cm 41–45
  has a second inserted G at PP 0.5–0.6. Its G is present, one column over. The earlier "C-C, not a
  pair" verdict is an artefact of exactly the one-base shift that was predicted, and the triple
  screen gives **no evidence either way** for this sequence.
- **NC_005064 — a real variant.** Its windows contain no insertions, and PP is `**.***` at cm 5–9
  and `*.*.***` at cm 27–31, so cm 7 = C and cm 29 = G are placed at ≥0.95. cm 43 = U sits at
  ≈0.65. Nothing nearby could be the "real" C, so the most likely reading is a genuine **G·U
  wobble** replacing G-C — a real pair, consistent with the paper's note on non-Watson-Crick pairs
  at the base of P2 in its departing sequences.
- **The six cluster-5 sequences carry no PP row** in this file, because they entered through the
  `--mapali` baseline and their probabilities were not recomputed. Their C-G-C readings are
  therefore unverified for confidence. One alignment measures it:

```bash
cmalign --cpu 4 -o "$PLUS/cluster5/pp_check.stk" "$BASE.cm" \
  "$PLUS/cluster5/class1b_plusFJIS_cluster5_inf112_added.fa" > "$PLUS/cluster5/pp_check.log"
# then run the window script above on pp_check.stk
```
  Their windows show no insertions, so high PP is expected, but it should be measured rather than
  assumed. **Not yet run.**

**Consequences for the decisions: none, but the grounds change.** Both further additions remain
rejected and the expansion stops at cluster 5 — on the rebuild losses above, which are unaffected.
What changes is what the triple screen is allowed to claim: for MW897328 it claims nothing, and the
same caveat applies to **Menghai**, whose overall PP is 0.465, so its apparent deletions at cm 29
and 43 could also be alignment failure. Menghai's rejection rests on the 11–17 lost hits alone, not
on the triple. Earlier text in this file that leans on Menghai's missing triple is overstated.

#### Should the seed be shifted so the triple aligns? — no (2026-11-03)

The answer is no, for three reasons, and there is a measurement that would change it.

1. **A shift cannot make the model see the triple at all.** `cmbuild` has no base-triple state.
   cm 7's interaction with the 29-43 pair is absent from the model under *every* column
   arrangement. Moving or adding columns changes which residues `cmalign` places where; it does not
   add the constraint. So a shift could only improve the *readout*, never the model's power.
2. **The current layout is right for the family and wrong only for MW897328.** The 138 included
   sites align with the insert columns empty; MW897328 has a residue there. Adding a consensus
   column to absorb that insert asserts that every member should have a residue at that position,
   which is false for the other 137, and raises `clen` from 81 to 82. That is in effect what the
   three variant rebuilds did, and all three lost hits — `OP860412 297` in every one. The
   experiment has already been run.
3. **A seed describes the consensus, not the hardest member.** A single sequence with an insertion
   *is* an insertion. The way to read its triple is the insert column, which is what the window
   script does. The seed changes only if the insert is the majority state.

**The measurement that would change the answer.** Count how many included library sites actually
occupy the insert columns flanking cm 29 and cm 43. A handful means sequence-level variation; a
substantial fraction means the seed is misdescribing the family there and a column should be added
(edit `RF` in the seed `.sto`, rebuild with `cmbuild --hand`, re-run the whole comparison).

```bash
C5=$PLUS/cluster5/class1b_plusFJIS_cluster5_inf112
python3 $FLAVISCRIPTS/cm_round_stats.py fetch "${C5}_library.tbl" 81 0.70 "$PLUS/cluster5/insertcheck"
esl-sfetch -Cf "$FA" "$PLUS/cluster5/insertcheck.fetchlist" > "$PLUS/cluster5/insertcheck.fa"
cmalign --cpu 4 -o "$PLUS/cluster5/insertcheck.stk" "$C5.cm" \
  "$PLUS/cluster5/insertcheck.fa" > "$PLUS/cluster5/insertcheck.log"

python3 - "$PLUS/cluster5/insertcheck.stk" <<'PY'
import sys, collections
rf=''; seqs=collections.OrderedDict()
for line in open(sys.argv[1]):
    if line.startswith('#=GC RF'): rf += line.split()[2]; continue
    if line.startswith('#') or line.startswith('//') or not line.strip(): continue
    f=line.split()
    if len(f)==2: seqs[f[0]] = seqs.get(f[0],'') + f[1]
cons=[i for i,c in enumerate(rf) if c.isalpha()]
for k in (7,29,43):
    lo = cons[k-2]+1 if k > 1 else 0        # first alignment column after cm k-1
    ins = [i for i in range(lo, cons[k-1]) if not rf[i].isalpha()]
    occ = sum(1 for n in seqs if any(seqs[n][i] not in '-.~' for i in ins))
    print(f"cm {k}: {len(ins)} insert column(s) before it, occupied in {occ}/{len(seqs)} sequences")
PY
```

**What would genuinely improve triple detection is not a shift but a different instrument.** No
Infernal 1.1.x model can represent the triple, so the CM's role is recruitment only. The triple is
read from a structure-aware alignment with the pseudoknot annotated — the MATER / R-scape route
already used for the candidates — and the CM alignment is used for it only with the insert columns
and PP in view, as above. Recorded as a standing rule in Part 8.

#### Next for cluster 106 (Xishuangbanna / Menghai / Kilpisjarvi): align it alone at 80 nt — 2026-11-03

**Where this leaves cluster 106.** Four routes have now been closed on it. It is not class1c (the
class1c-guided seed gave 1.55 / 1.33 / −2.14 bits and got worse when extended). It is not Class_1b
(the `all` variant aligned it at PP 0.38–0.47, 5′-truncated, and lost 11–17 included hits). Its own
171-nt alignment put the only covariation 60–130 nt past the stall, in a downstream stem-loop that
is not the element. And pooling it with cluster 5 was worse per base pair than either cluster alone
(−0.53 vs −0.69), so the pooled `cand_FJIS_261029` describes cluster 5, not cluster 106 — which is
why the pooled model's RNAvirus DB search says nothing about cluster 106's relatives.

**The one thing not yet tried: cluster 106 alone at 80 nt.** Every conclusion about it comes from
either the 171-nt windows (superseded — the structure ran past the element) or the pooled alignment
(dominated by cluster 5's five sequences). The 80-nt FASTA already exists, so this is cheap:

```bash
C106=$INFERNAL/build/cand_FJIS_cluster106_261103/iter_v1_explorer80
mkdir -p "$C106"
# the 80-nt windows already exist from 10-29 (file still uses the old `fz` spelling)
FA106=$INFERNAL/build/class1c/explorer_scan_261029/FJIS_fz106_explorer80.fa
grep -c '^>' "$FA106"          # expect 3: ON949931, NC_034017, NC_034204

mlocarna --stockholm --consensus-structure=alifold --probabilistic --consistency-transformation \
  --tgtdir "$C106/mlocarna" "$FA106" > "$C106/mlocarna.log" 2>&1
RES=$C106/mlocarna/results
stk_oneblock "$RES/result.stk" "$RES/result-oneblock.stk"
echo "alifold: $(alifold_line "$C106/mlocarna.log")"
R-scape -s --cacofold --outdir "$C106/rscape" "$RES/result-oneblock.stk"
ls "$C106/rscape"/*.cov >/dev/null 2>&1 && head -20 "$C106"/rscape/*.sorted.cov
clog cand_FJIS_cluster106_261103 'mlocarna on the 3 explorer 80-nt windows, cluster 106 alone' '<alifold line, R-scape significant pairs and power>'
```

**Be clear about what this can and cannot settle.** Three sequences at 0.84–0.94 identity give
R-scape essentially no power — measured at 0.00–0.10 on the 171-nt run, and 80 nt will not improve
it. So **this alignment cannot pass the covariation gate, and is not being run to try.** It is being
run for one thing only: a consensus secondary structure in **cluster 106's own coordinates**, so the
open question the triple section leaves can be asked properly —

> does cluster 106 have a base triple at a position the Class_1b model cannot align?

Menghai's apparent deletion at cm 29 / 43 was read off an alignment with overall PP 0.465, which is
not evidence (Part 8, pitfalls). With P1 / P2 / P3 annotated in its own frame, the triple is looked
for where the architecture says it should be — an unpaired C or U 5′ of P1, pairing into the base of
P2 — rather than at Class_1b's column numbers. A triple found there would make cluster 106 a class 1
xrRNA of its own; none found, with the architecture otherwise intact, is a real negative.

**What actually unblocks it is sequences, and only one route is left.** The library has three and
the RNAvirus DB search was run with the pooled (cluster-5-dominated) model, so it has never been
asked about cluster 106 specifically. Two steps, in order:

1. Build a provisional cluster-106-only model from the alignment above (plain `cmbuild` — mlocarna
   output has no `RF`, so no `--hand`), calibrate, and search the RNAvirus DB with **that** model.
   Read the hits down to E 10 by position: a real member sits downstream of that genome's Class_1b
   copies.
2. If the DB is still too narrow, assemble a targeted set of complete ISF genomes from NCBI around
   *Xishuangbanna aedes flavivirus*, *Menghai flavivirus* and *Kilpisjarvi flavivirus* and search
   that. This is the step that was written down on 10-30 and never run.

Until one of those adds sequences, cluster 106 stays **open** in the gap register, and a model for
it is not attempted — three near-identical sequences would build a model that only finds themselves.

### FJJI: clusters 41 and 44 — 2026-11-02

Jingmen tick viruses and relatives. The Jingmenvirus group has no CM coverage at all. Same
route as FJIS: the explorer's 80-nt windows (`explorer_cm_scan.py seqs`), mlocarna single and pooled,
`stk_oneblock`, R-scape.

| candidate (folder) | seqs | detected | alifold (total = energy + covariance) | R-scape |
|---|---:|---|---|---|
| `cand_FJJI_cluster41_261029` | 12 | **10 mM only**, SF 0.55–0.86 | −25.52 = −14.00 + −11.52; two hairpins in the first ~45 nt | 1 of 11 pairs (11–20), PPV 100 |
| `cand_FJJI_cluster44_261029` | 8 | mostly both | −29.53 = −19.54 + −9.99; one long hairpin | 0 in structure (1 FP, 20–82, non-canonical) |
| `cand_FJJI_cluster41-44_pooled_261029` | 20 | | −16.91 = −8.30 + −8.61 | no significant pairs |

- **Two separate elements.** Pooling is weaker than either cluster alone and loses all covariation;
  the clusters also differ in Mg dependence.
- **Cluster 41 stalls only at 10 mM**, like class 2 sites in these libraries and unlike
  `cand_FJTB_261026`. To separate Mg dependence from coverage, look up its sites in the 1 mM table
  (rows with SF near 0 = covered but no stall; no rows = coverage).

**Next**: MATER edit of each cluster separately (cluster 41 first: stronger covariation term, one
supported pair), then R-scape, first model, library search.

Alignments: `build/cand_FJJI_cluster{41,44}_261029/iter_v2_explorer80/mlocarna/results/result-oneblock.stk`.

Folders renamed 2026-11-02 from `cand_FJJI_fz41_261029`, `cand_FJJI_fz44_261029` and
`cand_FJJI_261029`; run-log rows written before the rename keep the old names in their text.

```bash
cd $INFERNAL/build
mv cand_FJJI_fz41_261029 cand_FJJI_cluster41_261029
mv cand_FJJI_fz44_261029 cand_FJJI_cluster44_261029
mv cand_FJJI_261029      cand_FJJI_cluster41-44_pooled_261029
cd - > /dev/null
```

### Aligning the no-CM explorer clusters — block updated 2026-11-02

Re-fetch of cluster 41 and cluster 5 (first run returned 1 of 12 and 0 of 5) done 2026-10-29: 12 and 5.
FJIS (cluster 5, cluster 106, pooled) aligned 2026-10-30 — results above. **Still to run: FJJI cluster 41, cluster 44,
pooled, and HPPV cluster 39.** cluster 110 (loquat) is class 3 and is not aligned. Candidates are named by
clade and date; the frozen-cluster index goes in the first log row as provenance.

Needs `clog`, `stk_oneblock` and `alifold_line` from Part 8 defined in the shell.

```bash
while read -r CAND SOURCES; do
  CAND_DIR=$INFERNAL/build/$CAND
  mkdir -p "$CAND_DIR/seed" "$CAND_DIR/iter_v1" "$CAND_DIR/rscape"
  SEED_FA=$CAND_DIR/seed/$CAND.fa
  : > "$SEED_FA"
  for SRC in $(echo "$SOURCES" | tr , ' '); do cat "$X/$SRC.fa" >> "$SEED_FA"; done
  NSEQ=$(grep -c '^>' "$SEED_FA")
  echo "== $CAND: $NSEQ seqs from $SOURCES"
  mlocarna --stockholm --consensus-structure=alifold --probabilistic --consistency-transformation \
    --tgtdir "$CAND_DIR/iter_v1/mlocarna" "$SEED_FA" > "$CAND_DIR/iter_v1/mlocarna.log" 2>&1 \
    || { echo "$CAND: mlocarna failed, see $CAND_DIR/iter_v1/mlocarna.log"; continue; }
  RES=$CAND_DIR/iter_v1/mlocarna/results
  stk_oneblock "$RES/result.stk" "$RES/result-oneblock.stk"
  ALIFOLD=$(alifold_line "$CAND_DIR/iter_v1/mlocarna.log")
  echo "$CAND alifold: ${ALIFOLD:-not found -- check $CAND_DIR/iter_v1/mlocarna.log}"
  clog "$CAND" "mlocarna --probabilistic --consistency-transformation, $NSEQ seqs from explorer $SOURCES (stall -20/+150 from the reference)" \
    "alifold ${ALIFOLD:-not found in log}"
  R-scape -s --outdir "$CAND_DIR/rscape" "$RES/result-oneblock.stk" > "$CAND_DIR/rscape/rscape_s.log" 2>&1
  ls "$CAND_DIR"/rscape/*.cov >/dev/null 2>&1 && head -12 "$CAND_DIR"/rscape/*.cov
done <<'EOF'
cand_FJJI_fz41_261029 FJJI_fz41
cand_FJJI_fz44_261029 FJJI_fz44
cand_FJJI_261029 FJJI_fz41,FJJI_fz44
cand_HPPV_fz39_261029 HPPV_fz39
EOF
```

GATE 1 is the alifold **covariance term**; with ~170 nt windows compare it **per base pair**
(cluster 106 −0.69, cluster 5 −0.53, hepaci ≈ −0.5 kept, clusterA −0.90, pegivirus set aside on a single
weak stem). R-scape then says how much of that is significant; with few sequences expect low
power. `dedup_stockholm.py` is no longer run here: it reads the two-block file as twice the rows
and removed nothing in any run.

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

---

# Part 4. Model statistics, and the earlier candidates (2026-09-15 – 11-02)

## Model statistics

Every model and candidate in one place. Status is maintained in the gap register and the candidate
cards (Part 3); this table is for comparing the numbers.

| model | clade | nseq | eff_nseq | clen | bps | bifs | note |
|---|---|---:|---:|---:|---:|---:|---|
| Class_1a | — | 75 | 9.31 | 74 | 19 | 2 | provided |
| Class_1b | — | 88 | 48.62 | 81 | 19 | 2 | provided, Infernal 1.1.2 (Part 2) |
| Class_2 | — | 38 | 3.58 | 93 | 22 | 1 | provided; curated, lowest eff_nseq of the accepted set |
| class1c | PLPV + HPHV | 46 | 9.54 | 84 | 15 | 1 | built here 2026-09-17 |
| `class1b_plusFJIS_cluster5_inf112` | + ISF | 94 | 50.24 | 81 | 19 | 2 | **candidate Class_1b version**, 2026-11-02; passes the rule |
| `class1b_plusFJIS_all_inf112` | + ISF | 97 | 63.32 | 81 | 19 | 2 | rejected: 11 hits lost |
| `cand_FJIS_261029` | FJIS | 8 | 4.44 | 82 | 13 | 1 | superseded by the two outcomes above / cluster 106 |
| `cand_FJTB_261026` | FJTB | 16 | 1.63 | 80 | **23** | **2** | built, searched; +1 accession only |
| `cand_PLLG_260915` | PLLG | 12 | 1.90 | 76 | 15 | 0 | built, searched; 24 of 60 |
| `cand_PLLG_260915_cmalign` | PLLG | 24 | 1.55 | 75 | 15 | 0 | built; stopped, too conserved |
| `hepaci_hits_v2` | HPHV | 55 | 19.93 | 78 | 18 | 1 | intermediate on the way to class1c |

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
  cmsearch --toponly -E 100 -o /dev/null --tblout /dev/stdout "$CM" "$CAND_FA" 2>/dev/null \
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

## Not candidates

| set | why not |
|---|---|
| KY370101 + NC_025677 | share `AAGCGACTCGCA(C/T)CACC`, `GGGAGTGACGCCCC`, `GTTCAT` with each other only. Two sequences. Also the two borderline class1c pestivirus hits left undecided in the Sept doc |
| NC_027817, NC_001655, NC_020902, KY370100 | fell in the `cand_FJTB_261026` positional band but share no sequence with it |
| Pegivirus | 16 candidates, single weak stem-loop (−3.56). Underpowered, not structureless. The original pool was 27 before cd-hit-est at 90 % collapsed it to 16 — worth re-running at 0.95 to preserve sequences for covariance detection |
| PLLG clusters D, E | 2 sequences each |

---

---

# Part 5. class1c review (2026-10-28 – 10-30)

## class1c

### How class1c was found, and how that differs from the current route

Recorded 2026-11-02, because the two routes give different kinds of candidate and the counts are
not comparable. class1c came out of a **genus** route in September; everything since 2026-10-28 uses
a **clade / cluster** route.

| | class1c (Sept 2026) | current candidates (from 2026-10-28) |
|---|---|---|
| pool | `extract_genus_fastas.py` on the August annotated xlsx: rows with `any_hit == False` and `n_reps_passing` in (3,4), split **by genus** (`Hepacivirus.fasta`, `Pestivirus.fasta`, …) | the no-hit pool joined to **Mifsud clade codes**, then the flavi150 explorer's **LocARNA similarity clusters** within a clade |
| windows | the `downstream_seq` column (starts at the stall, capped at 80 nt) | `explorer_cm_scan.py seqs` (the same `downstream_seq`) or `fetch --ref` (cut from the reference, any width) |
| grouping evidence | genus label only | sequence/structure similarity, plus distinct-species and stall-position-spread ranking |
| alignment | mlocarna per genus → hand-edited Stockholm | mlocarna per cluster and pooled, `stk_oneblock`, MATER edit, R-scape |
| how it grew | `cmbuild` from 22 hand-edited Pestivirus sequences → library `cmsearch` → `esl-sfetch` + `cmalign` of the 46 `!` hits → MATER/CaCoFold → `class1c` | build, then `cm_iterate.sh` novelty check against the library and the RNAvirus database; grow by `cmalign --mapali` so the edited seed is kept |
| result | a **mixed-genus** class: 22 Pestivirus + Hepacivirus hits the search pulled in | candidates are within one clade by construction; cross-clade membership appears as model-vs-model tests |

Consequences that keep coming up:

- **The genus split mixed unrelated viruses** — the recorded rule is to split by clade code, since a
  genus split puts insect-specific and tick-borne flaviviruses in one alignment. The 29 unexamined
  orthoflavivirus vsearch clusters come from that route and are superseded.
- **class1c's seed is library hits**, which is why it is saturated on the library: the search →
  `cmalign` → rebuild round was already done one model earlier (`pesti_short1b`). A candidate whose
  seed is a cluster alignment is not saturated for the same reason.
- **The Sept "still unclassified" genus lists are stale** (Part 5, Known uncovered): they were
  derived against a different model set, and KY370100 / KY370101 / NC_025677 all carry Class_1b
  hits in the 261021 annotation.
- **Counts are in different units.** Genus-route counts are per sequence or per accession; the
  cluster route counts distinct stall sites. The gap register (Part 3) keeps the unit on every row.

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
  explorer cluster **cluster 106** — *Xishuangbanna aedes flavivirus* NC_034017 10511 (SF 0.942) and
  *Menghai flavivirus* NC_034204 10523 (SF 0.840). Adding one FJIS sequence recovers the whole
  FJIS cluster 106 cluster at stall positions, which a forced fit would not do.
- **ky** costs more (42 of 47 hits lower, worst −5.6) at PP 0.77; its non-circular gains are
  ON949931 (at its stall) and two Class_1b sites.
- **Every variant containing KY370101 or ON949931 picks up BK013349 75, and the KY variants also
  MN587695 77 — both start exactly on stalls that Class_1b already annotates.** No stall in the
  261021 tables is annotated by two models (Model co-occurrence), so these are the first
  class1c / Class_1b overlaps. Class_1b is the weak model library-wide (median E 4.0e-06), so the
  question is which model scores the span better, not just whether class1c reaches it.
- **All of this is at E ≤ 0.01.** None of it is established until it holds at `--incE 1e-10`.

**Decision, 2026-10-30: no variant accepted; class1c unchanged.** The two checks below were run:

- at `--incE 1e-10` nothing holds except the added sequences themselves (`ky`: KY370101 8.3e-17);
  in `on`, ON949931 3.6e-10, NC_034017 5.1e-06, NC_034204 2.8e-05, BK013349 1.4e-03;
- against a Class_1b library search, **Class_1b has the lower E at every overlap**: v0 0 of 1,
  `on` 0 of 4 (BK013349 75: 17.7 vs 48.0 bits; MN242370 / MN242371 83–169: 8.6 vs 47.3; OP860412
  327–340: 6.5 vs 20.5), `ky` 0 of 11 (MN587695 77: 15.4 vs 47.0).

`ky` and `nc` rejected; `on` not accepted (gains below 1e-10, all 4 overlaps lost to Class_1b).
Its one real signal — the cluster 106 members at their stalls — became `cand_FJIS_fz106_261029`
(Part 3). KY370101 12807 stays a sub-threshold class1c match (14.9 bits, E 0.0082 in v0).

The checks, as run (2026-10-30):

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
   re-derive the explorer and pool-queue rows for FJIS cluster 106.

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

**Outcome 2026-10-30: merge not reopened** — class1c had the lower E at none of the 16 overlaps
(v0 0/1, `on` 0/4, `ky` 0/11).

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

**Superseded by the gap register (Part 3)**; kept as the Sept/Oct derivation, and the lists
themselves are stale (see "How class1c was found" above).

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

---

# Part 6. class1b and class1c: overlap, merge question, Class_1b expansion (2026-09 – 10-30)

## Overlap and the merge question

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
  cmsearch --toponly -E 100 -o /dev/null --tblout /dev/stdout "$CM" /tmp/MN564793.fa 2>/dev/null \
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

### The class1b merge attempt, and why it stopped — September 2026

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

### Class_1b expansion attempt — 2026-10-30

**Question.** Class_1b is a provided model whose 88-sequence seed comes from outside this
library. Unlike class1c, its library hits might add information. Can some be added without losing
what it already annotates?

**Saturation check** (`cm_iterate.sh --check-only`, `--incE 0.01` because Class_1b's median E is
4.0e-06 and almost nothing passes 1e-10): 129 included hits over 84 accessions, **68 novel**
(< 80 % of 15-mers in the seed). Not saturated.

**How novel the 68 are.** Containment bins: 35 at 0.0, 13 at 0.1–0.5, 17 at 0.6–0.8, and 61 hits
counted as in the seed at ≥ 0.8. The seed's names are genome spans of ~76 nt
(`AEFV_KJ741266-1_10497-10572_xr1`) while library hits are 81–107 nt, so part of the 0.6–0.8 band
is span length, not novelty. The 68 come from 51 accessions, **45 of them absent from the seed**
(the seed covers 50 accessions); 68 → 66 at 98 % identity, so little redundancy. Seed accessions
that also have novel hits: KJ741266, MH282908 (three seed copies, xr1–xr3), KY370101, NC_030291.

**Method.** Novel hits appended to the seed with `cmalign --mapali` (seed kept as it is),
`cmbuild --hand` on the model's 81 columns, `cmcalibrate`, `cmsearch --toponly --incE 0.01`,
per-hit comparison with the original model's own search (`cm_round_stats.py compare`, start
within 10 nt). Subsets: **strong** = novel hits with E ≤ 1e-05 (38); **all** = 68; **newvirus** =
strong minus the 4 from seed accessions (34). Every new or lost hit was checked against the
explorer's stall positions (Class_1b starts ~1 nt before the stall).

| build | Infernal | added | nseq / eff_nseq | lost | gained | lower / worst Δ |
|---|---|---:|---|---|---|---|
| strong | 1.1.5 | 38 | 126 / 20.17 | MH307700 124 | MN587651 70 (stall 9782); KY370101 518 (no stall) | 47 / −7.4 |
| all | 1.1.5 | 68 | 156 / 21.54 | MH307700 124 | + MN587661 72 (stall 9940) | 41 / −7.1 |
| v0 (seed only, `--hand`) | 1.1.2 | 0 | 88 / 48.65 | — | — | reproduces the original |
| strong | 1.1.2 | 38 | 126 / 23.97 | **AB021287 65** | OM030319 57 (stall 11865, SF 0.844); MN587651 70; OP860412 297 (stall 10802, −4 nt) | 64 / −7.0 |
| all | 1.1.2 | 68 | 156 / 23.84 | NC_008604 113, MH307700 124, KJ741266 810, KC181923 859, LC536088 839 — all Class_1b sites | OM030319, MN587651 | 56 / −10.8 |
| newvirus | 1.1.2 | 34 | 122 / 24.43 | **AB021287 65** | same three as strong | 65 / −7.2 |

Reading:

- **The 1.1.5 rows are confounded** by the version difference (Part 2) and are superseded by the
  1.1.2 rows, which differ from the original only in the added sequences.
- **`all` is rejected**: five annotated Class_1b sites lost.
- **strong and newvirus behave the same.** So the damage does not come from extra copies of seed
  viruses: MH282908 loses 5.5 / 3.1 bits although none of its hits was added in newvirus.
- **The gains are real but weak**: three new hits at unannotated stalls (OM030319, MN587651,
  OP860412), at E ~1e-03. OM030319 is one of the September "still unclassified" pestiviruses.
  MN587651 / MN587661 are rodent hepaciviruses whose class1c pair sits downstream (feature
  positions 177, 332), so these genomes would carry a Class_1b-like element upstream of class1c.
- **eff_nseq falls to ~24 in every variant**, with relative entropy fixed at 0.700. That reads as
  cmbuild's entropy weighting compensating for consensus-like sequences (the model found them),
  not as lost diversity. The per-hit losses are what count.
- **AB021287 is suspicious**: it was itself an added sequence, yet the strong search has **no row
  for it at all**, not even below threshold. Most likely the search's filter stage dropped it.

**Status: not accepted; paused on one check.** Search AB021287 alone with and without `--max`
(filters off) against the original, strong and newvirus models:

```bash
AB_T=$(grep -m1 '^>AB021287' "$FA" | sed 's/^>//; s/ .*//'); esl-sfetch "$FA" "$AB_T" > "$CLASS1B_INF112/AB021287.fa"
for M in "$CL1B" "$CLASS1B_INF112/strong/class1b_alignHits_strong_inf112.cm" "$CLASS1B_INF112/newvirus/class1b_alignHits_newvirus_inf112.cm"; do
  for MODE in default max; do
    OPT=""; [ $MODE = max ] && OPT="--max"
    printf '%-40s %-7s ' "$(basename "$M" .cm)" "$MODE"
    cmsearch --toponly $OPT -E 100 -o /dev/null --tblout /dev/stdout "$M" "$CLASS1B_INF112/AB021287.fa" 2>/dev/null \
      | awk '$1!~/^#/ {print "cm "$6"-"$7, $8"-"$9, $15" bits", "E "$16, $17; f=1; exit} END{if(!f) print "no hit"}'
  done
done
```

If AB021287 scores well under `--max` only, its loss is a filter artefact; then strong / newvirus
come down to three stall-anchored gains against MH307700 −4.0 and MH282908 −5.5. If it is missing
under `--max` too, both are rejected, as the September merge was. Any accepted Class_1b rebuild
is a new model version: new name, and cluster steps 10–13 re-run.

Paths: `build/class1b/iter_v1_saturation/r0/` (original model's search, novelty table),
`iter_v2_alignHits/` (1.1.5 builds, fetch lists), `iter_v2_alignHits_inf112/{v0,strong,all,newvirus}/`
(1.1.2 builds, `class1b_alignHits_<subset>_inf112.{stk,cm,_library.tbl,_library.tbl.compare.tsv}`).

---

# Part 7. Accounting: stalls with no CM home (2026-10-28)

## Accounting: stalls with no CM home

### Counts of what is not covered

**Superseded by the gap register (Part 3)**; kept as the 2026-10-28 derivation.

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

The 2026-10-28 snapshot. Current state per gap: the gap register, Part 3.

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

---

# Part 8. Methods

## Working with this file and the scripts

### How this file is kept current

The **Run log** tables at the end are written by the scripts, not by hand. Everything above them is
interpretation and is edited by hand when a run changes a conclusion.

| script (`flaviLib/scripts/`) | md5 | writes to this file |
|---|---|---|
| `cm_iterate.sh` | `7f05a0c316dca558370f955c318d2992` | one row per search round and per rebuild, under `### \`<name>\`` |
| `cm_round_stats.py` | `f010ece4117261f72d057d39269ce5d7` | helper for `cm_iterate.sh` (novelty, per-hit bit-score comparison, cmstat parse) |
| `cm_log.py` | `8de58f4755bee2ecbd2343b142d92704` | any single row; use it for manual steps (MATER, CaCoFold, decisions). Fixed 2026-11-02: new model tables now go inside Part 10 (before, they landed after the `# Part 11` heading) |
| `make_pool_fastas.py` | `f363267accdfc27a9b03e4c061779e3d` | nothing; builds the pool FASTAs and `pool_summary.tsv` |
| `cm_add_borderline.sh` | `a330c754f27244edeabb2e69e0d1a718` | step 17: one run-log row per variant (v0 + each `--add`) |
| `seed_vs_hits.py` | `c5ac6aea20b4045c63c4c02f0ae5f875` | nothing; seed vs tblout comparison (saturation and lineage checks) |
| `explorer_cm_scan.py` | `1c4b4ad1d63695100ee8694c4ee1f441` | nothing; scans the flavi150 explorer's sites with a CM; `fetch` (reference windows) and `seqs` (the explorer's own 80-nt windows) per cluster |

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

### Shell notes for the laptop (zsh on macOS) — 2026-10-29 to 11-02

Each of these broke a command once.

| symptom | cause | do instead |
|---|---|---|
| `fetch: error: the following arguments are required: name` | zsh does not split an unquoted `$c` into words, so `for c in "41 FJJI_fz41"` passes one argument | `while read -r a b; do …; done <<'EOF'` with one pair per line |
| `zsh: event not found` | `!` inside double quotes is history expansion | `setopt NO_BANG_HIST` once per terminal (or single quotes) |
| `L="python3 …"; $L --step …` runs nothing | same: a variable holding a command is not split | a shell function (`clog`, below) |
| `zsh: no matches found: …/*.cov` aborts the loop | zsh errors on a wildcard that matches nothing | `ls …/*.cov >/dev/null 2>&1 && …` |
| `permission denied` on a script | downloaded files lose the executable bit | `chmod +x`, or `bash script.sh` |
| `duplicate seq name` from R-scape / Easel | LocARNA 2.0.1 writes `result.stk` as two blocks with no blank line between (`#=GF SQ 6` for 3 sequences) | join with `stk_oneblock` first |
| alifold line logged without energies | mlocarna wraps the alignment at ~120 characters; RNAalifold space-pads one-digit energies | the `alifold_line` function below (padding fixed 2026-11-02) |
| an E-value looks far better than expected | E scales with the size of the searched database, so it is not comparable between searches of different targets (bitten twice: the RNAvirus DB looked saturated, and a 2-sequence search looked like an annotation bug) | compare **bit scores** across searches; compare E only when the target file is the same |
| a residue is "missing" from a conserved column | `cmalign` may have placed it in the adjacent **insert** column; the flat per-column readout cannot tell a shift from a substitution (bitten on MW897328 at cm 29 and cm 43) | print the ±2-column window plus the `#=GR … PP` row, as in Part 3's triple block; treat a column with PP ≲ 0.6 and an occupied neighbouring insert as unreadable, not as absent |
| a structural feature looks absent in an alignment | `cmbuild` cannot represent a base triple or any other non-nested interaction, so the CM neither scores it nor aligns to it; and a sequence with low overall PP (Menghai, 0.465) may simply be misaligned | use the CM for recruitment only; read triples and pseudoknots from a structure-aware alignment (MATER / R-scape with the pseudoknot annotated) |
| `cmsearch --tblout /dev/stdout` output mixed with the alignment report | cmsearch also prints its main report to stdout | add `-o /dev/null`, or write the tblout to a file (fixed in Parts 4–6 on 2026-11-02) |
| `command not found: alifold_line` (or `clog`, `stk_oneblock`) | functions last only for the terminal session | paste the definitions below into each new terminal |
| a `<…>` placeholder copied into a command | placeholders are not paths | replace before running |

```bash
setopt NO_BANG_HIST     # zsh: make ! literal for this terminal (first line in every new terminal)
clog() { python3 "$FLAVISCRIPTS/cm_log.py" "$DOC" --model "$1" --step "$2" --result "$3"; }

stk_oneblock() {  # stk_oneblock IN.stk OUT.stk -- join LocARNA's unseparated blocks into one
  awk '
  /^# STOCKHOLM/ || /^\/\// || /^#=GF SQ/ {next}
  /^#=GF/ {gf[++ngf]=$0; next}
  /^#=GC/ {k=$2; if(!(k in gc)) gco[++ngc]=k; gc[k]=gc[k] $3; next}
  /^#/ || NF<2 {next}
  { if(!($1 in s)) o[++n]=$1; s[$1]=s[$1] $2 }
  END{
    print "# STOCKHOLM 1.0"; for(i=1;i<=ngf;i++) print gf[i]; print "#=GF SQ " n
    w=0; for(i=1;i<=n;i++) if(length(o[i])>w) w=length(o[i])
    for(i=1;i<=ngc;i++) if(length("#=GC " gco[i])>w) w=length("#=GC " gco[i])
    for(i=1;i<=n;i++) printf "%-" w "s  %s\n", o[i], s[o[i]]
    for(i=1;i<=ngc;i++) printf "%-" w "s  %s\n", "#=GC " gco[i], gc[gco[i]]
    print "//" }' "$1" > "$2"
}

alifold_line() {  # alifold_line mlocarna.log -> "<structure> (<total> = <energy> + <covariance>)"
  # energies may be space-padded, e.g. "( -9.10 =  -6.00 +  -3.10)" (fixed 2026-11-02)
  awk -v re='\\( *-?[0-9.]+ *= *-?[0-9.]+ *\\+ *-?[0-9.]+\\)' '
    /^alifold/{s=$2; f=1; if(match($0,re)){e=substr($0,RSTART,RLENGTH); f=0}; next}
    f && /^ +[.()]/{s=s $1; if(match($0,re)){e=substr($0,RSTART,RLENGTH); f=0}}
    END{print s, e}' "$1"
}
```

`stk_oneblock` drops `#=GS` / `#=GR` lines (LocARNA writes none). Tested on a two-block file;
`esl-reformat` reads the output. Alignments that went through MATER (class1c, FJTB) were not
affected: MATER writes a clean file.

R-scape writes its results to files in `--outdir` (`.cov`, `.power`, `.helixcov`, `.sorted.cov`,
`.R2R.sto.pdf/.svg`), not to the terminal. `RFview: No such file` is the known broken RFview path
and only skips one drawing; `gnuplot not found` skips plots
(`conda install -y -c conda-forge gnuplot`).

## Checks of 2026-10-29

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
| cluster 137 all class1c; cluster 130 8 class1c / 7 Class_1b / 1 none; cluster 131 48 Class_1b / 10 class1c / 11 none | `annotate`, cluster composition |
| ON949931 10608: 13.3 bits, `cm 1–84`, node = stall 10608, SF 0.900, cluster 106 | `annotate`, weaker hits; node `id` |
| cluster 106 = NC_034017 10511 (0.942), NC_034204 10523 (0.840), ON949931 10608 (0.900); the other two < 10 bits | node listing by `fz` |
| no-hit clusters cluster 41, 44, 3, 5, 39, 106, 64, 110, 117 and their members, SF, detection | node listing by `fz` |
| cluster 41 and cluster 44 are different Jingmen tick virus segment accessions at stalls 2493–2672 and 2448–2563 | node `id`s; segment identity from the accessions, not checked against GenBank |
| cluster 110 = *Loquat jingmen-related virus 1*, OL344024 / 026 / 028, self-clustering; expected class 3 | node listing by species; expectation from JG |
| cluster 110 is class 3: cl3 36.8 / 34.2 / 26.0 bits, `cm 1–52` (3–52), at the stall; no other node ≥ 10 bits | `annotate` with the cl3 tblout (laptop run) |
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

---

# Part 9. Reference

## Naming

`cand_<CLADE>_<yymmdd>` while a candidate; `class<N>` once accepted.

vsearch cluster indices (`cluster_2`, `clusterA`) are not names — they depend on the input FASTA,
the `--id` threshold and the run date. Record them as provenance.

**Cluster N** = **frozen cluster N** of the flavi150 explorer: the 2026-10-28 clustering of the 416
pooled sites by LocARNA similarity, cut at 0.55 with the largest component recut at 0.57 (colour by
"frozen cluster (20261028)" in the explorer). The number is an index from that one clustering, not
a name; it goes into a candidate's first log row as provenance. Written `fz N` before 2026-11-02;
that abbreviation remains in file names (`FJIS_fz106_explorer80.fa`), in the superseded folders
`cand_FJIS_fz106_261029` / `cand_FJIS_fz5_261029`, and in run-log rows, which are records and are
not rewritten. New candidate folders spell it out: `cand_FJJI_cluster41_261029`. `G<n>` / `E<n>` are gap-register ids
(Part 3).

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
   Confirmed on disk 2026-10-30: `work/infernal/cm/seeds/CL_Class_1b_xrRNA_final.sto`.

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

## Conventions

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

---

# Part 10. Run log

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
| 2026-10-30 | step 17 check 1: new hits at --incE 1e-10 | none holds except the added sequences themselves (ky: KY370101 8.3e-17). on: ON949931 3.6e-10, NC_034017 25.3 b 5.1e-06, NC_034204 23.0 b 2.8e-05, KY370101 5.2e-04, BK013349 1.4e-03. v0: KY370101 14.9 b 0.0082 (included), ON949931 0.026 |
| 2026-10-30 | step 17 check 2: overlap with Class_1b library search (cm_round_stats.py overlap, lower E wins) | Class_1b better at every overlap: v0 0/1, on 0/4, ky 0/11. BK013349 75: class1c 17.7 b vs Class_1b 48.0 b 5.8e-08; MN587695 77: 15.4 b vs 47.0 b 9.2e-08; MN242370/MN242371: 8.6 b vs 47.3 b; OP860412: 6.5 b vs 20.5 b |
| 2026-10-30 | step 17 decision | No variant accepted; class1c unchanged. ky and nc rejected; on not accepted (gains below 1e-10, 4 Class_1b overlaps all lost). FJIS fz 106 (NC_034017, NC_034204, ON949931) to be built as its own candidate; its class1c resemblance noted. Merge 1b/1c not reopened: class1c lost every overlap |

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

### `class1b`

| date | step | result |
|---|---|---|
| 2026-10-30 | r0 cmsearch vs library, --toponly --incE 0.01 | CL_Class_1b_xrRNA_final.cm: nseq=88 eff_nseq=48.62 clen=81 bps=19 bifs=2 relent_cm=0.700.      129 ! hits /       84 accessions; 129 pass coverage >= 0.85; **68 novel** vs seed (88 seqs). Detail: /Users/jeaninegezelle/Desktop/viromelib/flaviLib/work/infernal/build/class1b/iter_v1_saturation/r0/hits.novel.tsv |
| 2026-10-30 | saturation check, library, --toponly --incE 0.01 (cm_iterate.sh --check-only) | CL_Class_1b_xrRNA_final.cm 88/48.62/81/19/2: 129 ! hits / 84 accessions, 68 novel vs the 88-seq seed. Not saturated (unlike class1c). Next: iter_v2_alignHits -- append novel hits to the seed with cmalign --mapali (class1b_alignHits_strong: E<=1e-5; class1b_alignHits_all), cmbuild --hand, compare per hit |
| 2026-10-30 | novelty check of the 68 novel hits | containment bins: 35 at 0.0, 13 at 0.1-0.5, 17 at 0.6-0.8 (partly a span-length artefact: seed spans ~76 nt, hits 81-107 nt), 61 in seed at >=0.8. 51 novel accessions, 45 absent from the seed; 68 -> 66 at 98 % identity |
| 2026-10-30 | iter_v2_alignHits: seed + novel hits via cmalign --mapali, cmbuild --hand, --incE 0.01 | strong (+38): 126/20.17/81/19/2, matched 128 lost 1 gained 2 lower 47 worst -7.4. all (+68): 156/21.54/81/19/2, matched 128 lost 1 gained 3 lower 41 worst -7.1. AB021287 +0.8 / +3.7. LOST MH307700 124 (Class_1b site at stall 11358). NEW at stalls: MN587651 70 (stall 9782), MN587661 72 (stall 9940, all only), both unannotated rodent hepaci upstream of the class1c pair. NEW not at a stall: KY370101 518. Not accepted: MH307700 loss, eff_nseq 48.62 -> ~20 unexplained (baseline rebuild pending) |
| 2026-10-30 | Infernal version of the original model | CL_Class_1b_xrRNA_final.cm header: INFERNAL1/a [1.1.2 \| July 2016]; local is 1.1.5. Same command and same seed (checksum) give 88/87.08/78/18/2 under 1.1.5 vs 88/48.62/81/19/2 under 1.1.2, so cmbuild output differs between versions. Rebuilds of provided models must be compared with a 1.1.5 v0_hand baseline (seed only, model RF, --hand), not with the provided model. Optional confirmation: rebuild with bioconda infernal=1.1.2 |
| 2026-10-30 | iter_v2_alignHits_inf112: Infernal 1.1.2 cmbuild --hand + cmcalibrate, 1.1.5 cmsearch --toponly --incE 0.01, vs the original model search | v0 (seed only, --hand): 88/48.65/81/19/2, reproduces the original. strong (+38): 126/23.97/81/19/2, matched 128 lost 1 (AB021287 65) gained 3 lower 64 worst -7.0; MH307700 -4.0, MH282908 383 -5.3; NEW at unannotated stalls: OM030319 57 (stall 11865, SF 0.844), MN587651 70 (9782), OP860412 297 (10802, -4 nt). all (+68): 156/23.84, lost 5 (NC_008604 113, MH307700 124, KJ741266 810, KC181923 859, LC536088 839; all Class_1b sites), worst -10.8; rejected. strong not accepted (AB021287 lost). eff_nseq drop read as entropy weighting (relent fixed 0.700), not diversity loss. Next: newvirus variant (novel hits from accessions with no seed sequence) |
| 2026-10-30 | newvirus variant (1.1.2): strong novel hits from accessions with no seed sequence | 34 added: 122/24.43/81/19/2, matched 128 lost 1 (AB021287 65) gained 3 (OM030319 57, MN587651 70, OP860412 297) lower 65 worst -7.2; MH282908 -5.5/-3.1 although none of its hits was added; MH307700 -4.0. Same as strong |
| 2026-10-30 | AB021287 in the strong search | no row at all, not even below threshold, although AB021287 is an added sequence; suspected filter artefact. `--max` check outstanding |
| 2026-11-02 | status | not accepted; paused on the AB021287 `--max` check (Part 6) |
| 2026-11-02 | CFAV, Class_2 and the Class_1b seed | the Class_1b seed already contains all three CFAV copies by name (CFAV_NC_001564-2 xr1 10173-10247, xr2 10260-10335, xr3 10555-10632). Original Class_1b on the library CFAV features: xr1 33.8 / 35.8 b (3.1e-07 / 1.2e-07), xr2 32.8 / 30.8 b, xr3 19.9 b 2.2e-04, all cm 1-81; plusFJIS_cluster5 raises xr3 to 23.4 b 5.6e-05. Class_2 reaches only xr1 and xr2, partially (cm 17-63 of 93), 10.9-13.5 b, E 2.2e-03 to 1.1e-02 -- 4 orders weaker than Class_1b. So CFAV is not a Class_2 exception here; a published class-2 attribution would be a labelling difference |
| 2026-11-02 | annotation discrepancy at LR694076 10565 | original Class_1b hits feature 476-553 (= stall 10565) at 19.9 b, E 2.2e-04, inclusion !, yet the 261021 annotation calls that stall no-hit (explorer None found; gap G15). Recorded annotation threshold is looser than that. Check the 260807_trueRef Class_1b tblout: if other no-hit sites are like this, part of the no-CM pool is an annotation artefact. Bears on every Part 7 count |
| 2026-11-02 | base triple located empirically from the papers own exception sequences | the Class_1b seed contains CXFV_NC_008604-2_10246-10326_xr1 and _10598-10675_xr4, the two sequences the paper reports as carrying U...A-U instead of C...G-C. They differ from the seed consensus at exactly three well-conserved columns: cm 7 (C 0.97 -> U, unpaired 5 prime region), cm 29 (G 0.97 -> A), cm 43 (C 0.86 -> U); SS_cons pairs 29 with 43. So the triple is cm 7 ... 29-43. Matches their >97 pct G and >97 pct C; their >90 pct for the second C vs 0.86 here. Supersedes the earlier guess of 30-42, which was wrong: cm 43 fell below the 0.90 G/C filter |
| 2026-11-02 | what the cluster5 expansion actually adds, mapped to the seeds xrN copies | recovered seed loci the original model missed: NC_027817 10756 = PaRV xr4 (10757-10848), NC_027819 10810 = MECDV xr1 (10811-10887), LR694076 10565 / MH237596 10555 = the CFAV xr3 copy (seed has it from isolate NC_001564). New fifth array copies, each just downstream of that genomes seed xr4: NC_008604 10708 (xr4 ends 10675), NC_021069 10737 (10704), NC_012671 10736 (10703, QBV), NC_024299 10746 (10716, NIEV). Genomes absent from the seed entirely: AB981186, MH827524. So the expansion extends the ISF tandem array by one copy at a consistent position (10708-10746) and repairs recovery of existing members |
| 2026-11-02 | correction: there is no annotation discrepancy at LR694076 10565 | the 260807_trueRef Class_1b tblout does contain those rows, as ? below inclusion: LR694076 476-553 and MH237596 478-555 at 19.9 bits E 0.067, NC_027817 543-636 and NC_027819 561-637 at 22.3 bits E 0.021. My earlier E 2.2e-04 came from a cmsearch of a 2-sequence file, so it is not comparable with a full-library search; bit scores are identical. The annotation is correct, those stalls are genuinely below inclusion, G15 is a real gap and the Part 7 counts are not inflated. Strike the earlier rows claiming an artefact |
| 2026-11-02 | what the expansion fixes, stated precisely | in the full-library search the original Class_1b scores four of its own seed sequences loci just below inclusion: PaRV xr4 (NC_027817 543, 22.3 b E 0.021), MECDV xr1 (NC_027819 561, 22.3 b E 0.021, its only seed copy), CFAV xr3 in two isolates (LR694076 476 and MH237596 478, 19.9 b E 0.067). NC_027817 has three other Class_1b rows included at 30.7-38.1 b. The cluster5 expansion raises these to 23.4-28.3 b and includes them, and adds four previously uncatalogued fifth array copies. So the expansion closes a recovery failure on its own P1-deviant members rather than defining a new family |
| 2026-11-03 | base triple located from the papers own exception sequences | the seed contains CXFV_NC_008604-2_10246-10326_xr1 and _10598-10675_xr4, the two sequences PMC7527734 reports with U...A-U instead of C...G-C. They depart from the seed consensus at exactly three well-conserved columns: cm 7 (C 0.97 -> U, unpaired 5 prime region), cm 29 (G 0.97 -> A), cm 43 (C 0.86 -> U); SS_cons pairs 29 with 43. **The triple is cm 7 ... 29-43.** Two of three conservation figures match the paper exactly; their >90 pct for the second C reads 0.86 here. Supersedes the earlier 30-42 guess, which failed because cm 43 fell below the 0.90 G/C filter -- conservation level alone cannot locate a triple |
| 2026-11-03 | base triple in the candidates | at cm 7 / 29 / 43 all six cluster5 sequences read C / G / C (intact C...G-C); NC_034204 reads - / - / -. cm 29 and 43 are inside Menghais aligned span (cm 17-78) so those are genuine deletions of the triples pair; cm 7 is outside its span (missing data, though cmalign starting it at column 17 is itself informative). cmbuild cannot represent a triple, so this is structural evidence independent of all scores. Menghai is not a Class_1b member; it could still be a class 1 xrRNA with a triple this model cannot align |
| 2026-11-03 | remaining sub-threshold Class_1b sites | with the cluster5 expansion, NC_005064 1079-1154 (= stall 11245, Kamiti River virus) is 18.5 b E 0.079 ? and MW897328 66-154 (stall 10653 at position 67) is 19.3 b E 0.057 ?: both still below inclusion, both starting at their stall. Their genomes other sites are included (NC_005064 191 and 787 at 37.6-38.7 b; MW897328 641 at 34.6 b). Candidates for a further expansion round via cm_add_borderline.sh on the cluster5 model |
| 2026-11-03 | rule | compare bit scores between searches, never E-values, unless the target file is identical: E scales with database size. Recorded in Part 8 after it caused two wrong readings |
| 2026-11-03 | adding the two remaining sub-threshold sites to the cluster5 seed | all three variants rejected. kamiti (NC_005064): 95 seq / eff 51.72, clen 81 / W 254, added sequence aligns cm 1-81 untruncated at 7.06 b avg PP 0.853, loses OP860412 297, gains nothing, 41 lower worst -0.70. phaiomys (MW897328): 95 / 50.87, W 251, added sequence 3 prime truncated cm 1-80 at 8.57 b avg PP 0.622, loses AB981186 590 and NC_012671 545 (both cluster5 member sites) and OP860412 297, gains only itself at 23.5 b, 85 lower worst -1.10. both: 96 / 52.03, same three lost. Every variant loses OP860412 297, the hit cluster5 gained, so this is the fourth independent demonstration that the expansion is at capacity at cluster 5. kamiti is the near miss (one loss, best-aligning addition tried) but buys nothing: its own site is not raised to inclusion. Paths build/class1b/iter_v3_plusFJIS/plus_subthreshold/{kamiti,phaiomys,both}/ |
| 2026-11-03 | window and PP view of the triple columns: the screen distinguishes shift from variant | MW897328: RF c.G.GGG vs seq C.GGCGG -- an extra G in the insert column beside cm 29, cm 29 itself C, PP *.83566 (about 0.55 at cm 29, 0.3 at the insert); cm 41-45 a second inserted G at PP 0.5-0.6. Its C-C not-a-pair verdict is a misalignment, the G is one column over: the triple screen gives no evidence either way for it. NC_005064: no insertions in the windows, PP **.*** at cm 5-9 and *.*.*** at cm 27-31 (cm 7 = C and cm 29 = G at >=0.95), cm 43 = U at PP about 0.65 -- most likely a genuine G.U wobble replacing G-C, consistent with the papers non-Watson-Crick pairs at the base of P2. The six cluster5 sequences carry no PP row (they came through --mapali, probabilities not recomputed) so their C-G-C readings are unverified for confidence; re-align without --mapali to cluster5/pp_check.stk to measure it (not yet run). Decisions unchanged: both further additions rejected on the rebuild losses, expansion stops at cluster 5. Same caveat now applies to Menghai (overall PP 0.465): its rejection rests on the 11-17 lost hits alone, not on the triple |
| 2026-11-03 | note on reading RF | Infernals RF line marks match columns with the consensus residue, uppercase when well conserved and lowercase when not, and insert columns with a dot. So c.isalpha() is the correct test for a match column and it returns exactly clen = 81. An earlier worry that lowercase meant insert was unfounded; the column count confirms it |
| 2026-11-03 | should the seed be shifted so the triple aligns | no. cmbuild has no base-triple state, so cm 7s interaction with the 29-43 pair is absent under every column arrangement: a shift can only improve the readout, never the models power. The current layout is right for the 138 included sites, which leave the insert columns empty, and wrong only for MW897328; adding a consensus column to absorb that insert asserts a residue there for the other 137 and raises clen 81 to 82, which is in effect what the three variant rebuilds did, and all three lost hits. A seed describes the consensus, not the hardest member. The measurement that would change the answer: count how many included library sites occupy the insert columns flanking cm 29 and cm 43 (insertcheck block, Part 3) -- a substantial fraction means the seed misdescribes the family and a column should be added via RF plus cmbuild --hand. What would genuinely improve triple detection is a different instrument, not a shift: the CM is recruitment only, the triple is read from a structure-aware alignment with the pseudoknot annotated (MATER / R-scape) |
| 2026-11-03 | explicit membership table added to Part 3 | the six added sequences were recorded only in pieces (gap register, candidate card, reciprocal-scoring table, four run-log rows) with no single list. Part 3 now has one authoritative table: added = NC_008604.2 Culex flavivirus 10707, NC_012671.1 Quang Binh virus 10735, NC_021069.1 mosquito flavivirus 10735, NC_024299.2 Nienokoue virus 10747 (all four fifth array copies just downstream of that genomes seed xr4), AB981186.1 mosquito flavivirus 10732 and MH827524.1 Quang Binh virus 10759 (both genomes absent from the seed entirely). 88 + 6 = 94. Kept out, each tested and failed the no-loss rule: NC_034017 Xishuangbanna aedes flavivirus, NC_034204 Menghai flavivirus, ON949931 Kilpisjarvi flavivirus (cluster 106, PP 0.38-0.47, 11-17 hits lost), NC_005064 Kamiti River virus and MW897328 (sub-threshold, 11-03), and the 68 novel library hits (separate paused extension). Not to be confused: KC181923, KJ741266, LC536088 are Aedes flavivirus, cluster 133, already Class_1b |
| 2026-11-03 | inconsistency flagged, not yet resolved | the further-addition rejections are phrased as losing OP860412 297, the hit cluster 5 gained, but OP860412 297 is recorded in Part 6 as a gain of the strong 1.1.2 variant, and six own sites plus four recovered seed loci (NC_027817 543 PaRV xr4, NC_027819 561 MECDV xr1, LR694076 476 and MH237596 478 CFAV xr3) already account for all 10 gains. Either the count is 11 or the attribution is wrong. Settle from cluster5/class1b_plusFJIS_cluster5_inf112_library.tbl.compare.tsv with grep NEW. No decision depends on it: every rejected variant lost other hits too |

### `cand_FJIS_fz106_261029`

| date | step | result |
|---|---|---|
| 2026-10-30 | status of ON949931 / fz 106 relative to class1c | ON949931 10608 is sub-threshold class1c (13.4 b, E 0.052 Sept; 0.026 in v0), not a class1c hit. fz 106 = ON949931 10608 (SF 0.900), NC_034017 10511 (Xishuangbanna aedes flavivirus, 0.942), NC_034204 10523 (Menghai flavivirus, 0.840); not Aedes flavivirus (KC181923/KJ741266/LC536088, Class_1b, fz 133). Adding ON949931 to class1c lifted the other two at their exact stalls (25.3 b 5.1e-06, 23.0 b 2.8e-05), so the three share a class1c-like element, but below 1e-10 and with Class_1b overlaps: build as own candidate. Seeds: mlocarna (alignment block) and class1c-guided cmalign of the three spans |
| 2026-10-30 | mlocarna --probabilistic --consistency-transformation, 3 seqs from explorer FJIS_fz106 (stall -20/+150 from the reference) | alifold .((..((......)))).......((((...(((((((....)))))))...((((........)))))))).....((.((.(((((..(((((((((.((((......))))..)))) |
| 2026-11-02 | mlocarna alifold, corrected (earlier row truncated by line wrapping) | 3 seqs, alignment 185 cols: (-69.58 = -35.17 + -34.42), 50 bp, covariance -0.69 per bp. Structure spans the whole -20/+150 window; element likely near the stall (col ~21) |
| 2026-10-30 | class1c-guided cmalign of the three on-variant spans to cm_set class1c.cm | ON949931 419-499 cm 1-84 1.55 b PP 0.892; NC_034017 177-250 cm 1-75 (3' trunc) 1.33 b PP 0.846; NC_034204 170-244 cm 1-74 (3' trunc) -2.14 b PP 0.790 |
| 2026-10-30 | same, spans extended to hit start +99 | cm 1-35, 17-66, 1-70; -12.17, -13.19, -14.69 b. Resemblance ends near class1c col 75 and is weak: class1c-guided seed abandoned |
| 2026-11-02 | R-scape -s on result.stk | failed: duplicate seq name (LocARNA two-block Stockholm). Fixed with stk_oneblock -> result-oneblock.stk |
| 2026-11-02 | R-scape -s on result-oneblock.stk (3 seqs, 185 cols) | 49 bp tested; significant: 128-149 (in structure), 22-181 (not); Sen 2.04, PPV 50. Helix 126-133/144-151 1 of 8 bp covarying. Power 0.00-0.10: underpowered |
| 2026-11-02 | mlocarna, 3 seqs, explorer downstream_seq windows (<=80 nt from the stall; iter_v2_explorer80) | alifold |
| 2026-11-02 | mlocarna alifold, explorer downstream_seq windows (iter_v2_explorer80), corrected row: alifold_line was undefined in the first logging | alifold ..((((...(((((((....)))))))...((((........))))))))..(((........)))................... (-25.65 = -13.97 + -11.68) |
| 2026-11-02 | superseded | by `cand_FJIS_261029` (pooled fz 5 + fz 106, 80-nt windows, MATER edit) |

### `cand_FJIS_fz5_261029`

| date | step | result |
|---|---|---|
| 2026-10-30 | mlocarna --probabilistic --consistency-transformation, 5 seqs from explorer FJIS_fz5 (stall -20/+150 from the reference) | alifold ..((.((..(((((....)))))))))(((((((((.....)))).(((((........))))).......)))))...(((((((((..(((((...(((((((((((((.......)) |
| 2026-11-02 | mlocarna alifold, corrected (earlier row truncated by line wrapping) | 5 seqs, 156 cols: (-80.63 = -54.10 + -26.53), 50 bp, covariance -0.53 per bp |
| 2026-11-02 | R-scape -s on result-oneblock.stk (5 seqs, 153 cols) | 50 bp tested; significant 87-141, 88-140, both in structure (PPV 100, Sen 4.00). Helix 80-88/140-150 2 of 9 bp. Power 0.00-0.10: underpowered. Supported helices ~60-130 nt downstream of the stall |
| 2026-11-02 | mlocarna, 5 seqs, explorer downstream_seq windows (<=80 nt from the stall; iter_v2_explorer80) | alifold |
| 2026-11-02 | mlocarna alifold, explorer downstream_seq windows (iter_v2_explorer80), corrected row: alifold_line was undefined in the first logging | alifold ...(((......((((.....)))).(((((........))))))))......(((..(((((.((.....)).)))))))).. (-28.97 = -15.96 + -13.01) |
| 2026-11-02 | superseded | by `cand_FJIS_261029` (pooled fz 5 + fz 106, 80-nt windows, MATER edit) |

### `cand_FJIS_261029`

| date | step | result |
|---|---|---|
| 2026-10-30 | mlocarna --probabilistic --consistency-transformation, 8 seqs from explorer FJIS_fz5,FJIS_fz106 (stall -20/+150 from the reference) | alifold .........(((((.....)))))....(((((((((.....)))).(....((((........)))))............)).))).......(.......(..(...((((...(((( |
| 2026-11-02 | mlocarna alifold, corrected (earlier row truncated by line wrapping) | 8 seqs (fz 5 + fz 106), 194 cols: (-50.10 = -27.19 + -22.91), 43 bp, -0.53 per bp. Weaker than either cluster alone: fz 5 and fz 106 kept as separate candidates |
| 2026-11-02 | mlocarna, 8 seqs, explorer downstream_seq windows (<=80 nt from the stall; iter_v2_explorer80) | alifold |
| 2026-11-02 | mlocarna alifold, explorer downstream_seq windows (iter_v2_explorer80), corrected row: alifold_line was undefined in the first logging | alifold ...(((......((((.....))))......((((........)))).)))..................................... |
| 2026-11-02 | r0 cmsearch vs library, --toponly --incE 1e-10 | cand_FJIS_261029.cm: nseq=8 eff_nseq=4.44 clen=82 bps=13 bifs=1 relent_cm=0.692.        9 ! hits /        9 accessions; 9 pass coverage >= 0.85; **0 novel** vs seed (8 seqs). SATURATED on library -- a cmalign round would only re-fit seed (8 seqs). Detail: /Users/jeaninegezelle/Desktop/viromelib/flaviLib/work/infernal/build/cand_FJIS_261029/iter_v2_explorer80/search_library/r0/hits.novel.tsv |
| 2026-11-02 | manual edit of the pooled 80-nt alignment, 2026-11-02 | build/cand_FJIS_261029/iter_v2_explorer80/mlocarna/results/result-oneblock_edit261102.stk (hand edit of result-oneblock.stk; 8 seqs: fz 106 x3 + fz 5 x5, explorer downstream_seq windows, all 80 nt). 97 cols, 22 bp: P1 7-10/60-63, P2 11-17/23-29, P3 36-39/48-51, PK A 4-6/53-55 (5 prime end), PK B 42-45/67-70 (P3 loop to downstream). Canonical: fz106 82 pct, fz5 79 pct |
| 2026-11-02 | MATER wiggle-refine of the edit, 2026-11-02 | build/cand_FJIS_261029/iter_v2_explorer80/mlocarna/results/result-oneblock_edit261102-MATER-wiggle-refined.stk. Same SS_cons; canonical fz106 60/66 (91 pct), fz5 91/110 (83 pct); PK A 9/9 and 15/15, PK B 12/12 (fz106) and 13/20 (fz5, weakest helix). Class 1-like layout (5 prime PK + loop-to-downstream PK). cmbuild keeps only the nested 15 bp. This is the seed for the first model |
| 2026-11-02 | R-scape in MATER (-s --onemsa) on the wiggle-refined edit, 2026-11-02 | input build/cand_FJIS_261029/iter_v2_explorer80/mlocarna/results/result-oneblock_edit261102-MATER-wiggle-refined.stk; output build/cand_FJIS_261029/iter_v2_explorer80/rscape_mater/. 8 seqs, avgid 53.08, 22 bp, 4 covarying vs 0.2 +/- 0.5 expected, FP 0, PPV 100, Sen 18.18; 1.5 substitutions per bp. Covarying: P1 9-61, P2 17-23, P3 37-50 and 39-48 (E 0.010-0.049). PK A 4-6/53-55 and PK B 42-45/67-70 untested (0-2 subs, power 0). Passes the covariation gate: every nested helix supported |
| 2026-11-02 | path correction for the MATER R-scape row above | MATER R-scape output is in build/cand_FJIS_261029/iter_v2_explorer80/mlocarna/results/result-oneblock_edit261102-MATER-wiggle-refined-MATER-R-scape/ (unzipped; the .zip is beside it), not rscape_mater/. Command-line R-scape on the same file: build/cand_FJIS_261029/iter_v2_explorer80/rscape_refined/ |
| 2026-11-02 | library search, cm_iterate.sh --check-only, --toponly --incE 1e-10 | build/cand_FJIS_261029/iter_v2_explorer80/search_library/: 9 ! hits / 9 accessions, 0 novel (saturated on the library). The 8 seed sites (MH827524 594 = stall 10759, model starts at the stall) plus NC_012671 (Quang Binh virus) 544-623, 78.6 bits, genomic 10735 -- no explorer stall there (its 4 stalls are Class_1b); check the peaks tables |
| 2026-11-02 | reciprocal test with class1c (cmsearch -T 0 against each seed, ungapped) | class1c.cm on the 8 FJIS seeds: only ON949931, 13.3 bits. cand_FJIS_261029.cm on the 46 class1c seeds: 12 hit, 8 pangolin pestivirus full-length (cm 1-82) 12.5-21.9 bits (ON024090 E 6.8e-06), 4 hepaci partial (cm 11-42 / 26-42) 7.6-10.9 bits. Weak one way, moderate the other: sibling families with a shared class 1-like architecture, not one family. Files build/cand_FJIS_261029/iter_v2_explorer80/cm/{class1c_on_fjis_seed,fjis_on_class1c_seed}.tbl |

| 2026-11-02 | NC_012671 10735 in the 261021 peaks tables | 10 mM: stall at 10735, n_reps_passing 2, SF 0.311 (failed the >=3-replicate gate); other tile rows 0 reps. 1 mM: nothing passing within 40 nt. Element present (78.6 bits), stall weak; relative MH827524 stalls at the same element (SF 0.863). Element downstream of the Class_1b stalls in Culex / Quang Binh genomes (feature 114-466 vs 544-709): tandem, no overlap |
| 2026-11-02 | status | covariation gate passed; library saturated; sibling of class1c. Open: Class_1b comparison, RNAvirus DB search, position overlap with the 7 models, name. Card in Part 3 (G1) |
| 2026-11-02 | r0 cmsearch vs RNAvirusDB, --toponly --incE 1e-10 | cand_FJIS_261029.cm: nseq=8 eff_nseq=4.44 clen=82 bps=13 bifs=1 relent_cm=0.692.        3 ! hits /        3 accessions; 3 pass coverage >= 0.85; **0 novel** vs seed (8 seqs). SATURATED on RNAvirusDB -- a cmalign round would only re-fit seed (8 seqs). Detail: /Users/jeaninegezelle/Desktop/viromelib/flaviLib/work/infernal/build/cand_FJIS_261029/iter_v2_explorer80/search_RNAvirusDB/r0/hits.novel.tsv |
| 2026-11-02 | Class_1b comparison: reciprocal scoring and library overlap | FJIS model on the 88 Class_1b seeds: 13 hit; ISF copies MECDV NC_027819 xr1 24.3 b 2.6e-06, NIEV NC_024299 xr1 21.5 / xr2 19.6, PaRV NC_027817 xr4 18.9 / xr1 12.3, AEFV NC_012932 xr3 13.2. Class_1b on the 8 FJIS seeds: 4 hit, all fz 5 (NC_024299 19.1 b 1.7e-04; NC_021069, MH827524, AB981186 10.7-12.7 b); fz 106 none. Moderate both ways: closer to Class_1b than to class1c; fz 5 element looks like a further, diverged copy in the ISF class 1b tandem array (NIEV: Class_1b seed xr1 10211, xr2 10349; FJIS site 10747). Library overlap (any inclusion): FJIS lower E at 10 of 28, Class_1b at 18; per-site split pending. Files build/cand_FJIS_261029/iter_v2_explorer80/cm/ |
| 2026-11-02 | RNAvirus DB result is threshold-limited | 3 hits at 1e-10 against 9 in the library: E scales with database size (~1e4 larger), so library 1e-13 hits fall to ~1e-9. Re-reading search_RNAvirusDB/r0/search.tbl at 1e-5 and 1e-3 |
| 2026-11-02 | per-site split with Class_1b in the library (cm_round_stats.py overlap, rows with an included hit) | clean partition: FJIS included and lower E at all 5 of its own sites (AB981186, MH827524, NC_012671, NC_021069, NC_024299 629-709; Class_1b there 10.7-20.4 b, not included); Class_1b included and lower E at all 14 of its sites (FJIS there 8.5-23.0 b, not included). No site included by both. NIEV NC_024299: Class_1b 92-185 and 230-315, FJIS 629-709 = three-copy array. File build/cand_FJIS_261029/iter_v2_explorer80/cm/fjis_vs_class1b_library_overlap.tsv |
| 2026-11-02 | RNAvirus DB search re-read at looser cutoffs | 3 hits at 1e-10, 5 at 1e-5, 5 at 1e-3: NC_021069, NC_012671, NC_008604, NC_034204, NC_034017, all library viruses. AB981186, MH827524, NC_024299, ON949931 (52-79 b in the library) absent: DB most likely lacks those genomes. No novel sequence |
| 2026-11-02 | open question | Class_1b subgroup or separate family? Class_1b is a weak broad model, so the clean split may reflect the model. Test: append FJIS hits to the Class_1b seed (cmalign --mapali, 1.1.2 --hand), compare per hit (build/class1b/iter_v3_plusFJIS/) |
| 2026-11-02 | published identity of the element (PMC7527734) | the cluster-5 element is the P1-deviant putative ISF xrRNA subset of that survey, found in downstream copies (xr3, xr4): PaRV_xr4 = NC_027817 (new hit at 544), CFAV_xr3 = NC_001564 (already a Class_1b seed sequence), MECDV_xr1 = NC_027819 (new hit at 561), MFV_xr1 = NC_034204 (cluster 106). Their open question was whether these form a subtype within subclass 1b; the cluster5 rebuild supports that. Only a 2-bp P1 was proposed there for PaRV_xr4; the MATER edit gives P1 4 bp (7-10/60-63) with 9-61 covarying |
| 2026-11-02 | cluster 106 reframed | 3 of the 4 published P1-deviant sequences are in cluster 5; the fourth (Menghai flavivirus NC_034204) is in cluster 106, the part that broke the Class_1b rebuild. So cluster 106 may be the diverged end of the same subtype, not a separate family. Test: add NC_034204 alone to the Class_1b seed |

### `cand_FJJI_cluster41_261029`

Folder renamed 2026-11-02 from `cand_FJJI_fz41_261029`.

| date | step | result |
|---|---|---|
| 2026-11-02 | mlocarna, 12 seqs, explorer downstream_seq windows (iter_v2_explorer80), from FJJI_fz41 | alifold .((.((((((((......)))))..))).).).(((....)))................................................ (-25.52 = -14.00 + -11.52) |
| 2026-11-02 | Mg dependence from the explorer detection field | all 12 fz 41 sites are detected at 10 mM only (none at 1 mM), SF 0.55-0.86: Mg-dependent like class 2 sites in these libraries, unlike cand_FJTB_261026 (holds at 1 mM). fz 44 is detected mostly at both. A second difference between fz 41 and fz 44, consistent with the failed pooled alignment |
| 2026-11-02 | candidates renamed | fz41 -> cluster41, fz44 -> cluster44, pooled cand_FJJI_261029 -> cand_FJJI_cluster41-44_pooled_261029 ('fz' = frozen cluster, spelled out). Pooled run fails: two separate candidates |

### `cand_FJJI_cluster44_261029`

Folder renamed 2026-11-02 from `cand_FJJI_fz44_261029`.

| date | step | result |
|---|---|---|
| 2026-11-02 | mlocarna, 8 seqs, explorer downstream_seq windows (iter_v2_explorer80), from FJJI_fz44 | alifold .((((((((((((((....))..))))))....))))))(((..........)))........................... |
| 2026-11-02 | mlocarna alifold, corrected row (energy regex missed space-padded energies) | alifold .((((((((((((((....))..))))))....))))))(((..........)))........................... (-29.53 = -19.54 +  -9.99) |

### `cand_FJJI_cluster41-44_pooled_261029`

Folder renamed 2026-11-02 from `cand_FJJI_261029`.

| date | step | result |
|---|---|---|
| 2026-11-02 | mlocarna, 20 seqs, explorer downstream_seq windows (iter_v2_explorer80), from FJJI_fz41,FJJI_fz44 | alifold (.(((((.((.(((..........)).))).....))))))...................................................... |
| 2026-11-02 | mlocarna alifold, corrected row (energy regex missed space-padded energies) | alifold (.(((((.((.(((..........)).))).....))))))...................................................... (-16.91 =  -8.30 +  -8.61). Pooled fz 41 + fz 44 is weaker than either alone and has no significant R-scape pairs: two separate elements |

---

# Part 11. Open items

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
  (2026-10-30: provided seeds are in `cm/seeds/` — `CL_Class_1b_xrRNA_final.sto` found there. Whether
  `stockholm/` still exists was not checked.)
- Infernal version of the other provided models (1a, 2, 3, dumbbell) — Part 2.
- `build_candidate_cm.sh` defects: GATE 1 passes on an energy parse failure; the alifold regex misses
  mlocarna's line format (`alifold<ws><structure> (…)`); mlocarna's exit status is unchecked; dedup
  can produce no output while the manual-step banner still prints; R-scape is left to the manual step
  and its outdir is not created; the tblout path is not printed.
- `gnuplot` missing in the `viromelib` env (R-scape skips its plots);
  `conda install -y -c conda-forge gnuplot`. `RFview` path under `~/local/lib/RFview/` is broken.

---

#### NEXT list of 2026-10-28 — superseded by Part 1

Kept for the items not yet carried into Part 1. Status of the first items as of 2026-11-02: 1 (step
18) closed — class1c saturated on the library; 2 (step 17) closed — no variant accepted; 3 (steps
15/16, MN564793) superseded by the overlap check — Class_1b wins there; 4–8 open; 13 (reference
windows) implemented as `make_pool_fastas.py` / `explorer_cm_scan.py fetch`.

Rewritten 2026-10-28. Grouped by what blocks what, not by priority alone.

#### Ready to run now

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

#### Discovery, in order of what the evidence supports

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

#### Blockers these depend on

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

#### Record-keeping

16. **Record the 261021 annotation command** in `flaviLib.md`. Steps 10 and 11b of the run log have
    it; the workflow document stops at the four-model 150x150 annotation.
17. **Decision 37 needs re-deriving, not patching.** Four problems: the no-hit call used 4 models
    not 7; the analysis took the lowest-p peak per accession, so one stall per accession; the peak
    calls come from the superseded August postproc; and the source flags *"double check the PLLG
    fishing from the Mifsud sheet was actually successful"*. Accessions in
    `build/cand_PLLG_260915/seed/PLLG_LGF_unclassified_60.fa` headers.
18. **Close the hepaci accounting gap** — one comparison over the original genus pool, not three
    partial ones. The 9 / 9 / 13 tiers may overlap; MN564793 is known to sit in two.

---

# Part 12. History

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

## Superseded: the alignment block as first written (2026-10-29)

Replaced by the block in Part 3 (2026-11-02), which adds `stk_oneblock`, the wrapped-line alifold
extraction and R-scape.

#### Aligning the no-CM explorer clusters (step 3 of the procedure)

Re-fetch the two that failed (cluster 41 returned 1 of 12, cluster 5 0 of 5), then align. Candidates by
clade and date; the frozen cluster index goes in the first log row as provenance. FJJI cluster 41 +
cluster 44 and FJIS cluster 5 + cluster 106 are also aligned pooled, to test one element across segments
(FJJI) and across the two FJIS groups. cluster 110 (loquat) is class 3 and is not aligned here.

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
between versions (one of the recorded `build_candidate_cm.sh` defects). cluster 106 (3 sequences) and
cluster 39 (4) are small for covariation; read their pooled runs first. Then the manual MATER /
CaCoFold step (procedure step 4) on whichever pass.

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
