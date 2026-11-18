# CM expansion: candidates, accounting, and procedure

**The single current document for CM discovery.** Start at Part 1 (Status). Conclusions found here; below files = dated records of what was run on the dates in the file name.

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

Last updated 2026-11-18 (**cluster 106 now has a model and it is SATURATED on the library**: `cand_FJIS_c106_261118`, built under 1.1.5, eff_nseq **1.62** — barely above the recorded rejection case of 1.55 — clen 80, 13 bp, 1 bifurcation, and the library search returns its own 3 seed sequences and **0 novel**. So the library holds no fourth cluster-106 site and the RNAvirus DB search is the point rather than a formality. **The tail was read, and "0 novel" was purely an artefact of `--incE 1e-10`**: there are six substantial non-seed hits — five **pangolin pestiviruses that are already class1c seed members** (15.9–26.1 b) and **MK636875 at 28.6 b, E 4.2e-06, which appears nowhere in this file**. Cluster 106 alone hits them *harder* than the pooled FJIS model did (12.5–21.9 b), so isolating it sharpened its link to class1c. **The competitor is class1c, not Class_1b** — nothing here touches `class1b_v2_inf112.cm`. **MK636875 is *Dongyang pangolin virus*, a pestivirus** — same group, not a new type. Asked whether class1c might encompass cluster 106 after all: three lines say no — the direct test failed (guided seed 1.55 / 1.33 / **−2.14** bits), class1c reaches only 1 of 3 cluster-106 seeds, and **the pestivirus sites cluster 106 finds are `cls None found` in frozen cluster 137, annotated by no model at all**. They are arrays, and cluster 106 hits mostly the **5′-most** copy — the E8 pattern a third time, now in *Pestivirus*. **New register entry: cluster 137**, 4 genomes, priority 3. Proposed next: **merge the 106 and 137 gaps** — the one route to a GATE 1 that means something *without* E7, since 3 near-identical sequences give R-scape no power while 4 divergent pestivirus genomes would. Conditional on "orphaned", which is unproven: those genomes are class1c **seed members**, so the class1c-locus check decides whether this is a merge or a mistake. **Method: the documented class1c lineage — `cmalign`, dedup, manual MATER, rebuild, one round only.** First result in: all six pangolin copies align at **PP 0.743–0.968**, against E2b's rejection at 0.397–0.465, so the grafting objection is answered by measurement. Bits are low (4.25–16.98) and two `3′` truncations are a **fetch artefact** — those windows are 74 and 76 nt against an 80-column model — so re-fetch with a 3′ margin before MATER. An earlier claim here that the merge should re-align rather than graft is **retracted**; grafting is what produced class1c, and what that lineage warns against is *iterating* (nine rounds drove `clusterA_refined` to eff_nseq 1.55), not grafting. **E6 IS COMPLETE** — `class1b_v2_inf112.cm` deployed, searched library-wide with `--toponly`, and 11b re-annotated both conditions under `DS=261117_flaviLib_150x150` (34,102 and 40,324 peaks, matching the 261021 inputs exactly, so only the annotation changed). **Part 1's priority list is revised**: B4 and E6 are done, cluster 106's alignment is done and its provisional model is next, and **HPPV 39 is now to be aligned together with cluster 135** because E8 showed they are two positions in one rodent-pegivirus array. Background: **`--toponly` searches are done: Class_1b 134 → 139, exactly the five predicted sites, and the database halving is confirmed in the statistics (185,242 residues against 370,484).** `class1c` gained **one** and `dumbbell` none — the reverse of the guess from the exposure table, because that table counted the 0.001–0.01 band while this gain is the 0.01–0.02 band. The five gains are confirmed as the predicted sites, **both CFAV xr3 isolates included**, so the published type example of the downstream subtype now annotates. The `class1c` +1 is **KY370101 12807** — *Pestivirus Q*, already recorded in Part 5 as a sub-threshold class1c hit at 14.9 b that "stays open as a site", and placed by E5 in **frozen cluster 131, a main Class_1b cluster**. The 10-30 class1c *seed* decision is unaffected; what changed is that the existing model now annotates the site. **No collision**: the two hits are 82 nt apart and annotate different copies of that array — `class1b_v2` takes genomic 12620–12726 (42.5 b) and `class1c` 12808–12900 (14.9 b), both in cluster 131. **E6 is clear for 11b**, with `TBLOUT` pointed at the `--toponly` directory. Background:  Of the eleven added or recovered sites, 5 annotate at `--evalue 0.01` — including **PaRV xr4** and **MECDV xr1** — but AB981186, NC_012671, OP860412 and **both CFAV xr3 isolates** sit at E 0.017–0.019 purely because step 10 searched both strands and doubled every E-value. CFAV xr3 is the published type example of this element and a named sequence of the provided seed, so that is not a tolerable place to stop: **10 of 11 would annotate under `--toponly`**. Searching all seven into a *separate* `$TBLOUT` keeps both tbl sets, so attribution survives without running 11b twice. Also retracted: **class 4's zero hits are a negative control passing**, and its zero at the permissive threshold is evidence that 0.01 is not manufacturing cross-family hits. Earlier framing:  Measured — AB981186 is 23.4 b at E 0.0086 in development and 23.4 b at E 0.017 deployed, *exactly* double, because searching both strands doubles the effective database size. So the five flipped sites are just those whose development E sat between 0.005 and 0.01, and **the searching Infernal's version is irrelevant**: calibration is stored in the `.cm` and read, not recomputed. The `--evalue` default is **0.01** while its help text claims 0.001; only the first is behaviour, and **it is not a cosmetic difference — at 0.001 four of the five gains vanish, including both recoveries** (PaRV xr4 at E 0.0018 and MECDV xr1 at 0.0023). 0.01 is also Infernal's own `--incE` default, which makes the script's filter agree with the `!` column, so the +5/nothing-lost comparison already recorded is the right one and **11b can run**. `--toponly` *is* the correct fix — the script discards minus-strand hits, so the doubling buys nothing and costs five real recoveries — but it is a **pre-existing 2× inflation in all seven columns**, so it is opened as its own step rather than folded into E6, and can be quantified with no re-search at all. `comm` on the included-accession sets is empty, and the five increases are MH827524, NC_021069 and NC_024299 (fifth array copies), **NC_027817 — PaRV xr4 recovered**, and **NC_027819 — MECDV xr1, where the old model found nothing at all**. Only `--evalue` remains before 11b. Two earlier worries are retired: `post_process_peaks.py` **discards minus-strand hits itself**, so the missing `--toponly` is harmless, and the **E-value does not depend on the searching Infernal** — calibration is stored in the `.cm` by `cmcalibrate` and read, not recomputed, and both models here were calibrated under 1.1.2 and searched by the same 1.1.5. Also: each tbl yields **four** columns, so a rename touches four. Earlier:  `post_process_peaks.py` reads the **E-value**, not `!`/`?`, and applies its own `--evalue` — so the `?` verdicts in the deployed tbl do not exclude anything. The deployed counts favour the successor: **134 included against the predecessor's 129**, 165 total against 161, four of them minus-strand from the missing `--toponly`. What remains is (1) the `--evalue` the 261021 run passed, which must be reused unchanged since it is part of what every one of the seven columns means, and (2) re-establishing the **no-loss rule on the deployed tbls**, compared by accession rather than coordinate. Superseded alarm:  The deployed tbl gives the five 23.2–23.4 b gains — AB981186, NC_012671, both CFAV xr3 isolates, OP860412 — as **`?` rather than `!`**, at identical bit scores: inclusion is an E-value test and the E-value depends on the database searched, so **"10 gained, 0 lost" was measured under a threshold the deployed search does not apply**. Whether those sites still annotate depends entirely on whether `post_process_peaks.py` honours the `inc` column, which this file has never recorded. Read the script and compare the predecessor's tbl before 11b. `class1b_v2_inf112.cm` sits in the cluster's `$CMDIR` at md5 `fa9768bce80ba3b6cbc57e9f238c097d` with `NAME class1b_v2`; the new env reports exactly `cmsearch still needed: class1b_v2_inf112.cm` and has moved `POSTPROC_BASE`/`LOG` to 261117, so the 261021 annotation is safe. The **cluster runs Infernal 1.1.5** against a model built by 1.1.2 — the line's normal situation, but MANIFEST now records `searched_by_infernal` as well, because E1's `AB021287` loss was a *filter* artefact and filters are what differs between versions. **Before step 10, `$CMS` must be word-split and counted** (7 entries, none missing from `$CMDIR`): the env's own loop checks the `.tbl` and not the `.cm`, so it cannot catch a corrupted model name. Staged in `flaviLib/work/infernal/deploy_261117`: `class1b_v2_inf112.cm` with `NAME class1b_v2`, md5 `fa9768bce80ba3b6cbc57e9f238c097d`, plus `class1b_groups.tsv` and a 10-column `MANIFEST.tsv` whose md5 matches the file that ships. Part 9 now opens with **Local or cluster**, because that was the real source of confusion: there are **two machines, each with its own env script**, and **`$CMDIR` resolves differently on each** — `work/infernal/cm` on the laptop, `work/06_infernal/cm` on the cluster — so a command carried between them resolves and is wrong. The laptop builds and tests models; the cluster does the annotation, and `$CMS` is defined there and only there. `env_261021_flaviLib.sh` is the **cluster's**. Today: this file's E6 section was **duplicated** by a bad splice of mine and the stale copy contradicted the corrected one — deduplicated. Three clarifications. **Block B** is the *cluster* half of E6 (dated env copy, three `sed`s, step 10, step 11b); block A is the laptop half and is now `cm_deploy_class1b_v2.sh`. **The deployed `cmsearch` is not the development one** — step 10 runs the plain form, with **no `--toponly`, so both strands**, and the default `--incE`, so deployed tables and Parts 1–8's numbers are not directly comparable; the check is that plus-strand included hits agree. **Names change when the model changes, never on their own**, because the annotation column *is* the filename: `class1b` is renamed at E6 and nothing else is, even though `cl3_NAR_2025.align…SS_cons.cm` is a 56-character build name that should never have been deployed — it gets renamed when cl3 is next rebuilt. Also: a model has a second, internal `NAME`, already clean across the set, which must be checked against the new filename before staging. Previously: **E8 closed and E6 live again. The positional hypothesis is confirmed and there is nothing to add: the accepted model *is* the positional model.** With species names attached, clusters 5 and 21 are **entirely insect-specific flaviviruses** and 3′-most in **8 of 8**, while clusters 39 and 135 are **entirely rodent pegiviruses** — cluster 39 being `HPPV 39`, already a registered gap — so the apparent 5′ satellite was a different genus, not a second ISF position, and my earlier "satellites occupy the array's ends" merged two genera and is retracted. Every ISF positional element is seeded or already annotated **except Kamiti River virus NC_005064 11245**, rejected alone on 11-03 as `kamiti`, so `e8b` has no experiment left and is struck. The 13 genomes this file had never mentioned are hepaci-, pegi- and pestiviruses plus *Tamana bat virus* — non-*Flavivirus* Flaviviridae, belonging to the priority-8 clade pools, not to E7. **NC_008604 10707 is resolved and nothing gates E6**: the original model has *no hit at that locus at all*, included or reported, while the accepted model has one at 20.9 b `?` two nt from the stall — so E3's stated reason was wrong, its conclusion stands, nothing was lost, and the 11-02 acceptance is intact. `hits_at_stall` now reports a distance, because its ±1 tolerance printed that 2-nt hit as a flat `no`. **Step 4 is done**: `env_261021_flaviLib.sh` is **on the cluster**, so E6 is a **two-machine deployment** — CM development here, steps 10 and 11b on the HPC. Its `$CMS` is seven `.cm` basenames, recorded verbatim. Three corrections follow: there is **no `cm_set_` directory on the cluster** (models are flat in `work/06_infernal/cm` and the set is the `$CMS` list alone, so nothing is deleted — dropping the old name *is* the replacement); **`$DS` must be bumped** to `261117_flaviLib_150x150` or step 11b overwrites the 261021 annotation this file's gap counts rest on; and the env file's own closing loop **verifies the swap for free**, naming `class1b_v2_inf112.cm` as still needing `cmsearch` until step 10 runs. The E6 block is rewritten as A (laptop: stage, md5, MANIFEST, `scp`) and B (cluster: dated env copy, three `sed`s, step 10, step 11b per condition). **Nothing now gates E6.** Formerly: **E8 view 1 run, positional hypothesis holds 8 of 8** — every cluster-5 and cluster-21 satellite is its array's 3′-most copy — but the right statement is **satellites occupy the array's *ends***, because LC602141, MT210614 and MT210620 each carry a **cluster 39** copy at the 5′ end as well, making `HPPV 39` a 5′-terminal subtype rather than a scattered gap. 20 of the 22 apparent failures are unclustered 3′-most copies, open cases rather than counterexamples; only MW897328 and ON949931 are genuine. **View 2 raises a contradiction that must be settled before E6 moves**: five of the six added cluster-5 sequences are included, but **NC_008604 10709 is 20.9 b `?`, not included**, where the E3 row says that locus "was already an included hit" — so either E3's reason is wrong or the accepted model lost an included hit and fails the no-loss rule it was accepted under. Also: `KC181923 859` is one of **E2b's** nineteen, not E2's nine, correcting my own earlier row. The candidate list needed three fixes (seed exclusion, a bit floor, and clustering support exempting a candidate from that floor) and `e8` now chains both views. **E6 remains held.** Part 1 now carries **Next, in order**, a six-step runnable procedure: install and md5-verify the script, re-run `e8`, settle NC_008604 10707 (gates E6), find the real `$CMS` definition, run `e8b`, then E6 with whichever model survives. `e8`'s first run was invalid** — `class1b_arrays.py` filtered `cls == "1b"`, and the explorer's `cls` is **CM-derived**, so every satellite copy is labelled `None found` by construction and the filter deleted the question; it also read an unassigned `fz` of `None` as a satellite, manufacturing all four counterexamples. Both fixed. **One real result survived: KC181923** carries copies at 10492 / 10630 (fz 133) and **10929 (fz 21)** — a cluster-21 satellite as its 3′-most copy, in a genome this file calls ordinary core Class_1b, and in no addition set. The decisive check is whether `KC181923 859`, one of the nine marginal sites E2 loses, *is* that element; if the nine marginals are the satellites, E2's fragility finding and the positional hypothesis are one result. **`scripts/env_261021_flaviLib.sh` does not exist**, so the claim that `$CMS` lives there is a stale path inherited from the 261021 run log, and E6 step 4 is unverified until the file is located. Two corrections first: **the accepted model is not "cluster 5"** — that phrase names the seed-addition set that survived E2, not the model's coverage, and the model already recovers PaRV xr4, MECDV xr1 and **CFAV xr3** (a named sequence of the provided seed, finally included at 23.4 b) and already spans two frozen clusters, since LR694076 10565 is fz 21; and **Part 9's `_inf<ver>` rule is conditional**, applying only to a non-default builder, with the version authoritative in the `.cm` header rather than the filename. **E8**: PMC7527734 defines this element *positionally* — the P1-deviant subtype sits in downstream copies, xr3/xr4 — and E5's satellite pattern found the same from the clustering side, so the set to seed may be "the 3′-most copy of every ISF array", which **no step has tested**: E2 cut on bit score, `newvirus` on novelty, and 11-03 tested the sub-threshold sites one at a time. `class1b_arrays.py` plus `cm_class1b_E.sh e8`/`e8b` run it in two independent views; E5's own data already contains one counterexample (MW897328's odd copy is upstream of its main-cluster copy). E6 is held because steps 10–13 are the expensive part and E8 is one `cmbuild`. The **grep sweep is done**: 49 hits, only three live consumers (`build_pllg_outputs.py:142`, `plot_combined_peaks.R:50`, `flavi_env.sh:29`), the rest archived logs and provenance not to be edited — and `scripts/env_261021_flaviLib.sh` is **not among them**, so `$CMS` is a directory or glob and "replaces, does not join" is enforced by the predecessor being absent from the new set rather than by editing a list. **the deployed name is settled: `class1b_v2_inf112.cm`**. Previously: **E1–E5 all complete, E6's commands written** — grounded in Part 9's steps 10 and 11b, and resting on two facts from there: `$CMS` in `scripts/env_261021_flaviLib.sh` is the single definition of the annotating set, and a model's filename *is* its annotation column. **The successor replaces Class_1b rather than joining as an 8th model**, so the set stays at 7 and the earlier "against 8 models" notes are corrected; **the deployed name is settled: `class1b_v2_inf112.cm`**, so the annotation column becomes `class1b_v2_inf112.cm_hit` -- a new name rather than a content swap under the old one, with the build name `class1b_plusFJIS_cluster5_inf112` kept in MANIFEST's `build_path` and the run log instead of in every downstream table. Part 9 gains **Versions of an existing model** to cover the case the stage scheme had not: `<family>_v<n>_inf<ver>.cm`, the family name retained, a version replacing its predecessor rather than joining it, and a version bump requiring a recorded grep sweep for the old column name -- **that sweep is the next action**, before E6 runs. `cm/class1b_groups.tsv` is written — 19 rows, no placeholders — and its key result is that **no site included in the deployed model is `core`**: all eleven model members are `transition:*`, the satellite copies rather than main-cluster elements. Four rows carry an unresolved group and must not be joined yet. The 10-29 explorer snapshot is confirmed intact and backed up. **the explorer has been regenerated and `explorer_cm_scan.py extract` no longer runs on it** — its nodes have lost `fz` and gained `e1c, ev, fam, q, xr`, with cluster assignments now in `DATA.sets[].cl`. Only `extract` is affected: `seqs`, `fetch` and `annotate` read `data.json`, so **nothing is blocked**. The hazard is that `extract` writes `data.json` and truncates the node files *before* it crashes, which would destroy the 10-29 snapshot — back those three files up first. **Do not revert the explorer**: the generator changed, so reverting defers the problem and discards the new fields; keep both, dated. `explorer_cm_scan_fz.patch` fixes `extract` and adds the backup. E5's labels stand — its node table is the 10-29 snapshot and cross-checks exactly against the documented counts. Also an interface audit of the new scripts against the four existing ones: one real bug found (`cm_round_stats.py fetch` writes its `OUT` argument exactly, which is why `insertcheck` failed). **E5 result: main Class_1b clusters are 131 and 133**, holding 62 of the 73 clustered Class_1b nodes; every B1/B2 label now assigned per stall, and **no B1 site is `core`**. A **satellite-cluster pattern** emerged: every cluster-5 genome carries 3–4 ordinary Class_1b elements in main cluster 131 plus the fifth copy in cluster 5, and clusters 21 and 135 repeat it — so the clustering independently separates the P1-deviant copy without reference to any CM. **class 2 is a class 1 subclass**, which answers the axis question: the `class1<x>` series is right and `class1d` is defensible in substance, held up only by class 2 not being in the series and by E7. **the base triple carries no class information** — every subclass has one, and class 2's is also C-G-C, which retracts both of the day's attempts to read cluster 106's naming off it. What survives is that the cluster 5 ↔ cluster 106 substitution is concerted and homologous; what changes is that **U•(A-U) is a novel identity**, not a within-class swap, making cluster 106 the outlier on the one feature where Class_1b and class 2 agree. A distinct element is therefore more defensible and the name `class1d` less: **do not use it** — the label stays `transition_candidate:106` until the feature matrix and E7 resolve whether the class 1 / class 2 axis is the right one at all. **E5 unblocked**: `fz` is *derived* by `explorer_cm_scan.py extract`, not a raw field — `DATA.nodes` has none, and per-site clusters live in `DATA.sets` as `cl` arrays parallel to the nodes. Part 3 already said so and a validated parser already existed; `e5` now uses it. **Open hypothesis raised**: class 2's long PK1 and purine between P2 and P3 make it resemble class1c and may make it a subclass rather than a class — and since cluster 106 has three purines there where cluster 5 has none, the P2–P3 insert is a cross-class axis that could cut across the class 1 / class 2 split; a feature matrix over the models' own seeds would settle it. **E4 complete, both parts pass**: `pp_check` reads C/G/C at cm 7/29/43 at PP 0.85–>0.95 in all six added cluster-5 sequences, and `insertcheck` finds **zero insert columns beside any of the three, occupied in 0/139 sites** — the seed layout stands, nothing needs re-comparing, and this was the last step that could have moved the model's columns. E5 is blocked on the explorer's field names (`DATA.sets` holds clustering definitions, not sites; run `--dump`) but **does not block the model** — only the `core`/`transition` labels. **E3 resolved**: 10 gains, `OP860412 297` among them, and NC_008604 10707 is **not** a gain — its copy was already an included hit, so the correct accounting is 5 own + 4 recovered + OP860412. **E4 `pp_check`: every one of the six cluster-5 additions carries the Class_1b C…G-C triple** at cm 7/29/43 with PP 0.85 to >0.95 and no insertions — so cluster 5 belongs inside Class_1b and should not be split off, against cluster 106's U…A-U; the `transition:5` label stays. `insertcheck` and E5 both hit script bugs, now fixed. **E2: `strong` and `newvirus` both rejected — Class_1b is saturated.** Each loses the same 9 hits, the 9 weakest at 23.4–27.8 b, **7 of them cluster 5's own gains**; and since the 68 novel hits were already found by the baseline, the trade is +2 sites against −9 for no annotation gain. `eff_nseq` 50.24→25.6 on similar additions and →71.32 on divergent ones, so the model is at its relative-entropy ceiling either way: library-internal expansion is closed, shown three ways on one baseline. **The model to deploy is cluster 5 alone**, and seven of its ten sites are marginal and will not survive a later revision. **cluster 106's three diagnostic features, and a concerted triple substitution between the clusters**: P1 shortened to 2 bp, three unpaired purines (AAA) between P2 and P3 present in 3/3 cluster-106 and 0/5 cluster-5 sequences, and the triple reading **C•(G-C) in cluster 5 (5/5) against U•(A-U) in cluster 106 (3/3)** at the same pooled columns — all three positions substituted together, each cluster invariant. That makes the triple real, independently reproduces the recorded Class_1b C…G-C from cluster 5, and locates the covariation **between** the clusters, which is why the pooled alignment yielded 4 covarying pairs where neither cluster alone can yield any: the pooled alignment is the one to cite for the structure, not a superseded step. With E2b this gives a distinct class 1 element, sibling to Class_1b, still gated on E7 for sequences. **cluster 106 has a conserved U•A-U base triple** — U6 against pk_A's innermost A5-U48 pair, all three positions invariant; the new alignment swallows that U into pk_A as a 4th pair, which the pooled alignment correctly left unpaired. Class_1b's triple is C…G-C, so this is the same interaction with the identity substituted, which **supports** class 1 membership and makes `class1d` defensible on architecture — correcting the opposite conclusion reached earlier the same day from the wrong expectation. `cmbuild` sees neither the triple nor the pseudoknots: 13 nested bp either way. **cluster 106 aligned alone**: same architecture as the pooled alignment element for element — P1 2 bp, 7-bp inner hairpin, 4-bp hairpin 2, pk_A `GGAU:AUCC`, pk_B `UCAC:GGUG` — and cluster 106 fits that structure at least as well as cluster 5 (98 % vs 97 % canonical, and 100 % vs 80 % on pk_B). But **16 of its 21 pairs are identical in all three sequences**, so covariation has no power on P1 or either pseudoknot: GATE 1 is inapplicable, not failed, and only E7 can settle a class claim. No conserved C 5′ of P1, so `class1d` should not be presumed as the name. **E1: AB021287's loss is a filter artefact** — NO HIT by default but 30.0/30.2 b under `--max` in `strong`/`newvirus`, higher than the original model's 29.7 b, so the CM never lost it and **library-internal Class_1b expansion is reopened**; E2 is the live step and E6 deployment waits on it. Cluster 5 stays in: nothing in E2b bears on it. **E2b complete: cluster 106 rejected on every criterion** — PP 0.397/0.465/0.424 5′-truncated with negative alignment scores, identical between 1.1.5 and 1.1.2; 19 hits lost including eight of cluster 5's own ten gains, eff_nseq 50.24→71.32 on three sequences, 111 hits lower; and by a position check the three sites are **not recruited at their stalls** at all, the model instead finding other loci — ON949931 even loses a 30.2 b Class_1b hit 333 nt away. Cluster 106 is a different element sharing an architecture, not a subtype; → Track B, and E7 for a named class. `flavi_env.sh` gains `hits_at_stall`, since the first check used accession membership. Side finding: `cmalign` to a fixed model is version-stable where `cmbuild` is not. `cm_set_261021` mixes builder versions — `class1c.cm` is 1.1.5, the three provided `CL_*` are 1.1.2 — so the env is derived per model from its header, never configured once. The conda env is now part of the method: `flavi_env.sh` activates it, exits on a missing tool and pins `cmalign` to 1.1.2. Cluster 106 reopened: the covariation that defines the pooled structure comes from comparing cluster 5 with cluster 106, cluster 106 is 91 % canonical on it vs cluster 5's 83 %, and every rejection of 106 used the superseded 88-seq model — new step E2b tests it alone on the cluster-5 baseline, and the file's two readings of the Menghai triple contradict each other; `class1b_groups.tsv` extended to nine columns with `decided`/`model`/`change`/`rationale`; `flavi_env.sh` holds every path for all scripts; naming scheme revised in Part 9 — stage prefix `aln_`/`cand_`/`conf_`/`class<N>`, `c<N>` for frozen clusters, the alignment round out of the name and into `iter_v<n>_<window>`, with `cm_rename_builds.sh` to apply it; classification status added to Part 1: finished classes / Class_1b extensions and transitions from 1b / unknown; the Class_1b expansion route decided as E1–E7; `class1b_groups.tsv` specified in Part 9; the two tracks and where the manual MATER step sits, Part 8; `cm_class1b_E.sh` and `cm_candidate.sh` written, the latter superseding `build_candidate_cm.sh`; next-priority list replaced; Part 1 workstream rows brought to 11-03 state). Previous: 2026-11-03 (sub-threshold Class_1b additions rejected; the triple read with windows and PP; seed-shift question answered; explicit Class_1b membership table; cluster 106 plan). Reorganised into dated parts on 2026-11-02; no content removed
(superseded passages are kept and marked).

## How to read this file

The file is in parts, most current first. Every dated section says when the work was done; the
**Run log** (Part 10) has one row per step, written by the scripts or by `clog`.

| part | what | dates |
|---|---|---|
| 1 | **Status: goal, classification status, where Class_1b expansion goes, where each workstream stands, next steps** | 2026-11-17 |
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

There are many tables; these five are the ones to read, and the rest are dated measurements or
superseded snapshots kept for provenance.

| question | table |
|---|---|
| which site groups are finished, Class_1b extensions / transitions, or unknown; what is next | **classification status** and **where Class_1b expansion goes**, Part 1 |
| what is still uncovered, and what is being worked on | **gap register**, Part 3 |
| what each candidate is, and which gates it has passed | **candidate cards**, Part 3 |
| which models annotate the data | **the 7 annotating models**, Part 2 |
| model statistics side by side (nseq, eff_nseq, clen, bps, bifs) | **model statistics**, Part 4 |
| what was measured on a given day | the dated tables in Parts 3, 6 and 7, and the **run log**, Part 10 |

Superseded by the gap register, kept as the derivation: the **progress table** and **counts of what
is not covered** (Part 7), **known uncovered** (Part 5). The **pool queue** (Part 3) is not
superseded — it holds the per-clade site counts and the pipeline stage of each clade.

---

# Part 1. Status — 2026-11-17 (workstream table rows 4 and 6 current; the rest 2026-11-02)

## Goal

Find covariance models for Xrn1 stall sites that none of the 7 annotating models explains (the
"no CM" sites), working through them cluster by cluster, grouped by Mifsud sub-clade. Each new
model starts as a candidate, `cand_<CLADE>_<yymmdd>`, and is accepted only after it passes the
gates in Part 8.

Along the way two existing models were checked for whether they could be **extended** to cover
sites they narrowly miss: class1c and Class_1b. That matters for gap filling because a site an
extended model can claim is not a gap. Neither extension has been accepted, so the gap list is
unchanged by them. *(Superseded 2026-11-02: the Class_1b extension by FJIS cluster 5 was accepted
as `class1b_plusFJIS_cluster5_inf112`. It is not deployed — not in `cm_set_261021` — so every
"no CM" count in this file is still against the 7 models.)*

## Classification status — 2026-11-16

Every site group in this file is in one of three states. This section is the summary; the gap
register (Part 3) holds the per-gap detail and the run log holds the steps.

- **A. Finished.** Annotated by a model in `cm_set_261021`, or assigned to one with no open question.
- **B. Class_1b extension.** Added to, or tested against, the Class_1b seed. Split into **core**
  (member sites cluster with the main Class_1b clusters) and **transition from 1b** (member sites
  fall in a separate explorer frozen cluster). A transition group keeps its own label **even after
  the Class_1b model includes it** (rule B3), so absorbing it into the model does not erase the
  distinction.
- **C. Unknown.** No model and no assignment. Ordered by priority in "Next priority" below.

### A. Finished classes

| class | model | state in flaviLib | site groups assigned to it in this work |
|---|---|---|---|
| Class_1a | `CL_Class_1a_xrRNA_final.cm`, provided | annotating. 13 of 15 dumbbell genomes also carry 1a | — |
| Class_1b | `CL_Class_1b_xrRNA_final.cm`, provided, Infernal 1.1.2 | annotating; weak, broad model (median E 4.0e-06). Successor version `class1b_plusFJIS_cluster5_inf112` accepted 11-02, **not deployed** (section B) | explorer cluster 133 (*Aedes flavivirus*) was already Class_1b |
| Class_2 | `CL_Class_2_xrRNA_final.cm`, provided | annotating | none added. CFAV xr1/xr2 are not class 2 here (partial, cm 17–63 of 93, ~4 orders weaker in E than Class_1b) |
| class3 (cl3) | NAR 2025 alignment | annotating; call at `--call-bits 20` | **cluster 110**, *Loquat jingmen-related virus 1*, one site per segment (closed 10-29) |
| class1c | `class1c.cm`, built 09-17 | annotating. Saturated on the library; borderline variants rejected (10-30); kept separate from Class_1b, overlaps resolved by lower E (Class_1b won 16 of 16) | cluster 137 (19 pangolin pestiviruses); 45 explorer "None found" nodes = its seed sites |
| cl4_v9 | built from viromelib | 0 hits in all 439 flaviLib accessions | — |
| Flavivirus_DB (dumbbell) | RF00525 | annotating | — |

### B. Class_1b extensions

**Main Class_1b clusters: not yet determined.** Known 1b-dominated frozen clusters: **cluster 131**
(48 Class_1b + 10 class1c + 11 none) and **cluster 133** (*Aedes flavivirus*); cluster 130 is mixed
(8 class1c + 7 Class_1b + 1 none). The explorer holds 106 Class_1b nodes, so these account for
about half. Block B4 tabulates the rest and the frozen cluster of every site below. Until it is run,
the "label" column is provisional except where the cluster is known to be a no-hit cluster.

#### B1. Included in `class1b_plusFJIS_cluster5_inf112` (accepted 11-02; 94 seqs, 10 gained, 0 lost)

| group | sites (genomic stall) | frozen cluster | label | evidence |
|---|---|---|---|---|
| FJIS cluster 5: fifth ISF array copies | NC_008604 10707, NC_021069 10735, NC_024299 10747, AB981186 10732, MH827524 10759; + NC_012671 10735 (no explorer node: 2 of 4 reps, SF 0.311) | **5** (no-hit cluster) | **transition from 1b** — the P1-deviant ISF subtype (PMC7527734) | joins Class_1b with 0 losses; triple C…G-C read at cm 7/29/43 (PP not measured, B4 / Part 3 `pp_check`); 4 covarying pairs in the pooled `cand_FJIS_261029` alignment |
| P1-deviant loci of the seed's own sequences, previously `?` | NC_027817 543 (PaRV xr4, stall 10757); NC_027819 561 (MECDV xr1); LR694076 10565 and MH237596 10555 (CFAV xr3) | LR694076: **21**; others: B4 | **transition from 1b** where the cluster is not a main 1b cluster; otherwise core | 19.9–22.3 b `?` under the original model → 23.4–28.3 b `!` |

**Count conflict — RESOLVED 2026-11-17 by E3.** The ten `NEW` rows of the accepted model are, with
baseline bit scores:

| site | bits | | site | bits |
|---|---|---|---|---|
| NC_024299 628 | 30.1 | | NC_012671 545 | 23.4 |
| NC_027817 543 | 28.3 | | LR694076 476 | 23.4 |
| NC_027819 561 | 27.7 | | MH237596 478 | 23.4 |
| MH827524 595 | 26.6 | | **OP860412 297** | **23.2** |
| NC_021069 597 | 24.9 | | | |
| AB981186 590 | 23.4 | | | |

Count = 10, and **`OP860412 297` is among them.** The earlier arithmetic — "6 own sites + 4
recovered loci" — was wrong on one point: **NC_008604 10707 is not a gain.** Its cluster-5 copy was
added to the seed (it is one of the six sequences `pp_check` aligns), but it was *already* an
included hit, so adding it to the seed produced no new annotation. The correct accounting is
**5 own sites + 4 recovered loci + OP860412 297 = 10**, and the rejections of further additions were
right to call `OP860412 297` "the hit cluster 5 gained". B1 above lists NC_008604 as a gain; that
one row is the error.

#### B2. Tested against Class_1b, not included — transition candidates, open

These were rejected as additions to the **model** (each loses an included hit), not as Class_1b
relatives. They stay in the record as transition candidates and as gaps.

| group | sites | frozen cluster | why not in the model | next |
|---|---|---|---|---|
| FJIS cluster 106 | NC_034017 10511, NC_034204 10523 (MFV_xr1, the fourth published P1-deviant sequence), ON949931 10608 | **106** | `all` variant: PP 0.38–0.47, 5′-truncated, 11–17 hits lost. Not class1c either (1.55 / 1.33 / −2.14 bits guided) | **priority 2**: align alone at 80 nt; provisional model → RNAvirus DB, targeted NCBI ISF set |
| Kamiti River virus | NC_005064 11245 (feature 1079, 18.5 b `?`) | **21** | `kamiti`: loses `OP860412 297`, raises nothing. Aligns full length at PP 0.853; G·U at cm 43, a genuine triple variant | **E7**: sequences from outside this library, or a looser model of its own |
| MW897328 | 10653 (feature 66, 19.3 b `?`) | **135** | `phaiomys`: 3′-truncated, PP 0.622, loses AB981186 590, NC_012671 545, OP860412 297 | **E7**, same; triple unreadable here (insert shift at cm 29 and 43) |
| gains of the paused `Class_1b + novel hits` extension | OM030319 57 (stall 11865, SF 0.844), MN587651 70 (9782), MN587661 72 (9940, `all` only), OP860412 297 (10802) | B4 | `strong` / `newvirus` lose AB021287 65; `all` loses 5 Class_1b sites | AB021287 `--max` check, then rebuild on the cluster-5 seed (E1 / E2). MN587651 / MN587661 are rodent hepaciviruses with a class1c pair downstream: 1b-like element upstream of 1c |
| 13 hepaciviral partial Class_1b matches (Sept) | list in the Sept doc (`class1b_v3` survivors) | B4 | match cm 1–~74 only; fail past ~74 | **1b → 1c transition candidates**; reconcile inside the HPHV pool (priority 8) |

#### B3. Rule for transition labels (decided 2026-11-16, not yet written)

A site included by any Class_1b version is **core** if its frozen cluster is a main Class_1b
cluster (B4), and **transition:`<cluster>`** otherwise — and it keeps that label after inclusion,
so absorbing a group into the model does not erase the distinction. The annotation keeps the
`CL_Class_1b….cm_hit` columns as they are and adds one column, `class1b_group`, joined on
accession + stall from a **hand-kept** lookup, `cm/class1b_groups.tsv`. B2 groups get a row with
`group = transition_candidate:<cluster>` so they are not lost when they leave the gap list.

**Nine columns — including `decided`, `model`, `change` and `rationale`, the provenance of each
addition and why it was made — the reason the file is hand-kept rather than derived, and the rows
to write: Part 9 → `class1b_groups.tsv`.** Written at E6, with four `frozen_cluster` values coming out of E5.

#### E5 RESULT — main Class_1b clusters and every B1/B2 label, 2026-11-17

Run on `explorer_cm_scan.py extract`'s node table. **Cross-checks exactly against Part 8's
documented explorer contents**, which validates it: the per-class drops between the 416 nodes and
the 265 that carry a frozen cluster sum to 151, and 416 − 265 = 151.

| cls | documented, all 416 | in a frozen cluster | unassigned |
|---|---|---|---|
| 1a | 78 | 71 | 7 |
| **1b** | **106** | **73** | **33** |
| 2 | 17 | 16 | 1 |
| dumbbell | 7 | 4 | 3 |
| None found | 208 | 101 | 107 |

**Main Class_1b clusters: 131 and 133.**

| fz | nodes | 1b | cum 1b | cum % of the 73 | other classes present |
|---|---|---|---|---|---|
| **131** | 69 | **48** | 48 | 66 | None found 21 |
| **133** | 14 | **14** | 62 | **85** | — |
| 130 | 16 | 7 | 69 | 95 | None found 9 |
| 135 | 4 | 3 | 72 | 99 | None found 1 |
| 21 | 3 | 1 | 73 | 100 | None found 2 |

131 and 133 hold 62 of the 73 Class_1b nodes that are in any cluster (85 %), or 58 % of all 106.
Cluster 133 is pure Class_1b; 131 is Class_1b plus 21 "None found".

**Every B1/B2 label, decided per stall.** No B1 site is `core` — all are transition groups:

| site | stall | fz | explorer cls | label |
|---|---|---|---|---|
| NC_008604 | 10707 | **5** | None found | `transition:5` |
| NC_021069 | 10735 | **5** | None found | `transition:5` |
| NC_024299 | 10747 | **5** | None found | `transition:5` |
| AB981186 | 10732 | **5** | None found | `transition:5` |
| MH827524 | 10759 | **5** | None found | `transition:5` |
| NC_012671 | 10735 | — | no node (2/4 reps) | `transition:5`, inherited from MH827524 10759 |
| LR694076 | 10565 | **21** | None found | `transition:21` |
| MH237596 | 10555 | — | **no node at this stall** | `transition:21`, inherited from LR694076 10565 (same element) |
| NC_027817 | 10757 | — | accession absent from the 416 | `transition:5`? — see below |
| NC_027819 | 10811 | — | **no node at this stall** | its 10587 node is **fz 7, cls 1a** |
| NC_034017 | 10511 | **106** | None found | `transition_candidate:106` |
| NC_034204 | 10523 | **106** | None found | `transition_candidate:106` |
| ON949931 | 10608 | **106** | None found | `transition_candidate:106` |
| NC_005064 | 11245 | **21** | None found | `transition_candidate:21` |
| MW897328 | 10653 | **135** | None found | `transition_candidate:135` |
| MN587651 | 9782 | **131** | None found | **`core`** — a main cluster |
| MN587661 | 9940 | **131** | None found | **`core`** |
| OM030319 | 11865 | — | no node | — |
| OP860412 | 10802 | — | no node | — |

**The pattern this exposes, and it is the independent confirmation the cluster-5 story needed.**
Every cluster-5 genome carries **three or four ordinary Class_1b elements in main cluster 131**, plus
the fifth copy in cluster 5:

| genome | Class_1b nodes in 131 | the cluster-5 copy |
|---|---|---|
| AB981186 | 10240, 10339, 10487, 10619 | 10732 |
| MH827524 | 10269, 10368, 10514, 10644 | 10759 |
| NC_012671 | 10245, 10344, 10490, 10620 | (10735, no node) |
| NC_021069 | 10244, 10343, 10489, 10621 | 10735 |
| NC_024299 | 10211, 10349, 10561, 10637 | 10747 |
| NC_008604 | 10246, 10478, 10598 | 10707 |

So the clustering, which knows nothing about any CM, independently separates the array's fifth copy
from its first four — exactly the P1-deviant ISF subtype this file identified from the literature and
from the triple. `transition:5` is the right label and it is now evidence-based rather than a
convention.

**Cluster 21 is a second group of the same kind**, not noticed before:

| genome | Class_1b nodes in main 133 | the cluster-21 copy |
|---|---|---|
| LR694076 (CFAV) | 10185, 10271 | 10565 — the recovered xr3 locus |
| NC_005064 (Kamiti) | 10358, 10954 | 11245 — the site the `kamiti` variant was rejected for |

And MW897328 likewise carries 11228 in main 133 while its own odd copy sits in 135. **So "a
main-cluster Class_1b copy plus one odd copy in a satellite cluster" is a recurring genome
architecture, and clusters 5, 21 and 135 are the satellites.** That reframes the transition groups:
they are not scattered oddities but the same phenomenon three times over, which is a reason to keep
the labels and a hypothesis worth testing against the remaining satellites.

**Two consequences for `class1b_groups.tsv`.** `MN587651 9782` and `MN587661 9940` sit in main
cluster **131**, so if either is ever included they are `core`, not transition — which is consistent
with their aligning at PP 0.74–0.93 and argues they are ordinary Class_1b that the model cannot hold
for entropy reasons (E2), not a distinct group. And `NC_027817`'s accession has no node at all, so
its group must be inherited; `NC_027819 10811` has no node either, though that genome does have an
**fz 7 / cls 1a** node at 10587, which is a Class_1a element and not a basis for inheritance.

#### B4. Commands that settle sections B1–B3#### B4. Commands that settle sections B1–B3

```bash
bash $FLAVISCRIPTS/cm_class1b_E.sh e5     # main 1b clusters + the cluster of every B1/B2 site
bash $FLAVISCRIPTS/cm_class1b_E.sh e3     # the OP860412 297 count conflict
```

`e5` calls `explorer_class1b_clusters.py`, which parses the explorer's `const DATA = {...}`
as JSON (position-wise, so a reformatted file still works) and prints Class_1b nodes per frozen
cluster with a **cumulative share**, then every explorer node in the B1/B2 genomes, then the
B1/B2 accessions with no node at all.

Read it as: the clusters down to ~80 % cumulative are the **main Class_1b clusters**. Record them
here, then fill the B1/B2 `frozen cluster` and `label` columns and the rows of
`class1b_groups.tsv` (Part 9). **Done 2026-11-17** — main clusters 131 and 133, every label assigned,
the groups file written. The script prints the `clog` line to run.

### Cluster 106's own alignment, read against the pooled one — 2026-11-17

Two hand-refined alignments now exist and can be compared directly:

- pooled, 8 seqs, 98 cols — `conf_FJIS_c5+c106_261029/iter_v2_explorer80/mlocarna/results/result-oneblock_edit261102-MATER-wiggle-refined_shortenP1forBT.stk`
- cluster 106 alone, 3 seqs, 85 cols — `aln_FJIS_c106_261117/iter_v1_explorer80/mlocarna/results/cluster106_edit261117.stk`

**The architecture is the same in both, element for element.**

| element | pooled (cols) | c106 alone (cols) | cluster-106 sequence |
|---|---|---|---|
| P1, outer | 9:62, 10:61 (col 8 is a gap in all three c106 seqs) | 8:55, 9:54 | **G-C, C-G** — the same two pairs in both |
| inner hairpin | 11:29 … 17:23, 7 bp | 10:27 … 16:21, 7 bp | the only variable element |
| hairpin 2 | 36:52 … 39:49, 4 bp | 31:46 … 34:43, 4 bp | A-U, C-G, G-C, U-A/G-C |
| **pk_A** | 4:56, 5:55, 6:54, 3 bp | 3:50 … 6:47, **4 bp** | **GGAU : AUCC**, 4 Watson–Crick |
| **pk_B** | 43:71 … 46:68, 4 bp | 37:61 … 40:58, 4 bp | **UCAC : GGUG** |

The pooled P1 looks like 3 bp but its 5′-most pair is cluster 5's alone (G-U); cluster 106 has two
P1 pairs in **both** alignments, and they are the same two. So the de novo pass did not change the
reading — it reproduced it in cluster 106's own coordinates, with pk_A one pair longer.

**Canonical fractions, cluster-106 sequences, pooled alignment:** nested 36/37 = 97 %, pk_A 9/9 =
100 %, pk_B **12/12 = 100 %** — against cluster 5's nested 58/58 = 100 %, pk_A 15/15 = 100 %, pk_B
**12/15 = 80 %**. Overall 57/58 = 98 % for cluster 106 against 85/88 = 97 % for cluster 5. **Cluster
106 satisfies this structure at least as well as cluster 5 does, and better on pk_B.**

#### The finding that governs everything else: these three sequences cannot support a structure

Across all 21 pairs of the cluster-106-alone alignment, **16 are identical in all three sequences**.
Only five vary at all, and two of those vary only because ON949931 gaps them:

| pair | element | the variation |
|---|---|---|
| 13:24 | inner | G-C / G-C / U-A |
| 14:23 | inner | G-C / **A-C non-canonical** / G-U |
| 15:22 | inner | C-G / U-A / gap |
| 16:21 | inner | C-G / U-A / gap |
| 34:43 | hairpin 2 | U-A / U-A / G-C |

**P1, pk_A, pk_B and three of hairpin 2's four pairs are invariant.** An invariant column pair
cannot covary, so R-scape has no power on any of them however the alignment is drawn — expected
covarying pairs ≈ 0. The two pseudoknots, which are the most interesting features here, are exactly
the ones that are 100 % sequence-conserved.

So GATE 1 is not merely unlikely to pass on cluster 106, it is **not applicable**: the covariation
gate is a statement about sequence diversity, and there is none. This is a **data limit, not a
modelling failure, and no further alignment work changes it.** E7 — a targeted set of complete ISF
genomes — is therefore not the preferable route to a class1d claim, it is the only one. The
provisional model's purpose is to be that search's query.

#### Two consequences for the scripts

1. **Neither file carries `#=GC RF`.** `cm_candidate.sh build` will therefore use plain `cmbuild`
   and infer match columns by occupancy, so `clen` is set by the data rather than by the hand
   annotation. For the cluster-106-alone model that is acceptable — it has its own coordinates
   anyway — but it must be recorded, because the resulting `clen` is not 85.
2. **The subset route does not preserve cm numbering on these files.** That claim, made earlier
   today, assumed RF was present; it is not. `subset` now says so and offers `--keep-columns`,
   which synthesises an RF line over every column the source alignment occupies so `--hand` keeps
   the full column set. The cost is model size: columns gapped in the retained sequences become
   consensus columns carrying prior-only emissions.

#### Cluster 106's diagnostic features, in standard nomenclature — 2026-11-17

Element names mapped onto the two alignments (`c106` = the 85-column cluster-106-alone file,
`pool` = the 98-column pooled file):

| element | c106 cols | pool cols | cluster 106 | cluster 5 |
|---|---|---|---|---|
| **P1** | 8:55, 9:54 — **2 bp** | 9:62, 10:61 (+8:63) | **2 bp**: G-C, C-G. Col 8:63 cannot pair — col 63 is gapped in all three | **3 bp**: G-U, C-G, A-U |
| **P2** | 10:27 … 16:21, 7 bp | 11:29 … 17:23, 7 bp | the only variable element: 13:24, 14:23, 15:22, 16:21 | invariant, 100 % canonical |
| **three purines** | **28–30 = AAA** | **33–35 = AAA** | **AAA, 3/3 sequences** | **absent — 0/5** (NC_024299 has a lone G at pool col 35) |
| **P3** | 31:46 … 34:43, 4 bp | 36:52 … 39:49, 4 bp | A-U, C-G, G-C, U-A/G-C | A-U … , pk_B region 12/15 = 80 % |
| **PK1** | 3:50, 4:49, 5:48 — **3 bp** after the fix | 4:56, 5:55, 6:54, 3 bp | `GGA : UCC` | `GGG : CCC` |
| **PK2** | 37:61 … 40:58, 4 bp | 43:71 … 46:68, 4 bp | `UCAC : GGUG`, 12/12 | 12/15 = 80 % |
| **base triple** | U6 • (A5-U48) | U7 • (A6-U54) | **U•(A-U)**, 3/3 | **C•(G-C)**, 5/5 |

So cluster 106 differs from cluster 5 at **three** diagnostic points, each conserved within its
cluster: P1 shortened from 3 bp to 2, three unpaired purines inserted between P2 and P3, and the
triple substituted.

#### The triple substitution is the strongest evidence in this file

The pooled alignment puts both clusters at the same columns, and the triple reads:

| | pool col 6 | pool col 7 | pool col 54 | triple |
|---|---|---|---|---|
| cluster 5 | **G** (5/5) | **C** (5/5) | **C** (5/5) | **C • (G-C)** |
| cluster 106 | **A** (3/3) | **U** (3/3) | **U** (3/3) | **U • (A-U)** |

**All three positions change together, and each cluster is invariant at all three.** That is a
concerted three-position substitution preserving the interaction — pyrimidine • (purine–pyrimidine)
in both cases. Two independent consequences:

1. **The triple is real.** A coincidence would not substitute all three partners coherently while
   staying fixed inside each cluster. And cluster 5's reading, `C•(G-C)`, **independently reproduces
   the Class_1b triple this file records as C…G-C at cm 7/29/43** — which is a cross-check on the
   Class_1b annotation as well, from sequences aligned without reference to it.
2. **It is where the covariation lives.** Within cluster 106 alone, 16 of 21 pairs are invariant and
   R-scape has no power (above). Between the clusters there is variation, and it is concerted — which
   is exactly why the pooled alignment yielded 4 covarying pairs against 0.2 expected while neither
   cluster alone can yield any. **The pooled alignment is not a historical artefact to be superseded
   by the cluster-106-alone one; it is the only alignment in which this element's structure has
   statistical support at all.** Keep both, and cite the pooled one for the structure.

#### What this settles, and what it does not

Taken with E2b, the picture is consistent and the two findings are not in tension:

- **Shared architecture**: P1, P2, P3, PK1, PK2 and a base triple at PK1's innermost pair, in both
  clusters, with between-cluster covariation supporting it.
- **Every diagnostic feature substituted** in cluster 106: P1 3→2 bp, an AAA insertion, and the
  triple C•(G-C)→U•(A-U).
- **Primary sequence too diverged for the Class_1b CM**: E2b, 19 hits lost, no recruitment at the
  stalls, PP 0.40–0.47.

Structural homology and CM-absorbability are different things, and this is the case that separates
them: two homologous elements can be too far apart in primary sequence for one covariance model.
That is the "siblings, not one family" relationship this file already uses for class1c.

So **cluster 106 is a distinct element, sibling to Class_1b** — distinct on three measured features
and not absorbable by the Class_1b CM. Whether it is a class **1** element is a separate question
the evidence here does not answer: the base triple cannot decide it (every subclass has one, and
C-G-C spans Class_1b and class 2), and the P2–P3 insert points the other way, toward class 2 and
class1c. So `class1d` is not the right name on current evidence, because it asserts an axis that is
itself in question; the label stays `transition_candidate:106`.

What is still missing is what it was before — **sequences.** A model from 3 sequences at 0.84–0.94
identity generalises to nothing, so E7 remains the gate, and the three features are the diagnostics
to search with: a 2-bp P1, an AAA insert before P3, and a **U•(A-U)** triple where both established
classes read C-G-C.

#### The base triple: U•A-U, present and conserved

**Cluster 106 has a predicted base triple, and it is the U at position 6 — currently mis-annotated
as part of pk_A.** Freeing it gives:

| | cluster 106 alone (85 cols) | pooled (98 cols) |
|---|---|---|
| triple base | **U6** — annotated as pk_A's 4th pair, `6:47` | **U7** — already an unpaired dot |
| the WC pair it contacts | **A5–U48**, pk_A's innermost pair | **A6–U54**, pk_A's innermost pair |
| triple | **U • (A-U) = U-A-U** | the same interaction, one column later |
| pk_A | should be **3 bp** (3:50, 4:49, 5:48) | **already 3 bp** (4:56, 5:55, 6:54) |

All three triple positions — U6, A5, U48 — are **invariant across all three sequences**. The pooled
alignment annotated this correctly a fortnight ago; the new cluster-106-alone file over-extends pk_A
by one pair and swallows the triple U into it. Corrected `SS_cons`, 85 columns, 13 nested bp
unchanged:

```
..AAA..(((((((((....)))))))...((((..BBBB..)))).aaa...))..bbbb........................
```

(`A` at 6 → `.`, `a` at 47 → `.`. Saved as `cluster106_edit261117_triple.stk` with the triple
recorded in `#=GF CC` lines.)

**The triple carries no class information, and two arguments made earlier on 2026-11-17 were
wrong.** Reported 2026-11-17: **every subclass has a base triple, and class 2's is also C-G-C.**
That retires both attempts to read the naming off this feature:

| | triple | where |
|---|---|---|
| Class_1b / cluster 5 | **C•(G-C)** | cm 7 / 29 / 43, PP ≥ 0.85, 6/6 |
| **class 2** | **C•(G-C)** | reported 2026-11-17 |
| class1c | ? | — |
| **cluster 106** | **U•(A-U)** | col 6 / 5 / 48, 3/3 |

- The **first** argument — no conserved C 5′ of P1, so not class 1 — tested the wrong position; the
  triple sits against PK1's innermost pair, not 5′ of P1.
- The **second** — a triple is present, so class 1 membership is supported — was wrong because
  presence is universal. Every subclass has one, so having one distinguishes nothing. And the C-G-C
  identity spans Class_1b **and** class 2, so even that is not class-1-diagnostic.

**What survives, and it is the stronger half.** The concerted substitution between cluster 5 and
cluster 106 at homologous columns — all three positions moved together, each group invariant —
remains good evidence that cluster 106's triple is **real** and that it is **homologous** to cluster
5's at that position. That was never an argument about which class; it is an argument that the
feature exists and is shared. It stands.

**What it now implies is the opposite of what I wrote.** If Class_1b and class 2 both read C-G-C,
then **U•(A-U) is a novel triple identity**, not a within-class substitution — cluster 106 is the
outlier on the one feature where the two established classes agree. Combined with its 2-bp P1 and
its AAA insert, that is three features, none matching either class fully. So a **distinct element is
more defensible than before**, while the name **`class1d` is less** so: it asserts class 1, and
nothing here places cluster 106 in class 1 rather than class 2. The insert in fact groups it with
class 2 and class1c (see the open hypothesis below).

**Working position, revised later the same day:** class 2 is itself a class 1 subclass (below), so
the `class1<x>` series **is** the right series and `class1d` is defensible in substance. What holds
the name up is bookkeeping and evidence, not the axis: class 2 belongs in the series and is not in
it, and cluster 106 has three near-identical sequences with no covariation support. The label stays
**`transition_candidate:106`** until E7. The novel U•(A-U) is meanwhile a **search diagnostic** for
E7, alongside the 2-bp P1 and the AAA insert.

**Neither the triple nor the pseudoknots reach the model.** `cmbuild` reads only the primary nested
`SS_cons`; `A`/`a` and `B`/`b` are not WUSS characters and are ignored, and Infernal has no base
triple state at all (Part 2). Both alignments therefore give a **13-bp** model — which is exactly the
`13 bp` recorded for the pooled model's `cmbuild` output, a useful check that nothing else is being
read. So the triple is annotation for the analyst, for R-scape `--cacofold`, and for any 3D work; it
cannot be scored, and a CM search can neither confirm nor refute it.

One further consequence: the triple positions being invariant means **covariation can never support
the triple either**, from these three sequences. It is a prediction from structure plus conservation,
and should be labelled as such wherever it is cited.

### class 2 is a subclass of class 1, and what that does to the naming — 2026-11-17

Reported from the structural side, and it settles the axis question rather than leaving it open:
**class 2 is misnamed. By structure these are subclasses of class 1.** Class 2's distinctive feature
is a **long PK1**; it differs from Class_1b in several ways besides, one being **the A between P2
and P3**. And **every subclass has a base triple** — class 2's is **C-G-C**, like Class_1b's.

So the feature table is not evidence for two classes, it is a table of subclass distinctions within
one:

| | P1 | PK1 | insert between P2 and P3 | base triple |
|---|---|---|---|---|
| Class_1b / cluster 5 | 3 bp | 3 bp | **none** (0/5) | **C•(G-C)**, 6/6 at PP ≥ 0.85 |
| **class 2** | ? | **long — its distinctive feature** | **an A** | **C•(G-C)** |
| class1c | ? | ? | **a purine** (reported as resembling class 2) | ? |
| **cluster 106** | **2 bp** | 3 bp | **AAA**, 3 purines (3/3) | **U•(A-U)** |
| Class_1a | ? | ? | ? | ? |

**What this means for cluster 106's name.** The series `class1<x>` is the right series — cluster 106
has the class 1 architecture (P1, P2, P3, PK1, PK2, triple at PK1's innermost pair), so there was
never a real question of it being "class 2 instead". `class1d` is therefore defensible in substance.

The difficulty is bookkeeping, not biology: **class 2 belongs in the series and is not in it.**
Adding `class1d` to a series that already excludes one of its own members leaves two inconsistencies
instead of one, and makes the lettering uninformative — a reader cannot tell from the names that
class 2 is a sibling of 1b while 1d is a sibling of both. So the order to do this in matters:

1. decide whether class 2 is renamed into the series (and to what), since that is the pre-existing
   inconsistency;
2. then assign cluster 106's letter, which is free once the series is coherent;
3. and only after E7, because a subclass with three near-identical sequences and no covariation
   support is not yet established regardless of what it is called.

Until then the label stays **`transition_candidate:106`**. That is a statement about evidence, not
about the axis, so it survives whatever is decided about class 2's name.

**Three positions were taken on this name on 2026-11-17 and the first two were wrong.** For the
record: (i) "no conserved C 5′ of P1, so not class 1" — wrong position for the triple; (ii) "a
triple is present, so class 1 is supported" — wrong because presence is universal; (iii) "the
class 1 / class 2 axis may not be real, so defer" — the axis question was real but is now answered,
and the answer is that class 2 is a class 1 subclass. What was stable throughout, and what the
evidence actually supports: cluster 106 is a **distinct subclass with the class 1 architecture**,
distinguished by a 2-bp P1, three purines between P2 and P3, and a **U•(A-U) triple where both
Class_1b and class 2 read C-G-C**. The novel triple identity is the strongest of the three, because
its positions substitute together and are invariant within each group.

**The feature matrix is still the thing to build**, now as a subclass table rather than a test of
the axis. The `?` cells — class 2's P1 length, class1c's triple, Class_1a's row — are what would
make the subclass distinctions systematic instead of pairwise. Procedure, per model: recover the
seed alignment (class1c's is in its build tree, Part 5; the provided models may need `cmemit -c`
plus the model's `SS_cons`), identify P1/P2/P3/PK1/PK2 in that model's own coordinates, and tabulate
the four features. PK1 length cannot come from any CM, since `cmbuild` reads only the primary nested
`SS_cons` — it has to come from an alignment with the pseudoknot annotated.

### Should cluster 5 be its own subclass? And when do the models get checked against each other?

**No, and `pp_check` is why.** All six cluster-5 additions carry Class_1b's **C…G-C triple at cm
7/29/43** with PP 0.85 to >0.95 and no insertions (E4, above). Cluster 106 carries **U…A-U** at the
homologous position. The triple is the class's defining tertiary feature, so on the one criterion
that distinguishes these elements structurally, cluster 5 is inside Class_1b and cluster 106 is not.

The fragility finding does not argue otherwise. Cluster 5's sites being the marginal band
(23.4–27.7 b) measures **divergence in primary sequence**, not a different architecture: they align
full length, at the right columns, with the right triple. A model's inclusion threshold is a
property of the model's entropy budget, and E2 showed that budget is exhausted — which is why those
sites are first to fall. Low score, correct structure.

What the sub-structure does deserve is a label, and it already has one: **`transition:5`**, because
cluster 5 occupies its own explorer frozen cluster (B1, B3). The E2 result strengthens the case for
keeping that label rather than dissolving these sites into `core` — they behave as a distinct, more
weakly-scoring group within the class, and the annotation should say so.

| | cluster 5 | cluster 106 |
|---|---|---|
| triple | **C…G-C**, PP ≥ 0.85, 6/6 | **U…A-U**, 3/3 |
| P1 | 3 bp | 2 bp |
| AAA between P2 and P3 | absent | present |
| joins the Class_1b CM | **yes**, 0 lost, 10 gained | **no**, 19 lost, not recruited at its stalls |
| verdict | divergent subtype **inside** Class_1b, labelled `transition:5` | **separate element**, sibling to Class_1b |

**When the models get checked against each other** — this is the overlap check, and it is per site
by **position**, never by accession membership (E2b is the cautionary case: a grep by accession said
cluster 106 "came in" when no hit covered its stalls). It happens at three points:

1. **Before E6, for the deployed set.** Each pair of models that could claim the same site gets
   `cm_round_stats.py overlap A.tbl B.tbl <nameA> <nameB>`, and overlaps are resolved by lower E —
   the procedure already used when class1c and Class_1b collided (Class_1b won 16 of 16). With
   cluster 5 merged, the pairs worth re-running are **Class_1b × class1c** and **Class_1b × Class_1a**,
   because the ten new sites are new opportunities for collision.
2. **For any new candidate, at `cm_candidate.sh build`.** The build stage prints the instruction;
   the test is the same `overlap`, plus **reciprocal scoring** — score each model's seed with the
   other's model and compare **bit scores** in both directions, never E-values across different
   targets. One family scores well both ways, siblings moderately, unrelated not at all.
3. **For cluster 106 specifically, once its model exists.** That is the measurement that converts
   "sibling" from a reading of E2b into a number. Expectation from E2b: moderate both ways.

```bash
# 1. deployed-set collisions, after E6 re-annotation
python3 $FLAVISCRIPTS/cm_round_stats.py overlap \
  <class1b.tbl> <class1c.tbl> Class_1b class1c

# 3. cluster 106 against Class_1b, both directions, bit scores
#    (needs the c106 model from cm_candidate.sh build)
C106CM=$INFERNAL/build/aln_FJIS_c106_261117/iter_v1_explorer80/cm/aln_FJIS_c106_261117.cm
esl-sfetch -Cf $FA <class1b_seed_fetchlist> > /tmp/c1b_seed.fa
cmsearch --toponly --max -E 100 --tblout /tmp/c106_vs_1bseed.tbl "$C106CM" /tmp/c1b_seed.fa
cmsearch --toponly --max -E 100 --tblout /tmp/1b_vs_c106seed.tbl "$C5.cm" \
  $INFERNAL/build/aln_FJIS_c106_261117/iter_v1_explorer80/aln_FJIS_c106_261117.stk.fa
```

Use `--max` for both directions of the reciprocal test: the point is what the CM scores, not what
the filter passes, and E1 showed those differ by enough to flip a conclusion.

### Where the three live questions stand — 2026-11-17

**1. Does Class_1b stay expanded with cluster 5? Yes.** Nothing in the E2b result bears on cluster 5.
Cluster 5 joined at **zero losses**; cluster 106 then cost 19, eight of which are cluster 5's own
gains. That is a measurement of cluster 106 — a model stretched to cover it stops covering what it
had — not a retraction of cluster 5. `class1b_plusFJIS_cluster5_inf112` remains the accepted
baseline and every comparison is made against it.

But **do not deploy it yet.** E1 reopened the 68-novel-hit extension (below), so the Class_1b model
that gets deployed may be cluster 5 **plus** `strong` or `newvirus`. Deployment means a new
`cm_set`, cluster steps 10–13 and a full re-annotation; doing that twice in a week is the thing the
E-ordering exists to avoid. E2 first, then E6.

**2. Is cluster 106 class1d? No — "not Class_1b" is necessary, not sufficient.** E2b settles that
Class_1b cannot align or recruit it. A name needs three things, and cluster 106 has none of them yet:

| requirement | status |
|---|---|
| a covariation-supported structure **in its own coordinates** | not done. The existing structure is the *pooled* consensus, which describes cluster 5 (5 of 8 sequences); cluster 106's 91 % canonical fraction is measured against that, which is evidence of relatedness, not of its own fold. **Track B, priority 2** |
| separation from the existing models **per site, by position** | partly: E2b shows Class_1b does not recruit it at its stalls, and the guided class1c test gave 1.55 / 1.33 / −2.14 bits. Needs the formal `overlap` check once a model exists |
| **recruits members beyond its seed** | impossible at present: 3 sequences at 0.84–0.94 identity build a model that finds only themselves. **E7 is the blocker** |

And a name is a fourth requirement, not a consequence of the other three. The architecture is class
1 — class 2 is itself a class 1 subclass, so `class1<x>` is the right series — but the base triple
cannot be what establishes that, since every subclass has one and C-G-C spans Class_1b and class 2
while cluster 106's U•(A-U) matches neither. The name waits on two things that are not evidence
about cluster 106 at all: resolving class 2's place in the series, and E7.

Until all three hold, the label stays `transition_candidate:106`.

**3. How is it expanded? Two routes, and the cheap one reuses the alignment you already made.**

The pooled refined alignment (`conf_FJIS_c5+c106_261029`) already contains cluster 106 fitted to
that structure by hand. So the first option is not a new alignment at all — it is **the same
alignment with the cluster-5 rows dropped**, rebuilt from the same columns:

```bash
source $FLAVISCRIPTS/flavi_env.sh
ITER=iter_v2_explorer80 bash $FLAVISCRIPTS/cm_candidate.sh subset aln_FJIS_c106sub_261117 \
  $INFERNAL/build/conf_FJIS_c5+c106_261029/iter_v2_explorer80/mlocarna/results/<refined>.stk \
  keep NC_034017 NC_034204 ON949931
```

`esl-alimanip --seq-k`, then `cmbuild --hand`. **Columns are not trimmed**: with `#=GC RF` present,
`--hand` keeps every RF column as a consensus column even where the three retained sequences gap
it, so `clen` and the cm numbering stay identical to the pooled model. That is what keeps cm 7 / 29
/ 43 — the triple columns — comparable between the two models, and it is the reason not to let
cmbuild re-infer match columns by occupancy here.

**What each route answers is different, and this is the thing to be clear about:**

| | subset of the pooled alignment | de novo alignment of the 3 alone |
|---|---|---|
| question answered | **does cluster 106 fit the structure cluster 5 defines?** | **what is cluster 106's own consensus structure?** |
| structure | inherited — and the pooled consensus was set by cluster 5, 5 of the 8 sequences | derived from cluster 106 only |
| cm coordinates | identical to the pooled model, so cm 7/29/43 line up | its own, not comparable |
| manual work | none; your MATER edit and pseudoknots are reused | a second MATER pass |
| what it can support | a reciprocal test, a library/DB search, an E7 query | **a class1d claim** |

The subset route is therefore first — it is free, it reuses the hand work, and it yields the
reciprocal test immediately: build the complementary cluster-5 subset the same way (`drop` the three
cluster-106 names), then score each seed with the other's model and compare **bit scores** in both
directions. One family scores well both ways; siblings moderately; unrelated not at all. Given E2b,
the expectation is "siblings", and measuring it is worth more than asserting it.

What the subset route **cannot** do is establish cluster 106's own fold, because the structure it
uses is cluster 5's. So the class1d question still needs the de novo pass, and so does the triple
5′ of P1 — a triple read off a structure imposed by other sequences is the same error as reading it
off the Class_1b CM alignment at PP 0.465. Run the de novo pass when the subset result says the
element is worth naming:

```bash
source $FLAVISCRIPTS/flavi_env.sh      # $FA106 etc. live here, not in your shell
bash $FLAVISCRIPTS/cm_candidate.sh align aln_FJIS_c106_261117 $FA106
# -> mlocarna, stk_oneblock, GATE 1, R-scape, then STOP at MATER
#    GATE 1 will not pass on 3 sequences at 0.84-0.94 identity. That is expected and is not a
#    failure: this run is for a consensus structure in cluster 106's own coordinates and for the
#    triple 5' of P1, not for the gate.
# ---- MATER: pseudoknots -> hand-edit SS_cons -> wiggle-refine -> R-scape ----
bash $FLAVISCRIPTS/cm_candidate.sh build aln_FJIS_c106_261117 <refined>.stk
# -> cmbuild, cmcalibrate, GATE 2, then cm_iterate.sh: library first, then the RNAvirus DB
```

In both routes the library `cmsearch` comes *after* the model exists, and will almost certainly
return the seed and nothing else — that is the saturation signal, and it is what says the blocker is
sequences rather than modelling. The RNAvirus
DB is demonstrably too narrow for this clade (4 of the 8 FJIS seed genomes score 52–79 b in the
library and are absent from the DB). **So the provisional model's real purpose is to be the query
for E7**: a targeted set of complete ISF genomes from NCBI, around *Xishuangbanna aedes flavivirus*,
*Menghai flavivirus*, *Kilpisjarvi flavivirus* and the ISF genomes carrying tandem arrays. No model
is accepted from 3 sequences, so E7 is not optional for this one.

### Is cluster 106 really not Class_1b? — open question restated 2026-11-16

Short answer: **not established.** The positive evidence comes from your own pooled alignment and
has not been weighed against the negative evidence, which all comes from one superseded baseline.

**What the pooled MATER alignment says — FOR cluster 106 belonging:**

| finding | value | where |
|---|---|---|
| R-scape on the wiggle-refined pooled alignment | 22 bp, **4 covarying vs 0.2 ± 0.5 expected**, FP 0, PPV 100, avgid 53.08 | Part 3, `cand_FJIS_261029` |
| what those 4 pairs rest on | **covariation between cluster 5 and cluster 106 sequences** — recorded in this file as "the evidence that the two clusters share one structure" | same |
| cluster 106's fit to that shared structure | **91 % canonical over all 22 bp** (82 % pre-wiggle) | MATER table, Part 3 |
| cluster 5's fit to the same structure | 83 % canonical (79 % pre-wiggle) | same |
| FJIS model vs the 88 Class_1b seeds | 13 hits, best are ISF class-1b copies at 24.3 b (NC_027819 xr1) — "moderate both ways, closer to Class_1b than to class1c" | Part 3 |

So in the one alignment built to test it, **cluster 106 satisfies the consensus structure better
than cluster 5 does**, and cluster 106 is half of the comparison that produces the covariation
making that structure credible at all. Cluster 5 was then merged into Class_1b and cluster 106 was
not.

**What the CM tests say — AGAINST:**

| finding | value | confound |
|---|---|---|
| Class_1b scores on the 8 FJIS seeds | 4 of 5 cluster-5 sites at 10.7–19.1 b; **cluster 106: none** | none. This one is clean and is the strongest negative |
| `all` variant (cluster 5 + 106 → seed) | PP 0.38–0.47, 5′-truncated, 11–17 included hits lost | **against the original 88-seq model, and pooled with cluster 5.** Cluster-5-only lost 0, so the losses are attributable to 106 — but not to 106 *on the current baseline* |
| Menghai triple | cm 29 and 43 read as deleted inside its aligned span (cm 17–78) | **this file contradicts itself here** — see below |
| its own 171-nt alignment | covariation 60–130 nt past the stall | superseded: the window ran past the element |
| pooling, per base pair | −0.53 vs −0.69 for 106 alone | argues the clusters are separate *candidates*, not that 106 is outside Class_1b |

**The internal contradiction to resolve.** The triple section calls Menghai's cm 29/43 deletion
"structural evidence independent of every score, and … the firmest ground under both decisions:
cluster 5 joins Class_1b, cluster 106 does not." The cluster 106 section says the same reading "was
read off an alignment with overall PP 0.465, which is not evidence" (and the pitfalls table agrees:
a deletion at PP < 0.7 is unreadable). Both cannot stand. The second is the more careful statement,
which means **the firmest ground under the cluster-106 decision is, by this file's own standard, not
evidence.** E4's `pp_check` measures the PP at those columns; E2b produces a new alignment to read
them from.

**Why E2b is not a repeat of a test already done.** Three things changed on 11-02: the seed gained
6 sequences including the P1-deviant ISF subtype (the architecture nearest cluster 106), `clen`
stayed 81 but the emission profile did not, and the comparison baseline became
`${C5}_library.tbl`. A sequence that aligned 5′-truncated at PP 0.45 to the old model can align
differently to a model whose seed now contains its closest relatives. The test costs one `cmalign`
and one `cmsearch`.

**E2b RESULT — 2026-11-16, CONFIRMED under Infernal 1.1.2.** Run twice: first with base's unpinned
`cmalign` (1.1.5 line), then with `cmalign` pinned to `$CONDA112` by `cm_env_require` reading the
model's header. **Both runs returned identical figures to three decimal places.** The three
cluster-106 sequences aligned to the accepted cluster-5 baseline (`--mapali`) as:

| sequence | cm span | truncated | bits | avg PP |
|---|---|---|---|---|
| NC_034017.1 stall 10511 | 27–81 | 5′ | **−10.59** | **0.397** |
| NC_034204.1 stall 10523 | 17–78 | 5′ | **−12.38** | **0.465** |
| ON949931.1 stall 10608 | 17–61 | 5′ **and** 3′ | **−14.40** | **0.424** |

The expanded seed changed nothing: the old model gave PP 0.38–0.47 and 5′ truncation, and Menghai's
0.465 is the same figure to three places. Alignment scores are **negative**, so these sequences fit
the model worse than the null. Adding the P1-deviant ISF subtype to the seed — the architecture
nearest cluster 106 — did not bring them any closer.

By the decision table below this is the third row: **PP well under 0.7 and still truncated, so
Class_1b cannot reach cluster 106 on the best baseline available.** The loss count is not needed;
the alignment already fails. The conclusion now rests on an unconfounded test instead of on the
Menghai triple, which resolves the contradiction above in the same direction — and note PP 0.397–0.465
means the triple reading is *still* unreadable, so it should not be cited as evidence either way.

**Side finding: `cmalign` is version-stable for this model where `cmbuild` is not.** The 1.1.5 and
1.1.2 runs agree exactly — same spans, truncation flags, bit scores and PP — whereas the same seed
through `cmbuild` gives 88/48.62/81/19/2 under 1.1.2 against 88/87.08/78/18/2 under 1.1.5 (Part 2).
So the version sensitivity recorded on 2026-10-30 is in model **construction**, not in alignment to
a fixed model. Scope it narrowly: one model, one `--mapali`, three sequences. It is not a licence to
drop the pinning, which costs nothing and is what makes the figure reproducible.

**E2b COMPLETE — 2026-11-17: rejected on every criterion, and worse than the `all` variant.**
`cmstat` on the rebuilt model, and the per-hit comparison against `${C5}_library.tbl`:

| | nseq | eff_nseq | clen | bps | bifs |
|---|---|---|---|---|---|
| cluster-5 baseline | 94 | 50.24 | 81 | 19 | 2 |
| `class1b_c5plus_c106_inf112` | 97 | **71.32** | 81 | 19 | 2 |

`matched 120, lost 19, gained 1, lower_bits 111, worst_delta −15.60.` The structure survives (clen,
bps and bifs unchanged) but **three sequences raised eff_nseq by 21.08** and pulled 111 hits down.
The `all` variant lost 11–17; this loses 19.

**What is lost is the cluster-5 merge itself, plus core Class_1b.** Eight of the ten sites cluster 5
gained are among the 19 — NC_027819 561, NC_024299 628, NC_021069 597, MH827524 595, AB981186 590,
NC_012671 545, LR694076 476, MH237596 478 — together with OP860412 297 yet again, and with
KC181923 859, KJ741266 810, LC536088 839, MN635449 73, AB021287 65, MT276199 198, NC_020902 424,
MH307700 124, ON391060 22. One gain: MH282908 223 at 36.2 b.

**And the three cluster-106 sites are still not recruited at their stalls.** They appear in the
tblout by accession — which is all the first version of this check reported — but these genomes
carry several elements, so accession membership answers the wrong question. Converting each stall to
subsequence coordinates (`genomic_stall − subseq_start + 1`, the convention verified to ±1 against
four cluster-5 sites whose genomic stalls this file records):

| site | stall, rel. | reported hits, rel. | covers the stall? |
|---|---|---|---|
| NC_034204 10523 | 170 | **32–87, 30.8 b, E 6.5e-4, `!`** | **no** — ends 83 nt short |
| NC_034017 10511 | 177 | **30–102, 27.4 b, E 3.2e-3, `!`**; 142–259, 12.0 b, E 3.8, `?` | only the weak `?` one |
| ON949931 10608 | 419 | 86–166, 19.8 b, `?`; 640–731, 14.6 b, `?` | **no** — neither |

So forcing cluster 106 into Class_1b does not make the model find the cluster-106 element. It makes
the model find **other loci** in those genomes, while dropping 19 hits it already had.

**ON949931 86 is the sharpest version of this.** That locus was an *included* Class_1b hit at
**30.2 b** in the cluster-5 baseline and is now LOST, reappearing at 19.8 b below threshold. It sits
333 nt from the cluster-106 stall at rel 419. So a cluster-106 genome already carries a genuine
Class_1b element elsewhere in its 3′UTR, and the price of admitting its cluster-106 element is
losing that one.

**Reading.** A merely divergent Class_1b copy is absorbed at modest cost — cluster 5 was absorbed at
zero. Cluster 106 instead broadens the emission profile (eff_nseq 50.24 → 71.32 on three sequences),
drags 111 hits down, drops 19, and still is not recruited where it matters. That is the signature of
a **different element sharing an architecture**, not of a subtype. It also strengthens the class-1d
possibility rather than settling it: the covariation and canonical-pair evidence from the pooled
MATER alignment stands, and only E7 can supply the sequences a named class needs.

**Consequence: cluster 106 goes to Track B**, and `aln_FJIS_c106_<yymmdd>` is priority 2 proper.
E7 remains the only route to a named class.

**Decision table — the outcome reached is the third row:**

| E2b outcome | reading | then |
|---|---|---|
| **0 hits lost**, cluster 106 aligns full length at PP ≥ 0.7 | it is Class_1b, and the old rejection was an artefact of the old seed | merge; label `transition:106` (B3), since it is its own frozen cluster. The "separate element" question closes |
| **0–2 lost, PP ≥ 0.7** | borderline; the no-loss rule as applied on 11-03 rejects it | keep as `transition_candidate:106`, but record that it now aligns. Do not force it in — the 11-03 precedent rejected Kamiti for exactly one lost hit |
| ✓ **hits lost and PP still < 0.7** | Class_1b's model cannot reach it, on the best baseline available | **this is what happened** — Track B: cluster 106 alone at 80 nt, then E7. The negative is real, not inherited |

**Is it class1d?** Not decidable now, and E2b does not decide it either. By this file's own standard
a class must (a) have a covariation-supported structure of its own, (b) be separate from the
existing models per site by position, and (c) **recruit members beyond its seed.** Cluster 106 has
3 near-identical sequences (0.84–0.94) that would build a model finding only themselves, which is
the stated reason no model is attempted. So:

- E2b decides **merge or not merge**.
- Only E7 — a targeted NCBI ISF set — can decide **class1d or permanent transition candidate**,
  because only sequences can satisfy (a) and (c).
- Until then the correct label is `transition_candidate:106`, not `class1d`, and not "Class_1b".

Naming note, settled 2026-11-17: the series is right, the timing is not. Class 2 is itself a class 1
subclass by structure, so `class1<x>` is the correct series and `class1d` is defensible in substance.
Hold it anyway until (a) class 2's place in the series is resolved — it belongs there and is not
there, and adding a letter to an inconsistent series makes the lettering uninformative — and (b) E7
supplies sequences. Label meanwhile: `transition_candidate:106`.

### C. Unknown — no model, no assignment

| gap | size | state | next step |
|---|---|---|---|
| FJIS cluster 106 | 3 sites | aligned 11-17; **model built 11-18** as `cand_FJIS_c106_261118` (1.1.5, eff_nseq 1.62, clen 80, 13 bp, 1 bif). Library: 3 included, 0 novel at `--incE 1e-10` — but the **sub-threshold tail is six class1c pestiviruses at 15.9–26.1 b plus the unknown MK636875 at 28.6 b**, harder than the pooled FJIS model's 12.5–21.9 | priority 2 — **identify MK636875**, then RNAvirus DB, then E7. Competitor is **class1c, not Class_1b** |
| FJJI cluster 41 | 12 sites, 10 mM only | aligned at 80 nt; 1 covarying pair; two hairpins | priority 3: MATER, R-scape, first model, library search |
| FJJI cluster 44 | 8 sites | aligned; one long hairpin; 0 pairs in structure | priority 3, after 41 |
| FJTB cluster 64 | 3 sites | not looked at | priority 4: position against the class 2 pair and `cand_FJTB_261026` |
| PLLG cluster 117 | 3 sites | not looked at | priority 4: does `cand_PLLG_260915` already hit them |
| HPPV cluster 39 **+ cluster 135** | 4 + 4 sites | fetched, not aligned. **E8: 39 is 5′-terminal and 135 3′-terminal in the same three rodent-pegivirus arrays** (LC602141, MT210614, MT210620), plus a fourth 135 copy in MW897328 | priority 5 — **align the two together**; separating them splits one array |
| `cand_FJTB_261026` (cluster 3) | 16 seqs | model built; diversity-blocked; class-2-copy hypothesis against inverted Mg dependence | priority 6: record 10-27 RNAvirus DB result; `cmstat` on the model in `cm/`; step 14a |
| `cand_PLLG_260915` | 24 of 60 PLLG | model built; too conserved to refit | priority 6: record DB result; `--toponly --incE 1e-10` rerun |
| KY370101 12807 | 1 site, SF 0.924 | **2026-11-18: now annotated by the existing `class1c` model** (14.9 b, E 0.0082) once `--toponly` halved the E-values. **No collision** — the Class_1b hit in that genome is 82 nt away at 12621 (42.5 b), a different array copy, so the clan rule has nothing to resolve. The 10-30 class1c *seed* decision is unaffected | annotated; the open part is that **both copies sit in frozen cluster 131** yet get different class calls. PLPV pool |
| **cluster 137 — pangolin pestiviruses** | 4 genomes, 3–4 array copies each | **new 2026-11-18**: `MK636875` *Dongyang pangolin virus*, `ON024097`, `ON024102`, `ON024104` *Pangolin pestivirus*, all `cls None found`. `cand_FJIS_c106_261118` reaches one copy per genome (mostly the 5′-most) at 15.9–28.6 b. **But these genomes are class1c seed members**, so "orphaned" is unproven | **priority 3**: establish whether class1c hits a *different* copy of the same arrays. If so, **merge with cluster 106** — see *Merging the cluster-106 and cluster-137 gaps*, which is the one route to GATE 1 without E7 |
| clade pools | PLLG remainder 66 sites, HPHV 34, not-in-Mifsud 29, FJMB 17, PLPV 15, FJAF 9, FJUN 7 | not started | priority 8 |
| downstream copies | 56 of 173 annotated accessions | target list only | after the pools; anchored by the neighbouring element |

#### `cand_FJIS_c106_261118` built and searched library-wide — 2026-11-18

Built under Infernal **1.1.5** (the default; no `_inf` suffix, per *Versions of an existing model*),
from `cluster106_edit261117_triple.stk`.

```
nseq 3   eff_nseq 1.62   clen 80   W 111   bps 13   bifs 1   relent_cm 0.708   relent_hmm 0.568
```

**`eff_nseq` 1.62 sits just above the recorded rejection case** — `cand_PLLG_260915_cmalign` at
1.55 — and far below Class_2's curated 3.58, `class1c`'s 9.54 and `hepaci_hits_v2`'s 19.93. That is
not a surprise or a fault: it is the arithmetic consequence of three near-identical sequences, and
it is precisely why Part 3 records that **no model is accepted from 3 sequences**. The model is a
search instrument here, not a claim.

**13 bp and 1 bifurcation match the alignment exactly.** Counting the nested structure in
`SS_cons` — ignoring the pseudoknot letters, which `cmbuild` does not read — gives 9 + 4 opening
pairs against 7 + 4 + 2 closings, i.e. 13 pairs, with the two inner stems nested inside the outer
one producing the single bifurcation. So the model encodes P1, P2 and P3 and **not** PK1, PK2 or the
U•(A-U) triple. Expected, and the reason this model cannot by itself describe the fold.

**No `#=GC RF` line**, so `cmbuild` ran plain and re-inferred match columns by occupancy: 80 match
columns from the alignment's 84. **The cm numbering therefore does not map 1:1 onto the alignment
columns**, which matters later — locating the triple in cm coordinates will need the mapping, unlike
the cluster-5 work where `C/G/C at cm 7/29/43` could be read directly because RF fixed the columns.
If that mapping is wanted, add an RF line and rebuild with `--hand` before anything depends on cm
positions.

#### Library result: saturated, 0 novel

```
3! hits / 3 accessions; 3 pass coverage >= 0.85; 0 novel vs seed (3 seqs)
SATURATED on library -- a cmalign round would only re-fit seed
```

The model recovers its own three sequences and nothing else. By the readings set out for
`--library-only` this is the **seed-only** case: **the library holds no further cluster-106
relatives, so the RNAvirus DB search becomes the point of the exercise rather than a formality.**
It confirms from the model's side what the explorer said from the clustering's — cluster 106 is
3 sites and there is no fourth hiding in the library.

**One cheap check before the DB search.** `cm_iterate.sh` searched at `--incE 1e-10`, which is very
strict, so "0 novel" is a statement at that threshold and not a statement that the model is
selective. The reported-but-not-included tail of the same tbl says which sequences it *nearly* hits,
and that is worth knowing now rather than after the DB search:

```bash
B=$INFERNAL/build/cand_FJIS_c106_261118/iter_v1_explorer80/search_library/r0
grep -v '^#' $B/search.tbl | awk '$10=="+"{printf "%-44s %7s-%-7s %7s %10s %s\n",$1,$8,$9,$15,$16,$17}' | head -20
```

Two outcomes, and they point different ways:

- **the tail is Class_1b sites** → the models compete, and that must be known before E7 brings in
  more sequences, because any new class built from this seed inherits the overlap. Check the
  competitors' E-values at those loci, since the clan rule resolves by lower E.
- **the tail is unrelated or empty** → cluster 106 is genuinely isolated in this library, which
  strengthens the case that it is its own thing and makes E7 the only way to test it.

#### The sub-threshold tail is class1c, not Class_1b — and it is stronger than the pooled FJIS model's was

Read 2026-11-18. The full reported list from the library search:

| sequence | span | bits | E | |
|---|---|---|---|---|
| NC_034017 *Xishuangbanna aedes flavivirus* | 177–256 | 102.3 | 4.3e-29 | `!` seed |
| NC_034204 *Menghai flavivirus* | 170–249 | 101.7 | 6.4e-29 | `!` seed |
| ON949931 *Kilpisjarvi flavivirus* | 419–493 | 84.9 | 1.2e-23 | `!` seed |
| **MK636875** | 171–250 | **28.6** | **4.2e-06** | `?` **not in this file** |
| ON024101 | 138–217 | 26.1 | 2.5e-05 | `?` |
| ON024090 | 99–172 | 21.7 | 0.00059 | `?` |
| ON024102 | 80–155 | 20.7 | 0.0012 | `?` |
| ON024097 | 102–183 | 20.7 | 0.0012 | `?` |
| ON024104 | 106–184 | 15.9 | 0.038 | `?` |
| MN587678, MN587686, MN587661, MN564793 | — | 14.0–8.8 | 0.15–6.2 | `?` noise |

**"0 novel" was entirely an artefact of `--incE 1e-10`.** At any conventional threshold there are
six substantial non-seed hits, and `MK636875` at E 4.2e-06 is strong by ordinary standards.

**The `ON024*` series are pangolin pestiviruses, and they are class1c seed members.** Part 5 already
records the reciprocal test run on 10-29/30: *"FJIS model on the 46 class1c seeds — 12 hits: 8
pangolin pestiviruses full-length, **12.5–21.9 bits** (ON024090 E 6.8e-06)"*, against *"class1c on
the 8 FJIS seeds — only ON949931, 13.3 bits"*, concluding **"weak one way, moderate the other:
siblings, not one family."**

**That conclusion was reached with the *pooled* FJIS model — cluster 5 and cluster 106 together.
Cluster 106 alone hits the same viruses harder: 15.9–26.1 bits, plus MK636875 at 28.6.** So
separating cluster 106 from cluster 5 *sharpened* the relationship to class1c's pestivirus subset
rather than diluting it. The asymmetry is unchanged in direction — 5–6 hits one way against a single
13.3-bit hit the other — but the "moderate" side is now moderately stronger, and it was measured on
a model with `eff_nseq` 1.62, which if anything understates it.

**Three consequences.**

1. **The collision risk is with `class1c`, not with Class_1b.** That was the thing worth knowing
   before E7, and the answer is the reassuring one for Class_1b and the interesting one for
   class1c: nothing here competes with `class1b_v2_inf112.cm`.
2. **Do not add the pangolin pestiviruses to the cluster-106 seed.** They are *already* class1c seed
   sequences. Adding them would not expand cluster 106; it would merge it into class1c, which is
   precisely what the reciprocal test says is wrong. The sibling reading has to be tested with
   sequences that belong to neither — which is E7.
3. **`MK636875` is the one genuine unknown**, is the strongest non-seed hit, and appears nowhere in
   this file. It is the first thing to identify:

   ```bash
   grep -E 'MK636875|ON024102|ON024097|ON024104' $SCAN/nodes.tsv
   grep -n 'MK636875' $ROOT_TAXONOMY 2>/dev/null   # or the 261021 taxonomy CSV on the cluster
   ```

   Its 3′UTR span `11978–12446` puts the genome near 12.4 kb, the pestivirus range and well above
   the ISFs' 10.9 kb — so the expectation is another pestivirus, but it should be read rather than
   assumed. If it is **not** a class1c seed member, it is the first novel sequence this model has
   found, and it is the one that would raise `eff_nseq` above 1.62 without merging cluster 106 into
   class1c.

**This also bears on where cluster 106 sits in the `class1<x>` series.** The open question recorded
in Part 1 was whether it is `class1d`. The evidence now says its nearest neighbour is **class1c**,
not Class_1b — which is consistent with a `class1d` naming but means the comparison that decides it
is against class1c, and the deciding test is still E7.

#### Could class1c encompass cluster 106? — asked 2026-11-18

A fair reading of the tail, and three pieces of evidence bear on it. Two were already recorded and
point against; the third is new and points against more sharply.

**1. The direct test was run and failed.** Part 3 records cluster 106 as **"not class1c (guided seed
1.55 / 1.33 / −2.14 bits)"** — that is cluster 106's three sequences scored against a class1c seed
guided to include them, and one of the three comes out at **negative bits**. A sequence that scores
below zero against a model built to contain it is not encompassed by it.

**2. The reciprocal is asymmetric in the wrong direction for nesting.** class1c on the 8 FJIS seeds
reaches **only ON949931, at 13.3 bits** — so class1c does not find two of cluster 106's three
sequences at all. Nesting would require the parent to reach its members; this parent reaches one
third of them, weakly.

**3. The pestivirus sites cluster 106 finds are not class1c sites.** This is the new evidence. Every
one of them is `cls None found` in the node table and sits in **frozen cluster 137**:

```
MK636875.1  Dongyang pangolin virus  Pestivirus   None found  fz 137   (3 copies)
ON024097.1  Pangolin pestivirus      Pestivirus   None found  fz 137   (4 copies)
ON024102.1  Pangolin pestivirus      Pestivirus   None found  fz 137   (4 copies)
ON024104.1  Pangolin pestivirus      Pestivirus   None found  fz 137   (3 copies)
```

`cls None found` means **no model in the annotating set calls these stalls**, class1c included. If
class1c encompassed cluster 106, the sites cluster 106 reaches should already be class1c's. They are
not: they are unassigned, in a frozen cluster of their own.

**And they are arrays, with cluster 106 hitting one copy each.** Converting the hits through each
sequence name's offset against the explorer's nodes:

| genome | cluster-106 hit | node | which copy |
|---|---|---|---|
| MK636875 | 12148–12227 | 12148 | **2 of 3** |
| ON024097 | 12021–12102 | 12021 | **1 of 4** |
| ON024102 | 12006–12081 | 12006 | **1 of 4** |
| ON024104 | 12036–12114 | 12036 | **1 of 3** |

Mostly the **5′-most** copy. This is the E8 pattern a third time — tandem arrays whose copies get
different treatment — now in *Pestivirus*, after ISFs (clusters 5 and 21, 3′-terminal) and rodent
pegiviruses (clusters 39 and 135, both ends).

**So the better reading is not that class1c encompasses cluster 106, but that the two are siblings
that reach different copies of the same pestivirus arrays.** That is testable in one command, and it
is the question to settle before E7 rather than after:

```bash
awk '!/^#/ && $10=="+" && $1 ~ /MK636875|ON0240(90|97|101|102|104)/ {
  split($1,p,"|"); split(p[2],c,"-"); off=c[1];
  printf "%-14s %7d-%-7d %7s %10s %s\n", p[1], off+$8-1, off+$9-1, $15, $16, $17 }' \
  "$TBL2/class1c.cm.tbl" | sort
```

Read it against the table above:

- **class1c hits a *different* copy in each genome** → the two models partition one array, which is
  the sibling reading and makes cluster 106 a distinct element that happens to co-occur with
  class1c's. That is a positive result for `class1d`, and it would make the pangolin pestiviruses a
  *shared* target rather than class1c's property.
- **class1c hits the *same* copy, more strongly** → cluster 106 is reaching class1c's own sites
  weakly, the clan rule gives them to class1c, and the sibling claim weakens considerably.
- **class1c does not hit these genomes in the 3′UTR at all** → then the 8 pangolin pestiviruses in
  its seed are there from a different region or a looser search, which would need explaining before
  any of this is interpreted.

**Either way, cluster 137 is now a live register entry.** It is a 4-genome pestivirus array cluster
that no model annotates, and the only model that reaches it at all is a 3-sequence candidate. It
belongs in Part 1's gap register alongside HPPV 39 + 135, not in the undifferentiated clade pools.

#### Merging the cluster-106 and cluster-137 gaps — proposed 2026-11-18

The proposal: cluster 137 is orphaned, cluster 106 is orphaned, cluster 106's model reaches cluster
137, so treat them as one gap and align them together.

**The payoff is large and specific, and it is not only "more sequences".** Cluster 106 is stuck for
one reason recorded repeatedly in this file: **three near-identical sequences cannot support a model
or pass a covariation gate** — `eff_nseq` 1.62, barely above the 1.55 rejection case, and R-scape
with zero power because 16 of 21 pairs are invariant. A merged alignment would be **3 ISF sequences
plus 4 pestivirus genomes' worth of copies**, and those pestiviruses are *divergent* — 15.9–28.6 bits
against an 80-column model is weak-to-moderate, which is exactly the divergence that produces
covariation signal. So the merge is the one route that could make **GATE 1 applicable for the first
time**, and it does so **without E7**. That matters: E7 is the expensive step this has been waiting
on, and if a merged alignment passes GATE 1, cluster 106 stops needing NCBI to become testable.

**But there is a contradiction to resolve before the word "orphaned" can be used.** Part 5 records
that the **8 pangolin pestiviruses are class1c *seed* members** — `"FJIS model on the 46 class1c
seeds — 12 hits: 8 pangolin pestiviruses full-length"`. A genome cannot be both in class1c's seed
and orphaned. Yet every explorer node in those genomes reads `cls None found`. Three readings, and
they are not equivalent:

1. **class1c's seed spans are at different loci than the explorer's nodes** — i.e. class1c holds a
   *different copy* of the same arrays. Then cluster 137's copies genuinely are orphaned, the merge
   is sound, and the sibling reading is confirmed in the strongest possible way.
2. **class1c hits these same copies but below the explorer's `cls` threshold.** Then they are not
   orphaned, they are class1c's weak tail, and merging them into cluster 106 would be building a
   model from another class's sequences — the same error as adding the pestiviruses to the seed,
   just arrived at from a different direction.
3. **class1c's seed came from a search against something other than this library**, so these
   genomes' library sequences were never its targets. Then `cls None found` says nothing about
   class1c's claim and the question is still open.

**Only reading 1 licenses the merge**, and the command already written above distinguishes all
three. It must be run before any alignment work, because readings 1 and 2 differ in whether the
result would be a new class or a corner of class1c.

**If reading 1 holds, follow the class1c lineage — which is `cmalign` then MATER then rebuild.**
An earlier draft of this section said the opposite, that the merge should go back to
`cm_candidate.sh align` rather than graft with `cmalign`; **that was wrong and is retracted**. The
documented procedure that produced class1c grafts, and the objection — that added sequences conform
to the model rather than inform it — is answered by the manual MATER step being a real
re-examination. What the lineage warns against is **iterating**, not grafting. See *Correction:
follow the class1c lineage* below for the steps and the one place the recipe has to change.

Naming, if it proceeds: the two clusters come from **different pools** (FJIS and the pestiviruses),
so the usual `cand_<pool>_<cluster>_<yymmdd>` does not fit. Follow the pooled precedent
`cand_FJJI_cluster41-44_pooled_261029` and call it **`cand_c106-137_pooled_261118`**, with no pool
prefix — and note that the absent prefix is itself the finding: this candidate crosses pools, which
no accepted class in this file does.

**One caution about what success would mean.** If the merged alignment passes GATE 1, it establishes
that the ISF cluster-106 element and the pangolin-pestivirus element share a structure. It does
**not** establish that they are one class — Part 6's reciprocal tests exist because shared structure
across distant genera is how `class1c` and Class_1b were found to be siblings rather than one
family. The merged model would need the same reciprocal treatment against class1c before any
`class1d` claim.

#### Correction: follow the class1c lineage, which *is* `cmalign` → MATER → rebuild

Written 2026-11-18, retracting the advice given an hour earlier that the merge should be done by
re-alignment rather than by `cmalign` grafting. **The documented procedure that produced class1c is
the grafting one**, set out in *class1c lineage and where every file is*:

| step | what | here |
|---|---|---|
| 1 | `cmbuild` from hand-edited seqs | **done** — `cand_FJIS_c106_261118.cm` from the 3 cluster-106 sequences |
| 2 | `cmsearch` library-wide | **done** — 3 included, 6 substantial sub-threshold |
| 3 | fetch list, `esl-sfetch -Cf` | the pangolin hits |
| 4 | **`cmalign` with the step-1 model** | the scaffold |
| 5 | `dedup_stockholm.py` | |
| 6 | **manual MATER + CaCoFold** | where the structure is actually decided |
| 7 | `cmbuild -F -n <name>` + `cmcalibrate` | |
| 8 | `cmsearch` library-wide | |

So the answer to "cmalign, then MATER, then a new CM?" is **yes, that is the method**, and the
objection I raised — that `cmalign` makes added sequences conform to the model rather than inform
it — is answered by **step 6 being a manual re-examination, not a formality**. The alignment that
becomes class1c is the MATER-refined one, not the `cmalign` output.

**What the lineage actually warns against is iterating, not grafting.** The same section records
that class1c "was never realigned on its own hits and never rebuilt — **one round only, no
self-refitting**", and contrasts it with `class4_cl4_v9_20260824`, flagged under decision 35 for
**nine** rounds of taking a model's own hits, realigning and rebuilding — "the same procedure that
drove `clusterA_refined.cm` to eff_nseq 1.55". That is the failure mode, and it is the reason
class1c's nseq 46 / eff_nseq 9.54 is called legitimate rather than a converged artefact. **One
round. Do not repeat it on the result.**

**One place the recipe needs a deliberate change, and it should be recorded rather than slipped in.**
Step 3 takes the fetch list from `$17=="!"`. Here nothing but the seed is included, because
`cm_iterate.sh` searched at `--incE 1e-10`. The criterion has to become an explicit E-value cut, and
the data separates cleanly: six hits at **E 4.2e-06 to 0.038** (MK636875, ON024101, ON024090,
ON024102, ON024097, ON024104), then a gap to **E 0.15 and worse** (MN587678, MN587686, MN587661,
MN564793) which are 14.0 bits and below. A cut at **E ≤ 0.05** takes the six and none of the noise.

```bash
C106=$INFERNAL/build/cand_FJIS_c106_261118
CM=$(find "$C106" -name 'cand_FJIS_c106_261118.cm' | head -1)
TBL=$C106/iter_v1_explorer80/search_library/r0/search.tbl
OUT=$INFERNAL/build/cand_c106-137_pooled_261118; mkdir -p "$OUT"

# 3. fetch list -- E cut replaces $17=="!" ; expect 9 lines = 3 seed + 6 pangolin
grep -v '^#' "$TBL" | awk '$10=="+" && $16+0<=0.05 {print $1"/"$8"-"$9, $8, $9, $1}' \
  > "$OUT/hits.fetchlist"
wc -l "$OUT/hits.fetchlist"
esl-sfetch -Cf "$FA" "$OUT/hits.fetchlist" > "$OUT/hits.fa"

# 4. cmalign with the step-1 model
cmalign --cpu "$CPU" -o "$OUT/hits_aligned.stk" "$CM" "$OUT/hits.fa"

# 5. dedup
python3 "$FLAVISCRIPTS/dedup_stockholm.py" "$OUT/hits_aligned.stk" > "$OUT/hits_aligned_dedup.stk"

# 6. MANUAL: MATER + CaCoFold on hits_aligned_dedup.stk
#    -> cand_c106-137_pooled_edit261118.stk
#    This is where the merge is actually decided. Read the PP line: pangolin copies
#    aligning at low PP means cmalign forced them, and the structure must be fixed
#    here rather than inherited.

# 7-8. then, once the edit exists:
bash "$FLAVISCRIPTS/cm_candidate.sh" build --library-only \
  cand_c106-137_pooled_261118 "$OUT/cand_c106-137_pooled_edit261118.stk"
```

**What to watch at step 7.** `eff_nseq` is the number that says whether the merge did anything: the
cluster-106-only model sits at **1.62**, against the 1.55 rejection case. Nine sequences spanning
two genera should move it substantially — if it does not, the pangolin copies have been aligned into
conformity rather than contributing diversity, and step 6 is where to look. And GATE 1 becomes
meaningful for the first time: R-scape on three near-identical sequences had no power, whereas
R-scape across ISFs and pestiviruses does.

**The precondition still stands.** None of this should run until the class1c locus check says these
pangolin copies are not class1c's own — reading 1 of the three in *Merging the cluster-106 and
cluster-137 gaps*. The lineage is the right method; it is not a reason to skip asking whose
sequences these are.

#### `cmalign` of the 9: PP clears the bar, bits are low, two windows were cut short

Run 2026-11-18, `cand_FJIS_c106_261118.cm` over the 9 fetched spans.

| seq | len | cm span | trunc | bits | avg PP |
|---|---:|---|---|---:|---:|
| NC_034017 *Xishuangbanna aedes flavivirus* | 80 | 1–80 | no | 90.58 | **1.000** |
| NC_034204 *Menghai flavivirus* | 80 | 1–80 | no | 90.02 | **1.000** |
| ON949931 *Kilpisjarvi flavivirus* | 75 | 1–80 | no | 73.16 | 0.994 |
| MK636875 *Dongyang pangolin virus* | 80 | 1–80 | no | 16.98 | 0.968 |
| ON024101 | 80 | 1–80 | no | 14.47 | 0.953 |
| ON024090 | **74** | 1–**74** | **3′** | 10.41 | 0.866 |
| ON024102 | **76** | 1–**78** | **3′** | 11.32 | 0.743 |
| ON024097 | 82 | 1–80 | no | 8.99 | 0.898 |
| ON024104 | 79 | 1–80 | no | **4.25** | 0.861 |

**The PP result is the significant one, and it is favourable.** Every pangolin copy aligns at
**0.743–0.968**. The bar this file has used is recorded in Part 1's outcome table — the failure case
is *"hits lost and PP still < 0.7"* — and E2b's rejection of cluster 106 into Class_1b was at
**PP 0.397 / 0.465 / 0.424**. These are roughly twice that and all clear 0.7. So `cmalign` is not
forcing these sequences into the model's columns; it is placing them confidently.

**The bit scores are low, and much lower than the search reported.** `cmsearch` gave MK636875 28.6
and ON024104 15.9; `cmalign` gives 16.98 and 4.25. That drop is expected — `cmsearch` finds optimal
local boundaries while `cmalign` is global to the model — but 4.25 bits for ON024104 is weak enough
that it should be treated as a candidate for exclusion at the MATER step rather than carried
automatically.

**The two `3′` truncations are a fetch artefact, not biology.** Their windows are **74 and 76 nt
against an 80-column model**: the sequence ran out before the model did. The fetch list took the
`cmsearch` envelope exactly, following the class1c lineage's step 3, and for these two the envelope
is shorter than the model. Extending the 3′ end and re-aligning distinguishes "the element really is
shorter here" from "the window was tight", and that distinction matters because a genuinely shorter
3′ end in pestiviruses would be a *structural* difference worth keeping, while a tight window is
noise to be removed before the alignment is hand-edited.

```bash
# re-fetch with a 3' margin on the pangolins only (bits < 50 separates them cleanly
# from the three seeds at 73-102); the seeds keep their exact spans, since they
# define the model
grep -v '^#' "$TBL" | awk '$10=="+" && $16+0<=0.05 {
    e = ($15+0 < 50) ? $9+12 : $9;
    print $1"/"$8"-"e, $8, e, $1 }' > "$OUT/hits_margin.fetchlist"

esl-sfetch -Cf "$FA" "$OUT/hits_margin.fetchlist" > "$OUT/hits_margin.fa"
cmalign --cpu "$CPU" -o "$OUT/hits_margin_aligned.stk" "$CM" "$OUT/hits_margin.fa"
```

If `esl-sfetch` errors on a coordinate past the end of a library sequence, reduce the margin for
that one — it means the element sits at the very 3′ end of its window, which is itself worth noting.

**Result: all three outcomes occurred, one per sequence** — see *The +12 margin* below. The
original windows were right for four of the six, `ON024090` was genuinely 6 nt short, and
`ON024102`'s truncation is real. The uniform margin was the wrong instrument; use `hits_aligned.stk`
and correct those two by hand at MATER.

**Then MATER, on whichever alignment that settles.** The things to decide by hand: whether ON024104
at 4.25 bits earns its place; where the pestivirus 3′ boundary is; and whether the pangolin copies
support the same P1/P2/P3 and the same pseudoknots as the three ISF sequences, which is the actual
question the merge exists to answer.

#### The +12 margin: revert to the original windows, with two hand corrections

Run 2026-11-18. The margin was added to test whether the two `3′` truncations were a tight window or
a real boundary. It answered that, and incidentally demonstrated a trap.

| seq | original | with +12 | verdict |
|---|---|---|---|
| MK636875 | 80 nt, cm 1–80, no, **16.98 b**, PP 0.968 | 92 nt, cm 1–78, **3′**, 6.48 b, PP 0.958 | margin **broke** a complete fit |
| ON024101 | 80 nt, cm 1–80, no, **14.47 b**, PP 0.953 | 92 nt, cm 1–79, **3′**, 4.93 b, PP 0.950 | margin **broke** a complete fit |
| ON024090 | 74 nt, cm 1–**74**, 3′, 10.41 b, PP 0.866 | 86 nt, cm 1–**80**, no, 3.63 b, PP 0.888 | margin **completed** the model |
| ON024102 | 76 nt, cm 1–**78**, 3′, 11.32 b, PP 0.743 | 88 nt, cm 1–**78**, 3′, 3.47 b, PP 0.785 | **truncation is real**, not the window |
| ON024097 | 82 nt, cm 1–80, no, 8.99 b, PP 0.898 | 94 nt, cm 1–80, no, 0.56 b, PP 0.910 | unchanged fit |
| ON024104 | 79 nt, cm 1–80, no, 4.25 b, PP 0.861 | 91 nt, cm 1–80, no, **−5.82 b**, PP 0.841 | unchanged fit |

**Do not compare the bit scores between these two runs.** `cmalign` is global, so every added
nucleotide that is not model-like must be absorbed as an insert and counted against the null — the
scores fell by 8–10 bits across the board *because the sequences got 12 nt longer*, not because the
alignments got worse. **PP is the length-robust comparison**, and PP moved by at most ±0.04:
−0.010, −0.003, **+0.022**, **+0.042**, +0.012, −0.020. The alignment quality is essentially
identical; only the flanking changed. Treating that bit drop as evidence about the element would
have been a mistake, and it is the same category of error as reading `cmsearch` bits against
`cmalign` bits earlier.

**The margin was the wrong instrument applied uniformly**, and it is informative per sequence:

- **MK636875 and ON024101 were already complete at cm 1–80.** Adding 12 nt made `cmalign` truncate
  them at 78 and 79 — the extra sequence is not element and its presence pulled the 3′ end off. The
  original windows were right.
- **ON024090 was genuinely 6 nt short.** With the margin it completes to cm 80. Its element extends
  past the `cmsearch` envelope.
- **ON024102 is genuinely truncated.** Twelve more nucleotides and it still stops at cm 78: the
  pestivirus element here really does lack the last two model columns. That is a structural
  observation, not a fetch problem, and it belongs in the MATER edit.
- **ON024104 at 4.25 b originally and −5.82 b with margin** is the weakest member either way.

**So: use `hits_aligned.stk` — the original — and fix two sequences by hand.** ON024090 needs about
6 nt more at its 3′ end; ON024102 is correct as fetched and its short 3′ end is a feature to record.
A per-sequence fetchlist would be the tidy way, but this is exactly what the manual MATER step
exists for, and the class1c lineage puts the hand edit after `cmalign` for this reason.

**What this says about the merge, so far.** PP across the six pangolin copies is 0.74–0.97 in both
runs, against E2b's 0.397–0.465 rejection — the alignment holds. The bit scores are low and one
sequence is marginal. Neither of those is decided here: `eff_nseq` after the rebuild is the number
that says whether nine sequences across two genera bought anything over 1.62, and GATE 1 on the
MATER-refined alignment is the one that says whether the structure is shared. Both come after the
hand edit.

### Next priority — revised 2026-11-18 (replaces the 2026-11-16 list below)

**Done since the 11-16 list:** item 1 (B4) was answered by E5 — main Class_1b clusters are **131 and
133**, every B1/B2 site now carries its frozen cluster, and the `OP860412 297` conflict was settled
by E3. Item 7 (Class_1b E6) is **complete**: `class1b_v2_inf112.cm` is deployed, searched
library-wide with `--toponly`, and 11b has re-annotated both conditions under
`DS=261117_flaviLib_150x150`.

1. **Close out E6's bookkeeping.** Cheap, and it is what makes the deployment legible later:
   write the *deployed* outcome into `class1b_groups.tsv` — which of the eleven added or recovered
   sites actually annotate, which did so only after `--toponly` — resolve the four rows with
   unmeasured groups (NC_027817, NC_027819, OP860412, OM030319), confirm `NC_005064.1`'s version,
   and extend `MANIFEST.tsv` from one row to all seven models with both `built_by_infernal` and
   `searched_by_infernal`.
2. **Cluster 106 → build, calibrate, then search the LIBRARY first.** The "align alone at 80 nt"
   step of the 11-16 list is **done**: `cluster106_edit261117_triple.stk` is the corrected
   alignment, with the 2-bp P1, the AAA between P2 and P3, and the U•(A-U) triple in `#=GF CC`.
   What remains is `cmbuild` + `cmcalibrate` — **there is no cluster-106 model yet** — and then the
   **library-wide search before the RNAvirus DB**, which is also the order `cm_candidate.sh build`
   already runs. The library comes first because every other model's hits are measured there, so a
   cluster-106 result is immediately comparable; the RNAvirus DB is both an outside set and a
   demonstrably narrow one (4 of the 8 FJIS seed genomes score 52–79 bits in the library and do not
   appear in the DB at all), so it is the weaker test and belongs after. Search it `--toponly`, like
   everything else from 2026-11-18 on.

   **Build it under the default 1.1.5, not 1.1.2.** The 1.1.2 constraint is specific to the
   Class_1b line, because that model was built under it; cluster 106 is a *new* model with no
   predecessor to stay comparable with. Part 9's scheme therefore gives it a plain name with **no
   `_inf` suffix**, since the suffix marks a non-default builder.

   **What the search is for, and what it cannot settle.** No model is accepted from 3 near-identical
   sequences — the build is a search tool, not a claim, and R-scape has no power here (16 of 21
   pairs invariant). The prediction to judge the library search against is specific: it should
   recruit its own three sites strongly, and the question is whether it recruits **anything else**.
   Nothing else → the library holds no more of this element and E7 is not optional but required.
   Class_1b sites → cluster 106 is not distinct after all, which would contradict E2b and would need
   explaining rather than accepting.
3. **FJJI 41, then 44**: MATER edit, R-scape, first model, library search. For 41, check the 1 mM
   table to separate Mg dependence from coverage.
4. **FJTB 64 and PLLG 117**: position checks against `cand_FJTB_261026` and `cand_PLLG_260915`
   before any alignment.
5. **HPPV 39 — align it together with cluster 135, not alone.** This changes with E8. Clusters 39
   and 135 are **two positions in one rodent-pegivirus array**: 39 is 5′-terminal and 135 3′-terminal
   in the same three genomes (*Rodent pegivirus* LC602141, Wenzhou *Rattus tanezumi* pegivirus 1
   MT210614, Wufeng *Niviventer fulvescens* pegivirus 1 MT210620), with a fourth 135 copy in
   *Phaiomys leucurus* pegivirus MW897328. Aligning 39 by itself would split an array that the
   clustering has already shown to be one thing. Register size therefore reads **4 sites (39) + 4
   sites (135)**, not 4.
6. **`cand_FJTB_261026` / `cand_PLLG_260915`**: record the 10-27 RNAvirus DB results; step 14a.
7. **E7 — the targeted NCBI ISF set.** Serves three stuck questions at once: cluster 106, and
   NC_005064 and MW897328, which both need sequences from outside this library. The RNAvirus DB is
   demonstrably too narrow (4 of the 8 FJIS seed genomes score 52–79 bits in the library and do not
   appear in the DB at all).
8. **Clade pools**, priority 8 as before — and note from E8 that the thirteen genomes this file had
   never discussed are hepaci-, pegi- and pestiviruses plus *Tamana bat virus*, i.e. they belong
   here and not to E7.

**Not on this list, deliberately, and each already recorded:** the `--evalue` 0.01-against-0.001
policy question; the taxonomy gap (3,111 peaks across 28 accessions at 10 mM have no
`virus_taxonomy_flaviLib_261021.csv` entry, so any per-genus count omits them); and the tile-collapse
and Part 7 recount, which are E6's own follow-ups rather than cluster work.

### Next priority — 2026-11-16 (replaces "Next steps, in order" below)

1. **B4**: main Class_1b clusters, frozen cluster of every B1/B2 site, `OP860412 297` conflict.
   Cheap, and it fixes the B tables.
2. **cluster 106 → Track B.** E2b is **run, negative and confirmed under 1.1.2** (PP 0.397–0.465,
   5′-truncated, negative bits — see "Is cluster 106 really not Class_1b?" below). So: align
   cluster 106 alone at 80 nt
   (`cm_candidate.sh align aln_FJIS_c106_<yymmdd> $FA106`) for a consensus structure in its own
   coordinates and a triple 5′ of P1, then a provisional model → RNAvirus DB → targeted NCBI ISF
   set. No model is accepted from 3 sequences.
3. **FJJI 41, then 44**: MATER edit, R-scape, first model, library search. Cluster 41: check the
   1 mM table to separate Mg dependence from coverage.
4. **FJTB 64 and PLLG 117**: position checks against the existing candidates before any alignment.
5. **HPPV 39**: align (Aligning block, Part 3).
6. **`cand_FJTB_261026` / `cand_PLLG_260915`**: record the 10-27 RNAvirus DB results; step 14a.
7. **Class_1b: E1–E5 are all done; E6 is the live step.** The model to deploy is **cluster 5
   alone** (E2 rejected `strong` and `newvirus`). Nothing is outstanding before it: E3 settled the
   count, E4 passed both parts and confirmed the seed's columns need no change, and E5 supplied every
   label, now written to `cm/class1b_groups.tsv`. **E6:** MANIFEST, new `cm_set_<yymmdd>`, the
   groups file, steps 10–11b, the tile-collapse follow-up, recount against **7** models — commands and
   the replace-vs-add decision in "E6: the deployment commands" below. Record at E6 that seven of the ten
   cluster-5 sites are marginal (23.4–27.7 b) and will not survive a later revision, and that four
   rows of the groups file carry an unresolved group that must not be joined yet.
8. **Clade pools** with `make_pool_fastas.py`; reconcile the hepaci lists and the 13 partial 1b
   matches inside HPHV.

### Where Class_1b expansion goes — decided 2026-11-16

**Library-internal expansion is at capacity at cluster 5**, demonstrated four independent times
(step 17; the three 1.1.2 rebuild variants; `kamiti`; `phaiomys`/`both`): `OP860412 297` is the
marginal hit in every direction, gained by cluster 5 and lost by every further addition. One
library-level question is unfinished (E1 below); everything past it needs sequences from outside
the 439-member library.

**The ordering argument.** Deployment is the expensive step — new `cm_set`, cluster steps 10–13,
re-annotation, recount — so settle every library-level question first and deploy once. E1–E4 are
commands already written in this file; only E7 is new work.

**Everything below is `scripts/cm_class1b_E.sh e1`…`e5`** (one subcommand per step;
syntax-checked, never run — read each step's output before the next).

| # | step | why here | where the commands are |
|---|---|---|---|
| **E1** ✓ | **AB021287 `--max`** against the existing `strong` / `newvirus` models | **RUN 2026-11-17: it IS a filter artefact.** Original model 29.7 b both modes; `strong` and `newvirus` give NO HIT by default but **30.0 b** and **30.2 b** under `--max`, E 8e-7 / 7.5e-7, both `!`. The CM scores it *higher* than the original does — the HMM filter drops it. So the only ground for rejecting both variants falls away and **library-internal expansion is reopened**. → E2 | Part 6, end of "Class_1b expansion attempt" |
| **E2** ✓ | E1 cleared, so: **rebuilt `strong` and `newvirus` on the cluster-5 seed** and judge per hit against the cluster-5 baseline | **RUN 2026-11-17: BOTH REJECTED, and library-internal expansion is closed for good.** Each loses the **same 9** hits — the 9 weakest in the baseline, 23.4–27.8 b — of which **7 are cluster 5's own gains**. Gains: 2 sites (`strong`) or 1 (`newvirus`). Since the 68 novel hits were **already found** by the baseline, adding them to the seed buys no annotation: net **−7 sites for nothing**. `eff_nseq` 50.24 → 25.58, `lower_bits` 55, worst −6.2: the model is at its relative-entropy ceiling | Part 6 method + the `plusFJIS` block in Part 3, with `$SEED1B` replaced by the cluster-5 `.stk` |
| **E2b** ✓ | **cluster 106 alone, added to the cluster-5 baseline** — `cmalign --mapali $C5.stk` of the 3 cluster-106 sequences, rebuild, compare per hit against `${C5}_library.tbl` | **the test that decides whether 106 is Class_1b, and it has never been run.** Every rejection of 106 used the **original 88-sequence** model, and `all` added it *pooled with cluster 5*. The baseline changed on 11-02: the seed now contains the P1-deviant ISF subtype, which is the closest thing in the model to cluster 106, so the alignment it gets may not be the PP 0.38–0.47 it got before. Cheap; files all exist. **RUN 2026-11-16: negative** — PP 0.397–0.465, still 5′-truncated, negative bits; identical to the old model's reading. Cluster 106 goes to Track B. **Re-run under 1.1.2 gave identical figures to 3 d.p., so CONFIRMED and citable.** `cmcalibrate` onward not needed for the verdict | `cm_class1b_E.sh e2b` |
| **E3** | **`OP860412 297` count conflict** | no decision depends on it, but the membership table must be right before deployment, and E2 reuses the number | Part 3, B4 block (`grep -E 'NEW\|LOST'`) |
| **E4** ✓ | **`pp_check`** (PP of the six added sequences' triple columns) and **`insertcheck`** (how many included sites occupy the insert columns beside cm 29 / 43) | **RUN 2026-11-17, both pass.** `pp_check`: all six added sequences read C/G/C at cm 7/29/43 at PP 0.85–>0.95, no insertions — so every cluster-5 site carries the Class_1b triple. `insertcheck`: **0 insert columns beside any of the three, occupied in 0/139 sites** — the seed layout stands and nothing needs re-comparing | Part 3, the triple and seed-shift sections |
| **E5** ✓ | **B4**: main Class_1b clusters, frozen cluster of every B1 / B2 site | **RUN 2026-11-17: main clusters are 131 and 133** (62 of the 73 clustered Class_1b nodes). Every B1/B2 label assigned per stall; `cm/class1b_groups.tsv` written, 19 rows. **No deployed site is `core`** — all eleven model members are satellite copies | Part 1, B4 |
| **E6** ◀ **now live** | **deploy once**: MANIFEST, `cm_set_<yymmdd>`, `class1b_groups.tsv` (Part 9), cluster steps 10–13, recount the no-CM pool against **7** models (the successor replaces Class_1b; it is not an 8th) | until this runs, the 10 sites the accepted model claims are still counted as gaps — **unblocked 2026-11-17 by E8**, which confirmed the positional hypothesis and found nothing to add, so the accepted cluster-5 model is the model to deploy. The NC_008604 10707 anomaly was resolved at 22:12 in the acceptance's favour, so **nothing gates this step**. Until this runs, the 10 sites the accepted model claims are still counted as gaps, so the gap list is wrong by 10 | Part 9 → `class1b_groups.tsv`; cluster steps per the 261021 run log |
| **E7** | **a targeted set of complete ISF genomes from NCBI** — around *Xishuangbanna aedes flavivirus*, *Menghai flavivirus*, *Kilpisjarvi flavivirus*, and the ISF genomes carrying tandem arrays | the only route left, and it serves three stuck questions at once: cluster 106 (3 near-identical sequences can neither support a model nor pass the covariation gate), NC_005064 and MW897328 (both need "a looser model of their own or sequences from outside this library"), and any further Class_1b addition. **The RNAvirus DB is demonstrably too narrow here**: 4 of the 8 FJIS seed genomes score 52–79 bits in the library and do not appear in it at all | written 2026-10-30 under the FJIS RNAvirus-DB section; never run |
| **E8** ✓ **closed 2026-11-17** | **is the unit positional rather than clustered?** Seed *the 3′-most copy of every ISF tandem array* — the set E5's satellite pattern points at — and apply the no-loss rule. `cm_class1b_E.sh e8` enumerates the arrays in two independent views (explorer clustering, and the accepted model's own tbl by genomic position) and writes the fetchlist; `e8b` builds and compares | E2 closed a **bit-score** cut and `newvirus` a **novelty** cut; 2026-11-03 tested the sub-threshold sites **one at a time**. Nobody has tested the positionally-defined set, and it is the set the literature names (PMC7527734: the P1-deviant subtype is found in *downstream* copies, xr3/xr4). Cheap: one `cmbuild` and one `cmsearch` **RESULT: hypothesis confirmed, nothing to add.** Clusters 5 and 21 are entirely ISF and **3′-most in 8 of 8**; clusters 39 and 135 are entirely rodent pegiviruses (`HPPV 39`, already a registered gap), so the apparent 5′ satellite is a different genus, not a second ISF position. Every ISF positional element is seeded or already annotated **except Kamiti River virus NC_005064 11245**, rejected alone on 11-03 as `kamiti`. `e8b` has no experiment left. The accepted model **is** the positional model | this section; `class1b_arrays.py`; E5's satellite rows in Part 10 |

### E8: the accepted model is not "cluster 5", and the unit may be positional — 2026-11-17

**First, a scope correction, because it is this file's own wording that misleads.** "The model to
deploy is cluster 5 alone" (E2's conclusion, Part 10) is about which *seed-addition set* survived
testing — cluster 5's six sequences rather than `strong`, `newvirus`, `all` or cluster 106. It is
**not** a statement about which elements the model covers, and reading it that way is wrong. What
the accepted model actually does, from the 11-02 rows already in Part 10:

| what | sites | note |
|---|---|---|
| six sequences **added to the seed** | NC_008604 10707, NC_012671 10735, NC_021069 10735, NC_024299 10747 (fifth array copies), AB981186 10732, MH827524 10759 (genomes absent from the seed) | these are the "cluster 5" of the build name |
| four **recovered** seed loci the original model scored just below inclusion | **PaRV xr4** NC_027817 543 (22.3 → 28.3 b), **MECDV xr1** NC_027819 561 (22.3 → 27.7), **CFAV xr3** LR694076 476 and MH237596 478 (19.9 → 23.4) | already Class_1b seed members by name; the rebuild fixes a *recovery* failure |
| one further gain | OP860412 297 | |

So **CFAV's downstream element is already in, twice over**: `CFAV_NC_001564-2_10555-10632_xr3` is a
named sequence of the provided Class_1b seed, and the rebuild is what finally includes it in the
library at 23.4 b. And the model already spans two frozen clusters — LR694076 10565 is **fz 21**,
not fz 5 — so it is not a one-cluster model even on the clustering's own terms. The build name
`plusFJIS_cluster5` is the source of the confusion, which is a further argument for not carrying it
downstream.

**Second, the real gap, which is the question worth asking.** PMC7527734 identifies this element as
the P1-deviant ISF subtype **found in downstream copies (xr3, xr4)** — a *positional* definition.
E5 then found the same thing from the other direction: the clustering, which knows nothing about any
CM, separates the array's last copy into a satellite cluster, and does it three times over (5, 21,
135). If the unit is positional, then the set to seed is "the 3′-most copy of every ISF array", and
**no step has tested that set**:

- **E2** tested a *bit-score* cut (`strong`) and a *novelty* cut (`newvirus`). Both rejected.
- **2026-11-03** tested the remaining sub-threshold sites **one at a time**: `kamiti`
  (NC_005064 11245, fz 21, 18.5 b `?`) loses OP860412 297; `phaiomys` (MW897328 10653, fz 135,
  19.3 b `?`) is 3′-truncated at PP 0.622 and loses three sites. Both rejected individually.
- Nobody has added them **as a set**. That is a different test, and not a formality: a bit-score cut
  adds whatever is marginal and flattens the emissions (eff_nseq 50.24 → 25.58 on 38 sequences),
  whereas a handful of sequences that share a *defining* feature can sharpen the columns that
  distinguish the subtype. One outcome is as informative as the other.

Also outstanding: **AEFV xr3** (NC_012932) scores only 13.2 b under the FJIS model (11-02 reciprocal
scoring) and is a downstream copy that appears in no addition set.

**A counterexample is already visible in E5's own data**, and `e8` prints it: MW897328's odd
copy at 10653 (fz 135) is **upstream** of its main-cluster copy at 11228 (fz 133). So "last copy"
cannot be the whole definition, and that array needs reading by eye before the set is fixed.

#### First run, 2026-11-17: the script filtered out the sites it was asking about

`e8`'s first run reported 106 rows over 73 accessions and **no satellite copy** in AB981186,
MH827524, NC_008604, NC_012671, NC_021069, NC_024299, LR694076 or NC_005064 — every one of E5's
documented satellites missing, and MW897328 absent from the table entirely. The cause was a
`cls == "1b"` filter in `class1b_arrays.py`:

> **the explorer's `cls` is CM-derived.** A copy the Class_1b model misses is labelled
> `None found`, which is *every satellite copy, by construction* — that is the whole reason the
> expansion exists. Filtering on `cls` therefore deletes the question. This is the same error as
> the two accession-based greps corrected earlier (E2b's "did they come in?" and E5's per-accession
> listing): **using a CM-derived label to ask a question about what the CM misses.**

Fixed: keep `cls` in {`1b`, `None found`}, drop `1a` / `2` / `dumbbell` (a Class_1a copy in the same
genome is a different element, not an array member — NC_027819's fz 7 node at 10587), and restrict
to genomes carrying at least one confirmed `1b` copy so unclassified nodes elsewhere do not flood
the output. A second bug in the same run: 151 of 416 nodes have **no** frozen cluster, and `fz` of
`None` was being read as a satellite, which manufactured all four reported counterexamples
(MH282908, MT276199, NC_020902, NC_027817 — all unclustered, not satellites) and two of the three
confirmations. Unassigned is now its own verdict, *3′-most copy is unclustered — still a candidate*.

#### What survived that run: KC181923

One result was real, because its node is `cls 1b` and the filter let it through:

| accession | copies | frozen clusters | note |
|---|---|---|---|
| KC181923 | 10492, 10630, **10929** | 133, 133, **21** | Aedes flavivirus, listed in Part 10 (11-03) as "already Class_1b, cluster 133" |

So a genome this file treats as ordinary core Class_1b carries a **cluster-21 satellite as its
3′-most copy**, and that copy is in no addition set. It is the fourth instance of the satellite
pattern and it was not found by E5, which labelled only the B1/B2 stalls rather than enumerating
every array.

**Correction to the above, from the 21:42 run:** I wrote that `KC181923 859` is "one of the nine
marginal sites E2 loses". It is not — E2's nine are AB021287 65, NC_027819 561, MH827524 595,
MH307700 124, NC_021069 597, AB981186 590, NC_012671 545, LR694076 476, MH237596 478. `KC181923 859`
is one of **E2b's nineteen**, lost when cluster 106 was admitted. And view 2 settles the locus
anyway: KC181923 10928 is **included at 29.0 b**, not marginal. So the tie between the marginal band
and the satellite set has to be made from the satellites themselves, and view 2 now makes it
directly — see below.

#### E8 view 1, 2026-11-17 21:42: the positional hypothesis holds for every assigned satellite

314 rows over 73 accessions with a `1b` copy, 35 arrays of more than one copy. **Every satellite the
frozen clustering assigned to cluster 5 or cluster 21 is its array's 3′-most copy — 8 of 8:**

| accession | array | satellite | fz |
|---|---|---|---|
| AB981186 | 10240, 10339, 10487, 10619 | **10732** | 5 |
| MH827524 | 10269, 10368, 10514, 10644 | **10759** | 5 |
| NC_008604 | 10246, 10478, 10598 | **10707** | 5 |
| NC_021069 | 10244, 10343, 10489, 10621 | **10735** | 5 |
| NC_024299 | 10211, 10349, (10429, 10501), 10561, 10637 | **10747** | 5 |
| KC181923 | (10430), 10492, 10630 | **10929** | 21 |
| LR694076 | 10185, 10271 | **10565** | 21 |
| NC_005064 | 10358, (10914), 10954, (11088) | **11245** | 21 |

**With species names attached (run 22:00), every apparent counterexample is a different virus
group.** This is the result, and it is cleaner than the hypothesis as stated:

| cluster | copies | viruses | where in the array |
|---|---|---|---|
| **5** | 5 | Culex flavivirus, Mosquito flavivirus ×2, Nienokoue virus, Quang Binh virus | **3′-most, 5/5** |
| **21** | 3 | Aedes flavivirus, Cell fusing agent virus, Kamiti River virus | **3′-most, 3/3** |
| 135 | 4 | *Phaiomys leucurus* pegivirus, Rodent pegivirus, Wenzhou *Rattus tanezumi* pegivirus 1, Wufeng *Niviventer fulvescens* pegivirus 1 | 3′-most ×3, 5′-most ×1 |
| 39 | 3 | Rodent pegivirus, Wenzhou *Rattus tanezumi* pegivirus 1, Wufeng *Niviventer fulvescens* pegivirus 1 | **5′-most, 3/3** |
| 106 | 1 | Kilpisjarvi flavivirus | mid-array |

Clusters 5 and 21 are **entirely insect-specific flaviviruses**. Clusters 39 and 135 are
**entirely rodent pegiviruses** — a different genus, and cluster 39 is already in the Part 1 gap
register as **`HPPV 39`, "rodent pegiviruses, explorer cluster 39", 4 sites, priority 5**. The three
genomes that produced the apparent 5′ satellite (LC602141, MT210614, MT210620) are those pegiviruses,
and MW897328, the one counterexample from E5, is *Phaiomys leucurus* pegivirus.

**Correction to what I wrote before the names were available:** "satellites occupy the array's ends"
merged two genera and was wrong. Within insect-specific flaviviruses the positional hypothesis holds
**without exception — 8 of 8, all 3′-most**. The 5′ satellite is a pegivirus phenomenon belonging to
the `HPPV 39` workstream, not a second position in the ISF array. The only ISF exception is
**Kilpisjarvi flavivirus** (ON949931), whose deviant copy is mid-array at 10608 and is cluster 106 —
already rejected by E2b, and absent from the Class_1b tbl altogether, consistent with it.

#### E8 VERDICT: hypothesis confirmed, and the accepted model already covers the set

The positional set within ISFs, against the accepted model's own library tbl:

| virus | locus | in the seed? | accepted model |
|---|---|---|---|
| Culex flavivirus NC_008604 | 10707 | **yes** | **20.9 b `?` — not included** |
| Mosquito flavivirus AB981186 | 10732 | yes | 23.4 b `!` |
| Mosquito flavivirus NC_021069 | 10735 | yes | 24.9 b `!` |
| Nienokoue virus NC_024299 | 10747 | yes | 30.1 b `!` |
| Quang Binh virus MH827524 | 10759 | yes | 26.6 b `!` |
| Quang Binh virus NC_012671 | 10735 | yes (no explorer node) | 23.4 b `!` |
| Aedes flavivirus KC181923 | 10929 | no | 29.0 b `!` |
| CFAV LR694076 | 10565 | no (recovered) | 23.4 b `!` |
| CFAV MH237596 | 10555 | no (recovered) | 23.4 b `!` |
| PaRV NC_027817 | 10756 | no (recovered) | 28.3 b `!` |
| **Kamiti River virus NC_005064** | **11245** | **no** | **18.5 b `?` — not included** |

**Every ISF positional element is either seeded or already annotated, except Kamiti River virus
11245 — which was tested alone on 2026-11-03 as `kamiti` and rejected, because it loses
`OP860412 297`.** So E8 confirms the hypothesis and finds nothing to add: the candidate list reduces
to one sequence whose rejection is already recorded. `e8b` has no experiment left to run — a
one-sequence rebuild of an already-rejected addition is not a different test from the 11-03 one.

**E8 is therefore closed, and E6 is unblocked** — subject only to the NC_008604 10707 anomaly below,
which is a question about the accepted model's validity rather than about expansion.

The deeper reading: the positional hypothesis was right, and the accepted model is the positional
model. `cluster 5` was never the unit — it is the ISF 3′-terminal subtype, which is what PMC7527734
described, and the 11-02 rebuild captured it by seeding cluster 5 and *recovering* the rest
(PaRV xr4, CFAV xr3 ×2). That is why E2's broadenings all failed: there was nothing left of this
element to add.

#### E8 view 2, and a contradiction with E3 that must be resolved before E6

View 2's verdict line ("holds for 0, fails for 30") was a bug of mine — in tbl mode `MAIN` can never
match, so every *included* hit was counted as an odd copy. Fixed: in the tbl view the odd copy is a
**sub-threshold** hit. What the run does establish, from the accepted model's own library tbl:

**Five of the six added cluster-5 sequences are included; the sixth is not.**

| added sequence | in the accepted model's tbl |
|---|---|
| AB981186 10733 | 23.4 b `!` |
| MH827524 10760 | 26.6 b `!` |
| NC_012671 10736 | 23.4 b `!` |
| NC_021069 10737 | 24.9 b `!` |
| NC_024299 10746 | 30.1 b `!` |
| **NC_008604 10709** | **20.9 b `?` — not included** |

This contradicts the E3 row, which states that "NC_008604 10707 is NOT a gain. Its cluster-5 copy
was added to the seed … but **was already an included hit**, so it produced no new annotation." In
the accepted model's own search it is not an included hit. Two readings, and they are not equally
comfortable:

1. **E3's reason is simply wrong** — the locus was never included, by either model. The conclusion
   ("not a gain") survives, but so does a worse fact: a sequence in the seed is not recruited by the
   model built from it.
2. **It was included by the original model and is not now**, in which case the accepted model
   **lost an included hit** and does not satisfy the no-loss rule it was accepted under
   (`94 seqs, 10 gained, 0 lost`).

#### RESOLVED 2026-11-17 22:12: reading 1. E3's reason is wrong, its conclusion stands, the acceptance holds

`hits_at_stall` on both models, at `NC_008604:10707` (stall rel 575, offset 10133):

| model | hits in that sequence | at the stall |
|---|---|---|
| original `CL_Class_1b_xrRNA_final` | rel 113–194 (32.7 b `!`), 232–312 (44.0 `!`), 345–419 (47.2 `!`), 465–543 (42.5 `!`) | **nothing — not included, not even reported** |
| accepted `class1b_plusFJIS_cluster5_inf112` | the same four at 32.7 / 45.8 / 48.6 / 43.5 `!`, **plus rel 577–677 at 20.9 b `?`** | **a hit 2 nt from the stall**, below inclusion |

**So nothing was lost.** The original model had *no hit whatsoever* at this locus; the accepted model
has one at 20.9 b, reported but not included. The no-loss rule is intact and **the 11-02 acceptance
stands**. E3's conclusion — "NC_008604 10707 is NOT a gain" — is also right, because a `?` hit is no
new annotation. Only its stated *reason* was wrong: the locus was never an included hit, by either
model. Corrected in the E3 row.

What the seed addition actually bought at this locus is a hit where there had been none, which is
the weakest possible version of success and consistent with E2's capacity argument: this is the sixth
of six additions and the only one that stayed below inclusion. It also explains why the element was
uncatalogued — the original model does not see it at all.

The 20.9 b hit spans rel 577–677, 101 nt against the model's `clen` 81, starting 2 nt past the
stall. `hits_at_stall` called that a flat `no` (its tolerance was ±1); it now reports the distance,
because that `no` was within one reading of being taken as "absent" and reopening the acceptance for
no reason.

```bash
clog class1b 'NC_008604 10707 resolved: E3 reason wrong, conclusion right, acceptance holds' \
  'original model has NO hit at the locus, included or reported; accepted model has rel 577-677 20.9 b ? at 2 nt from the stall; no loss, no new annotation; E6 unblocked'
```

For reference, the original form of the question:

```bash
source ~/Desktop/viromelib/flaviLib/scripts/flavi_env.sh
hits_at_stall "$SAT/r0/search.tbl"  NC_008604:10707   # the ORIGINAL model's baseline
hits_at_stall "${C5}_library.tbl"   NC_008604:10707   # the accepted model
```

Three further observations from view 2. **KJ741266 10930, LC536088 10908 and KC181923 10928 are all
included at exactly 29.0 b** — three *Aedes flavivirus* genomes whose 3′-most copies score
identically, and two of those three loci have **no explorer node at all**, so the node set is
incomplete relative to the tbl and view 1 cannot see them. **The two views do not enumerate the same
population** (NC_005064: 5 nodes against 3 hits; MW897328: 5 against 2), so expecting their copy
counts to agree was naive — they must be compared by position, which is what `--satellites` now
does. And **ON949931 10829 is not the cluster-106 locus**: its fz 106 node is at 10608, and 10275 is
the included 30.2 b Class_1b hit E2b found was lost when cluster 106 was admitted, so 10829 is a
third locus and adding it is not the same experiment as E2b.

#### 13 of these genomes appear nowhere else in this file

Checked against this file as it stood before 2026-11-17. Of the genomes `e8` surfaced, these have
**no prior mention at all**: HE574573, KC796087, KX905133, LC602141, MT210614, MT210615, MT210620,
MT276199, MZ229974, NC_024377, NC_031327, OM030329, OU592965. That includes **all three genomes
that produced the 5′-satellite pattern** — LC602141, MT210614, MT210620 — so the new result sits
entirely in genomes this project has not discussed, which is why it could only be reported as
accessions: the file has no name for them.

The names exist in the node table, which carries `species` and `genus` columns that
`class1b_arrays.py` was reading past and discarding. Fixed: the array listing now prints the species
beside the accession, `satellites.tsv` gains `species`, `genus`, `n_copies` and `is_3prime_most`,
and the run ends with a **satellites-by-cluster summary giving each copy's species and which end of
its array it occupies**. Every statement about these elements should be made in those terms, as the
rest of this file does (PaRV xr4, MECDV xr1, CFAV xr3, QBV, NIEV), rather than by accession.

Two consequences. **The gap register in Part 1 is incomplete** — it tracks FJTB 64, PLLG 117 and
HPPV 39, but cluster 39 turns out to be a 5′-terminal subtype recurring across three unexamined
genomes, which is a different kind of entry from a single-cluster gap. And **the 13 unmentioned
genomes are not a side note**: they are where the array structure is least constrained by anything
already decided here, so they are the natural targets for E7's NCBI search alongside the ISF genomes
already listed.

#### The candidate list needed three fixes before `e8b` could use it

The 7 candidates the first run printed were not candidates, and after the fixes the list is **2**,
then **1**:

- **NC_008604 10709 is already in the seed.** Re-adding it would inflate `eff_nseq` for nothing.
  `--seed $C5.stk` excludes seeded loci and reports them separately, since a sub-threshold hit at a
  *seeded* locus is the finding above, not a candidate. **This did not work on the first attempt**:
  the 22:00 run read the seed (6 sequences) and still listed NC_008604 10709, because seed names
  carry the library sequence name *plus a relative subsequence range*
  (`ACC.1|10000-11000/708-788`), so matching raw numbers against a genomic position compares 708
  with 10707. Fixed by converting through the offset, exactly as the tbl view does. With that fix
  the candidate list is **NC_005064 11245 alone**.
- **NC_020902 11020 at 9.5 b and OM030329 10645 at 14.9 b** are nowhere near the 23.4–27.8 b band
  this file argues over. A `--floor` (default 20.0 b) excludes them and says so.
- **but a bit floor would also have discarded NC_005064 11245 at 18.5 b**, the one candidate *both*
  views support (fz 21 **and** 3′-most sub-threshold). A low score is what the model does; the
  clustering is independent evidence that the element is real. So `nodes` mode now writes
  `satellites.tsv` and `tbl` mode takes `--satellites`, which **exempts a cluster-backed candidate
  from the floor**. `e8` chains the two.

**E6 is held until E8 runs.** Not because the deployment is wrong — a version replaces its
predecessor, so a later `v3` is no catastrophe — but because cluster steps 10–13 and the no-CM
recount are the expensive part, and E8 costs one `cmbuild` and one `cmsearch`. If E8 passes, `v2`
should be the positional model and the name is already right.

```bash
# both views of the arrays, and the fetchlist
bash ~/Desktop/viromelib/flaviLib/scripts/cm_class1b_E.sh e8

# build the positional set and apply the no-loss rule
bash ~/Desktop/viromelib/flaviLib/scripts/cm_class1b_E.sh e8b
```


### Next, in order — 2026-11-17

Steps 1–4 are independent of each other except where noted; **step 3 gates E6** and **step 5 needs
step 2**. Each step says what its output decides.

**0. E8 is closed and step 3 is done.** The positional hypothesis is confirmed and the accepted
model already covers the set, so `e8b` is **not** to be run (step 5 is struck). NC_008604 10707 is
resolved in the acceptance's favour, so **step 3 is complete** and nothing gates E6. The live path
is **step 4, then E6** — steps 1 and 2 only matter if `satellites.tsv` is to be regenerated.

**1. Install the corrected `class1b_arrays.py` and verify it.** The version in `$FLAVISCRIPTS` has
been wrong twice today in ways that produced plausible-looking output, so the md5 is the check, not
the fact that it runs.

```bash
cp <download dir>/class1b_arrays.py "$FLAVISCRIPTS"/
md5 "$FLAVISCRIPTS/class1b_arrays.py"      # expect 4df8f2cb72c55a0fd78b2421f6a12fe8
md5 "$FLAVISCRIPTS/cm_class1b_E.sh"        # expect 41a3382bbcfb2b512a3465c78bd42f41
```

**2. Re-run `e8`** — only needed to regenerate `satellites.tsv` with the seed fix applied; the
scientific result is already in hand. Output is named by species, chains both views, and writes
`satellites.tsv` plus a filtered `positional_candidates.fetchlist`.

```bash
bash "$FLAVISCRIPTS/cm_class1b_E.sh" e8
```

Read the **satellites-by-cluster** summary at the end of view 1. Expect cluster 5 and cluster 21 to
be `3'-most` in all 8, and cluster 39 to be `5'-most` in three genomes. Anything that contradicts
that changes the hypothesis, not the script.

**3. Settle NC_008604 10707 — this gates E6.** Either the E3 row's reason is wrong, or the accepted
model lost an included hit and fails the no-loss rule it was accepted under.

The signature is the one in `flavi_env.sh` line 153 — **tbl first, then `ACC:stall` colon-joined** —
and the scripts here are `#!/usr/bin/env bash`, so this runs *under* bash rather than being sourced
into an interactive zsh:

```bash
bash -c '
  source "$HOME/Desktop/viromelib/flaviLib/scripts/flavi_env.sh"
  echo "== original model"; hits_at_stall "$SAT/r0/search.tbl"  NC_008604:10707
  echo "== accepted model"; hits_at_stall "${C5}_library.tbl"   NC_008604:10707
'
```

- included in both → impossible, the tbl says otherwise; re-read the position conversion
- included in the original, not in the accepted → **the acceptance reopens**; stop and record it
- not included in either → E3's reason is wrong, its conclusion stands, and the live fact is that a
  seed sequence is not recruited by the model built from it

```bash
clog class1b 'NC_008604 10707 resolved' '<original: X b; accepted: Y b; reading>'
```

**4. `$CMS` — done 2026-11-17 22:32. The env file is on the cluster**, not the laptop, and its list
is recorded verbatim in *Where E6 actually runs*. Nothing to search for and nothing to create. The
tbl listing below is now only a cross-check that the cluster's seven match what is annotated:

```bash
ls "$HOME/Desktop/viromelib/work/06_infernal/260807_trueRef"/*.tbl
```

Expect **seven**. Each basename minus `.tbl` is one `$CMS` entry. E6 then writes the list in full
with `class1b_v2_inf112.cm` in place of `CL_Class_1b_xrRNA_final.cm`, so the replacement is visible
in the command instead of hidden in a file that may not exist the next time.

**~~5. Run `e8b`~~ — struck.** After the seed-exclusion fix the candidate list is Kamiti River
virus 11245 alone, and a one-sequence rebuild of an addition already rejected on 11-03 is not a
different test. Record the closure instead:

```bash
clog class1b 'E8 closed: positional hypothesis confirmed, nothing to add' \
  'clusters 5 and 21 ISF and 3-most 8/8; 39 and 135 rodent pegiviruses (HPPV 39); every ISF positional element seeded or annotated except NC_005064 11245, rejected 11-03 as kamiti'
```

**6. Then E6, with whichever model step 5 leaves standing** — the cluster-5 model as accepted, or the
positional model. The deployed name `class1b_v2_inf112.cm` is right either way. Only after that, the
two column renames the sweep found, since they must name the model that is actually deployed:
`build_pllg_outputs.py:142` and `plot_combined_peaks.R:50`.

**Not on this list, and deliberately:** cluster 39 as a 5′-terminal subtype, and the 13 genomes this
file has never mentioned. Both belong to E7, which needs sequences from NCBI rather than anything in
the library, and neither changes what E6 deploys.

### E6: the deployment commands, and the one decision they need — 2026-11-17

Grounded in steps 10 and 11b as recorded under "How the CM columns are produced" (Part 9), not
invented. Two facts from there govern everything else:

- **`$CMS` lives in `scripts/env_261021_flaviLib.sh`, "the single definition of the CM set."** That
  file is what must change; dropping a `.cm` into `cm/` annotates nothing.
- **"Column names are the `.tbl` basenames including `.cm` … Rename a `.cm` and every downstream
  column moves with it."** So the model's *filename* is the column name.

#### The decision: replace the Class_1b model, or add alongside it?

| | replace `CL_Class_1b_xrRNA_final.cm` in the set | add as an 8th model |
|---|---|---|
| models annotating | stays **7** | **8** |
| the 10 new sites | appear in the Class_1b column | appear in a new column |
| double-claiming | none | **the same element is claimed by two versions of one model** — and overlap resolution by lower E is for competing *classes*, not for a model against its own successor |
| column name | changes unless the file keeps the old name | old column untouched |

**Replace.** The successor is strictly better by the rule that accepted it — 0 lost, 10 gained — so
keeping both would double-count every Class_1b site and make the no-CM recount meaningless. The
earlier note in this file about recounting "against 8 models" was wrong; it stays **7**, with
`cm_set_261021` preserved as the provenance of the old annotation.

#### Deployed name: `class1b_v2_inf112.cm` — decided 2026-11-17

The model gets a **new name**, not a content swap under the old one: swapping what
`CL_Class_1b_xrRNA_final.cm` contains would hold the column name stable at the price of a file that
contradicts itself, which is the failure this document exists to prevent.

The deployed name is **`class1b_v2_inf112.cm`**, so the annotation column becomes
**`class1b_v2_inf112.cm_hit`**:

| part | why |
|---|---|
| `class1b` | keeps the column recognisable as *the* Class_1b column, and matches the lowercase convention of the models built here (`class1c.cm`, `cl3…`, `cl4_v9`) rather than the provided `CL_*_final` names |
| `v2` | it is the successor to the provided model, which is v1 by implication |
| `_inf112` | the builder version. Part 9's rule is **conditional** — models carry `_inf<ver>` *when built by a non-default Infernal* — and 1.1.2 is non-default here, the env's own `cmbuild` being 1.1.5. So it applies, but it is not a blanket requirement on every model name, and `class1c.cm` correctly has no suffix |

The suffix is **redundant as data**: the builder version is in the model's own header
(`INFERNAL1/a [1.1.2 | July 2016]`), which is what `cm_version` reads and what makes
`cm_env_require` work, and the header is authoritative where a filename can be wrong. It is in the
name for two other reasons. The filename *is* the annotation column, so the suffix carries the
version into every downstream table without anyone opening the model; and a future rebuild of the
same seed under 1.1.5 is a different model (88/48.62/81/19/2 against 88/87.08/78/18/2, Part 2) that
must not be able to replace this one under one name.

**Not** `class1b_plusFJIS_cluster5_inf112.cm`, the build name. `plusFJIS_cluster5` describes *how*
the model was made, which belongs in MANIFEST and the run log, not in every downstream table for the
rest of the project. Part 9's scheme already works this way — `cand_`/`conf_` build names become a
clean name on acceptance — so renaming at deployment is the convention, not an exception. MANIFEST
carries `build_path` so the link back to
`build/class1b/iter_v3_plusFJIS/cluster5/class1b_plusFJIS_cluster5_inf112.cm` is exact.

**Sweep run 2026-11-17**, 49 hits, of which only **three** are live consumers:

| file | line | what it is |
|---|---|---|
| `flaviLib/scripts/build_pllg_outputs.py` | 142 | `"CL_Class_1b_xrRNA_final.cm_hit"` — **the column name**, must change |
| `figures/fig1/plot_combined_peaks.R` | 50 | `CM_HIT_1B <- "CL_Class_1b_xrRNA_final.cm_hit"` — **the column name**, must change |
| `flaviLib/scripts/flavi_env.sh` | 29 | `CL1B` path — keep, it is the predecessor and still referenced |

Everything else is one of three things that must **not** be edited: archived and dated workflow
records (`archive/`, `vintage_md/`, `FIGURES_log_consolidate_20261103.md`, the `260914-260917` and
`260915` logs) which record what was run at the time; md5 tables of the old model and its `.tbl`,
which are provenance; and `.sto` / `.cm` paths for the predecessor, which stay valid because the
predecessor is not deleted. Per Part 9 → **Renaming, and what is not rewritten**, a run log is
history and is appended to, never corrected in place.

**Two results worth noting, both contrary to expectation.**

- **`scripts/env_261021_flaviLib.sh` is not in the sweep at all.** This file's own claim that it
  holds "the single definition of the CM set" is true as far as `$CMS` goes, but `$CMS` evidently
  does **not** name the models by basename — it is a directory or a glob. So E6 step 4 may be a
  no-op and dropping the new `.cm` into the set directory may be the whole of it. Confirm before
  editing anything:

  ```bash
  # 2026-11-17: this path DOES NOT EXIST -- find the file before anything else
  # ONE -name, no -o: `find P -name A -o -name B` applies the implicit -print only
  # to the LAST term, so the first pattern's matches are silently not listed.
  find ~/Desktop/viromelib -type f -name 'env_*'
  grep -rn 'CMS=' ~/Desktop/viromelib --include='*.sh' | grep -v flaviLib/scripts/flavi_env.sh
  ```

  **FOUND 2026-11-17 22:32: the file is on the CLUSTER**, at
  `/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib/scripts/env_261021_flaviLib.sh`, and
  its `$CMS` is given verbatim in *Where E6 actually runs* above. The laptop searches below were
  negative simply because the annotation pipeline does not run on the laptop — the path in this
  file was never stale, only incomplete, lacking the machine. Superseded, kept for the method:

  **2026-11-17 22:17: no such file and no shell script defines `$CMS` on this laptop.** Both
  searches over the whole of `~/Desktop/viromelib` return nothing — no file named `env_*` anywhere,
  and no `.sh` containing `CMS=`. `$FLAVISCRIPTS` is `flaviLib/scripts`, whose listing holds
  `flavi_env.sh` and no `env_*` file either. So this file's repeated claim that `$CMS` "lives in
  `scripts/env_261021_flaviLib.sh`, the single definition of the CM set" is **wrong on this
  machine**: it was inherited from `README_261021_flaviLib_150x150.md` and never re-checked, and
  the 261021 annotation was run elsewhere — `vintage_md/flaviLib.md` records tbl paths under
  `/groups/as6282_gp/scratch_bkup/...`, an HPC path, so the env file most likely lives there.

  **`$CMS` is not a glob.** Step 10 and 11b iterate it with `for CM in $CMS`, so it is a
  space-separated list of model basenames *including* `.cm` — which is consistent with column names
  being the `.tbl` basenames including `.cm`. A missing list cannot be globbed around.

  **Consequence for E6, and it is an improvement: define `$CMS` explicitly in the E6 block.** Do not
  recreate the env file and do not depend on an unversioned variable from a shell that no longer
  exists. The authoritative record of what the list contained is the set of `.tbl` files that
  produced the current annotation:

  ```bash
  ls "$HOME/Desktop/viromelib/work/06_infernal/260807_trueRef"/*.tbl
  ```

  Each basename minus `.tbl` is one `$CMS` entry, and there should be exactly seven. E6 then sets
  the list in full with the successor swapped in for its predecessor, so the replacement is visible
  in the command rather than implied by a file's contents.

  If `$CMS` is a glob over a directory, then **the new model is picked up automatically and the old
  one must be physically absent from the new `cm_set_261117` directory**, which is how the
  "replaces, does not join" rule gets enforced in practice rather than by editing a list.
- **`figures/fig1/plot_combined_peaks.R` is the only R consumer**, and it binds the column to a
  single constant at line 50, so the plotting side is a one-line change.

#### Where E6 actually runs — corrected 2026-11-17 22:32

`env_261021_flaviLib.sh` **exists, on the cluster**:
`/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib/scripts/env_261021_flaviLib.sh`. The
laptop search was negative because the annotation pipeline is not on the laptop. Reading it
corrects three things in the plan below and settles one long-standing ambiguity:

| | |
|---|---|
| **`$CMS`, verbatim** | `CL_Class_1a_xrRNA_final.cm CL_Class_1b_xrRNA_final.cm CL_Class_2_xrRNA_final.cm cl3_NAR_2025.align.mpkadded.edited.confident.dedup.IDcurated.SS_cons.cm class4_cl4_v9_20260824.cm class1c.cm dumbbell_RF00525.cm` |
| **`$CMDIR`** | `$ROOT/work/06_infernal/cm` — **flat, no `cm_set_<date>` directories** |
| **`$TBLOUT`** | `$ROOT/work/06_infernal/260807_trueRef` — keyed to the reference, shared across runs |

- **There is no `cm_set_<yymmdd>` on the cluster.** Models live flat in one `cm/` directory and the
  annotating set is defined *only* by the `$CMS` list. So "the predecessor must be physically absent
  from `cm_set_261117`" — written above — is **wrong**: nothing is deleted or moved, the predecessor
  stays on disk as the provenance of the old `.tbl`, and dropping its name from `$CMS` is the whole
  of the replacement. The `cm_set_` scheme is a laptop-side convention and does not travel.
- **`$DS` must be bumped, or the 261021 annotation is overwritten.** `DS=261021_flaviLib_150x150`
  drives `POSTPROC_BASE=$ROOT/work/07_postproc/$DS` and `LOG`. Re-running step 11b under the same
  `DS` writes over the annotation this file's gap counts are based on. Set
  `DS=261117_flaviLib_150x150` and point `ANNOT_OLD` at the 261021 outputs, which is exactly what
  the file already does for the superseded 260903 run.
- **The env file verifies the swap for free.** Its closing loop checks `$TBLOUT/${_cm}.tbl` for every
  `$CMS` entry and prints `cmsearch still needed: <model>`, or `all 7 CM .tbl present`. After the
  swap it will name `class1b_v2_inf112.cm` until step 10 runs, and say `all 7` afterwards. That is
  the check that the edit took effect — no extra command needed.
- **It warns and never exits**, by design (line 79: exiting a sourced file would close the login
  shell). So a missing path does not stop anything downstream; the warnings have to be read.
- **Ambiguity settled**: the set contains `class4_cl4_v9_20260824.cm` and **not** `cl4.cm`. The
  `md5sum` line in `README_261015-261019` lists both, which is why the count read as eight; the
  annotating set is seven.

#### The commands

**A. On the laptop** — `cm_deploy_class1b_v2.sh` stages the three files and prints the `scp` line.
It verifies its inputs first and copies nothing if any is missing, because the two things most
likely to be wrong are silent: `$C5.cm` may not be the accepted 11-02 model, and
`class1b_groups.tsv` may still be sitting in `~/Downloads` rather than at its Part 9 home.

```bash
bash $FLAVISCRIPTS/cm_deploy_class1b_v2.sh                       # check only, copies nothing
bash $FLAVISCRIPTS/cm_deploy_class1b_v2.sh --stage               # build $INFERNAL/deploy_261117
bash $FLAVISCRIPTS/cm_deploy_class1b_v2.sh --groups <path>       # if the tsv is elsewhere
bash $FLAVISCRIPTS/cm_deploy_class1b_v2.sh --stage --set-name class1b_v2
```

**It prints every path it resolved before doing anything.** That is a requirement for any script
here, not a nicety: `flavi_env.sh` is what makes the paths consistent, and the price is that nobody
reading a command can see where it points. `flavi_env.sh --check` does this; the first version of
this script did not, and the result was a `MISS` line naming `$CMDIR` without saying what `$CMDIR`
is. For the record, since it is the one that confuses: **`$CMDIR` is
`viromelib/work/infernal/cm` — the *shared* viromelib tree, not `flaviLib/work`** — because the
models and `MANIFEST.tsv` are shared with viromelib, while the flaviLib build tree under
`$INFERNAL` is where candidates are developed.

It checks that `$C5.cm` and `$C5.stk` exist; finds `class1b_groups.tsv` in `$CMDIR`, `$PWD`,
`~/Downloads` or the scripts directory, and says which; resolves the conda env from the model's own
header via `cm_env_require`; and prints `cmstat`, **warning if it is not nseq 94 / clen 81** — the
accepted model's signature. With `--stage` it writes `$NEW.cm`, `class1b_groups.tsv` and a
`MANIFEST.tsv` carrying md5, builder version, the five `cmstat` fields and the `build_path` that the
deployed name drops, then prints the md5 to re-check after transfer and the `scp` line with
`<user>@<cluster>` left to fill in.

**A is complete, 2026-11-17/18.** `$INFERNAL/deploy_261117` holds the three files;
`class1b_v2_inf112.cm` has `NAME class1b_v2`, md5 **`fa9768bce80ba3b6cbc57e9f238c097d`**, built by
1.1.2, nseq 94 / eff_nseq 50.24 / clen 81 / 19 bp / 2 bif, `build_path` recorded;
`class1b_groups.tsv` (20 rows) is installed at its Part 9 home in the laptop's `$CMDIR`.

Two limits of this MANIFEST, to close on the cluster: it has **one row**, for the new model only,
where Part 9 wants the whole set; and one version is not enough.

**The cluster's Infernal is 1.1.5** (`INFERNAL 1.1.5 (Sep 2023)`, checked 2026-11-18), and the model
was **built by 1.1.2**. That split is not a problem and is not new — it is the whole Class_1b line's
situation, and it is what `cm_env_require` exists to manage: 1.1.2 for `cmbuild`, whatever is
current for the search. The laptop's development searches ran under 1.1.5 as well, so the deployed
search matches them in version; and the six existing `.tbl` files, made against a `260807` reference
on a cluster running 1.1.5 since Sep 2023, were searched the same way. The set is internally
consistent.

But it means **`built_by_infernal` alone under-describes a `.tbl`**, and this file has already been
bitten by exactly that distinction: E1's apparent loss of `AB021287` was a **filter artefact** — no
hit by default, 30.0/30.2 b under `--max` — and filter behaviour is the part of `cmsearch` most
likely to differ between versions. So MANIFEST gets a second version column, recording who searched
as well as who built:

```bash
V=$(cmsearch -h | sed -n '2s/^# INFERNAL \([0-9.]*\).*/\1/p')      # 1.1.5
awk -F'\t' -v OFS='\t' -v v="$V" \
  'NR==1{print $0,"searched_by_infernal"} NR>1{print $0,v}' \
  $CMDIR/MANIFEST.tsv > /tmp/M.tsv && mv /tmp/M.tsv $CMDIR/MANIFEST.tsv
cat $CMDIR/MANIFEST.tsv
```

**B. On the cluster** — swap the name, search the one new model, re-annotate.

`<user>` is almost certainly **`jgg2144`**: the cluster root is
`/groups/as6282_gp/scratch_bkup/jgg2144/…`, so the account name is already in the path. Only the
hostname is missing.

Before the `scp`, check what is already in the cluster's `cm/`. **Checked 2026-11-18**: the seven
`.cm` files and nothing else but a `vintage/` subdirectory — **no `MANIFEST.tsv` and no
`class1b_groups.tsv`**, so the transfer overwrites nothing. The seven match `$CMS` exactly and are
flat, confirming there are no `cm_set_` directories on the cluster.

| model | dated |
|---|---|
| `CL_Class_1a_xrRNA_final.cm`, `CL_Class_1b_xrRNA_final.cm`, `CL_Class_2_xrRNA_final.cm`, `cl3_NAR_2025.…SS_cons.cm` | Apr 24 2026 |
| `dumbbell_RF00525.cm` | Jun 11 |
| `class4_cl4_v9_20260824.cm` | Aug 25 |
| `class1c.cm` | Oct 15 |

**`cm/vintage/` is the cluster's attic for superseded models**, listed 2026-11-18 and previously
undocumented here:

```
cl1a.cm  cl1b.cm  cl2.cm  cl3.cm  cl4.cm  cl5.cm  cl5.picorna.merge.dedup.cm
picorna.cm  picornaPK.cm  picornaPK2.cm  picornaPKseed.cm  picornahit1.cm
picornastem.cm  picornastem_seed.cm
```

Two things worth recording. It holds **an earlier `cl1b.cm`**, so a Class_1b model has been
superseded here before and this is where its predecessor went — the convention is real. And the
names in the attic are *cleaner* than the names in service (`cl1b.cm` against
`CL_Class_1b_xrRNA_final.cm`), so the drift documented in *When a model's filename changes* ran the
wrong way over time. It is also a mixed attic: the `picorna*` models belong to another family
entirely and are not part of any flavi set.

**Decided, and the convention does not change it: do not move the predecessor.**
`env_261021_flaviLib.sh` still lists `CL_Class_1b_xrRNA_final.cm` in its `$CMS`, and that script is
the record of the 261021 run; if the file moves, re-running step 10 from that env fails on a missing
`.cm` and the old run stops being reproducible. The replacement is enforced by the *new* env's
`$CMS`, not by the filesystem. It can go to `vintage/` later, when no live env script names it.

#### The transfer landed one level too deep — 2026-11-18

The three files arrived at **`$CMDIR/deploy_261117/`** rather than in `$CMDIR` itself, which does
not work: `$CMS` holds **bare basenames**, and step 10 resolves each as `"$CMDIR/$CM"`, so
`cmsearch` would look for `$CMDIR/class1b_v2_inf112.cm` and not find it. `class1b_groups.tsv` and
`MANIFEST.tsv` belong directly in `$CMDIR` too, per Part 9. The staging directory is a *laptop-side*
holding area and has no counterpart on the cluster; only its contents travel.

```bash
ls -l $CMDIR/deploy_261117/
mv -n $CMDIR/deploy_261117/{class1b_v2_inf112.cm,class1b_groups.tsv,MANIFEST.tsv} $CMDIR/
rmdir $CMDIR/deploy_261117
md5sum $CMDIR/class1b_v2_inf112.cm          # fa9768bce80ba3b6cbc57e9f238c097d
grep -m1 '^NAME' $CMDIR/class1b_v2_inf112.cm # class1b_v2
cmsearch -h | head -2                        # the cluster's Infernal version -- for MANIFEST
```

`mv -n` so that nothing already in `$CMDIR` can be clobbered, and `rmdir` rather than `rm -r` so it
fails loudly if anything was left behind.

**Would nesting be better organisation?** It was asked, and it is worth answering precisely rather
than by taste, because two things depend on `$CMS` entries being bare basenames:

- `cmsearch --tblout "$TBLOUT/${CM}.tbl"` — a `$CM` of `deploy_261117/class1b_v2_inf112.cm` makes
  that `$TBLOUT/deploy_261117/class1b_v2_inf112.cm.tbl`, and `cmsearch` cannot create a file in a
  directory that does not exist. So **the nesting would have to be mirrored under `$TBLOUT`**, and
  again in the env file's own check loop, `[ -e "$TBLOUT/${_cm}.tbl" ]`.
- the annotation column is the `.tbl` **basename**, so the column itself survives nesting — this is
  not what breaks.

So nesting is possible at the price of keeping two directory trees in step. It buys little, because
**the project already has an organisation scheme here**: one flat directory of models in service,
plus `vintage/` for superseded ones. Per-deployment subdirectories would scatter the in-service set
across dated directories, so answering "what is annotating?" would mean looking in several places.

One consequence to be clear about either way: after this deployment `$CMDIR` holds **eight** `.cm`
files while `$CMS` names **seven**, so `ls $CMDIR/*.cm` stops being the list of what annotates. That
list is `$CMS`, and `MANIFEST.tsv` is what documents it — which is the argument for extending
MANIFEST to all seven on the cluster rather than leaving it at the one new row.

And the filename is descriptive enough on its own terms: `class1b_v2_inf112.cm` carries the family,
the version and the builder version, which is exactly what the scheme in *Versions of an existing
model* asks a deployed name to carry. The directory was never meant to supply that information.


```bash
source /groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib/scripts/env_261021_flaviLib.sh
md5sum $CMDIR/class1b_v2_inf112.cm          # must equal the laptop's md5
cmsearch -h | head -2                       # record the cluster's Infernal version in MANIFEST

# 1. a dated copy of the env file -- never edit the 261021 one, it is the old run's record
cd $ROOT/scripts
cp env_261021_flaviLib.sh env_261117_flaviLib.sh
sed -i 's/CL_Class_1b_xrRNA_final\.cm/class1b_v2_inf112.cm/' env_261117_flaviLib.sh
sed -i 's/^export DS=.*/export DS=261117_flaviLib_150x150/' env_261117_flaviLib.sh
sed -i 's|^export ANNOT_OLD=.*|export ANNOT_OLD=$ROOT/work/07_postproc/261021_flaviLib_150x150|' \
  env_261117_flaviLib.sh
grep -n 'DS=\|CMS=\|ANNOT_OLD=' env_261117_flaviLib.sh    # read all three before sourcing

# 2. source the new one. Its own closing loop is the check:
#    expect "cmsearch still needed: class1b_v2_inf112.cm" and no other
source env_261117_flaviLib.sh

# 3. step 10 -- the loop skips any model whose .tbl exists, so only the new one is searched
for CM in $CMS; do
    [ -f "$TBLOUT/${CM}.tbl" ] && { echo "exists, skipping: $CM"; continue; }
    cmsearch --tblout "$TBLOUT/${CM}.tbl" --cpu 8 "$CMDIR/$CM" "$FA"
done
source env_261117_flaviLib.sh               # expect "all 7 CM .tbl present"

# 4. step 11b -- re-annotate, per condition. Writes under the NEW $DS, so 261021 is untouched.
INFERNAL_ARGS=$(for CM in $CMS; do printf -- "--infernal-tbl $TBLOUT/%s.tbl " "$CM"; done)
for COND in $CONDITIONS; do
  OUT=$POSTPROC_BASE/$COND; mkdir -p "$OUT"
  python3 $ROOT/scripts/post_process_peaks.py \
    "$PEAK_DIR/$COND/1234_peaks_combined_with_seqs.csv" \
    --out-raw "$OUT/${DS}_${COND}.peaks_annotated.csv" ... $INFERNAL_ARGS
done
```

The `...` in step 11b is deliberate: the full argument list is in
`README_261021_flaviLib_150x150.md` step 11b and must be copied from there rather than
reconstructed, since the gates (`MIN_SF`, `MAX_Q`, `MIN_REPS`) and the taxonomy inputs are passed on
the same line.

**Then, and only then**, the two column renames on the laptop — `build_pllg_outputs.py:142` and
`plot_combined_peaks.R:50` — from `CL_Class_1b_xrRNA_final.cm_hit` to `class1b_v2_inf112.cm_hit`,
plus the Part 7 recount of the no-CM pool against **7** models.

#### The step-10 `cmsearch` is NOT the `cmsearch` used in development

Step 10's search is the plain form, and it differs from every search in Parts 1–8 in two ways that
change what lands in the `.tbl`:

```bash
cmsearch --tblout "$TBLOUT/${CM}.tbl" --cpu 8 "$CMDIR/$CM" "$FA"     # step 10, deployed
cmsearch --toponly --incE 0.01 --cpu "$CPU" --tblout … "$MODEL" "$FA" # development, E1-E8
```

- **No `--toponly`.** The deployed search covers **both strands**; every development search in this
  file used `--toponly`. The library is plus-strand tiles, so minus-strand hits are artefacts, but
  they will be *present in the deployed `.tbl`* and absent from the development one.
- **Default `--incE`** (0.01), which happens to match what E8 used but not the `1e-10` of
  `cm_iterate.sh` or the `-E 100` of the reciprocal-scoring checks. A bit score quoted anywhere in
  Parts 1–8 is from a `--toponly` search and is not necessarily the row the annotation sees.

The six existing `.tbl` files were made the same plain way, so the annotation is internally
consistent; the discrepancy is only between the deployed tables and this file's development
numbers. **Do not compare them directly.** The check after step 10 is that the plus-strand included
hits agree with what E2–E8 measured:

```bash
# deployed, plus strand only -- should match the development count
awk '!/^#/ && $17=="!" && $10=="+"' "$TBLOUT/class1b_v2_inf112.cm.tbl" | wc -l
awk '!/^#/ && $17=="!"'            "${C5}_library.tbl"                 | wc -l
# and the difference, if any, should be minus-strand only:
awk '!/^#/ && $17=="!" && $10=="-"' "$TBLOUT/class1b_v2_inf112.cm.tbl"
```

#### STEP 10 RAN — and its tbl does not include the sites this deployment was for

2026-11-18, on the cluster. `$CMS` was intact (five `exists, skipping`, 1a skipped, and
`class1b_v2_inf112.cm` searched), so the apparent `SS_cons.cm`/`class4` merge was a display artefact
and the word-split check predicted that correctly. The search finished in 18.85 s CPU against 439
target sequences / 370,484 residues, reporting **165 hits, 4 of them truncated**.

**But the newly-annotated sites come back `?`, not `!`.** Bit scores match this file exactly, so the
model and the sequences are right; only inclusion differs:

| site | this file (development tbl) | deployed tbl | E-value |
|---|---|---|---|
| AB981186 | 23.4 `!` | **23.4 `?`** | 0.017 |
| NC_012671 | 23.4 `!` | **23.4 `?`** | 0.017 |
| LR694076 — CFAV xr3 | 23.4 `!` | **23.4 `?`** | 0.017 |
| MH237596 — CFAV xr3 | 23.4 `!` | **23.4 `?`** | 0.017 |
| OP860412 | 23.2 `!` | **23.2 `?`** | 0.019 |
| NC_008604 | 20.9 `?` | 20.9 `?` | 0.053 |
| NC_005064 | 18.5 `?` | 18.5 `?` | 0.16 |

Identical bits, different inclusion, because **inclusion is an E-value test and the E-value depends
on the database searched**. This is the concrete form of the warning in *The step-10 `cmsearch` is
NOT the `cmsearch` used in development*, and it is sharper than that warning implied: it is not only
that the numbers are incomparable, it is that **"10 gained, 0 lost" was measured under a threshold
the deployed search does not apply**.

#### Answered: the `inc` column is never read, and the deployed comparison is favourable

Checked 2026-11-18. **`post_process_peaks.py` does not use `!`/`?` at all.** Its parser is

```
174:  def parse_tbl(tbl_path: Path, evalue_threshold: float) -> Dict[str, List[tuple]]:
175:      ...Parse Infernal .tbl into accession -> list of (seq_from_0based, seq_to_0based, evalue)...
```

— it reads the **E-value** and applies its own `--evalue` threshold, passed at the 11b call site
(`annotate_infernal(df, infernal_tbl, evalue, downstream, min_downstream_frac)`). So `cmsearch`'s
inclusion verdict is discarded, and the `?` rows above are *not* excluded by it. The script also
emits **four diagnostic columns per tbl** plus one `any_hit` across all of them, matches the peak
accession **verbatim** against the tbl's target name, and `_tbl_stem` strips `.tbl` — which is what
makes the column `class1b_v2_inf112.cm_hit`.

And the counts in the deployed tbls are **better than the development comparison, not worse**:

| tbl | `!` | `?` | total |
|---|---|---|---|
| `CL_Class_1b_xrRNA_final.cm` | 129 | 32 | 161 |
| **`class1b_v2_inf112.cm`** | **134** | 31 | **165** |

**+5 included, +4 reported.** The 165 agrees with the search's own `Total CM hits reported: 165`, so
nothing is unaccounted for. Four of the 165 are **minus-strand**, as expected from the deployed
search having no `--toponly`.

So what decides E6 is no longer `inc`. It is these two:

1. **What `--evalue` did the 261021 run pass?** The gains sit at E 0.017–0.019. If 11b runs with an
   `--evalue` below that, they are filtered *by the script*, irrespective of `cmsearch` — and the
   same threshold was applied to the predecessor's column, so the comparison stays fair but the
   gains may not appear. Take it from the recorded invocation, not from the default:

   ```bash
   grep -n -B2 -A8 'evalue' $ROOT/scripts/post_process_peaks.py | sed -n '1,80p'
   grep -rn 'post_process_peaks' $ROOT/workflows/README_261021_flaviLib_150x150.md
   grep -rn 'evalue' $LOG 2>/dev/null | head
   ```

2. **Does the no-loss rule still hold on the *deployed* tbls?** This file's "0 lost" was measured on
   development tbls under a different threshold, so it has to be re-established here. Compare by
   **accession**, not by coordinate — the two models place their boundaries a few nt apart, so exact
   coordinate matching would invent losses, the same trap as the ±1 tolerance in `hits_at_stall`:

   ```bash
   # any accession with an included hit in the old tbl but none in the new = a real loss
   comm -23 <(awk '!/^#/ && $17=="!"{print $1}' $TBLOUT/CL_Class_1b_xrRNA_final.cm.tbl | sort -u) \
            <(awk '!/^#/ && $17=="!"{print $1}' $TBLOUT/class1b_v2_inf112.cm.tbl | sort -u)

   # per-accession counts, to catch a lost second array copy
   join -a1 -a2 -e0 -o 0,1.2,2.2 \
     <(awk '!/^#/ && $17=="!"{print $1}' $TBLOUT/CL_Class_1b_xrRNA_final.cm.tbl | sort | uniq -c | awk '{print $2,$1}' | sort) \
     <(awk '!/^#/ && $17=="!"{print $1}' $TBLOUT/class1b_v2_inf112.cm.tbl      | sort | uniq -c | awk '{print $2,$1}' | sort) \
     | awk '$2!=$3'
   ```

   The first must print nothing. The second prints the accessions whose copy count changed, which is
   where both the five gains and any loss will show.

**One caution about `--evalue` that cuts the other way.** Because the script re-thresholds on
E-value and ignores `inc`, a *loose* `--evalue` lets in rows `cmsearch` marked `?` — including the
four minus-strand hits and the long filter tail this model produces (`local CM CYK` passed 279
envelopes against an expected 0.0001). Whatever value the 261021 run used must be reused unchanged,
because it is part of what the existing annotation means; changing it would alter every one of the
seven columns and not just this one.

One more thing in the filter statistics worth noting rather than acting on: `local HMM Forward`
passed 620 windows (0.196) against an expected 0.02, and `local CM CYK` 279 (0.0426) against
0.0001 — a model of low information content letting far more through the filters than typical. That
is the same property as `eff_nseq 50.24` over 94 sequences and the 23–27 b marginal band, not a
fault, but it is why this model's hit list has a long tail.

#### The no-loss rule holds on the deployed tbls — 2026-11-18

`comm -23` on the included-accession sets printed **nothing**: no accession with an included hit in
the predecessor's tbl lacks one in the successor's. The per-accession count join shows **five
increases and no decrease**, which accounts for 129 → 134 exactly:

| accession | predecessor | successor | what it is |
|---|---|---|---|
| MH827524 — Quang Binh virus | 4 | **5** | the fifth array copy |
| NC_021069 — mosquito flavivirus | 4 | **5** | the fifth array copy |
| NC_024299 — Nienokoue virus | 4 | **5** | the fifth array copy |
| NC_027817 — Parramatta River virus | 3 | **4** | **PaRV xr4 recovered** |
| NC_027819 — MECDV | **0** | **1** | **MECDV xr1 recovered — the old model found nothing at all in this genome** |

So the deployment is net additive in the annotation itself, not only in the development comparison.
The other five sites this file counts as gains (AB981186, NC_012671, both CFAV xr3 isolates,
OP860412, at E 0.017–0.019) are `?` here and whether they annotate depends on `--evalue`, below.

#### What `post_process_peaks.py` actually does with a tbl

Read 2026-11-18, and three details matter more than the `inc` question did:

- **the script discards minus-strand hits itself** — `if strand != "+": continue` (line 192). So the
  four minus-strand hits in the deployed tbl are dropped before anything else, and the absence of
  `--toponly` in step 10 is **harmless**. That retires the concern raised under *The step-10
  `cmsearch` is NOT the `cmsearch` used in development*; what remains of that section is the
  threshold point, not the strand point.
- **the `_hit` column holds a best E-value, not a boolean** — `df[hit_col] = best_evalue`, taken as
  `min(candidates, key=lambda x: x[2])`, and `float("nan")` where there is no candidate. That is
  what Part 7's "presence taken from each `.cm_hit` column being non-NA" means.
- **each tbl produces four columns, not one**: `<stem>_hit`, `<stem>_start`, `<stem>_end`,
  `<stem>_tile_truncated`, plus one `any_hit` across all tbls. So renaming a model renames **four**
  columns. The 2026-11-17 sweep still stands, because it matched the shared stem
  `CL_Class_1b_xrRNA_final` rather than `…_hit`, and found three live consumers — but the statement
  elsewhere in this file that the rename touches "the column" should be read as four of them.

#### Does the E-value depend on which Infernal is used? — asked 2026-11-18

A fair question given how often this line has moved between 1.1.2 and 1.1.5, and the answer splits
in two.

**An E-value is computed from three things:** the bit score, the model's own stored calibration
(the `ECM` lines that `cmcalibrate` writes into the `.cm` file), and the effective size of the
database searched.

- **The calibration travels with the file.** It was written once, by `cmcalibrate` under **1.1.2**,
  and `cmsearch` reads λ and μ from the model rather than recomputing them. So the version doing the
  *search* does not re-calibrate and does not move the E-value on that account. This is the same
  reason `cmalign` to a fixed model is version-stable while `cmbuild` is not (Part 2).
- **The database size does move it**, which is why a bit score can clear a threshold against one
  FASTA and not another.
- **The version doing the *calibration* does matter**, but it is already fixed and identical for
  both models here: `CL_Class_1b_xrRNA_final.cm` and `class1b_v2_inf112.cm` were both built and
  calibrated under 1.1.2, both searched by the cluster's 1.1.5, against the same reference. **The
  comparison above is therefore controlled**, and any residual version effect is common to both
  columns.

**And it was not the E-value formula that changed, nor the library.** Measured the same day: the
development E-value is **0.0086** against the deployed **0.017** at an identical 23.4 bits —
**exactly double**, which is the signature of searching both strands instead of one. See
*RESOLVED: the `?` verdicts are the missing `--toponly`* below; the answer to the question as asked
is that the searching Infernal's version is irrelevant here and a **flag** accounts for all of it.

#### RESOLVED: the `?` verdicts are the missing `--toponly`, and nothing else — 2026-11-18

The development tbl gives AB981186 590–666 as **23.4 b, E = 0.0086, `!`**. The deployed tbl gives
the same locus as **23.4 b, E = 0.017, `?`**. Identical bit score; the E-value is **exactly
doubled**.

That is not a version effect and not a different database. An E-value scales with the effective size
of the database searched, and searching **both strands instead of one doubles it**. The development
searches used `--toponly`; step 10 does not. With the default `--incE 0.01`:

- development: 0.0086 < 0.01 → `!`
- deployed: 0.017 > 0.01 → `?`

Every other site behaves the same way, which confirms the factor rather than assuming it:

| site | bits | deployed E | implied development E | verdict either side |
|---|---|---|---|---|
| AB981186 | 23.4 | 0.017 | 0.0086 **(measured)** | `!` → `?` |
| OP860412 | 23.2 | 0.019 | ≈0.0095 | `!` → `?` |
| NC_008604 | 20.9 | 0.053 | ≈0.027 | `?` → `?` |
| NC_005064 | 18.5 | 0.16 | ≈0.08 | `?` → `?` |

So the five sites that flipped are precisely those whose development E-value fell between 0.005 and
0.01, where doubling crosses the threshold. The two that were already `?` stay `?`. **Nothing about
the model, the sequences, the statistics or the Infernal versions changed.** The answer to "does the
E-value depend on which Infernal is used?" is no — it depended on `--toponly`, which is a flag.

And because `post_process_peaks.py` **discards minus-strand hits itself**, the strand doubling
inflates every E-value in every deployed tbl by 2 while contributing no usable hits. That is a
property of the existing annotation, not something introduced here: all six predecessor tbls were
made the same plain way, so the factor is uniform across all seven columns and the comparison
between them is unaffected.

#### The 11b invocation passes no `--evalue`, so the script's default decides

From `README_261021_flaviLib_150x150.md` step 11b (2026-10-21 21:06, `$LOG/step11b_annotate.txt`):

```bash
INFERNAL_ARGS=$(for CM in $CMS; do printf -- "--infernal-tbl $TBLOUT/%s.tbl " "$CM"; done)
for MG in $CONDITIONS; do
    OUT=$POSTPROC_BASE/$MG; mkdir -p $OUT
    python3 $ROOT/scripts/post_process_peaks.py \
        "$PEAK_DIR/$MG/1234_peaks_combined_with_seqs.csv" \
        --out-raw       "$OUT/${DS}_${MG}.peaks_annotated.csv" \
        --out-collapsed "$OUT/${DS}_${MG}.peaks_per_accession.csv" \
        --family-csv    "$FAMILY_CSV" \
        $INFERNAL_ARGS
done
```

There is **no `--evalue`**, so the script's own default — **0.01**, read 2026-11-18 — is what
produced the existing annotation, and reusing the invocation verbatim reuses it. That threshold is
the same one `cmsearch`'s `!` corresponds to, which is why the 129/134 comparison above is already
the right comparison: **+5, nothing lost**, applied identically to both columns.

#### `--evalue` default is 0.01, so the five doubled sites are filtered out — and `--toponly` is the right fix, but not here

Read 2026-11-18:

```
evalue: float = typer.Option(0.01, "--evalue", help="Infernal E-value threshold (default 0.001).")
downstream: int = typer.Option(20, "--downstream", ...)
min_downstream_frac: float = typer.Option(0.5, "--min-downstream-frac", ...)
```

**The default is `0.01`; the help text says `0.001`.** The two disagree by 10×, and only the first
is behaviour — `typer.Option(0.01, …)` is what runs, a help string is text. Which was *intended* is
not readable from here, and it was wrong to call it simply an error: noting the direction settles
one reading but not the other.

- **`0.001` is the *stricter* value, and it is the one in the help.** So the mismatch is not the
  script quietly being more conservative than documented; the behaviour is **more permissive** than
  the documentation promises. A stringency rationale would require the code to say 0.001.
- **`0.01` is Infernal's own default `--incE`**, which makes the script's filter agree exactly with
  the `!` column in every tbl. That coherence is a real argument that 0.01 is the operative policy
  and the help string is stale — probably left behind when the default was loosened.

Either way the operative number is **0.01**, and that is what produced the 261021 annotation and
what will produce 261117. But the reading matters for one thing: **if 0.001 was the intended policy,
the annotation has been running looser than intended since 261021**, and every hit between 0.001
and 0.01 in all seven columns is in question. That is quantifiable now, and worth knowing before
anyone "fixes" the help string in the wrong direction:

```bash
for CM in $CMS; do
  a=$(awk '!/^#/ && $10=="+" && $16+0<=0.01'  $TBLOUT/$CM.tbl | wc -l)
  b=$(awk '!/^#/ && $10=="+" && $16+0<=0.001' $TBLOUT/$CM.tbl | wc -l)
  printf '%-56s  0.01:%4s   0.001:%4s   %4s ride on the threshold\n' "$CM" "$a" "$b" "$((a-b))"
done
```

**And for this deployment it is not cosmetic at all.** The five gains sit at exactly the E-values
the two thresholds disagree about:

| gain | bits | E | survives 0.01 | survives 0.001 |
|---|---|---|---|---|
| NC_024299 — Nienokoue virus | 30.1 | 0.00079 | yes | **yes** |
| NC_027817 — **PaRV xr4** | 28.3 | 0.0018 | yes | **no** |
| NC_027819 — **MECDV xr1** | 27.7 | 0.0023 | yes | **no** |
| MH827524 — Quang Binh virus | 26.6 | 0.0038 | yes | **no** |
| NC_021069 — mosquito flavivirus | 24.9 | 0.0084 | yes | **no** |

**At 0.001, four of the five gains vanish — including both recoveries.** So the deployment's entire
benefit rests on the operative threshold being 0.01, which it is. The five *doubled* sites at
0.017–0.019 fail both thresholds and are unaffected by this question.

That makes the discrepancy worth settling properly rather than by editing a help string. The
command above quantifies it across all seven columns; if the intended policy were ever 0.001, this
deployment would need re-arguing from scratch, and so would the predecessor's 129 hits.

At 0.01, the five sites whose E-value doubled past the threshold — AB981186, NC_012671, both CFAV
xr3 isolates, OP860412 — **do not annotate**. The five that do are the ones the per-accession join
already found: MH827524, NC_021069, NC_024299, **NC_027817 (PaRV xr4)** and **NC_027819 (MECDV
xr1)**. Note also that two further per-peak filters apply after the E-value one — `--downstream 20`
and `--min-downstream-frac 0.5` — so the tbl counts are an **upper bound** on what annotates.

**The question was asked the right way round: since the script throws minus-strand hits away, what
is the doubling buying?** Nothing. `--toponly` would give identical hits with E-values halved, and
five genuine recoveries — including both CFAV xr3 isolates — would stop being lost to an artefact.
So `--toponly` is not a preference, it is a correction.

**But it must not be applied to this model alone.** All six predecessor tbls were searched without
`--toponly`, so their E-values carry the same 2× inflation. Re-searching only
`class1b_v2_inf112.cm` with `--toponly` would put one column on a 1× scale and six on a 2× scale
while a single `--evalue 0.01` is applied to all seven — which silently makes the threshold twice as
permissive for Class_1b as for every other class. That is worse than the artefact it fixes.

So there are three options and only two are coherent:

| | what it does | cost |
|---|---|---|
| **A. deploy as scoped** | both-strand E-values, consistent with the six existing columns and with the 261021 annotation | the five doubled sites do not annotate; the other five recoveries do |
| **B. re-search all seven with `--toponly`** | every column on a correct 1× scale; the ten gains likely all appear | **changes all seven columns**, so Part 7's counts, the no-CM pool and every figure shift — far beyond E6's scope |
| ~~C. re-search Class_1b only~~ | — | incoherent, as above |

**Decision: A now, B as its own step.** Not because B is wrong — it is right, and it is cheap
(seven searches at ~19 s each) — but because the 2× inflation is a **pre-existing, systematic
property of all seven columns**, not a Class_1b matter. Rolling it into E6 would make it impossible
to attribute any difference in the 261117 output to either change: E6 swaps one model, B re-scales
every E-value in the annotation. The no-loss rule has been applied one change at a time throughout
this file for exactly this reason.

B is therefore recorded as a new step with its own `$DS`, and it inherits two things from this
work: the strand filter in `post_process_peaks.py` is what makes `--toponly` strictly correct, and
the measured factor is exactly 2, so the effect on every existing column is predictable before
running anything:

```bash
# how many hits each of the seven columns would gain, with no re-search needed:
# halve the E-value and re-apply the 0.01 threshold
for CM in $CMS; do
  n0=$(awk '!/^#/ && $10=="+" && $16+0<=0.01'  $TBLOUT/$CM.tbl | wc -l)
  n1=$(awk '!/^#/ && $10=="+" && $16/2<=0.01'  $TBLOUT/$CM.tbl | wc -l)
  printf '%-56s %4s -> %4s  (+%s)\n' "$CM" "$n0" "$n1" "$((n1-n0))"
done
```

That costs nothing, needs no cluster time, and quantifies B before it is committed to. If the gain
across the other six is negligible, B is a small correction; if it is large, B is a finding about
the whole annotation and belongs in Part 7 rather than here.

#### Threshold exposure across the seven columns, and why only Class_1b has any — 2026-11-18

Plus-strand hits at each threshold, measured on the deployed tbls:

| model | E ≤ 0.01 | E ≤ 0.001 | ride on the threshold |
|---|---:|---:|---:|
| `CL_Class_1a_xrRNA_final.cm` | 84 | 84 | **0** |
| **`class1b_v2_inf112.cm`** | **134** | **118** | **16** |
| `CL_Class_2_xrRNA_final.cm` | 39 | 39 | **0** |
| `cl3_NAR_2025.…SS_cons.cm` | 5 | 5 | **0** |
| `class4_cl4_v9_20260824.cm` | **0** | **0** | 0 |
| `class1c.cm` | 46 | 46 | **0** |
| `dumbbell_RF00525.cm` | 91 | 89 | **2** |

Two things fall out of this table.

**Class_1b is the only class with a marginal population at all.** Every other class is a clean
step function — its hits are either strongly significant or absent, and a tenfold change in
threshold moves nothing. Class_1b has **16 of 134 hits** in the decade between 0.001 and 0.01, and
`dumbbell` has 2. That is the same property as `eff_nseq 50.24` over 94 sequences, the 23–27 b
marginal band, and the long filter tail (`local CM CYK` 279 envelopes against an expected 0.0001):
**this model is broad, and breadth is what the whole E2/E8 argument has been about.** It also means
the permissive threshold is doing real work *only* for Class_1b — which makes it a Class_1b policy
question rather than a pipeline-wide one.

**`class4_cl4_v9_20260824.cm` annotates nothing** — zero hits at either threshold, so the
`class4_cl4_v9_20260824.cm_hit` column is entirely NaN. **This is correct and expected**: class 4 is
not a flaviviral element, so in a flavivirus library it is a **negative control**. See *Retracted:
class 4's zero count is a negative control passing* below — calling it something to confirm was a
mistake, and its zero at the permissive threshold is evidence that 0.01 is not manufacturing
cross-family hits.

#### The collision question, which the permissiveness makes real

Being permissive is defensible for an expansion, but it raises exactly the risk noted: **a broad
Class_1b can claim sites that belong to another class.** Part 6 records the resolution rule — Rfam
clan competition resolves overlaps by **lower E-value, not raw bits** — so a collision is not
decided by which model looks stronger in bits but by which has the better E, and Class_1b's 16
marginal hits are the ones most likely to lose such a contest or to win one they should not.

This is checkable on the deployed tbls with no re-search, by looking for loci where Class_1b and
another model both report a plus-strand hit:

```bash
# every plus-strand hit from all seven, as model + target + span
for CM in $CMS; do
  awk -v m="$CM" '!/^#/ && $10=="+" && $16+0<=0.01 {print m"\t"$1"\t"$8"\t"$9"\t"$16}' $TBLOUT/$CM.tbl
done > /tmp/all_hits.tsv
wc -l /tmp/all_hits.tsv

# targets where more than one model reports a hit
cut -f2 /tmp/all_hits.tsv | sort | uniq -c | awk '$1>1{print $2}' > /tmp/multi.txt
wc -l /tmp/multi.txt

# of those, the ones involving class1b_v2, with every competing model's E beside it
grep -Ff /tmp/multi.txt /tmp/all_hits.tsv | sort -k2,2 -k3,3n \
  | awk -F'\t' '{printf "%-24s %-34s %7s-%-7s %10s\n", $2, $1, $3, $4, $5}' \
  | head -60
```

A shared *target* is not yet a collision — the library sequences are whole 3′UTRs and an array can
carry a Class_1a copy and a Class_1b copy legitimately, which is the whole satellite finding. A
collision is an **overlapping span** at the same locus. So the rows to read are those where two
models' `$8–$9` intervals intersect, and the rule then says the lower E takes it.

**This belongs after 11b, not before.** The annotation is what the collision matters for: Part 7's
`any_hit` and the per-class columns are where a mis-assigned site actually shows up, and the
collapsed per-accession output is the natural place to see it. Running 11b first also means the
comparison can be made against the 261021 annotation, where the predecessor's narrower column was
in the same contest.

#### Retracted: class 4's zero count is a negative control passing, not a problem

Noted 2026-11-18. `class4_cl4_v9_20260824.cm` returning **0 hits in flaviLib at either threshold is
the correct result**, not something to confirm or worry about: class 4 is not a flaviviral element,
so in a flavivirus library it functions as a built-in **negative control**. Treating a correct
result as a possible fault was the error.

It is also *informative* in a way that bears directly on the threshold question. If `--evalue 0.01`
were too permissive, the class with no true positives in this library is where spurious hits would
appear first. It reports **zero at 0.01, not merely few** — so the permissive threshold is not
manufacturing cross-family hits, and that is evidence *for* 0.01 rather than against it. The
specificity check and the sensitivity argument point the same way.

#### What happened to the xr3 / xr4 elements in the deployed annotation

Asked 2026-11-18, and this is the sharpest version of what the strand doubling costs. All eleven
sites, with the deployed E-value and the E-value the same hit would have under `--toponly` (exactly
half, measured):

| site | element | bits | deployed E | annotates at 0.01 | with `--toponly` |
|---|---|---|---|---|---|
| NC_024299.2 10746 | fifth copy, Nienokoue virus | 30.1 | 0.00079 | **yes** | yes |
| NC_027817.1 10756 | **PaRV xr4** | 28.3 | 0.0018 | **yes** | yes |
| NC_027819.1 | **MECDV xr1** | 27.7 | 0.0023 | **yes** | yes |
| MH827524.1 10760 | fifth copy, Quang Binh virus | 26.6 | 0.0038 | **yes** | yes |
| NC_021069.1 10737 | fifth copy, mosquito flavivirus | 24.9 | 0.0084 | **yes** | yes |
| AB981186.1 10733 | fifth copy, mosquito flavivirus | 23.4 | 0.017 | no | **yes** (0.0086) |
| NC_012671.1 10736 | fifth copy, Quang Binh virus | 23.4 | 0.017 | no | **yes** (0.0086) |
| **LR694076.1 10565** | **CFAV xr3** | 23.4 | 0.017 | **no** | **yes** (0.0086) |
| **MH237596.1 10555** | **CFAV xr3** | 23.4 | 0.017 | **no** | **yes** (0.0086) |
| OP860412.1 | — | 23.2 | 0.019 | no | **yes** (0.0095) |
| NC_008604.2 10709 | fifth copy, Culex flavivirus | 20.9 | 0.053 | no | no (0.027) |

**PaRV xr4 and MECDV xr1 annotate. Both CFAV xr3 isolates do not** — and they fail by a factor of
two on a flag, not on their merits. AEFV xr3 (NC_012932) is separately out of reach at 13.2 b.

That is not a tolerable place to leave it. **CFAV xr3 is the published type example of this
element** — PMC7527734's P1-deviant downstream copy, the thing the whole positional argument of E8
rests on — and `CFAV_NC_001564-2_10555-10632_xr3` is a named sequence of the *provided* Class_1b
seed. A deployment whose stated purpose includes recovering it, that then fails to annotate it
because both strands were searched, has not done the job.

So: **5 of 11 annotate now; 10 of 11 would under `--toponly`.**

#### Revised: do the `--toponly` search first, into a separate `$TBLOUT`, and run 11b once

This supersedes the earlier "deploy as scoped now, `--toponly` as its own step" decision. The
reasoning for separating them was attribution — not being able to tell which change caused which
difference in the output. **That concern is already satisfied without running 11b twice, because the
`.tbl` files are the evidence and both sets can be kept.** Writing the `--toponly` searches to a new
directory preserves the both-strand tbls, so the two changes stay separately quantifiable from the
tbls while the annotation is produced once:

```bash
source $ROOT/scripts/env_261117_flaviLib.sh
TBL2=$ROOT/work/06_infernal/260807_trueRef_toponly
mkdir -p "$TBL2"

for CM in $CMS; do
  [ -f "$TBL2/${CM}.tbl" ] && { echo "exists, skipping: $CM"; continue; }
  echo "searching (toponly): $CM"
  cmsearch --toponly --tblout "$TBL2/${CM}.tbl" --cpu 8 "$CMDIR/$CM" "$FA"
done

# quantify both changes from the tbls alone
for CM in $CMS; do
  a=$(awk '!/^#/ && $10=="+" && $16+0<=0.01' $TBLOUT/$CM.tbl | wc -l)
  b=$(awk '!/^#/ && $10=="+" && $16+0<=0.01' "$TBL2/$CM.tbl" | wc -l)
  printf '%-56s  both:%4s  toponly:%4s  (+%s)\n' "$CM" "$a" "$b" "$((b-a))"
done
```

**RESULT, 2026-11-18 14:53:**

| model | both strands | `--toponly` | gain |
|---|---:|---:|---:|
| `CL_Class_1a_xrRNA_final.cm` | 84 | 84 | 0 |
| **`class1b_v2_inf112.cm`** | 134 | **139** | **+5** |
| `CL_Class_2_xrRNA_final.cm` | 39 | 39 | 0 |
| `cl3_NAR_2025.…SS_cons.cm` | 5 | 5 | 0 |
| `class4_cl4_v9_20260824.cm` | 0 | 0 | 0 |
| **`class1c.cm`** | 46 | **47** | **+1** |
| `dumbbell_RF00525.cm` | 91 | 91 | 0 |

**Class_1b gains exactly the predicted five.** The halving of the effective database size is
confirmed directly in the search statistics: 185,242 residues searched against 370,484 both-strand —
exactly half, which is the mechanism rather than an inference about it.

**`class1c` gained one, and `dumbbell` gained none** — the opposite of the guess made here from the
exposure table, and the discrepancy is instructive rather than contradictory. The exposure table
counted hits between **0.001 and 0.01**; this gain counts hits between **0.01 and 0.02**, where
halving crosses the threshold. They are different bands, so `dumbbell`'s 2 marginal hits sat in the
first and none in the second, while `class1c`'s sat the other way round. **A marginal population in
one decade says nothing about the next.**

The `class1c` +1 is small but not ignorable, because `class1c` is the nearest neighbour Class_1b was
tested against (E7's guided-seed scores of 1.55 / 1.33 / −2.14 bits) — so a site newly claimed by
both is precisely the collision case. Identify it before 11b:

```bash
# which site class1c gained
comm -13 <(awk '!/^#/ && $10=="+" && $16+0<=0.01 {print $1"\t"$8"\t"$9}' $TBLOUT/class1c.cm.tbl | sort) \
         <(awk '!/^#/ && $10=="+" && $16+0<=0.01 {print $1"\t"$8"\t"$9}' "$TBL2/class1c.cm.tbl" | sort)

# and the five Class_1b gained, to confirm they are the expected ones
comm -13 <(awk '!/^#/ && $10=="+" && $16+0<=0.01 {print $1"\t"$8"\t"$9}' $TBLOUT/class1b_v2_inf112.cm.tbl | sort) \
         <(awk '!/^#/ && $10=="+" && $16+0<=0.01 {print $1"\t"$8"\t"$9}' "$TBL2/class1b_v2_inf112.cm.tbl" | sort)
```

**RESULT.** Class_1b gained **exactly the five predicted** — `AB981186.1` 590–666, `NC_012671.1`
545–621, `OP860412.1` 297–372, and **both CFAV xr3 isolates**, `LR694076.1` 476–553 and
`MH237596.1` 478–555. The `--toponly` correction did what it was meant to and nothing else.

`class1c` gained **one**: `KY370101.1|12448-13220_inferred_3UTR` 361–453, which is genomic
**12808–12900** — and that is a site this file already tracks. Part 5 records
**`KY370101 12807 | 1 site, SF 0.924 | sub-threshold class1c (14.9 b); class1c question closed |
stays open as a site; inside the PLPV pool`**.

Two things follow, and they do not conflict:

- **The 10-30 class1c decision stands.** That decision was whether to add KY370101 to the class1c
  *seed* — a model-building question — and it was closed with no variant accepted because the gains
  did not reach E 1e-10. Whether the *existing* class1c model annotates the site is a different
  question, which is why Part 5 wrote "class1c question closed | **stays open as a site**".
  `--toponly` answers that second question: at the halved E-value it now does.
- **It is a collision candidate, and a documented one.** E5 placed the node at 12807 in **frozen
  cluster 131 — a main Class_1b cluster** — with `cls` of `None found`. So the clustering calls the
  site Class_1b-like while the only CM that reaches it is class1c, weakly. KY370101 is
  *Pestivirus Q*, one of the thirteen non-*Flavivirus* genomes this file had never discussed, so the
  site sits in the PLPV pool rather than in the ISF story.

The clan rule resolves overlaps by **lower E-value, not raw bits**, so this is decided by reading
both models at that locus:

```bash
for CM in $CMS; do
  awk -v m="$CM" '!/^#/ && $1 ~ /^KY370101/ && $10=="+" {
     printf "%-56s %6s-%-6s %7s %10s %s\n", m, $8, $9, $15, $16, $17 }' "$TBL2/$CM.tbl"
done
```

**RESULT: there is no collision.** The two hits are 82 nt apart and do not overlap:

| model | rel span | genomic | bits | E | |
|---|---|---|---|---|---|
| `class1b_v2_inf112.cm` | 173–279 | **12620–12726** | 42.5 | 1.3e-06 | `!` |
| `class1c.cm` | 361–453 | **12808–12900** | 14.9 | 0.0082 | `!` |

So the clan rule has nothing to resolve: the two models annotate **two different copies** of the
same array. Converted through the sequence name's offset, they are E5's own nodes —
`class1b_v2` takes **12621** (fz 131, `cls 1b`) and `class1c` takes **12807** (fz 131,
`cls None found`), the two copies E8's view 1 listed for KY370101 alongside a third at 13029 that is
unclustered and that E8 flagged as *3′-most copy is UNCLUSTERED — still a candidate*.

**E6 is clear to proceed**, and the permissiveness worry does not materialise here: the one site the
looser threshold added is a locus no other model contests.

One observation to carry forward rather than act on now, because it is about the clustering and not
about this deployment: **both copies sit in frozen cluster 131**, yet one is strong Class_1b
(42.5 b) and the other is reached only weakly, and by a different class (14.9 b class1c). A single
frozen cluster containing two copies from one genome that get different class calls is the same
shape as the satellite finding — a main-cluster copy and a deviant one — but in *Pestivirus Q*
rather than in an ISF. It belongs with the PLPV pool and the thirteen non-*Flavivirus* genomes, not
with E7.

Then point the 11b loop at whichever directory is chosen by setting `TBLOUT` before building
`INFERNAL_ARGS`, and record the choice in MANIFEST. Both `.tbl` sets are kept either way, so this
decision is reversible without re-searching anything.

**The predecessor must be searched the same way for the comparison to mean anything.** It is not in
`$CMS` any more, so the loop above will not touch it; search it into `$TBL2` by hand if the
old-versus-new comparison is to be redone on the `--toponly` footing:

```bash
cmsearch --toponly --tblout "$TBL2/CL_Class_1b_xrRNA_final.cm.tbl" --cpu 8 \
  "$CMDIR/CL_Class_1b_xrRNA_final.cm" "$FA"
```

#### The three follow-ups, and why they are not written as commands here

After step 11b, three things remain, and none is a command this file should invent:

1. **Collapse peaks across overlapping tiles** at the same stall position per accession — 56 % of
   no-hit rows at 10 mM are tile duplicates. Tiles are 196 nt at a 20 nt step here, so neighbours
   overlap by 176 nt and one stall appears many times. The procedure is specified in `flaviLib.md`,
   not here.
2. **Recount the no-CM pool** per Part 7 and compare against its recorded counts — against **7**
   models, the successor replacing Class_1b rather than joining it.
3. **Step 11b's full argument list** has elided arguments in the source document
   (`--out-raw … ...`), and the gates (`MIN_SF`, `MAX_Q`, `MIN_REPS`) and taxonomy inputs ride on
   the same line. Copy it from `README_261021_flaviLib_150x150.md` step 11b rather than taking a
   reconstruction from me.

```bash
clog class1b "E6 deploy: class1b_v2_inf112 replaces CL_Class_1b_xrRNA_final" \
  "<7 models; the 10 sites now annotated; new no-CM count vs Part 7>"
```

**Two things to record at E6**, both measured 2026-11-17: seven of the ten cluster-5 sites are
marginal (23.4–27.7 b) and will not survive any later model revision; and four rows of
`class1b_groups.tsv` carry an unresolved group that must not be joined into the annotation yet.

### E2 result: Class_1b is saturated, and the cluster-5 merge is fragile — 2026-11-17

Both variants rebuilt on the cluster-5 seed and compared per hit against `${C5}_library.tbl`:

| | nseq | eff_nseq | clen/bps/bifs | matched | lost | gained | lower | worst |
|---|---|---|---|---|---|---|---|---|
| cluster-5 baseline | 94 | 50.24 | 81/19/2 | — | — | — | — | — |
| `strong` (+38) | 132 | **25.58** | 81/19/2 | 130 | **9** | 2 | 55 | −6.20 |
| `newvirus` (+34) | 128 | **25.64** | 81/19/2 | 130 | **9** | 1 | 56 | −6.00 |

**Both rejected.** And the decisive argument is not the loss count but what the gains are worth:
**the 68 novel hits were already found by the baseline model** — that is what "68 library hits not
in its seed" means — so moving them into the seed buys no annotation at all. The only true gains are
the sites the baseline does *not* find: `OM030319 57` at 31.5 b and, in `strong` only,
`MN587651 70` at 24.4 b. So the trade is **+2 sites against −9, i.e. net −7 annotated sites in
exchange for nothing**, and that holds however the AB021287 filter question is decided.

#### The nine lost are the nine weakest, and seven of them are cluster 5's own

Identical list in both variants, with baseline bit scores 23.4–27.8 — the marginal band:

| lost site | genomic | bits | cluster 5's own gain? |
|---|---|---|---|
| AB021287 65 | 8932 | 27.8 | no (the E1 site) |
| NC_027819 561 | 10810 | 27.7 | **yes** (MECDV xr1, recovered locus) |
| MH827524 595 | 10760 | 26.6 | **yes** |
| MH307700 124 | 11357 | 26.6 | no |
| NC_021069 597 | 10737 | 24.9 | **yes** |
| AB981186 590 | 10733 | 23.4 | **yes** |
| NC_012671 545 | 10736 | 23.4 | **yes** (the no-explorer-node site) |
| LR694076 476 | 10565 | 23.4 | **yes** (CFAV xr3) |
| MH237596 478 | 10555 | 23.4 | **yes** (CFAV xr3, 2nd isolate) |

Seven of cluster 5's ten gains; only NC_008604 10707, NC_024299 10747 and NC_027817 10757 survive.
**The cluster-5 merge is therefore fragile**: the sites it added sit at the inclusion threshold, so
they are the first casualties of any further broadening. That is worth recording before E6, because
it means those seven annotations will not survive a future model revision, whatever that revision is.

#### The mechanism: a relative-entropy ceiling, not a structural problem

The added sequences are **not** bad. They align full length at PP 0.74–0.93, most at `1-81` with no
truncation, at 23–46 b. They are Class_1b elements. What fails is capacity:

| model | nseq | eff_nseq |
|---|---|---|
| baseline | 94 | 50.24 |
| +3 (cluster 106) | 97 | **71.32** — three *divergent* sequences, so weighting rises |
| +34 (newvirus) | 128 | **25.64** — many *similar* sequences, so weighting falls |
| +38 (strong) | 132 | **25.58** |

With `relent` fixed at 0.700, `cmbuild` down-weights harder as similar sequences accumulate, the
emission distributions flatten, and every score falls — `lower_bits` 55 of 130 matched, worst −6.2.
The marginal hits then drop below `incE 0.01`. This is the entropy-weighting reading already
recorded on 2026-10-30, now measured in both directions: divergent additions raise `eff_nseq`,
similar additions lower it, and **either way the marginal band is lost.**

So **library-internal Class_1b expansion is closed**, now demonstrated three independent ways on
the same baseline — `+3 divergent` (19 lost), `+38 similar` (9 lost), `+34 similar` (9 lost) — each
losing the same marginal set. E1 reopened the question on a technicality and E2 has closed it on the
substance. Nothing in this library adds to Class_1b. The only remaining route for this model is a
wider target, which is E7's business.

One parameter was *not* varied and should be named rather than quietly ignored: `--ere`. Raising the
target relative entropy would keep the model sharper and might retain the marginal sites while
absorbing new sequences. It is a legitimate Infernal option, but changing it breaks the
like-for-like comparison the no-loss rule depends on, and tuning it to rescue a particular result is
not a measurement. If it is ever tried, it must be a declared modelling decision applied to the
baseline as well, with both models re-searched.

#### E3 answered, E4 half answered, E5 blocked — 2026-11-17

**E3: done.** Ten `NEW` rows, `OP860412 297` among them, and NC_008604 10707 is not a gain. Full
accounting in B1's count-conflict note above.

**E4 `pp_check`: done, and it answers the cluster-5 question.** All six added cluster-5 sequences
align with **no insertions** at the triple columns and PP of 0.85 to >0.95 there:

| sequence | cm 7 | cm 29 | cm 43 | PP at the three |
|---|---|---|---|---|
| MH827524 594-673 | C | G | C | 9/*/* |
| NC_021069 596-675 | C | G | C | */*/* |
| AB981186 589-668 | C | G | C | */*/* |
| NC_012671 544-623 | C | G | C | */*/* |
| NC_008604 576-654 | C | G | C | 9/*/* |
| NC_024299 629-709 | C | G | C | */*/* |

(`*` = PP > 0.95, `9` = 0.85–0.95.) **Every cluster-5 addition carries the Class_1b triple C…G-C at
high posterior probability.** That is the single cleanest piece of evidence in this file that cluster
5 belongs inside Class_1b, and it stands in direct contrast to cluster 106's U…A-U. It also
retrospectively validates the cluster-5 merge: the sites were accepted on a no-loss rule, and they
turn out to share the class's defining tertiary feature.

**E4 `insertcheck`: done, and it passes.** `cm_round_stats.py fetch` returned 139 included library
sites; aligned to the cluster-5 model, the result is:

```
cm  7: 0 insert column(s) before it, occupied in 0/139 sequences
cm 29: 0 insert column(s) before it, occupied in 0/139 sequences
cm 43: 0 insert column(s) before it, occupied in 0/139 sequences
```

**No insert columns exist beside any of the three triple columns at all**, so no included site needs
one. The seed-shift question answered on 2026-11-03 — should the seed be shifted so the triple
aligns? no — is now confirmed from the other direction: the seed does not misdescribe the family
there, and **nothing has to be re-compared before E6.** This was the last step that could have moved
the model's columns.

Taken with `pp_check`, E4 is complete: the triple columns are correctly placed, unoccupied by
inserts across 139 sites, and read at PP 0.85–>0.95 in all six added sequences.

**E5: resolved, and it should never have been blocked.** `DATA` has 416 `nodes` carrying
`acc, cls, conc, det, e1c, ev, fam, genus, id, q, seq, sf, sp, xr` — and **no `fz`.** The per-site
cluster assignment lives in `DATA.sets`: six saved clusterings, each
`{view, mode, date, cl, clusters, inmsa}`, where **`cl` is a list of ints parallel to `DATA.nodes`**
(−1 = unassigned). The frozen clustering of 2026-10-28 is one of those six; the `mode: "default"`
entries hold a much coarser cut (cluster ids in the low teens), the frozen one the ids this file
uses (5, 21, 106, 131, 133, 135, …).

**This was already documented, and a working parser already existed.** Part 3 states it plainly:
"`explorer_cm_scan.py extract` parses the explorer's embedded `const DATA = {...};` line as JSON.
Each node gives the feature ID, the stall … and the frozen cluster `fz`." `fz` is a field that
script *derives* — it is what produced the memberships recorded in Part 3 (cluster 41 12/12, 44 8/8,
5 5/5, 106 3/3, 39 4/4, 110 3/3). Writing a second parser that guessed at raw field names was the
error; the rule in Part 8 about reusing the existing scripts exists for exactly this.

`e5` now runs `explorer_cm_scan.py extract` and reads its node table, falling back to `DATA.sets`
only if no table is written. The fallback selects the set by **name** (`mode` containing `frozen`,
`view` of `all`), prints which one it chose and why, and `--list-sets` prints all six with their
cluster counts so the choice can be checked before the numbers are trusted — picking the wrong set
would silently give the wrong clusters.

```bash
bash $FLAVISCRIPTS/cm_class1b_E.sh e5
# or, to see the six clusterings first:
python3 $FLAVISCRIPTS/explorer_class1b_clusters.py --list-sets "$EXPLORER"
```

**E5 does not block the model.** It fills `frozen_cluster` for four B1 rows and decides which
clusters are the main Class_1b ones, i.e. the `core` vs `transition:<cluster>` labels. The model
itself, the new `cm_set`, the re-annotation and the recount can all proceed; `class1b_groups.tsv`
is then completed when E5 resolves. Splitting E6 that way is better than holding a deployment that
fixes a gap list currently wrong by 10.


## Where each workstream stands

| # | workstream | dates | question | outcome | status |
|---|---|---|---|---|---|
| 1 | class1c: another cmalign round + library search | 10-28 – 10-29 | would realigning class1c's library hits and searching again add anything? | No. Its 46 included library hits are its own 46 seed sequences; the realignment round was already done one model earlier (`pesti_short1b`). Part 5 | **closed** — only an RNAvirus-database search could add sequences |
| 2 | class1c: borderline hits (step 17) | 10-29 – 10-30 | add KY370101, ON949931 or NC_025677 to class1c? | No variant accepted: gains do not reach E 1e-10, and the broadened models reach Class_1b sites, where Class_1b wins every time. Part 5 | **closed** |
| 3 | merge class1b and class1c? | 10-29 – 10-30 | one model or two? | Two. class1c had the lower E-value at none of its 16 overlaps with Class_1b (1, 4 and 11 across the three class1c models tested). Overlaps are resolved per site by lower E-value. Part 6 | **closed** |
| 4 | Class_1b expansion | 10-30 | Class_1b has 68 library hits not in its seed; add them? | Every rebuild loses at least one existing hit (AB021287). The original model was built with Infernal 1.1.2, which changed how comparisons must be made. Part 6 | **closed 11-17** — E1 showed AB021287's loss is a filter artefact (30.0/30.2 b under `--max`), which reopened it; E2 then rejected `strong` and `newvirus` on the cluster-5 baseline, each losing the same 9 marginal hits for +2/+1 gains. Library-internal expansion is saturated. Part 1, "E2 result" |
| 5 | explorer scan with the missing models | 10-29 | how many explorer "None found" sites are already class1c / cl3? | 45 class1c, 3 cl3 (loquat, cluster 110). 163 no-CM sites remain; 6 no-CM clusters of ≥ 3 sites. Part 3 | **done** |
| 6 | **gap filling: FJIS clusters 5 and 106** | 10-30 – 11-02 | new candidate | **`cand_FJIS_261029`**: pooled cluster 5 + cluster 106, 80-nt windows, MATER edit (2 pseudoknots). Covariation gate passed (4 covarying vs 0.2 expected); separate from class1c and Class_1b site by site; saturated on library and RNAvirus DB. Part 3. **11-02/03: split.** Cluster 5 (+ NC_012671) joined Class_1b as `class1b_plusFJIS_cluster5_inf112` (0 lost, 10 gained); further additions rejected. **11-17:** E2b rejected cluster 106 on the cluster-5 baseline (19 lost, not recruited at its stalls), and `pp_check` showed all six cluster-5 additions carry the Class_1b C…G-C triple while cluster 106 carries U…A-U | **cluster 5 closed** (`transition:5`, inside Class_1b; not yet deployed); **cluster 106 closed as a Class_1b member, open as its own element** (Part 1; Track B model built, gated on E7) |
| 7 | **gap filling: FJJI 41 / 44, HPPV 39, FJTB 64, PLLG 117** | 11-02 | new candidates | FJJI aligned: two separate elements; cluster 41 stalls at 10 mM only. Others not aligned | **in progress** — FJJI MATER |
| 8 | earlier candidates `cand_FJTB_261026`, `cand_PLLG_260915` | 09-15 – 10-27 | | built; blocked on sequence diversity; RNAvirus-database searches started 10-27, results not recorded | **results pending** |
| 9 | Mifsud-clade pools beyond the explorer clusters | 10-28 | | pool queue ranked (Part 3); pool FASTAs not built | **queued** |

## Next steps, in order — 2026-11-02, superseded by "Next priority" (2026-11-16) in Part 1

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

**RULE, stated here because it was already documented on 2026-10-30 and still got violated on
2026-11-16: the Infernal version of a model is a property of the model, read from its header, not
a property of the shell.** Every Class_1b-line model descends from a provided 1.1.2 build, so every
`cmalign`, `cmbuild`, `cmcalibrate` and `cmstat` in that line runs under 1.1.2 — not because 1.1.2
was chosen, but because the ancestor was built that way and a rebuild under another version is a
different model. `cmsearch` is the exception the earlier work relied on deliberately: searching a
1.1.2 model with 1.1.5 is fine and is what the comparisons used.

This is now enforced rather than written down. `flavi_env.sh` provides `cm_version <model.cm>`,
which reads the builder version out of the header line, and `cm_env_for` / `cm_env_require`, which
map it to the conda env that matches and **exit if none does**. `cm_class1b_E.sh` derives the env
per model instead of naming 1.1.2 anywhere, so a model built under some third version stops the run
instead of being silently realigned. `flavi_env.sh --check` prints the builder version of every
model in `cm_set_261021` plus the cluster-5 baseline, beside the env each one requires.

The first E2b run is the worked example of the failure mode: the constraint was in this file, in
prose, since 2026-10-30, and nothing read it.

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
| **FJIS cluster 5** | insect-specific flaviviruses, explorer cluster 5 (+ NC_012671) | explorer | 6 sites | **closed 2026-11-02: joined Class_1b.** The published P1-deviant ISF subtype; carries the base triple; `class1b_plusFJIS_cluster5_inf112` accepted. See the Class_1b extension row. Kept as **transition from 1b** (own frozen cluster; Part 1 B1, B3) | 11-16 | Part 3, FJIS section | `class1b`, `cand_FJIS_261029` |
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
| **sub-threshold Class_1b** | stalls where Class_1b scores just under inclusion: explorer cluster 21 (CFAV LR694076 10565, Kamiti River NC_005064 11245), cluster 135 (MW897328 10653) | explorer | 3 sites | **closed 2026-11-03 as a Class_1b question; 2 sites remain open on their own.** LR694076 10565 was 19.9 b / E 0.067 `?` and the cluster-5 expansion includes it at 23.4 b. The other two were tested as seed additions and **all three variants were rejected** — every one loses `OP860412 297`, and the two with MW897328 also lose two cluster-5 member sites. NC_005064 1079 (18.5 b, E 0.079) and MW897328 66 (19.3 b, E 0.057) are not Class_1b; they need their own model or sequences from outside this library. Both kept as **transition candidates** (clusters 21, 135; Part 1 B2) | 11-16 | Part 3, FJIS section | `class1b` |
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

**RUN 2026-11-17 (E1): it is a filter artefact.**

| model | default | `--max` |
|---|---|---|
| `CL_Class_1b_xrRNA_final` | cm 1–81, 65–156, **29.7 b**, E 6.4e-07, `!` | identical |
| `class1b_alignHits_strong_inf112` | **NO HIT** | cm 1–81, 65–156, **30.0 b**, E 8e-07, `!` |
| `class1b_alignHits_newvirus_inf112` | **NO HIT** | cm 1–81, 65–156, **30.2 b**, E 7.5e-07, `!` |

Same span in every case, and both variants score the site **higher than the original model does**.
The CM did not lose AB021287; the HMM filter pipeline drops it before the CM sees it. So the sole
ground on which `strong` and `newvirus` were rejected is gone, and library-internal Class_1b
expansion is reopened. The rejection of `all` stands on its own — it lost 5 Class_1b sites.

**But a filter artefact is still a practical loss, and E2 has to decide what to do about it.**
Annotation runs `cmsearch --toponly --incE 0.01` with default filters, so a deployed `strong` or
`newvirus` would leave AB021287 65 **unannotated** even though the model scores it at 30 b. Three
options, to be settled when E2 reports:

1. Run the Class_1b line with `--max` (or `--nohmm` / `--mid`) at annotation time. Correct, and
   affordable on a 439-accession library, but it makes the Class_1b model's annotation command
   different from every other model's, which has to be recorded in MANIFEST.
2. Accept the one unannotated site, having recorded that the CM scores it. Cheapest, and defensible
   now that the cause is known rather than suspected.
3. Reject both variants anyway, on the ground that a model whose own filter hides a known true
   positive is worse than one that does not.

Option 3 is the conservative reading of the no-loss rule as it was applied on 11-03, and the
difference between 1 and 2 is a documentation question, not a modelling one. The decision belongs
with E2's per-hit comparison, where the three gains can be weighed against it.

**Moot as of E2 (2026-11-17).** Both variants were rejected for losing nine hits, not one, so
nothing turns on AB021287's filter behaviour any more. It is recorded because it is true of the
model — the CM scores that site at 30 b and the filter hides it — and because the same could be
true of other sites under the deployed model; but it no longer decides anything. The three options
above apply again only if some future Class_1b version is otherwise acceptable.

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

### Local or cluster: two trees, two env scripts, and `$CMDIR` means different things

Written 2026-11-18 because this is the single biggest source of confusion in this file. There are
**two machines, each with its own env script**, and they share model *contents* but not directory
*layout*.

| | **laptop** | **cluster** |
|---|---|---|
| env script | `flaviLib/scripts/flavi_env.sh` | `scripts/env_261021_flaviLib.sh` |
| sourced as | `source $FLAVISCRIPTS/flavi_env.sh` | `source $ROOT/scripts/env_261021_flaviLib.sh` |
| root | `~/Desktop/viromelib` | `/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib` |
| **`$CMDIR`** | **`work/infernal/cm`** | **`work/06_infernal/cm`** |
| the 7 models | `$CMDIR/cm_set_261021/` (a snapshot) | `$CMDIR/` (flat, no `cm_set_`) |
| tblout | development only, beside each build | `$TBLOUT` = `work/06_infernal/260807_trueRef` |
| what happens here | candidate building, `cmbuild`, `cmcalibrate`, development `cmsearch`, clustering, this document | **the annotation**: step 10 `cmsearch`, step 11b `post_process_peaks.py`, the `cm_hit` columns |
| `$CMS` | not defined | defined here, and **only** here |

**`$CMDIR` is the trap.** Both env scripts define it, to different paths, under trees with different
names (`work/infernal` against `work/06_infernal`). A command copied from one machine's notes to the
other will resolve and will be wrong. The same applies to `$ROOT`. When writing a command for the
cluster, spell the cluster path out or state the machine in the same breath.

What is genuinely shared is the model bytes: `cm_set_261021`'s seven models are byte-identical to the
cluster's `work/06_infernal/cm/` (Part 6, *Model identity*, 2026-10-27). So the laptop's `$CMSET` is
a faithful mirror of what annotates, and that is why development comparisons here are meaningful —
but the mirror is a *snapshot in a differently-named directory*, not a synced copy.

**Which machine each E6 block runs on:** block A is the laptop (`cm_deploy_class1b_v2.sh`, staging
and `scp`), block B is the cluster (the dated env copy, the three `sed`s, step 10, step 11b). The
`class1b_groups.tsv` file goes to **both**: its Part 9 home is the laptop's `$CMDIR`, and a copy
travels in the `scp` to the cluster's `$CMDIR` beside the models.

### Invocation: these scripts are bash, and the shell here is zsh

Recorded 2026-11-17 after `hits_at_stall` came back `command not found`. Two separate traps, both
of which cost a round trip:

- **Every script here starts `#!/usr/bin/env bash`**, and the interactive shell on this machine is
  **zsh**. Sourcing a bash script into zsh is not something they are written for. Run helpers under
  bash and keep the whole sequence inside one invocation, so the sourced environment survives:

  ```bash
  bash -c 'source "$HOME/Desktop/viromelib/flaviLib/scripts/flavi_env.sh"; <helper> ...'
  ```

  Note also that `$FLAVISCRIPTS` is **defined by** `flavi_env.sh`, so it cannot be used to locate
  the file being sourced in a shell that has not already sourced it — spell that one path out.
- **An md5 in the table below is only a check if it is run against the *installed* file.** I
  verified it against a local copy instead and then diagnosed a stale install, which **the installed
  file disproved**: it is `d38c8ffdee67696cb75f98d867d56f36` with `hits_at_stall` at line 154, i.e.
  current. The cause of the two `command not found` results is therefore **unexplained**, and the
  guess is retracted rather than recorded as a finding. What is worth keeping is the check itself,
  which takes one command and answers the question directly:

  ```bash
  md5 "$HOME/Desktop/viromelib/flaviLib/scripts/flavi_env.sh"   # expect f86b43a35627469f6d4695e81f096fc1
  grep -n '^[a-z_]*() {' "$HOME/Desktop/viromelib/flaviLib/scripts/flavi_env.sh"
  ```
- **Sourcing `flavi_env.sh` sets the paths but does NOT activate the conda env.** `conda activate`
  lives inside `flavi_conda`, which only runs when `flavi_require` calls it — and `flavi_require`
  runs from *scripts*, not from sourcing. So an interactive shell that has sourced the env file has
  `$FA`, `$CPU`, `$INFERNAL` and the rest, and still has no `esl-sfetch`, `cmalign` or `cmsearch` on
  PATH. Every script here has worked so far precisely because it activates internally; the first
  command typed **by hand** fails with `command not found`. For interactive work:

  ```bash
  conda activate viromelib        # or infernal112 for a 1.1.2 model
  ```

  and note that the env to activate depends on the model, not on preference: `cm_env_require` reads
  the builder version from the `.cm` header for exactly this reason.
- **A script that prints a usage line writes it to *stdout*, so a redirect captures it silently.**
  `dedup_stockholm.py` takes `<input.stk> <output.stk>` as two arguments; invoked as
  `dedup_stockholm.py in.stk > out.stk` it prints usage, exits, and leaves `out.stk` containing the
  usage string — a file that exists, is non-empty, and is not an alignment. Nothing fails loudly.
  The same shape as the `hits_at_stall` signature error: **assuming an interface instead of reading
  it**. Check what a script expects before piping into or out of it, and check the output is what
  it should be rather than merely present:

  ```bash
  python3 $FLAVISCRIPTS/dedup_stockholm.py in.stk out.stk
  awk '!/^#/ && !/^\/\// && NF>=2 {print $1}' out.stk | sort -u | wc -l   # sequence count
  ```
- **Read a helper's signature from its own usage comment, not from memory.** `hits_at_stall` is
  `hits_at_stall <tblout> <ACC:genomic_stall> [ACC:stall ...]` (`flavi_env.sh` line 153): the tbl
  comes **first** and the accession and stall are joined by a **colon**, because the function takes
  several loci in one call. Three invocations recorded in this file had the arguments in the wrong
  order and form; all are corrected.

- **`hits_at_stall` reported a 2-nt miss as a flat `no`.** Its tolerance was ±1, and a stall is the
  explorer feature's own start coordinate while a hit's 5′ boundary is the model's, so the same locus
  differs by a few nt. It now prints a **`dist`** column and says `near <n> nt` within 10 nt, because
  a bare `no` reads as "absent" and is how the NC_008604 10707 result was nearly misread.

The same applies to the two tbl paths that go with it: the original model's library search is
`$SAT/r0/search.tbl` (`SAT` = `build/class1b/iter_v1_saturation`, the baseline every comparison in
Part 6 uses), **not** `$CL1B.tbl`, which does not exist — `$CL1B` is the model, not a search.

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
| `explorer_cm_scan.py` | `1c4b4ad1d63695100ee8694c4ee1f441` | nothing; scans the flavi150 explorer's sites with a CM; `fetch` (reference windows) and `seqs` (the explorer's own 80-nt windows) per cluster. **2026-11-17: `extract`, `seqs` and `fetch` raise `KeyError: 'fz'` on the regenerated explorer** — see Part 8. Apply `explorer_cm_scan_fz.patch` |
| `explorer_cm_scan_fz.patch` | `4bf4d41b6a241d1e6732781db0b01214` | n/a — a patch, not a script. Adds `resolve_fz(d)` to `explorer_cm_scan.py` so `extract` injects `fz` from `DATA.sets` when the regenerated explorer's nodes lack it; chooses the set by name and prints it, and backs up `data.json` / `nodes.tsv` / `nodes.fa` before overwriting them. Written 2026-11-17, tested on both explorer generations, **not yet applied** |
| `flavi_env.sh` | `f86b43a35627469f6d4695e81f096fc1` | nothing; **sourced by the three scripts below — every path is defined here and nowhere else**, and it **establishes** the conda env rather than reporting on it (`flavi_require`, which exits if a tool is absent and prints the Infernal version). `bash flavi_env.sh --check` verifies paths, tools and the cmalign/cmbuild/1.1.2 versions side by side. Overridable from the caller (`ROOT=`, `ITER=`, `CONDA_ENV=`). Also holds `clog`, `need`, `have`, `infernal_version`, **`cm_version` / `cm_env_for` / `cm_env_require`** (the builder version read from a model's own header, and the env that matches it), **`hits_at_stall`** (whether a hit covers the stall, converted from the sequence name's own offset — a grep by accession does not answer this), `stk_oneblock`, `alifold_line`. 2026-11-16; `--check` activates `$CONDA_ENV` before reporting (fixed same day: it had inspected the active env, giving false 'absent' for tools that are installed). `REF` and `SEED1B` were MISSING on the laptop and need their real paths |
| `cm_class1b_E.sh` | `41a3382bbcfb2b512a3465c78bd42f41` | nothing yet; prints the `clog` line to run. Subcommands `e1`, `e2`, `e2b`, `e3`–`e5` = steps E1–E5 (`e2b` decides cluster 106), and `e8`/`e8b` = step E8, the positional downstream set. Written 2026-11-16, e8 added 2026-11-17. E1–E5 have been run; **`e8`/`e8b` are syntax-checked only**. **Superseded md5s: `7a2c5bbb3f5041ad6a7fb3c989324a60`** = `e8` dies on `C5_library_tbl: unbound variable` before view 2; **`b973c4e77dae54db6d7a268ca205a6c8`** = runs both views but does not chain them, so the clustering cannot exempt a candidate from the bit floor |
| `cm_deploy_class1b_v2.sh` | `7b6d68db7f279fc603f5f7bcae03830f` | nothing; writes only into `$INFERNAL/deploy_261117`. E6 block A: verifies the accepted model, its seed, `class1b_groups.tsv` and the matching conda env, prints `cmstat` with a warning if it is not the accepted nseq 94 / clen 81 model, prints every path it resolved first (`FLAVI`, `INFERNAL`, `VIR_INF`, `CMDIR`, `CMSET`, `C5`, `STAGE`), takes `--groups <path>`, searches six locations for the tsv and lists all of them when it fails, reports the model's internal `NAME` and flags a mismatch with the deployed filename, and with `--stage` writes the model, the groups file and `MANIFEST.tsv` (`cm_name`, md5, builder version, cmstat, `build_path`) plus the `scp` line. Default run is check-only. Written 2026-11-17 |
| `cm_stk_inventory.sh` | `31223fe08b421a78fe5cb1004d938279` | nothing; reads only. Inventories every `.stk` under `$INFERNAL/build` and reports `nseq`, whether `SS_cons` and `RF` are present, whether `SS_cons` carries pseudoknot letters (MATER applied or not), and whether a `.cm` and a `.tbl` already exist beside it — the `.tbl` column being the one that says which alignments have never been searched library-wide. Written 2026-11-18 |
| `class1b_arrays.py` | `4df8f2cb72c55a0fd78b2421f6a12fe8` | nothing; prints and writes `positional_candidates.fetchlist`. Enumerates each genome's Class_1b array and tests whether the satellite / sub-threshold copy is the array's 3′-most. Two modes: `nodes <nodes.tsv>` (the explorer's clustering, CM-independent) and `tbl <search.tbl>` (bits and inclusion, converting each hit to genomic coordinates via the sequence name's own offset, as `hits_at_stall` does). Written 2026-11-17, **corrected the same day**: the first version filtered `cls == "1b"`, which removes every satellite copy because `cls` is CM-derived, and read an unassigned `fz` of `None` as a satellite. Both fixed; `nodes` mode now reproduces E5's documented arrays including the MW897328 counterexample. Writes `satellites.tsv` (`nodes`) and `positional_candidates.fetchlist` (`tbl`); options `--seed`, `--satellites`, `--floor`. **Superseded md5s: `cc6f1350af4fb7d6c1a220c68b8769b3`** = the `cls` filter bug, output invalid; **`c33a7a01f438b576b18b903b90cadbf3`** = correct `nodes` mode but the `tbl` verdict line is meaningless (`MAIN` cannot match an `incl`/`sub` label) and the candidate list has no seed exclusion or bit floor |
| `explorer_class1b_clusters.py` | `6d30ac2159cce0e09c1cfb5e35088f92` | nothing; E5 — Class_1b nodes per frozen cluster with a cumulative share, plus the frozen cluster of every B1/B2 site. **Reads `explorer_cm_scan.py extract`'s node table** (the validated parser, which derives `fz`); the HTML path is a fallback that reads `DATA.sets` by name (`mode` frozen, `view` all), says which set it chose, and offers `--list-sets`. Rewritten 2026-11-17 after two wrong guesses at the raw field names. Now reports rows read / with a cluster / skipped, **cross-checks the `cls` counts against Part 8's documented 416-node explorer** and warns if they disagree (it had been run on the annotated `nodes_cl3.tsv`), states both denominators for the main-cluster call, and decides each B1/B2 label **per stall, not per accession** |
| `cm_candidate.sh` | `fde33df3f5efbe2da82818217123bc60` | one row per stage, by `clog`. Track B: `align` (GATE 1, stops at MATER), `build` (GATE 2, model, library + RNAvirus DB), and `subset` (rebuild an existing refined alignment minus named sequences, reusing its hand-made structure; `--keep-columns` synthesises RF so cm numbering is preserved when the source has none; no manual step). Supersedes `build_candidate_cm.sh`. Written 2026-11-16, **GATE 1 parser tested on a real-format log; the stages never run** |
| `cm_rename_builds.sh` | `a6afb45fb394d1045d83c82a121a3e36` | one row on `--apply`. Renames build folders to the stage-prefixed scheme (Part 9 → Naming); check-only by default, never overwrites or deletes; writes `build/RENAMES.tsv` + `RENAMED_FROM.txt`. Written 2026-11-16, **tested on a mock build tree, not run on the real one** |

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

#### The explorer has been regenerated, and `explorer_cm_scan.py` no longer runs on it — 2026-11-17

**`explorer_cm_scan.py extract`, `seqs` and `fetch` all raise `KeyError: 'fz'` on the current
explorer.** Its node fields have changed:

| | node fields |
|---|---|
| what the script expects (its own docstring) | `id, acc, sp, genus, cls, sf, det, conc, fz, seq` |
| the current explorer | `id, acc, sp, genus, cls, sf, det, conc, seq` + **`e1c, ev, fam, q, xr`**, and **no `fz`** |

The per-site cluster assignment has moved into `DATA.sets` — a list of saved clusterings, each
`{view, mode, date, cl, clusters, inmsa}` with `cl` parallel to `DATA.nodes` (−1 = unassigned). The
script reads `n['fz']` at three places (lines 52 and 55 in `extract`, 105 in `seqs`, 134 in
`fetch`), so all three fail.

**What this blocks: only `extract`.** `seqs`, `fetch` and `annotate` all read `data.json`, not the
HTML, so the remaining gaps — **FJTB 64, PLLG 117, HPPV 39** — can have their seeds regenerated
right now from the existing `$SCAN/data.json`. (An earlier note here said they were blocked; that
was wrong.)

**The real hazard is the write order inside `extract`.** It writes `data.json` at line 46, opens
`nodes.fa` and `nodes.tsv` with `"w"` at line 48, and only reaches `n['fz']` at line 52. So running
it **unpatched** on the regenerated explorer would overwrite `data.json` with the fz-less schema and
truncate both node files **before** crashing — destroying the 2026-10-29 snapshot and breaking
`seqs` and `fetch`, which currently work. Nothing is broken today; running one command would break
it. **Back those three files up before `extract` is ever run again:**

```bash
cd "$SCAN" && for f in data.json nodes.tsv nodes.fa; do
  [ -e "$f" ] && cp -n "$f" "$f.20261029.bak" && echo "backed up $f"
done
python3 -c "import json;d=json.load(open('data.json'));print('data.json nodes carry fz:', 'fz' in d['nodes'][0])"
```

If that prints `False`, `extract` has already been run against the new explorer and the snapshot is
gone — recover `data.json` from git, or from `nodes_cl3.tsv`, which still holds `id` and `fz` for
all 416 nodes.

**What it does not invalidate.** The node table E5 read, `nodes_cl3.tsv`, is the 2026-10-29
snapshot from the previous explorer, and it **cross-checks exactly** against this file's documented
counts (416 nodes; 1a 78, 1b 106, 2 17, dumbbell 7, None found 208). So it is the clustering this
file refers to and the E5 labels stand. But it is a snapshot, and the `e1c` / `xr` fields suggest the
new explorer carries a class1c annotation of its own that postdates it.

**Should the previous explorer just be put back? No.** The HTML is not what changed — the
*generator* did (`build_flavi150_explorer.py`, named in `explorer_cm_scan.py`'s own docstring).
Reverting the data file leaves the next regeneration to reintroduce exactly this, and it discards
whatever the new fields are for: `e1c` and `xr` look like a class1c call and an xrRNA call carried
in the explorer itself, and six clustering sets spanning `view` ∈ {all, 01mM, 10mM} is the Mg-condition
split this file reasons about throughout. Keep **both**, dated, as this file's own conventions
require for reference data — a `.tbl` belongs to the reference state and not to a run, and the same
holds for the explorer. The 2026-10-29 snapshot is evidence: every recorded cluster number depends
on it, so it is preserved under a dated name, not left as the live file.

**Fix:** `scripts/explorer_cm_scan_fz.patch` — one function, `resolve_fz(d)`, plus one call in
`extract`, and a pre-overwrite backup of the three outputs (step 3b) so the crash-after-write
hazard cannot recur. It injects `fz` from `DATA.sets` when the nodes lack it, choosing the set by **name**
(`mode` containing `frozen`, `view` of `all`) and printing which one and why, since picking the
wrong set would silently give the wrong clusters. Everything downstream is untouched: `seqs`,
`fetch` and `annotate` read `data.json`, which `extract` writes after the injection. Tested on both
generations — unpatched fails on the new explorer, patched handles new and old identically, and
`seqs` still produces the same FASTA.

**Verify before trusting it**, because the two explorers may differ in more than schema:

```bash
python3 $FLAVISCRIPTS/explorer_cm_scan.py extract "$EXPLORER" /tmp/scan_new
diff <(cut -f2,6 /tmp/scan_new/nodes.tsv | sort) <(cut -f2,6 $SCAN/nodes.tsv | sort) | head
```

Identical `id`+`fz` output means the 2026-10-29 clustering is still current and the E5 labels hold
unchanged. Any difference is a change in the clustering itself, which would change those labels —
and the new counts would then be a **second generation to record separately**, not a correction to
the Part 8 figures.

#### Interface audit of the 2026-11-17 scripts against the existing ones

Checked after reading `cm_log.py`, `explorer_cm_scan.py`, `cm_iterate.sh` and `cm_round_stats.py`:

| what was checked | result |
|---|---|
| `clog` → `cm_log.py DOC --model --step --result` | correct. It escapes `\|` itself and appends each row after the last in its section, which is the order the manual rows follow |
| `cm_log.py` updating the `Last updated` line | **never fires**: its regex wants `Last updated YYYY-MM-DD.` alone on the line, and this file's is a long parenthetical. Pre-existing; the line is maintained by hand |
| `cm_round_stats.py fetch` output path | **was wrong in `e4`.** `fetch` writes to its `OUT` argument *exactly*, with no suffix; passing `$OUT/insertcheck` and then opening `insertcheck.fetchlist` is why 11-17's first run failed. Now passes the full filename |
| `compare` writing `NEW.tbl.compare.tsv` | correct, as `e3` assumed |
| `overlap A.tbl B.tbl NAME_A NAME_B`, resolved by lower E | correct — and it is explicitly Rfam clan competition. Prints to stdout, writes no file |
| the `cmstat` field order | correct: `nseq` f[3], `eff_nseq` f[4], `clen` f[5], `bps` f[7], `bifs` f[8], `relent` f[10] |
| `cm_iterate.sh` flags used by `cm_candidate.sh build` | all valid. Note it **requires a calibrated CM** (`grep ^ECMLC`), so `cmcalibrate` must precede it, as `build` does; its default `--incE` is `1e-10`; and with `--doc` it writes its own run-log rows |
| `nodes.tsv` columns vs what `explorer_class1b_clusters.py` reads | columns are `node id species genus cls fz sf det seq_len` — no `acc`, no `stall`. It works only because the reader falls back to splitting `id` on `\|`, which is the right derivation |

#### How the scripts fit together#### How the scripts fit together

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

## The two tracks, and where the manual alignment sits — 2026-11-16

Everything in this file is one of two tracks. They differ in whether a **structure** is being
found or **reused**, which is what decides whether the manual MATER step is involved at all.

```
TRACK A -- extending an existing model          TRACK B -- a new candidate
(Class_1b + cluster 5; E1-E7, Part 1)           (cluster 106, FJJI 41/44, HPPV 39, the pools)

  sites to add                                    cluster FASTA (explorer 80 nt, or
       |                                          esl-sfetch from the reference)
       v                                               |
  cmalign --mapali SEED                                v
       |   the seed's structure is REUSED        mlocarna --probabilistic
       |   column for column                     --consistency-transformation
       v                                               |
  cmbuild --hand (RF = the model's own                 v
       |          columns, Infernal 1.1.2)      stk_oneblock  ->  GATE 1 alifold covariance/bp
       v                                               |
  cmcalibrate                                          v
       |                                        **MANUAL: MATER pseudoknots -> hand-edit
       v                                          SS_cons -> wiggle-refine -> R-scape**
  cmsearch, compare PER HIT with the                   |          (C. Langeberg's MATER)
  baseline: no included hit may be lost                v
       |                                        cmbuild (--hand only if RF present)
       v                                        cmcalibrate  ->  GATE 2 cmstat eff_nseq
  accept / reject                                      |
                                                       v
                                                cm_iterate.sh: library, then RNAvirus DB
                                                       |
                                                       v
                                                reciprocal scoring + position overlap
                                                       |
                                                       v
                                                candidate card (Part 3) -> accept -> class<N>
```

**There is no manual alignment anywhere in Track A, and that is the point.** `cmalign --mapali`
appends sequences to the Class_1b seed *under the model's existing structure*, so no consensus is
re-derived, no `SS_cons` is edited, and MATER never opens. E1–E6 are seed arithmetic and per-hit
comparison. The only judgement in Track A is the no-loss rule.

That has a consequence worth stating: **Track A cannot discover a structure, only test membership
in one.** So when a group fails Track A — cluster 106 at PP 0.38–0.47 with 11–17 hits lost — the
answer is not a better rebuild, it is Track B on that group in its own coordinates. Which is
exactly what priority 2 is.

**Where the manual work does bear on Track A:** reading the base triple. `cmbuild` has no
base-triple state, so no Track A model can score or align it (Part 2, and the pitfalls table). The
triple is read from a structure-aware alignment with the pseudoknot annotated — a MATER / R-scape
alignment — and from a CM alignment only with the insert columns and PP in view. E4 is that check
on the accepted baseline, and cluster 106's open question ("a triple at a position the Class_1b
model cannot align?") can only be answered in Track B.

**Scripts for each track:**

| track | script | stages |
|---|---|---|
| A | `cm_class1b_E.sh` | `e1` … `e5`, no manual step |
| B | `cm_candidate.sh` | `align` → **your MATER work** → `build` |

### Which Nov-2 build folder is live — 2026-11-16

Six candidate folders exist from 2026-11-02. Three are superseded, one was absorbed into Class_1b,
two are live and sitting at the manual step. Working directory is `iter_v2_explorer80/` in all six
(`iter_v1` was the superseded 171-nt run), so pass `ITER=iter_v2_explorer80` to `cm_candidate.sh`.

**Folder names below are the pre-2026-11-16 ones.** Run `cm_rename_builds.sh` to move them to the
stage-prefixed scheme (Part 9 → Naming); the new name of each is in the table there.

| folder | state | what is in it | action |
|---|---|---|---|
| `cand_FJIS_fz106_261029` | **superseded** | single cluster, 171-nt windows; R-scape support 60–130 nt past the stall, in a downstream stem-loop that is not the element | none. Keep for provenance; run log kept |
| `cand_FJIS_fz5_261029` | **superseded** | same, 5 seqs | none. Keep |
| `cand_FJJI_cluster41-44_pooled_261029` | **dead end, closed** | pooled 20 seqs, −16.91 = −8.30 + −8.61, no significant pairs — weaker than either cluster alone | none. The negative result is the finding: two separate elements |
| `cand_FJIS_261029` | **absorbed, do not delete** | the pooled 80-nt MATER seed and model that produced the cluster-5 result. Its `iter_v2_explorer80/mlocarna/results/*-MATER-wiggle-refined.stk` and `cm/` are the inputs Track A used | none as a candidate. Cluster 5 went into `class1b_plusFJIS_cluster5_inf112`; cluster 106 needs its own folder |
| `cand_FJJI_cluster41_261029` | **LIVE — at the manual step** | 12 seqs, −25.52 = −14.00 + −11.52, two hairpins in the first ~45 nt; R-scape 1 of 11 pairs (11–20), PPV 100 | MATER on `iter_v2_explorer80/mlocarna/results/result-oneblock.stk`, then `cm_candidate.sh build` |
| `cand_FJJI_cluster44_261029` | **LIVE — at the manual step** | 8 seqs, −29.53 = −19.54 + −9.99, one long hairpin; R-scape 0 in structure (1 FP, 20–82, non-canonical) | same, after 41 |

**The folder that does not exist yet** is `cand_FJIS_cluster106_261103` — priority 2. Its 80-nt
FASTA is already on disk from 10-29 (`build/class1c/explorer_scan_261029/FJIS_fz106_explorer80.fa`,
old `fz` spelling), so `cm_candidate.sh align` is the only step needed to create it.

So the queue is: **FJJI 41 (your MATER) → FJJI 44 (your MATER) → cluster 106 (align, then MATER)**,
with cluster 106 under the caveat that 3 sequences at 0.84–0.94 identity cannot pass GATE 1 and the
run is for a consensus structure in its own coordinates, not for the gate.

## Build procedure and gates

`cm_candidate.sh` (2026-11-16) is Track B, two stages split at the manual step. It supersedes
`build_candidate_cm.sh` (md5 `264fd3ef7cf2efcdc8da6a0102975426`), whose recorded defects it fixes:
GATE 1 passing on an energy parse failure, the alifold regex missing mlocarna's line format and
space-padded energies, mlocarna's exit status unchecked, R-scape's outdir not created, the tblout
path not printed.

```bash
# stage 1 -- pooled or single cluster; stops at MATER and prints the file to open
bash $FLAVISCRIPTS/cm_candidate.sh align cand_FJIS_cluster106_261103 \
  $INFERNAL/build/class1c/explorer_scan_261029/FJIS_fz106_explorer80.fa

# ----- MANUAL: MATER pseudoknots -> hand-edit SS_cons -> wiggle-refine -> R-scape -----
#   then: clog <CAND> 'MATER + CaCoFold' 'PK <cols>; SS_cons edits <cols>; R-scape <n> bp, <n> covarying, avgid <x>'

# stage 2 -- GATE 2, model, library then RNAvirus DB
bash $FLAVISCRIPTS/cm_candidate.sh build cand_FJIS_cluster106_261103 \
  $INFERNAL/build/cand_FJIS_cluster106_261103/iter_v1_explorer80/mlocarna/results/result-oneblock_edit261116-MATER-wiggle-refined.stk
```

`align` refuses fewer than 3 sequences, checks mlocarna's exit status, runs `stk_oneblock` before
R-scape (LocARNA's two-block file is rejected as `duplicate seq name`), and **fails rather than
passes GATE 1 if the energy triple cannot be parsed** out of the log. `build` detects `#=GC RF`
and chooses `--hand` accordingly, since a raw MATER-edited Stockholm carries none.

cmbuild reads only the primary `SS_cons` line, so crossing pairs (`AAAA…aaaa`) are annotation for
the analyst, not for the model. Feed the CaCoFold `.sto` to `build` to get `--hand`.

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

## Naming — scheme revised 2026-11-16

### The problem this fixes

Three unmarked number systems collided in the old names, and the stage was invisible. In
`cand_FJIS_261029` nothing says the members are frozen clusters 5 and 106, nothing says which
alignment round is live, and `cand_` covered everything from "aligned, no model" to "every gate
passed" — so `cand_FJJI_cluster41_261029` (no model at all) and `cand_FJIS_261029` (model,
covariation gate passed, saturated, position-separate) read as the same kind of object. **A build
that is promoted now gets renamed, so the name states the state.**

### The scheme

```
<stage>_<CLADE>_<members>_<yymmdd>
```

| field | values |
|---|---|
| **stage** | `aln_` alignment only, no model · `cand_` model built and calibrated, gates incomplete · `conf_` **confident build** · `class<N>` accepted and deployed (no prefix, no date) |
| **CLADE** | the four-letter Mifsud code (`FJIS`, `FJJI`, `PLLG`, …) |
| **members** | `c<N>` = frozen cluster N; `c5+c106` = pooled; `vs<X>` = vsearch cluster X, a different numbering that is **never** written `c<N>` |
| **date** | always last, always 6 digits `yymmdd` |

**Not in the name: the alignment round.** That is the directory — `iter_v<n>_<window>`, e.g.
`iter_v2_explorer80`. One folder, many rounds. This is the distinction that was being read as part
of the identity.

Models additionally carry `_inf<ver>` when built by a non-default Infernal
(`class1b_plusFJIS_cluster5_inf112`), because 1.1.2 and 1.1.5 give different models from the same
seed (Part 2).

So any token is unambiguous by shape: `c5` is a cluster, `iter_v2` is a round, `261029` is a date,
`inf112` is an Infernal version, `vsA` is a vsearch cluster.

### When a model's filename changes — and when it must not

Asked 2026-11-18. The rule follows from one fact already in Part 9: **the annotation column is the
`.tbl` basename, which is the model's filename.** So a filename is not a label, it is a schema.

**A model's filename changes when, and only when, the model itself changes.** Renaming a model that
has not been rebuilt buys tidiness and costs: a new `cmsearch` (the `.tbl` is keyed to the
filename), a new column in every downstream table, and edits to every consumer. Renaming a model
that *has* been rebuilt costs the same, but the alternative — a new model under the old name — is
the failure this file exists to prevent.

That is why `class1b` is renamed at E6 and nothing else is. The current seven, against the scheme:

| filename | conforms? | why it is not being renamed |
|---|---|---|
| `CL_Class_1a_xrRNA_final.cm` | no — provided-model name | the model is unchanged |
| `CL_Class_2_xrRNA_final.cm` | no — provided-model name | unchanged |
| `cl3_NAR_2025.align.mpkadded.edited.confident.dedup.IDcurated.SS_cons.cm` | **no — a build name that leaked into deployment**, 56 characters of pipeline history | unchanged. This is the clearest example of the rule in *Versions of an existing model*: the build name should not have survived. Rename it **when cl3 is next rebuilt**, not before |
| `class4_cl4_v9_20260824.cm` | partly — carries a version and a build date | unchanged |
| `class1c.cm` | yes | — |
| `dumbbell_RF00525.cm` | yes — the Rfam accession is the model's identity | — |
| `CL_Class_1b_xrRNA_final.cm` → **`class1b_v2_inf112.cm`** | **being renamed now** | **because the model is new** |

**Two names, not one.** A model also carries an internal `NAME`, which `cmsearch` writes into the
tblout's query column, and the set's `NAME` fields are already clean:
`class1a class1b class2 class3 class1c cl4_v9 Flavivirus_DB` (Part 6, *Model identity*). So the
ugliness is confined to filenames. The successor's `NAME` should be checked before deployment: if
it is still `class1b`, the tblout's query column will disagree with its filename. That does not
break the annotation, which keys on the filename, but it must be recorded in MANIFEST rather than
discovered later. Changing `NAME` means rebuilding with `cmbuild -n` and recalibrating, which
produces different bytes and a different md5 — so if it is changed, it is changed **before** the
md5 goes into MANIFEST, not after.

### Versions of an existing model

The stage scheme above covers new candidates becoming new classes. A **new version of a model that
already annotates** is a different case and was unwritten until 2026-11-17:

```
<family><_v N>_inf<ver>.cm        e.g. class1b_v2_inf112.cm
```

- the **family name** stays, so the annotation column is still recognisably that family's;
- `_v<n>` counts versions, the originally provided model being v1 by implication;
- `_inf<ver>` carries the builder version, which for the whole Class_1b line is 1.1.2;
- the **build name does not survive deployment.** `class1b_plusFJIS_cluster5_inf112` says how the
  model was made; that belongs in `MANIFEST.tsv` (as `build_path`) and in the run log, not in a
  column heading that every downstream table and plot then carries.

**Renaming a deployed model is a downstream-breaking change**, because "column names are the `.tbl`
basenames including `.cm`" (Part 9 → How the CM columns are produced). So a version bump requires,
and must record, a sweep for the old column name:

```bash
grep -rn "<old model basename>" ~/Desktop/viromelib --include="*.py" --include="*.R" \
  --include="*.sh" --include="*.md" | grep -v CM_CANDIDATES.md
```

A version **replaces** its predecessor in the annotating set rather than joining it — two versions of
one model would double-count every site they share, and the overlap rule (lower E) exists for
competing classes, not for a model against its own successor. The predecessor stays in its old
`cm_set_<yymmdd>` as the provenance of the tables it produced.

### Promotion

By gates already defined in this file, so nothing new has to be judged:

| from → to | requires |
|---|---|
| `aln_` → `cand_` | a model exists: `cmbuild` + `cmcalibrate`, `cmstat` recorded (GATE 2 reported) |
| `cand_` → `conf_` | R-scape significant pairs with **every nested helix supported**, library **and** wider-target searches run (saturated or novel hits resolved), position overlap with the existing models checked per site |
| `conf_` → `class<N>` | deployed: MANIFEST, new `cm_set_<yymmdd>`, annotation re-run |

A `conf_` build is finished analysis awaiting deployment, not a hypothesis. `conf_FJIS_c5+c106_261029`
is the worked example: it passed all three `conf_` conditions, and cluster 5 then went into
Class_1b while cluster 106 did not.

### Renaming, and what is not rewritten

`scripts/cm_rename_builds.sh` — **check-only by default**, `--apply` to move, never overwrites and
never deletes (an existing destination is skipped). It writes `build/RENAMES.tsv`
(old → new → date → why) and a `RENAMED_FROM.txt` in each moved folder, then logs one run-log row
and lists the places in this file that still carry an old folder name.

**Run-log rows are records and are not rewritten** — the precedent is the 2026-11-02
`fz41` → `cluster41` rename. The same applies to the `fz` spelling still in data file names
(`FJIS_fz106_explorer80.fa`). Only interpretive text is updated.

Superseded builds move to `build/archive_superseded/`, keeping a stage prefix and gaining a window
token where that is what superseded them (`aln_FJIS_c106_171nt_261029`).

### Current folder names

| now | was | stage, and why |
|---|---|---|
| `aln_FJJI_c41_261029` | `cand_FJJI_cluster41_261029` | `aln_` — no model; at the manual MATER step |
| `aln_FJJI_c44_261029` | `cand_FJJI_cluster44_261029` | `aln_` — no model; at the manual MATER step |
| `conf_FJIS_c5+c106_261029` | `cand_FJIS_261029` | `conf_` — all three conditions met; Track A's input; **do not delete** |
| `cand_FJTB_c3_261026` | `cand_FJTB_261026` | `cand_` — model built, diversity-blocked, RNAvirus DB result unrecorded |
| `cand_PLLG_vsA_260915` | `cand_PLLG_260915` | `cand_` — model built; `vsA` = vsearch clusterA, not a frozen cluster |
| `archive_superseded/aln_FJIS_c106_171nt_261029` | `cand_FJIS_fz106_261029` | superseded by the 80-nt pooled run |
| `archive_superseded/aln_FJIS_c5_171nt_261029` | `cand_FJIS_fz5_261029` | same |
| `archive_superseded/aln_FJJI_c41+c44_261029` | `cand_FJJI_cluster41-44_pooled_261029` | closed: pooling weaker than either cluster alone |
| `aln_FJIS_c106_<yymmdd>` | — | **does not exist yet**; created by `cm_candidate.sh align` (priority 2) |

**Cluster N** = **frozen cluster N** of the flavi150 explorer: the 2026-10-28 clustering of the 416
pooled sites by LocARNA similarity, cut at 0.55 with the largest component recut at 0.57 (colour by
"frozen cluster (20261028)" in the explorer). The number is an index from that one clustering, not
a name; it goes into a candidate's first log row as provenance. vsearch cluster indices
(`cluster_2`, `clusterA`) are likewise not names — they depend on the input FASTA, the `--id`
threshold and the run date — which is why they take the `vs` prefix. `G<n>` / `E<n>` are
gap-register ids (Part 3); `E1`–`E7` are the Class_1b expansion steps (Part 1).

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
- `$CMS` is a space-separated list of model basenames **including `.cm`**, iterated as `for CM in $CMS`. Its source was recorded as `scripts/env_261021_flaviLib.sh` — **which does not exist on this machine** (searched 2026-11-17: no `env_*` file anywhere under `viromelib`, no `CMS=` in any `.sh`). That path came from `README_261021_flaviLib_150x150.md` and the annotation was most likely run on the HPC, where `vintage_md/flaviLib.md` records tbl paths under `/groups/as6282_gp/scratch_bkup/…`. **Treat the list as unversioned**: recover it from `ls $TBLOUT/*.tbl` and write it out explicitly in any command that uses it.
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

### The conda environment is part of the method — 2026-11-16

A run in `(base)` with `cmalign` present but `esl-sfetch` and `mlocarna` absent is the dangerous
case: the scripts proceed, and the Infernal version that produced the result is unknown. Since a
model built under 1.1.2 and realigned under 1.1.5 is not the same model (Part 2), that makes a
result uncitable rather than merely untidy.

`flavi_env.sh` now **establishes** the environment instead of reporting on it:

- `flavi_require <tools…>` activates `$CONDA_ENV` (default `viromelib`) by sourcing
  `$(conda info --base)/etc/profile.d/conda.sh`, verifies every named tool, **exits if any is
  absent**, and prints the Infernal version in use so it goes into the log. Every stage of
  `cm_class1b_E.sh` and `cm_candidate.sh` calls it first.
- every `cmalign`/`cmbuild` against an existing model runs as `conda run -n $(cm_env_require <model>)`,
  where the env is derived from the **model's own header** (`cm_version`). Nothing names 1.1.2: a
  model built under an unconfigured version stops the run rather than being realigned silently.
- `flavi_env.sh --check` **activates `$CONDA_ENV` before reporting**, then prints which env it
  started in and which it is now in, flags absent tools, and prints the Infernal version of
  `cmalign`, `cmbuild`, `cmsearch` and of `$CONDA112` side by side. **cmalign and cmbuild must
  report the same version.** If activation fails it says so and warns that the tool list describes
  some other env, so absent means unknown rather than missing.

**`cm_set_261021` mixes builder versions — measured 2026-11-16 from the headers:**

| model | built by | realign/rebuild in |
|---|---|---|
| `CL_Class_1a_xrRNA_final.cm` | 1.1.2 | `infernal112` |
| `CL_Class_1b_xrRNA_final.cm` | 1.1.2 | `infernal112` |
| `CL_Class_2_xrRNA_final.cm` | 1.1.2 | `infernal112` |
| `class1c.cm` | **1.1.5** | `viromelib` |
| `class1b_plusFJIS_cluster5_inf112.cm` | 1.1.2 | `infernal112` |

The three provided `CL_*` models are 1.1.2; `class1c.cm` was built here under 1.1.5. So there is no
single correct env for the deployed set, which is why the env is derived per model from its header
rather than set once. Any future class1c extension goes through `viromelib`, and that now happens
automatically.

**Measured 2026-11-16:** `$CONDA_ENV` (`viromelib`) carries `cmalign`, `cmbuild` and `cmsearch` at
INFERNAL 1.1.5 (Sep 2023); `$CONDA112` (`infernal112`) carries 1.1.2 (July 2016). The two are
consistent *within* each env, which is what the gate asks — but it means **every `cmalign` against
a 1.1.2-built model must go through `conda run -n $CONDA112`, not the active env**, and the
Class_1b line of models is all 1.1.2. This is not a configuration detail: it invalidated the first
E2b run.

Required in `$CONDA_ENV`: `mlocarna`, `R-scape`, `esl-sfetch`, Infernal 1.1.5. Separately in
`$CONDA112`: Infernal 1.1.2. **All of these are installed** — the 2026-11-16 `--check` that reported
`esl-sfetch` and `mlocarna` absent was reporting on `(base)`, because that version of `--check`
inspected the active env instead of activating `$CONDA_ENV` first. A checker that does not establish
the environment it is checking produces exactly the kind of false negative that sent E2b out with an
unknown Infernal version.

### `class1b_groups.tsv` — the transition-label lookup (decided 2026-11-16, not yet written)

**Why a file exists at all.** Once a Class_1b version includes a group, the annotation says
`Class_1b` at those sites and the group disappears from the tables — that a site is the P1-deviant
ISF subtype sitting in its own frozen cluster is not recoverable from a `.cm_hit` column. The
recorded decision (Part 1, B3) is that such a group keeps its own label after inclusion, so the
label has to be carried somewhere. Nothing derives it: frozen-cluster membership comes from the
explorer and the accept/reject decisions come from the rebuild tests, neither of which is in the
tblout the annotation reads. So it is **hand-kept**, maintained the way the gap register is — one
row written when a group is accepted or rejected.

Path: `~/Desktop/viromelib/work/infernal/cm/class1b_groups.tsv` (beside `MANIFEST.tsv`; the shared
`cm/` because the label belongs to the model, not to one dataset). Tab-separated, header row.

| column | content | why it is there |
|---|---|---|
| `accession` | with version, as in the reference FASTA (`NC_008604.2`) | |
| `stall` | genomic stall position, integer; the site key used everywhere else in this file | |
| `frozen_cluster` | explorer frozen cluster (2026-10-28 clustering), or empty if the site has no explorer node | |
| `group` | `core`, `transition:<cluster>`, or `transition_candidate:<cluster>` (B3) | |
| `decided` | the date this row's `group` was set, `YYYY-MM-DD` | a group can be promoted (B2 → B1) or demoted; without a date the table cannot be read against the run log |
| `model` | the model version that **includes** it, or the rejected variant that tested it: `class1b_plusFJIS_cluster5_inf112`, `all`, `kamiti`, `phaiomys`, `strong`, `newvirus` | **provenance of the addition.** "Class_1b" alone is ambiguous once there is more than one version |
| `change` | what the test actually moved: `19.9b ? -> 23.4b !`, `0 lost / 10 gained`, `11-17 lost`, `new hit, stall-anchored` | **the change made.** Membership is a consequence of a measured delta; the delta is what a later reader needs in order to re-judge it |
| `rationale` | why that delta was accepted or rejected, in one clause: `no-loss rule`, `loses OP860412 297`, `PP 0.38-0.47, 5'-truncated`, `recovered seed locus` | **the rationale.** Stops a rejected group being re-tested blindly, and makes a promotion legible |
| `source` | how `group` was derived when it does not follow from an explorer node: `no explorer node (2/4 reps, SF 0.311); inherited from MH827524 10759, same element` | |

Nine columns, and the four added on 2026-11-16 are what make it worth keeping by hand: `decided`,
`model`, `change` and `rationale` are the provenance of each addition, what it changed, and why.
None of them is recoverable from a tblout, and `model` stops being optional the moment a second
Class_1b version exists — which it now does.

Joined into the annotation as **one added column, `class1b_group`**, on `accession` + `stall`; the
`CL_Class_1b….cm_hit` columns are untouched. A row for a site the annotation does not carry is not
an error — the `transition_candidate` rows exist precisely so a group is not lost when it leaves
the gap list.

**The `source` column is not decoration.** NC_012671 has no explorer node, because its stall failed
the ≥3-replicate gate (10 mM: 2 reps, SF 0.311), so its group is inherited from MH827524 stalling at
the same element in a relative — that has to be legible from the row, not reconstructed.

**Written 2026-11-17 from the E5 result: `cm/class1b_groups.tsv`, 19 rows, 9 columns.** No
`<E5>` placeholders remain — E5 supplied every frozen cluster that exists. Summary:

| group | rows | which |
|---|---|---|
| `transition:5` | 6 | the five cluster-5 sites plus NC_012671, which inherits |
| `transition:21` | 2 | LR694076 10565, and MH237596 10555 inheriting from it |
| `transition:unknown` | 3 | NC_027817 10757, NC_027819 10811, OP860412 10802 — **no explorer node, nothing to inherit from** |
| `transition_candidate:106` | 3 | the cluster-106 sites |
| `transition_candidate:21` | 1 | NC_005064 11245 — the same satellite as LR694076 |
| `transition_candidate:135` | 1 | MW897328 10653 |
| `core` | 2 | MN587651 9782, MN587661 9940 — both in main cluster 131 |
| `core?` | 1 | OM030319 11865, provisional: no node, so unmeasured |

**No site included in the deployed model is `core`.** All eleven model members are
`transition:*`, which is the strongest statement this table makes: the expanded Class_1b's additions
are, without exception, the satellite copies rather than main-cluster elements.

**Six rows have an empty `frozen_cluster`, and they divide into two kinds.** Two inherit cleanly from
a relative stalling at the same element (NC_012671 ← MH827524; MH237596 ← LR694076). Four cannot:
NC_027817 has no explorer node at all; NC_027819's only node is `fz 7 / cls 1a`, a Class_1a element
and not a basis for inheritance; OP860412 and OM030319 have no node either. Those four carry
`transition:unknown` or `core?` and **must not be joined into the annotation until resolved** — a
guessed group is worse than a blank one. Cluster 21 is the likely answer for the two recovered
P1-deviant loci by analogy with LR694076 and MH237596, but that is inference and the column says so.

One value to confirm before use: `NC_005064.1` — that version has not been seen in any tblout here,
only the bare accession in this file.


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
| 2026-11-16 | classification status and transition rule | Part 1 now classifies every site group as finished / Class_1b extension / unknown. Class_1b extensions split into core and transition from 1b by explorer frozen cluster; transition groups keep a label after inclusion (proposed `class1b_group` column from `cm/class1b_groups.tsv`, not implemented). B1 transitions: FJIS cluster 5 (+ NC_012671); P1-deviant recovered loci pending their clusters (LR694076 in cluster 21). B2 transition candidates: cluster 106, NC_005064 (cluster 21), MW897328 (cluster 135), novel-hit gains, 13 hepaci partial matches. Main Class_1b clusters not yet determined (131, 133 known); B4 block tabulates them |
| 2026-11-16 | decision: where Class_1b expansion goes, and the transition lookup | Library-internal expansion is at capacity at cluster 5 (four independent demonstrations; OP860412 297 is the marginal hit in every direction), with one unfinished library-level question. Order decided, E1-E7 in Part 1: E1 AB021287 --max on the existing strong/newvirus models -- the only Class_1b question the library can still answer; E2 only if E1 clears, rebuild strong/newvirus on the cluster-5 seed, since the 10-30 runs used the original model as baseline; E3 the OP860412 297 count conflict; E4 pp_check and insertcheck, before deployment because insertcheck can change the column layout; E5 B4 (main 1b clusters, frozen cluster of every B1/B2 site); E6 deploy once -- MANIFEST, new cm_set, class1b_groups.tsv, cluster steps 10-13, recount against 8 models; E7 a targeted set of complete ISF genomes from NCBI, the only route left and the one that serves cluster 106, NC_005064, MW897328 and any further 1b addition at once. Rationale for the order: deployment is the expensive step (new cm_set, cluster steps 10-13, re-annotation, recount), so settle every library-level question first and deploy once; and the RNAvirus DB is demonstrably too narrow here (4 of the 8 FJIS seed genomes score 52-79 bits in the library and are absent from it). Transition labels to be carried in a hand-kept cm/class1b_groups.tsv joined as one class1b_group column; spec and the 15 rows to write in Part 9. Hand-kept because nothing derives it -- frozen clusters come from the explorer, accept/reject from the rebuild tests, neither is in the tblout the annotation reads |
| 2026-11-16 | cluster 106 reopened; E2b added | The 106-is-not-Class_1b conclusion does not hold up on review. FOR: the 4 covarying pairs that make the pooled structure credible come from comparing cluster 5 with cluster 106 sequences (this file: "the evidence that the two clusters share one structure"); cluster 106 is 91 % canonical over the 22 bp (82 % pre-wiggle) vs cluster 5's 83 % (79 %); FJIS vs the 88 Class_1b seeds is moderate both ways. AGAINST: Class_1b scores 0 of 3 cluster-106 sites while scoring 4 of 5 cluster-5 sites (clean); the `all` variant lost 11-17 hits at PP 0.38-0.47 (confounded: original 88-seq model, and pooled with cluster 5); the Menghai cm 29/43 deletion, which the triple section calls the firmest ground and the cluster-106 section calls not evidence at PP 0.465 -- an internal contradiction now flagged in both places. New step E2b (`cm_class1b_E.sh e2b`): add the 3 cluster-106 sequences ALONE to the cluster-5 baseline, which has never been done; decision table for its three outcomes in Part 1. Runs BEFORE Track B on 106, which is now conditional on it. class1d is not decidable either way until E7 supplies sequences, since a class must recruit beyond its seed and 3 sequences at 0.84-0.94 would find only themselves; correct label meanwhile is transition_candidate:106 |
| 2026-11-16 | E2b run: cluster 106 is not Class_1b, on an unconfounded baseline | The 3 cluster-106 sequences aligned to the accepted cluster-5 baseline (cmalign --mapali): NC_034017 10511 cm 27-81 5'-trunc -10.59 b PP 0.397; NC_034204 10523 cm 17-78 5'-trunc -12.38 b PP 0.465; ON949931 10608 cm 17-61 5'&3'-trunc -14.40 b PP 0.424. Identical to the original 88-seq model's PP 0.38-0.47 and 5' truncation (Menghai's 0.465 to three places), and all three alignment scores are NEGATIVE, so adding the P1-deviant ISF subtype to the seed brought them no closer. Verdict: Class_1b cannot reach cluster 106; the loss count is not needed because the alignment itself fails. This resolves the Menghai-triple contradiction in the same direction while confirming that at PP 0.40-0.47 the triple reading is still unreadable and should not be cited either way. Cluster 106 -> Track B, priority 2. PROVISIONAL: the session ran in (base) with esl-sfetch and mlocarna absent, so the Infernal version behind cmalign is unknown; a 1.1.5 cmalign on a 1.1.2-built model is not the same alignment (Part 2). Confirm with flavi_env.sh --check and re-run if base's cmalign was not 1.1.2. Run stopped after cmalign (cmbuild needs conda run -n infernal112), so no cmstat and no per-hit comparison |
| 2026-11-16 | conda env made part of the method | A run in (base) with cmalign present but esl-sfetch and mlocarna absent produced a result whose Infernal version is unknown, which makes it uncitable rather than untidy. flavi_env.sh now ESTABLISHES the env: flavi_require activates $CONDA_ENV via conda.sh, verifies each named tool, exits if any is absent, and prints the Infernal version into the log; every stage of cm_class1b_E.sh and cm_candidate.sh calls it first. Every cmalign against a 1.1.2-built model now runs as conda run -n $CONDA112 cmalign, pinned not inherited. --check prints the active env and the cmalign/cmbuild/cmsearch/1.1.2 versions side by side; cmalign and cmbuild must match. Also: REF and SEED1B were MISSING on the laptop and need their real paths; CL1C resolved correctly inside cm_set_261021. CORRECTION, same day: --check itself did not activate $CONDA_ENV, so its esl-sfetch and mlocarna 'absent' lines described (base) and were false -- both are installed in viromelib. --check now activates first and reports which env it started in and which it ended in; an activation failure is stated as such so absent reads as unknown, not missing |
| 2026-11-16 | Infernal versions measured; first E2b run invalidated | flavi_env.sh --check from inside viromelib: cmalign, cmbuild and cmsearch all INFERNAL 1.1.5 (Sep 2023); infernal112 env INFERNAL 1.1.2 (July 2016); all 9 tools present, so the earlier esl-sfetch/mlocarna 'absent' report was indeed the checker's bug. Consequence: the E2b run earlier today used base's unpinned cmalign (1.1.5 line) against class1b_plusFJIS_cluster5_inf112, which was built under 1.1.2, so its PP 0.397/0.465/0.424 are not reproducible from the recorded method and are not citable; e2b now routes cmalign through conda run -n infernal112 and must be re-run. The verdict is not expected to change -- the 1.1.5 alignment reproduced Menghai's 0.465 to three places, which hints the versions agree here -- but that is not a measurement. Standing rule confirmed: every cmalign against a 1.1.2-built model goes through $CONDA112, never the active env, and the whole Class_1b model line is 1.1.2. Still missing on disk: REF and SEED1B (neither blocks E2b, which seeds from $C5.stk) |
| 2026-11-16 | the 1.1.2 constraint encoded, not just documented | Correction to today's framing: the reason the cluster-5 model is 1.1.2 is that CL_Class_1b_xrRNA_final.cm itself is, and that was already recorded in Part 2 and in the 2026-10-30 run-log row (header INFERNAL1/a [1.1.2 \| July 2016]; 88/48.62/81/19/2 under 1.1.2 vs 88/87.08/78/18/2 under 1.1.5). It was treated today as an open question and the first E2b run went out unpinned anyway, so the failure was not missing documentation but a constraint that lived only in prose. Now enforced: flavi_env.sh gains cm_version (builder version read from the .cm header), cm_env_for and cm_env_require (map it to the matching conda env, exit if none matches); cm_class1b_E.sh derives the env per model and names no version anywhere, so e2/e2b/e4 cannot realign a model with the wrong Infernal and a model from a third version halts the run; --check prints the builder version of every cm_set_261021 model and the cluster-5 baseline beside the env it requires. Standing exception kept: cmsearch of a 1.1.2 model under 1.1.5 is deliberate and is what the comparisons used |
| 2026-11-16 | E2b re-run under 1.1.2: cluster 106 is not Class_1b, confirmed | cm_env_require read class1b_plusFJIS_cluster5_inf112.cm's header as 1.1.2 and ran cmalign via conda run -n infernal112. Result IDENTICAL to the unpinned 1.1.5 run to three decimal places: NC_034017 10511 cm 27-81 5'-trunc -10.59 b PP 0.397; NC_034204 10523 cm 17-78 5'-trunc -12.38 b PP 0.465; ON949931 10608 cm 17-61 5'&3'-trunc -14.40 b PP 0.424. Verdict confirmed and citable: Class_1b cannot align cluster 106 on the best available baseline; cluster 106 -> Track B, priority 2. SIDE FINDING: cmalign against a fixed model is version-stable here while cmbuild is not (same seed: 88/48.62/81/19/2 under 1.1.2 vs 88/87.08/78/18/2 under 1.1.5), so the 2026-10-30 version sensitivity is in model construction, not in alignment to an existing model -- scoped to one model, one --mapali, 3 sequences, and not a reason to drop the pinning. Both runs stop after the alignment table because cmcalibrate follows and is slow; no cmstat and no per-hit comparison, neither needed for the verdict |
| 2026-11-17 | E2b complete: cluster 106 rejected on every criterion | cmstat 97 / eff_nseq 71.32 / clen 81 / 19 bp / 2 bif against the baseline's 94 / 50.24 / 81 / 19 / 2 -- structure preserved but 3 sequences raised eff_nseq by 21.08. Compare vs cluster-5 baseline: matched 120, lost 19, gained 1 (MH282908 223, 36.2 b), lower_bits 111, worst_delta -15.60; the all variant lost 11-17, so this is worse. The 19 lost include EIGHT of cluster 5's own ten gains (NC_027819 561, NC_024299 628, NC_021069 597, MH827524 595, AB981186 590, NC_012671 545, LR694076 476, MH237596 478) plus OP860412 297 and core Class_1b sites KC181923 859, KJ741266 810, LC536088 839, MN635449 73, AB021287 65, MT276199 198, NC_020902 424, MH307700 124, ON391060 22 -- i.e. admitting 106 undoes the cluster-5 merge. POSITION CHECK (not accession membership, which the first version of the check wrongly used): converting stalls to subsequence coords, NC_034204's included 30.8 b hit is at rel 32-87 while its stall is rel 170 (83 nt short); NC_034017's included 27.4 b hit is at rel 30-102, stall rel 177, covered only by a 12.0 b E 3.8 '?' hit at 142-259; ON949931's stall rel 419 is covered by neither of its hits (86-166 19.8 b, 640-731 14.6 b). So the model recruits OTHER loci in those genomes, not the cluster-106 element. Sharpest case: ON949931 rel 86 was an included Class_1b hit at 30.2 b in the baseline and is now LOST at 19.8 b -- that genome carries a genuine Class_1b element 333 nt from its cluster-106 stall, and admitting the latter costs the former. Reading: a divergent Class_1b copy is absorbed at modest cost (cluster 5 at zero); this broadens the profile, drags 111 hits down and is still not recruited, which is a different element sharing an architecture, not a subtype. Strengthens but does not settle class1d; E7 still required. Script fixed: flavi_env.sh gains hits_at_stall, which converts the stall from each sequence name's own offset and reports coverage, replacing the grep by accession in e2b |
| 2026-11-17 | E1: AB021287's loss is a filter artefact; library-internal expansion reopened | AB021287.1\|8868-9228_inferred_3UTR searched with and without --max: original model cm 1-81, 65-156, 29.7 b, E 6.4e-07, ! in BOTH modes; class1b_alignHits_strong_inf112 NO HIT by default but 30.0 b, E 8e-07, ! under --max; class1b_alignHits_newvirus_inf112 NO HIT by default but 30.2 b, E 7.5e-07, ! under --max. Same span throughout, and both variants score the site higher than the original does, so the CM never lost it -- the HMM filter drops it. The sole ground for rejecting strong and newvirus is therefore gone and E2 is live: rebuild both on the cluster-5 seed and judge the three stall-anchored gains (OM030319 11865, MN587651 9782, OP860412 10802) against MH307700 -4.0 and MH282908 -5.5. The rejection of the all variant stands on its own (5 Class_1b sites lost). OPEN DECISION for E2: a filter artefact is still a practical loss, because annotation runs default filters, so a deployed strong or newvirus leaves AB021287 65 unannotated at 30 b -- either run the Class_1b line with --max/--nohmm/--mid and record that in MANIFEST, or accept the one unannotated site now that the cause is known, or reject both variants on the ground that a model whose filter hides a known true positive is worse than one that does not. Consequence for E6: deployment waits on E2, since the model deployed may be cluster 5 plus strong or newvirus, and a new cm_set plus cluster steps 10-13 should not be run twice |
| 2026-11-17 | subset route added for cluster 106 | The pooled refined alignment already contains cluster 106 fitted by hand to that structure, so a cluster-106 model does not require a new alignment: cm_candidate.sh subset runs esl-alimanip --seq-k to drop the cluster-5 rows and cmbuild --hand to rebuild from the same columns. Columns are NOT trimmed -- with #=GC RF present, --hand keeps every RF column as consensus even where the 3 retained sequences gap it, so clen and the cm numbering stay identical to the pooled model and cm 7/29/43 remain comparable. SCOPE: the subset answers 'does cluster 106 fit the structure cluster 5 defines', since the pooled consensus was set by cluster 5 (5 of 8 sequences); it does NOT establish cluster 106's own fold, so a class1d claim and the triple 5' of P1 still need the de novo 80-nt pass -- reading a triple off a structure imposed by other sequences is the same error as reading it off the Class_1b CM alignment at PP 0.465. Subset first because it is free and yields the reciprocal test at once: build the complementary cluster-5 subset with 'drop', then score each seed with the other's model and compare bit scores both ways; given E2b the expectation is siblings, and measuring beats asserting |
| 2026-11-17 | cluster 106 aligned alone; architecture confirmed, covariation impossible | cluster106_edit261117.stk (3 seqs, 85 cols) compared element-for-element with the pooled result-oneblock_edit261102-MATER-wiggle-refined_shortenP1forBT.stk (8 seqs, 98 cols). SAME ARCHITECTURE: P1 outer 2 bp (G-C, C-G, the same two pairs in both -- the pooled P1's third pair is cluster 5's alone, G-U, col 8 being a gap in all three c106 seqs), 7-bp inner hairpin, 4-bp hairpin 2, pk_A GGAU:AUCC (4 bp alone vs 3 pooled), pk_B UCAC:GGUG 4 bp. Canonical fractions on the pooled structure, c106 seqs: nested 36/37 97%, pk_A 9/9 100%, pk_B 12/12 100%, overall 57/58 98%; cluster 5: 58/58, 15/15, 12/15 80%, overall 85/88 97% -- so cluster 106 fits at least as well as cluster 5 and better on pk_B. DECISIVE LIMIT: of the 21 pairs in the c106-alone alignment, 16 are IDENTICAL in all three sequences; only 13:24, 14:23 (one A-C non-canonical in NC_034204), 15:22, 16:21 (both gapped in ON949931) and 34:43 vary. P1, pk_A, pk_B and 3 of hairpin 2's 4 pairs are invariant, so R-scape has zero power on them however the alignment is drawn and expected covarying pairs ~ 0. GATE 1 is not applicable rather than failed: this is a data limit, not a modelling failure, and no further alignment work changes it -- E7 is the only route to a class claim. TRIPLE: see the correcting row below -- the reading given here, that there is no conserved C 5' of P1 and so class1d should not be presumed, tested the wrong expectation and is superseded. SCRIPT CORRECTION: neither .stk carries #=GC RF, so build will infer match columns by occupancy (clen will not be 85) and yesterday's claim that subset preserves cm numbering was wrong for these files; subset now warns and offers --keep-columns, which synthesises RF over the source's occupied columns |
| 2026-11-17 | cluster 106 has a conserved U-A-U base triple; the earlier naming argument was wrong | Reported from the structural prediction: the triple base is U6 of cluster106_edit261117.stk, currently swallowed into pk_A as the 6:47 pair. Freeing it gives pk_A = 3 bp (3:50, 4:49, 5:48) and the triple U6 . (A5-U48) = U-A-U against pk_A's innermost pair. All three positions -- U6, A5, U48 -- are invariant across all three sequences. The POOLED alignment already had this right: its equivalent U is col 7, left unpaired, with pk_A = 3 bp (4:56, 5:55, 6:54) and the triple U7 . (A6-U54); so the new file over-extends pk_A by one pair. Corrected SS_cons (A at 6 -> ., a at 47 -> .) saved as cluster106_edit261117_triple.stk with #=GF CC provenance; 85 cols and 13 nested bp unchanged. CORRECTION: the argument made earlier today -- that there is no conserved C immediately 5' of P1 and therefore class1d should not be presumed -- tested the wrong expectation. The triple is not 5' of P1; it sits against the innermost pseudoknot pair, and it IS present, as U...A-U where Class_1b has C...G-C at cm 7/29/43. Same interaction class with the identity substituted, which is a POSITIVE argument for class 1 membership, so class1d is defensible on architecture (two pseudoknots, short P1, conserved triple at the pseudoknot). What is missing is sequences, not structure. MODEL BLINDNESS: cmbuild reads only the primary nested SS_cons, so A/a and B/b are ignored and Infernal has no base-triple state; both alignments give a 13-bp model, matching the 13 bp recorded for the pooled model's cmbuild output. The triple cannot be scored or refuted by any CM search, and since its positions are invariant, covariation cannot support it either -- cite it as a prediction from structure plus conservation |
| 2026-11-17 | three diagnostic features for cluster 106, and a concerted triple substitution between the clusters | Features reported and verified against both alignments. (1) P1 shortened to 2 bp (G-C, C-G) where cluster 5 has 3 (G-U, C-G, A-U); in the pooled alignment the third pair cannot form for cluster 106 because pool col 63 is gapped in all three. (2) THREE UNPAIRED PURINES, AAA, between P2's 3' strand and P3: c106 cols 28-30, pool cols 33-35, occupied in 3/3 cluster-106 sequences and 0/5 cluster-5 sequences (NC_024299 has a lone G at pool col 35). (3) The base triple, at pooled cols 7/6/54: cluster 5 reads C.(G-C) in 5/5 sequences, cluster 106 reads U.(A-U) in 3/3 -- all three positions substituted together, each cluster invariant, interaction preserved as pyrimidine.(purine-pyrimidine). TWO CONSEQUENCES. First, the triple is real: a coincidence would not substitute all three partners coherently while staying fixed within each cluster, and cluster 5's C.(G-C) independently reproduces the Class_1b triple recorded in this file as C...G-C at cm 7/29/43, from sequences aligned without reference to it -- a cross-check on the Class_1b annotation too. Second, this is where the covariation lives: within cluster 106 alone 16 of 21 pairs are invariant and R-scape has no power, but between clusters the variation is concerted, which is why the POOLED alignment gave 4 covarying pairs against 0.2 expected while neither cluster alone can give any. So the pooled alignment is not superseded by the c106-alone one -- it is the only alignment in which this structure has statistical support, and it is the one to cite for the structure. SYNTHESIS with E2b: shared architecture with between-cluster covariation, every diagnostic feature substituted, and primary sequence too diverged for the Class_1b CM -- structural homology and CM-absorbability are different things, which is the siblings-not-one-family relationship this file already uses for class1c. Cluster 106 is a distinct class 1 element, sibling to Class_1b; class1d is right if the class 1 assignment holds, and the triple is now the evidence for it rather than the obstacle. Still gated on E7: 3 sequences at 0.84-0.94 identity generalise to nothing, and the three features above are the diagnostics to search with |
| 2026-11-17 | E2: strong and newvirus both rejected; Class_1b is saturated; the cluster-5 merge is fragile | Rebuilt on the cluster-5 seed with cmalign/cmbuild in infernal112 (model header read as 1.1.2). strong: 132 seqs, eff_nseq 25.58, 81/19/2; matched 130, lost 9, gained 2, lower_bits 55, worst -6.20. newvirus: 128, 25.64, 81/19/2; matched 130, lost 9, gained 1, lower 56, worst -6.00. Fetchlists found at iter_v2_alignHits/novel_strong.fetchlist (38) and novel_newvirus.fetchlist (34). BOTH REJECTED. Decisive argument is not the loss count but the value of the gains: the 68 novel hits were ALREADY FOUND by the baseline, so moving them into the seed buys no annotation; the only true gains are sites the baseline does not find, OM030319 57 at 31.5 b and (strong only) MN587651 70 at 24.4 b. Trade is +2 against -9 = net -7 annotated sites for nothing, independent of the AB021287 filter question, which is now moot. THE NINE LOST ARE THE NINE WEAKEST (23.4-27.8 b) and identical in both variants: AB021287 65, NC_027819 561, MH827524 595, MH307700 124, NC_021069 597, AB981186 590, NC_012671 545, LR694076 476, MH237596 478 -- SEVEN of which are cluster 5's own ten gains (only NC_008604 10707, NC_024299 10747, NC_027817 10757 survive). So the cluster-5 merge is fragile: its sites sit at the inclusion threshold and are the first casualties of any broadening; record this at E6, since those seven annotations will not survive a later revision. MECHANISM: the added sequences align full length at PP 0.74-0.93, 23-46 b, so they are genuine Class_1b elements; what fails is capacity. eff_nseq moves 50.24 -> 25.58/25.64 on similar additions and 50.24 -> 71.32 on the three divergent cluster-106 ones, so with relent fixed at 0.700 cmbuild down-weights harder as similar sequences accumulate, emissions flatten and every score falls (55 of 130 lower, worst -6.2) until the marginal band drops below incE 0.01. Either direction loses the same marginal set. CONCLUSION: library-internal Class_1b expansion is closed, demonstrated three independent ways on one baseline (+3 divergent 19 lost; +38 similar 9 lost; +34 similar 9 lost). E1 reopened it on a technicality, E2 closed it on the substance. NOT VARIED: --ere. Raising the target relative entropy might retain the marginal sites, but it breaks the like-for-like comparison the no-loss rule rests on and tuning it to rescue a result is not a measurement; if tried it must be declared, applied to the baseline too, and both models re-searched. E3 PARTLY ANSWERED: OP860412 297 appears as matched, 23.2 -> 26.2 (strong) and 23.2 -> 26.0 (newvirus), so it IS in the cluster-5 baseline at 23.2 b; whether it was new relative to the original 88-seq model still needs E3's grep. CONSEQUENCE: the model to deploy at E6 is cluster 5 ALONE |
| 2026-11-17 | E3 resolved; E4 pp_check shows every cluster-5 site carries the Class_1b triple; E4 insertcheck and E5 blocked on script bugs, both fixed | E3: ten NEW rows in the accepted cluster-5 model -- NC_024299 628 (30.1), NC_027817 543 (28.3), NC_027819 561 (27.7), MH827524 595 (26.6), NC_021069 597 (24.9), AB981186 590 (23.4), NC_012671 545 (23.4), LR694076 476 (23.4), MH237596 478 (23.4), OP860412 297 (23.2) -- count 10 and OP860412 297 IS among them. The count conflict is settled and the earlier arithmetic was wrong on one point: NC_008604 10707 is NOT a gain. Its cluster-5 copy was added to the seed (it is one of the six pp_check aligns) but was already an included hit, so it produced no new annotation. [CORRECTED 2026-11-17 22:12: the REASON here is wrong. hits_at_stall on both models shows the original has NO hit at that locus at all, included or reported, and the accepted model has rel 577-677 at 20.9 b '?', 2 nt from the stall. So it was never an included hit; the conclusion 'not a gain' stands because a '?' hit is no new annotation, and nothing was lost, so the no-loss rule and the acceptance are intact.] Correct accounting: 5 own sites + 4 recovered loci + OP860412 297 = 10. The B1 row listing NC_008604 as a gain is the error. E4 pp_check: all six added cluster-5 sequences align with NO insertions at the triple columns and PP 0.85 to >0.95, reading C at cm 7, G at cm 29, C at cm 43 in every one -- so every cluster-5 addition carries the Class_1b C...G-C triple, against cluster 106's U...A-U. This is the cleanest evidence in the file that cluster 5 belongs inside Class_1b, and it retrospectively validates a merge that had been accepted only on the no-loss rule. Answers the question of whether cluster 5 should be split off: no -- its marginal bit scores measure primary-sequence divergence, not a different architecture, and the transition:5 label already records the sub-structure, which E2's fragility finding argues for keeping rather than dissolving into core. E4 insertcheck: cm_round_stats.py fetch reported 139 sites but wrote no file at the assumed path, so esl-sfetch failed; the script now discovers whatever file fetch wrote and lists the directory if there is none. insertcheck is the last step that could still move the seed's columns and must run before E6. E5: the explorer's node list carries no 'fz' field -- the cluster key is named something else -- so explorer_class1b_clusters.py now auto-detects cluster and class keys from a candidate list and, failing that, prints DATA's structure and every list-of-dicts with its first item's keys, with --cluster-key / --class-key to override. Also recorded: when models get checked against each other (overlap by POSITION before E6 for Class_1b x class1c and x Class_1a; reciprocal bit-score scoring with --max for any new candidate, cluster 106 included once its model exists) |
| 2026-11-17 | E4 complete, both parts pass; E5 blocked on the explorer's field names | pp_check, 6 added cluster-5 sequences aligned without --mapali: cm 7 = C in all six at PP 0.85->0.95 (two at 9, four at *), cm 29 = G at PP * in all six, cm 43 = C at PP * in all six; RF reads GGCAa / cGGGG / CCCCC at the three windows and the sequences carry no insertions there. insertcheck, 139 included library sites fetched at 70% coverage and aligned to the cluster-5 model: ZERO insert columns exist beside cm 7, 29 or 43, occupied in 0/139 sequences. So the seed does not misdescribe the family at the triple columns, confirming the 2026-11-03 seed-shift answer from the other direction, and NOTHING needs re-comparing before E6 -- this was the last step that could have moved the model's columns. E4 is therefore complete: triple columns correctly placed, insert-free across 139 sites, and read at high PP in every added sequence. E5 still blocked: the explorer's cluster field is 'cl' on a list at DATA.sets, but that list's keys (cl, clusters, date, inmsa, mode, view) are CLUSTERING DEFINITIONS, not sites -- one entry per saved clustering, with the per-site assignment presumably inside its 'clusters' field keyed by date 20261028 and mode frozen. The auto-detector matched it only because one key is spelled 'cl'. Script now requires a cluster-like AND a class-like key in the same list, prefers the largest such list, and has a --dump mode printing DATA's full shape. Needed from the dump: which list holds the ~416 sites, which field gives each site's frozen cluster (or how DATA.sets[...].clusters keys back to them), and which field gives the class label with what value meaning Class_1b. NOTE: E5 does not block the model -- it fills four frozen_cluster rows and decides core vs transition labels, so E6's cm_set, re-annotation and recount can proceed and class1b_groups.tsv be completed afterwards |
| 2026-11-17 | E5 unblocked -- fz is derived, not raw, and a validated parser already existed | The explorer dump: DATA has 416 nodes with keys acc, cls, conc, det, e1c, ev, fam, genus, id, q, seq, sf, sp, xr and NO fz. Per-site cluster assignment lives in DATA.sets -- six saved clusterings, each {view, mode, date, cl, clusters, inmsa}, where cl is a list of ints PARALLEL to DATA.nodes (-1 = unassigned); the mode=default entries are a coarse cut (ids in the low teens), the frozen one carries the ids this file uses (5, 21, 106, 131, 133, 135). SELF-CORRECTION: this was already documented. Part 3 states that explorer_cm_scan.py extract parses the DATA line and that each node gives the feature ID, the stall and the frozen cluster fz -- fz being a field that script DERIVES, and the one that produced the recorded memberships (41 12/12, 44 8/8, 5 5/5, 106 3/3, 39 4/4, 110 3/3). Writing a second parser that guessed at raw field names was the error, twice over (first fz, then a key spelled cl on DATA.sets). e5 now runs explorer_cm_scan.py extract and reads its node table; the HTML path is a fallback that selects the set by NAME (mode contains frozen, view all), reports which it chose and why, and offers --list-sets to show all six with cluster counts, since picking the wrong set would silently give wrong clusters |
| 2026-11-17 | open hypothesis: the P2-P3 insert is a cross-class feature and class 2 may be misnamed | Reported from the structural side: class 2's distinguishing features are a long PK1 and a purine between P2 and P3, resembling class1c in the second respect, so class 2 may be a subclass rather than a class. This bears on cluster 106, which has THREE purines between P2 and P3 (3/3) where cluster 5 has none (0/5) -- so the insert is not a cluster-106 peculiarity but recurs across currently separate classes and may group the elements differently from the present naming. If it holds, cluster 106 would share its insert with class 2 and class1c while sharing its triple architecture with Class_1b, and class1d would assert the very axis the insert contradicts; the question becomes whether the class 1 / class 2 split is the right axis at all. TEST: a feature matrix over the models' own seeds -- P1 length, PK1 length, presence/length/purine content of any unpaired P2-P3 insert, and the triple's identity and position relative to PK1's innermost pair -- built from the alignments, with cmemit -c plus the model's SS_cons where a provided model's seed is not to hand, and noting that PK lengths are unavailable from any CM since cmbuild reads only the primary nested SS_cons. CAUTIONS: a shared insert is weak evidence alone (single-nucleotide junction insertions recur, and purine is a two-letter alphabet) where the triple substitution is strong because all three positions moved together with each group invariant; and nothing is to be decided from three cluster-106 sequences. Open hypothesis, not a finding; changes no current call -- cluster 5 stays inside Class_1b on the triple evidence, cluster 106 stays transition_candidate:106 pending E7 |
| 2026-11-17 | the base triple carries no class information: every subclass has one, and class 2's is also C-G-C | Reported. Two consequences, both retractions of arguments made earlier the same day. (1) The argument that cluster 106 lacks a conserved C 5' of P1 and is therefore not class 1 tested the wrong position -- the triple sits against PK1's innermost pair. (2) The replacement argument, that a triple IS present and so class 1 membership is supported, was wrong because presence is universal: every subclass has a triple, so having one distinguishes nothing, and the C-G-C identity spans Class_1b AND class 2, so even that is not class-1-diagnostic. WHAT SURVIVES: the concerted substitution between cluster 5 and cluster 106 at homologous columns -- three positions moving together, each group invariant -- remains good evidence that cluster 106's triple is real and homologous to cluster 5's. That was never a claim about which class. WHAT IT NOW IMPLIES, opposite to what was written: if Class_1b and class 2 both read C-G-C, cluster 106's U.(A-U) is a NOVEL triple identity rather than a within-class substitution, making cluster 106 the outlier on the one feature where the two established classes agree. With the 2-bp P1 and the AAA insert that is three features, none matching either class fully, so a distinct element is MORE defensible while the name class1d is LESS: nothing places cluster 106 in class 1 rather than class 2, and the insert groups it with class 2 and class1c. The two measured features sort the elements differently -- the triple puts Class_1b with class 2 and leaves 106 alone; the insert puts 106 with class 2 and class1c and leaves Class_1b alone -- and neither grouping is the class 1 / class 2 split. WORKING POSITION: do not use class1d; the label stays transition_candidate:106 and the class name waits on the feature matrix and E7, since a name presupposing the axis is worse than no name. U.(A-U) is a search diagnostic for E7 alongside the 2-bp P1 and the AAA insert, and the stronger of the two distinguishing features, because the triple's positions substitute together and are invariant within each group whereas a purine at a junction is not |
| 2026-11-17 | E5 RESULT: main Class_1b clusters are 131 and 133; every B1/B2 label assigned; a satellite-cluster pattern found | Run on explorer_cm_scan.py extract's node table. Cross-checks exactly against Part 8: of 416 nodes, 265 carry a frozen cluster and 151 do not, and the per-class drops (1a 78->71, 1b 106->73, 2 17->16, dumbbell 7->4, None found 208->101) sum to exactly 151. MAIN CLASS_1B CLUSTERS 131 (69 nodes, 48 1b, 21 None found) and 133 (14 nodes, all 1b, pure), together 62 of the 73 clustered 1b nodes = 85% (58% of all 106); then 130 (7), 135 (3), 21 (1). LABELS, per stall: all five cluster-5 sites are fz 5 -> transition:5; NC_012671 10735 has no node and inherits transition:5 from MH827524 10759; LR694076 10565 is fz 21 -> transition:21; MH237596 10555 has NO NODE at that stall and inherits transition:21 from LR694076; NC_027817's accession is absent from the 416 entirely; NC_027819 10811 has no node, though that genome has an fz 7 / cls 1a node at 10587 which is a Class_1a element and not a basis for inheritance; the three cluster-106 sites are fz 106; NC_005064 11245 fz 21; MW897328 10653 fz 135; and MN587651 9782 and MN587661 9940 are fz 131, a MAIN cluster, so they would be core not transition -- consistent with their PP 0.74-0.93 alignments and with E2's reading that they are ordinary Class_1b the model cannot hold for entropy reasons. No B1 site is core. SATELLITE PATTERN, new: every cluster-5 genome carries 3-4 ordinary Class_1b elements in main cluster 131 plus the fifth copy in cluster 5 (AB981186 10240/10339/10487/10619 + 10732; MH827524 10269/10368/10514/10644 + 10759; NC_012671 10245/10344/10490/10620 + none; NC_021069 10244/10343/10489/10621 + 10735; NC_024299 10211/10349/10561/10637 + 10747; NC_008604 10246/10478/10598 + 10707) -- so the clustering, which knows nothing about any CM, independently separates the array's fifth copy from its first four, which is the P1-deviant subtype identified from the literature and the triple. CLUSTER 21 IS THE SAME PHENOMENON: LR694076 has 10185/10271 in main 133 plus 10565 in 21, and NC_005064 has 10358/10954 in main 133 plus 11245 in 21; MW897328 has 11228 in main 133 plus its own odd copy in 135. So 'a main-cluster Class_1b copy plus one odd copy in a satellite cluster' recurs, with 5, 21 and 135 as the satellites -- the transition groups are one phenomenon three times over, not scattered oddities. SCRIPT FIXES: e5 globbed nodes*.tsv by mtime and picked the annotated nodes_cl3.tsv, and the loader silently dropped the 151 unassigned rows while reporting 73 as though it were the total; it now prefers the plain nodes.tsv, reports the row accounting, cross-checks against Part 8, states both denominators, and labels per stall rather than per accession |
| 2026-11-17 | class 2 is a class 1 subclass, so the class1<x> series is right and the hold on the name is bookkeeping | Reported: class 2 is misnamed -- by structure these are subclasses of class 1, its distinctive feature is a LONG PK1, it differs from Class_1b in several further ways including an A between P2 and P3, and every subclass has a base triple with class 2's being C-G-C. That answers the axis question raised earlier the same day rather than leaving it open, and the feature table becomes a table of subclass distinctions within one class. CONSEQUENCE FOR THE NAME: cluster 106 has the class 1 architecture, so class1<x> is the right series and class1d is defensible in substance; what holds it up is that class 2 belongs in the series and is not in it, so adding a letter now leaves two inconsistencies and uninformative lettering. Order: resolve class 2's name first, then assign cluster 106's letter, and only after E7. Label meanwhile transition_candidate:106, which is a statement about evidence and survives whatever is decided about class 2. FOR THE RECORD, three positions were taken on this name today and the first two were wrong: (i) no conserved C 5' of P1 so not class 1 -- wrong position for the triple; (ii) a triple is present so class 1 is supported -- wrong because presence is universal; (iii) the axis may not be real so defer -- the axis question was real but is now answered. Stable throughout: cluster 106 is a distinct subclass with the class 1 architecture, distinguished by a 2-bp P1, three purines between P2 and P3, and a U.(A-U) triple where both Class_1b and class 2 read C-G-C, the triple being the strongest of the three because its positions substitute together and are invariant within each group |
| 2026-11-17 | the explorer has been regenerated; explorer_cm_scan.py no longer runs on it | Found by reading the four existing scripts. explorer_cm_scan.py reads n['fz'] in extract (lines 52, 55), seqs (105) and fetch (134), but the current explorer's nodes carry id, acc, sp, genus, cls, sf, det, conc, seq plus NEW fields e1c, ev, fam, q, xr -- and no fz; the per-site assignment moved to DATA.sets[].cl. So extract, seqs and fetch all raise KeyError. BLOCKS: seqs and fetch are how every cluster FASTA here was made, so the remaining gaps FJTB 64, PLLG 117 and HPPV 39 cannot have their seeds regenerated until it is fixed; annotate still works since it reads data.json. DOES NOT INVALIDATE E5: nodes_cl3.tsv is the 2026-10-29 snapshot from the previous explorer and cross-checks exactly against the documented 416-node counts, so it is the clustering this file refers to and the labels stand -- but it is a snapshot, and the e1c/xr fields suggest the new explorer carries its own class1c annotation postdating it. FIX: scripts/explorer_cm_scan_fz.patch adds resolve_fz(d) plus one call in extract, injecting fz from DATA.sets and choosing the set by name (mode frozen, view all) with the choice printed, since the wrong set would silently give wrong clusters; seqs, fetch and annotate are untouched because they read data.json. Tested on both generations: unpatched fails on the new explorer, patched handles both and seqs reproduces the same FASTA. Not yet applied. After applying, diff id+fz against $SCAN/nodes.tsv -- identical means the 10-29 clustering is current and the E5 labels hold; any difference changes those labels and the new counts are a second generation to record separately, not a correction to Part 8 |
| 2026-11-17 | correction: only `extract` is broken, and the hazard is its write order | The earlier row overstated this. seqs, fetch and annotate all read data.json, not the HTML, so the FJTB 64 / PLLG 117 / HPPV 39 seeds can be regenerated right now from the existing $SCAN/data.json -- nothing is blocked. The real problem is the write order: extract writes data.json at line 46, opens nodes.fa and nodes.tsv in write mode at line 48, and only reaches n['fz'] at line 52, so running it UNPATCHED on the regenerated explorer overwrites data.json with the fz-less schema and truncates both node files BEFORE crashing -- destroying the 2026-10-29 snapshot and breaking seqs and fetch, which work today. One command would break what is currently fine. Back up data.json, nodes.tsv and nodes.fa before extract is run again, and check whether data.json's nodes still carry fz; if not, the snapshot is already gone and must come from git or be rebuilt from nodes_cl3.tsv, which holds id and fz for all 416 nodes. DECISION: do NOT revert the explorer HTML. The generator (build_flavi150_explorer.py) is what changed, so reverting the data file only defers the problem to the next regeneration, and it discards the new fields -- e1c and xr look like a class1c call and an xrRNA call carried in the explorer itself, and six clustering sets across view all/01mM/10mM is the Mg-condition split this file reasons about throughout. Keep both, dated, per this file's own rule that reference data belongs to a reference state and not to a run. The patch gains a pre-overwrite backup of the three outputs so the crash-after-write hazard cannot recur |
| 2026-11-17 | class1b_groups.tsv written; E1-E5 complete, E6 is the live step | The 10-29 explorer snapshot was confirmed intact (data.json nodes carry fz) and backed up as data.json/nodes.tsv/nodes.fa .20261029.bak, so seqs and fetch keep working and the E5 labels rest on a preserved artefact. cm/class1b_groups.tsv written from the E5 result: 19 rows, 9 columns, no placeholders left. Groups: transition:5 x6 (the five cluster-5 sites plus NC_012671 inheriting from MH827524 10759), transition:21 x2 (LR694076 10565 and MH237596 10555 inheriting from it), transition:unknown x3 (NC_027817 10757, NC_027819 10811, OP860412 10802), transition_candidate:106 x3, transition_candidate:21 x1 (NC_005064 11245, the same satellite as LR694076), transition_candidate:135 x1 (MW897328 10653), core x2 (MN587651 9782 and MN587661 9940, both fz 131), core? x1 (OM030319 11865, provisional). KEY RESULT: no site included in the deployed model is core -- all eleven model members are transition:*, so the expanded Class_1b's additions are without exception the satellite copies rather than main-cluster elements. Four rows cannot be resolved by inheritance (NC_027817 has no node at all; NC_027819's only node is fz 7 / cls 1a, a Class_1a element; OP860412 and OM030319 have no node) and must NOT be joined into the annotation until settled -- cluster 21 is the likely answer for the two recovered P1-deviant loci by analogy, but that is inference and the rationale column says so. NC_005064.1's version is unconfirmed, seen only as a bare accession in this file. STATUS: E1, E2, E2b, E3, E4 and E5 are all complete and E6 is live -- MANIFEST, new cm_set, the groups file, cluster steps 10-13, recount against 8 models |
| 2026-11-17 | E6 commands written; the successor REPLACES Class_1b, so the set stays at 7 models | Grounded in steps 10 and 11b as recorded in Part 9. Two facts there govern it: $CMS lives in scripts/env_261021_flaviLib.sh, 'the single definition of the CM set', so editing that file is what changes the annotation and dropping a .cm into cm/ annotates nothing; and column names are the .tbl basenames including .cm, so the model's FILENAME is the column name. DECISION: replace CL_Class_1b_xrRNA_final.cm rather than add an 8th model. The successor is strictly better by the rule that accepted it (0 lost, 10 gained), so keeping both would double-count every Class_1b site and make the no-CM recount meaningless; and overlap resolution by lower E is for competing classes, not for a model against its own successor. CORRECTION: the earlier rows in this log saying 'recount against 8 models' are wrong -- the set stays at 7, with cm_set_261021 preserved as the provenance of the old annotation. SUB-DECISION left open deliberately, because it has a downstream cost: keeping the filename CL_Class_1b_xrRNA_final.cm and swapping its contents holds the column name stable and needs no downstream edits but makes the file contradict its own name, which is the failure this document exists to prevent; using the real name class1b_plusFJIS_cluster5_inf112.cm gives honest provenance and carries the builder version as Part 9's scheme requires, at the price of a column rename that every downstream consumer must follow (a grep to find them is in the E6 block). Steps 6-8 of that block -- step 11b's full post_process_peaks.py call, the tile-collapse follow-up specified in flaviLib.md, and Part 7's recount -- are deliberately NOT written as commands, because the source document elides step 11b's arguments and Part 7 records figures rather than a script; they are to be read at the source rather than reconstructed |
| 2026-11-17 | interface audit of the new scripts against cm_log.py, explorer_cm_scan.py, cm_iterate.sh, cm_round_stats.py | One real bug of mine: cm_round_stats.py fetch writes to its OUT argument EXACTLY with no suffix, so e4 passing $OUT/insertcheck and then opening insertcheck.fetchlist is why the first 11-17 run failed; e4 now passes the full filename. Everything else checks out: clog matches cm_log.py's --model/--step/--result (which escapes pipes itself and appends after the last row in its section); compare writes NEW.tbl.compare.tsv as e3 assumed; overlap takes A.tbl B.tbl NAME_A NAME_B and resolves by lower E-value, explicitly Rfam clan competition, printing to stdout; the cmstat field order read in this file is right (nseq f[3], eff_nseq f[4], clen f[5], bps f[7], bifs f[8], relent f[10]); and every cm_iterate.sh flag cm_candidate.sh passes is valid, with the caveats that it requires an already calibrated CM, defaults to --incE 1e-10, and writes its own run-log rows when given --doc. Two notes: cm_log.py's Last updated regex wants a bare date and a period, so it never fires on this file's parenthetical line, which is maintained by hand; and nodes.tsv has no acc or stall column, so explorer_class1b_clusters.py works only via its fallback of splitting id on the pipe |
| 2026-11-17 | the deployed Class_1b successor is named `class1b_v2_inf112.cm`, and Part 9 gains a rule for model versions | DECIDED, closing E6's open sub-decision. The two options were to keep the filename CL_Class_1b_xrRNA_final.cm and swap its contents (stable annotation column, no downstream edits, but a file that contradicts its own name, with the MANIFEST md5 as the only record of which model produced which table) or to deploy under a new name (honest provenance, at the cost of a column rename to chase downstream). NEW NAME, since silently changing what a named file contains is the exact failure this document exists to prevent. The name is class1b_v2_inf112.cm, so the annotation column becomes class1b_v2_inf112.cm_hit: class1b keeps the column recognisable as THE Class_1b column and matches the lowercase convention of the models built here (class1c.cm, cl3..., cl4_v9) rather than the provided CL_*_final names; v2 marks it the successor to the provided model, which is v1 by implication; and _inf112 carries the builder version as Part 9's scheme requires, non-negotiable here because the whole Class_1b line is 1.1.2. NOT the build name class1b_plusFJIS_cluster5_inf112.cm: plusFJIS_cluster5 says HOW the model was made, which belongs in MANIFEST.tsv as build_path and in this log, not in every downstream table for the rest of the project -- and Part 9's stage scheme already renames on acceptance (cand_/conf_ -> a clean name), so renaming at deployment is the convention rather than an exception. SCHEME GAP FILLED: the stage scheme covered new candidates becoming new classes but said nothing about a new version of a model that already annotates, so Part 9 gains 'Versions of an existing model' -- <family>_v<n>_inf<ver>.cm, family name retained so the column stays recognisable, build name not surviving deployment, a version REPLACING its predecessor in the annotating set rather than joining it (two versions of one model would double-count every shared site, and the lower-E overlap rule is for competing classes, not a model against its own successor), the predecessor staying in its old cm_set as the provenance of the tables it produced, and a version bump requiring a recorded grep sweep because column names are the .tbl basenames including .cm. NEXT ACTION IS THE SWEEP, before E6 runs: grep -rn "CL_Class_1b_xrRNA_final" ~/Desktop/viromelib --include="*.py" --include="*.R" --include="*.sh" --include="*.md" \| grep -v CM_CANDIDATES.md |
| 2026-11-17 | scope correction, the sweep result, and E8: the unit may be positional, so E6 is held | THREE THINGS. (1) SCOPE CORRECTION, my error in wording: 'the model to deploy is cluster 5 alone' is about which SEED-ADDITION SET survived E2 (cluster 5's six sequences, not strong/newvirus/all/c106), NOT about which elements the model covers. The accepted model already recovers four seed loci the original scored below inclusion -- PaRV xr4 NC_027817 543 22.3->28.3, MECDV xr1 NC_027819 561 22.3->27.7, CFAV xr3 LR694076 476 and MH237596 478 19.9->23.4 -- so CFAV's DOWNSTREAM element is already in twice over: CFAV_NC_001564-2_10555-10632_xr3 is a named sequence of the provided seed and the rebuild is what finally includes it in the library. And LR694076 10565 is fz 21, so the model already spans two frozen clusters and is not a one-cluster model on the clustering's own terms. The build name plusFJIS_cluster5 is the source of the confusion, a further reason not to carry it downstream. (2) THE _inf112 JUSTIFICATION WAS OVERSTATED: Part 9's rule is CONDITIONAL -- models carry _inf<ver> when built by a NON-DEFAULT Infernal -- and 1.1.2 is non-default here, so it applies, but it is not a blanket requirement and class1c.cm correctly has no suffix. The suffix is also redundant as data, since the builder version is in the .cm header, which is what cm_version reads and is authoritative where a filename can be wrong; it is in the name because the filename IS the annotation column and so carries the version into every downstream table, and because a 1.1.5 rebuild of the same seed is a different model (88/48.62/81/19/2 vs 88/87.08/78/18/2) that must not replace this one under one name. (3) E8 ADDED AND E6 HELD. PMC7527734 defines the element POSITIONALLY -- the P1-deviant subtype is found in downstream copies, xr3/xr4 -- and E5 found the same from the other direction, the clustering separating the array's last copy into a satellite three times over (5, 21, 135). No step has tested the positionally-defined set: E2 tested a bit-score cut, newvirus a novelty cut, and 11-03 tested the remaining sub-threshold sites ONE AT A TIME (kamiti NC_005064 11245 fz 21 loses OP860412 297; phaiomys MW897328 10653 fz 135 is 3'-truncated at PP 0.622 and loses three). Adding them as a SET is a different test, because a bit-score cut adds whatever is marginal and flattens emissions (eff_nseq 50.24->25.58 on 38 seqs) whereas a few sequences sharing a DEFINING feature can sharpen the distinguishing columns. Also outstanding: AEFV NC_012932 xr3, 13.2 b under the FJIS model, a downstream copy in no addition set. COUNTEREXAMPLE already in E5's data and printed by e8: MW897328's odd copy 10653 is UPSTREAM of its main-cluster copy 11228, so 'last copy' is not the whole definition and that array needs reading by eye. E6 held because cluster steps 10-13 and the no-CM recount are the expensive part while E8 costs one cmbuild and one cmsearch; if E8 passes, v2 should BE the positional model and the name is already right. New script class1b_arrays.py (modes nodes and tbl, two independent views, converts tbl hits to genomic coords via each sequence name's own offset) and cm_class1b_E.sh gains e8/e8b. (4) GREP SWEEP RUN, 49 hits, only THREE live consumers: build_pllg_outputs.py:142 and plot_combined_peaks.R:50 both bind the column name and must change, flavi_env.sh:29 is the predecessor path and stays. All the rest are archived/dated run logs, md5 provenance tables, or .sto/.cm paths for the predecessor, none to be edited. SURPRISE: scripts/env_261021_flaviLib.sh is NOT in the sweep, so $CMS does not name models by basename and is a directory or glob -- E6 step 4 may be a no-op, and if it is a glob then 'replaces, does not join' is enforced by the old model being physically ABSENT from cm_set_261117, not by editing a list. Check with: grep -n 'CMS\|cm_set\|CMDIR' scripts/env_261021_flaviLib.sh |
| 2026-11-17 | E8 first run: the script filtered out the sites it was asking about; KC181923 carries an unrecorded cluster-21 satellite | TWO BUGS, ONE FINDING, ONE STALE PATH. BUG 1, the serious one: class1b_arrays.py filtered cls == '1b', and the explorer's cls is CM-DERIVED, so every copy the Class_1b model misses is labelled 'None found' -- which is every satellite copy by construction, the whole reason the expansion exists. The run therefore reported 106 rows over 73 accessions with NO satellite copy in AB981186, MH827524, NC_008604, NC_012671, NC_021069, NC_024299, LR694076 or NC_005064, every one of E5's documented satellites, and MW897328 absent entirely. Same error as the two accession-based greps corrected earlier today: using a CM-derived label to ask about what the CM misses. Fixed by keeping cls in {1b, None found}, dropping 1a/2/dumbbell (a Class_1a copy in the same genome is a different element, not an array member -- NC_027819's fz 7 node at 10587), and restricting to genomes with at least one confirmed 1b copy. BUG 2: 151 of 416 nodes have no frozen cluster and fz 'None' was read as a satellite, which manufactured all four reported counterexamples (MH282908, MT276199, NC_020902, NC_027817 -- all unclustered) and two of the three confirmations (MZ229974, OU592965); unassigned is now its own verdict. BUG 3, trivial: e8 wrote BASE=$C5_library_tbl, which bash reads as one identifier, so it died on 'unbound variable' under set -u before reaching view 2; now ${C5}_library.tbl. THE ONE REAL RESULT, which survived because its node is cls 1b: KC181923 has copies at 10492 (fz 133), 10630 (fz 133) and 10929 (fz 21) -- so a genome this file lists (11-03) as 'already Class_1b, cluster 133' carries a CLUSTER-21 SATELLITE AS ITS 3'-MOST COPY, in no addition set. Fourth instance of the satellite pattern, missed by E5 because E5 labelled only the B1/B2 stalls instead of enumerating every array. DECISIVE CHECK, and it must be positional not accession-based for the reason above: is KC181923 859, one of the nine marginal 23.4-27.8 b sites E2 loses, the same element as genomic 10929? If the nine marginal sites ARE the satellite copies then E2's fragility finding and the positional hypothesis are one result, and seeding them deliberately is the answer rather than leaving them at the inclusion threshold. Run: hits_at_stall ${C5}_library.tbl KC181923:10929 (signature is tbl first, then ACC:stall -- flavi_env.sh line 153). STALE PATH: ~/Desktop/viromelib/scripts/env_261021_flaviLib.sh DOES NOT EXIST, which is why the grep sweep missed it -- not because $CMS is a glob. This file's claim that $CMS lives there, 'the single definition of the CM set', is inherited from the 261021 run log and was never re-checked, so everything E6 step 4 says about editing it is unverified. Locate it before E6: find ~/Desktop/viromelib -type f -name 'env_*' and grep -rln 'CMS=' ~/Desktop/viromelib --include='*.sh' -- ONE -name and no -o, because find applies its implicit -print only to the last term of an -o expression, so the two-pattern form I first gave would have silently hidden any env_*flaviLib* match. $FLAVISCRIPTS is flaviLib/scripts, whose listing contains only flavi_env.sh and no env_* file, so the file is not there either. Do NOT create it |
| 2026-11-17 | E8 view 1: the positional hypothesis holds for 8/8 assigned satellites, and there are TWO satellite positions; view 2 contradicts E3 on NC_008604 | VIEW 1, 314 rows / 73 accessions with a 1b copy / 35 multi-copy arrays. EVERY satellite the frozen clustering assigned to cluster 5 or 21 is its array's 3'-most copy, 8 of 8: AB981186 10732, MH827524 10759, NC_008604 10707, NC_021069 10735, NC_024299 10747 (all fz 5), KC181923 10929, LR694076 10565, NC_005064 11245 (all fz 21). Of the 22 reported failures, 20 carry (uncl) -- the 3'-most copy has no frozen cluster, an open case not a counterexample, and a reminder that 151 of 416 nodes are unassigned. THREE ARE REAL AND THEY ARE ONE PATTERN: LC602141 10648, MT210614 10562 and MT210620 10652 are all fz 39 at the array's 5' END, in genomes whose 3'-most copy IS a satellite (fz 135 at 10820, 10740, 10840). So SATELLITES OCCUPY THE ARRAY'S ENDS rather than only its 3' end, and cluster 39 -- HPPV 39, a pending gap in the Part 1 register -- is consistently the 5'-terminal copy in three genomes. Only genuine counterexamples left: MW897328 (3'-most 11228 is main fz 133, satellites upstream) and ON949931 (fz 106 mid-array at 10608). VIEW 2: its verdict line was my bug -- in tbl mode MAIN can never match an incl/sub label, so every INCLUDED hit was counted as odd, giving 'holds for 0, fails for 30'; the odd copy in that view is a SUB-THRESHOLD hit, now fixed. What view 2 does establish: FIVE OF THE SIX ADDED CLUSTER-5 SEQUENCES ARE INCLUDED AND THE SIXTH IS NOT -- AB981186 10733 23.4 !, MH827524 10760 26.6 !, NC_012671 10736 23.4 !, NC_021069 10737 24.9 !, NC_024299 10746 30.1 !, but NC_008604 10709 is 20.9 b '?', NOT INCLUDED. This CONTRADICTS the E3 row, which says NC_008604 10707 'was already an included hit'. Either E3's reason is wrong and the locus was never included by either model (conclusion survives, but a seed sequence is not recruited by the model built from it), or it was included by the original and is not now, in which case the accepted model LOST an included hit and fails the no-loss rule it was accepted under (94 seqs, 10 gained, 0 lost). Reading 2 would reopen the acceptance, so CHECK BEFORE E6 MOVES: hits_at_stall "$SAT/r0/search.tbl" NC_008604:10707 and hits_at_stall "${C5}_library.tbl" NC_008604:10707. THREE MORE VIEW-2 OBSERVATIONS: KJ741266 10930, LC536088 10908 and KC181923 10928 are all included at EXACTLY 29.0 b, three Aedes flavivirus 3'-most copies scoring identically, and two of those loci have NO explorer node, so the node set is incomplete relative to the tbl; the two views do not enumerate the same population (NC_005064 5 nodes vs 3 hits, MW897328 5 vs 2), so expecting their counts to agree was naive and they must be compared by POSITION; and ON949931 10829 is NOT the cluster-106 locus (fz 106 is at 10608, and 10275 is the 30.2 b hit E2b found was lost when 106 was admitted), so it is a third locus and adding it is not E2b's experiment. CORRECTION TO MY OWN EARLIER ROW: KC181923 859 is NOT one of E2's nine lost -- it is one of E2b's nineteen -- and view 2 shows KC181923 10928 included at 29.0 b, not marginal. CANDIDATE LIST FIXED, three ways: --seed excludes loci already in the accepted seed (NC_008604 10709 was in the printed list and is already seeded); --floor, default 20.0 b, excludes NC_020902 11020 at 9.5 and OM030329 10645 at 14.9, nowhere near the 23.4-27.8 band; but a floor would ALSO have discarded NC_005064 11245 at 18.5 b, the one candidate BOTH views support, so nodes mode now writes satellites.tsv and tbl mode takes --satellites, which exempts a cluster-backed candidate from the floor, and e8 chains the two |
| 2026-11-17 | E8 CLOSED: the positional hypothesis is confirmed and there is nothing to add; clusters 39 and 135 are pegiviruses, not a second ISF position | SPECIES NAMES SETTLE IT. With species carried through from nodes.tsv, cluster 5 (5 copies: Culex flavivirus NC_008604 10707, Mosquito flavivirus AB981186 10732 and NC_021069 10735, Nienokoue virus NC_024299 10747, Quang Binh virus MH827524 10759) and cluster 21 (3 copies: Aedes flavivirus KC181923 10929, Cell fusing agent virus LR694076 10565, Kamiti River virus NC_005064 11245) are ENTIRELY INSECT-SPECIFIC FLAVIVIRUSES and 3'-most in 8 of 8. Cluster 135 (4 copies) and cluster 39 (3 copies) are ENTIRELY RODENT PEGIVIRUSES -- Phaiomys leucurus pegivirus MW897328, Rodent pegivirus LC602141, Wenzhou Rattus tanezumi pegivirus 1 MT210614, Wufeng Niviventer fulvescens pegivirus 1 MT210620 -- and cluster 39 is ALREADY in the Part 1 gap register as HPPV 39, 'rodent pegiviruses, explorer cluster 39', 4 sites, priority 5. RETRACTION of my own row from earlier today: 'satellites occupy the array's ends' merged two genera and is wrong. Within ISFs the hypothesis holds WITHOUT EXCEPTION, all 3'-most; the 5'-terminal satellite is a pegivirus phenomenon in a different genus. The only ISF exception is Kilpisjarvi flavivirus ON949931, whose deviant copy is mid-array at 10608 and is cluster 106, already rejected by E2b and absent from the Class_1b tbl entirely, which is consistent. VERDICT: every ISF positional element is either in the seed (NC_008604 10707, AB981186 10732, NC_021069 10735, NC_024299 10747, MH827524 10759, NC_012671 10735) or already annotated by the accepted model (KC181923 10928 29.0 !, LR694076 10565 23.4 !, MH237596 10555 23.4 !, NC_027817 10756 28.3 ! -- the last three recovered rather than seeded), EXCEPT Kamiti River virus NC_005064 11245 at 18.5 b '?', which was tested alone on 11-03 as kamiti and rejected because it loses OP860412 297. So the candidate list reduces to ONE sequence whose rejection is already recorded, e8b has no experiment left and is STRUCK, and E6 IS UNBLOCKED. DEEPER READING: the positional hypothesis was right and the accepted model IS the positional model -- cluster 5 was never the unit, it is the ISF 3'-terminal subtype of PMC7527734, and the 11-02 rebuild captured it by seeding cluster 5 and RECOVERING the rest (PaRV xr4, CFAV xr3 in two isolates). That is why E2's broadenings all failed: there was nothing left of this element to add. NEW FOR THE HPPV WORKSTREAM, not for E6: clusters 39 and 135 are two positions in ONE pegivirus array, 39 consistently 5'-terminal and 135 3'-terminal in the same three genomes, so they should be aligned together rather than as separate clusters. THE 13 PREVIOUSLY UNMENTIONED GENOMES ARE NOT ISFs: with species attached they are hepaciviruses (BK013349 Bat hepacivirus, KX905133 Norway rat hepacivirus 1, MN564793 Rodent hepacivirus), pegiviruses (KC796087 Bat pegivirus, MT210615, MT276199 Pegivirus equi, NC_020902 Equine pegivirus 1, NC_024377 Simian pegivirus, NC_030291 GB virus-D, OP860412 Eospalax rufescens pegivirus), pestiviruses (KY370100 Pestivirus R, KY370101 Pestivirus Q, MH282908 bat pestivirus, NC_025677 Norway rat pestivirus) and MZ229974 Tamana bat virus plus OU592965 Zikole virus -- non-Flavivirus Flaviviridae, belonging to the priority-8 clade pools and NOT to E7, whose target list is ISF genomes. Their 20 unclustered 3'-most copies are an observation about those genera and bear on nothing in E6. SCRIPT FIXES: species/genus now carried from nodes.tsv into the listing, into satellites.tsv (which gains species, genus, n_copies, is_3prime_most) and into a satellites-by-cluster summary; the tbl verdict uses 'sub' as the odd label; --seed, --satellites and --floor added; and the seed exclusion failed on its first attempt because seed names carry the library sequence name plus a RELATIVE subsequence range (ACC.1\|10000-11000/708-788), so matching raw numbers against a genomic position compared 708 with 10707 -- now converted through the offset as the tbl view does, which is what reduced the candidate list from 2 to 1 |
| 2026-11-17 | NC_008604 10707 resolved: E3's reason was wrong, its conclusion stands, and the acceptance holds -- E6 fully unblocked | hits_at_stall on both models at NC_008604:10707 (offset 10133, stall rel 575). ORIGINAL CL_Class_1b_xrRNA_final: four included hits in that sequence at rel 113-194 32.7 b, 232-312 44.0, 345-419 47.2, 465-543 42.5, and NOTHING at the stall -- not included, not even reported. ACCEPTED class1b_plusFJIS_cluster5_inf112: the same four at 32.7/45.8/48.6/43.5 plus rel 577-677 at 20.9 b '?', which begins 2 nt past the stall. READING 1 CONFIRMED: the locus was never an included hit by either model, so E3's stated reason is wrong, but its conclusion 'NC_008604 10707 is NOT a gain' is right because a '?' hit is no new annotation. NOTHING WAS LOST, so the no-loss rule and the 11-02 acceptance are intact and E6 has nothing gating it. What the addition bought at this locus is a hit where the original model had none -- the weakest form of success, consistent with E2's capacity argument, this being the sixth of six additions and the only one below inclusion, and it explains why the element was uncatalogued: the original model does not see it. SCRIPT FIX: hits_at_stall used a +/-1 tolerance and so printed a flat 'no' for a hit 2 nt from the stall, which reads as 'absent' and was within one reading of reopening the acceptance for no reason; it now prints a dist column and says 'near <n> nt' within 10 nt, the stall being the explorer feature's own start while a hit's 5' boundary is the model's. RETRACTION: the two earlier 'command not found' results were diagnosed by me as a stale flavi_env.sh; the installed file is d38c8ffdee67696cb75f98d867d56f36 with hits_at_stall at line 154, i.e. current, so that diagnosis is withdrawn and the cause is unexplained. The error that WAS mine and is recorded in Part 9: I checked the md5 against a local copy rather than the installed file, and I gave the signature as 'ACC stall tbl' when flavi_env.sh line 153 says 'tbl ACC:stall' |
| 2026-11-17 | $CMS has no definition anywhere on this machine; E6 will set it explicitly | SEARCHED THE WHOLE TREE: find ~/Desktop/viromelib -type f -name 'env_*' returns NOTHING, and grep -rln 'CMS=' ~/Desktop/viromelib --include='*.sh' returns NOTHING. $FLAVISCRIPTS is flaviLib/scripts, whose listing holds flavi_env.sh and no env_* file. So this file's claim that '$CMS comes from scripts/env_261021_flaviLib.sh, which is the single definition of the CM set' -- an ORIGINAL line, 3393 of the uploaded version, now rewritten -- is wrong on this machine. It was inherited from README_261021_flaviLib_150x150.md, and the 261021 annotation was most likely run on the HPC: vintage_md/flaviLib.md records tbl paths under /groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/..., so the env file probably lives there. $CMS IS NOT A GLOB: steps 10 and 11b iterate it as 'for CM in $CMS', so it is a space-separated list of model basenames INCLUDING .cm, consistent with column names being the .tbl basenames including .cm, and a missing list cannot be globbed around. CONSEQUENCE, and it improves E6: define $CMS explicitly in the E6 block rather than recreating the env file or depending on a variable from a shell that no longer exists. Recover the seven current entries from the tbl files that produced the current annotation -- ls $HOME/Desktop/viromelib/work/06_infernal/260807_trueRef/*.tbl, each basename minus .tbl being one entry -- then write the list out in full with class1b_v2_inf112.cm in place of CL_Class_1b_xrRNA_final.cm, so the replacement is VISIBLE in the command instead of implied by a file's contents. E6 step 4 rewritten accordingly. ALSO FIXED: the find command I first gave, 'find P -name A -o -name B', applies the implicit -print only to the LAST term, so it would have silently hidden any env_*flaviLib* match; every copy in this file is now a single -name with -type f. INTEGRITY NOTE: the count of original lines this file has rewritten moves from 31 to 32 with this row, the 32nd being line 3393 |
| 2026-11-17 | env_261021_flaviLib.sh FOUND on the cluster; E6 is a two-machine deployment and three things in its plan were wrong | The file is at /groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib/scripts/env_261021_flaviLib.sh. The laptop searches were negative because the ANNOTATION PIPELINE IS NOT ON THE LAPTOP: the CM development work is local, step 10 and 11b are on the HPC. So the path recorded in this file was never stale, only incomplete -- it lacked the machine -- and my 22:17 conclusion that no definition exists is superseded. $CMS VERBATIM, seven entries: CL_Class_1a_xrRNA_final.cm, CL_Class_1b_xrRNA_final.cm, CL_Class_2_xrRNA_final.cm, cl3_NAR_2025.align.mpkadded.edited.confident.dedup.IDcurated.SS_cons.cm, class4_cl4_v9_20260824.cm, class1c.cm, dumbbell_RF00525.cm. AMBIGUITY SETTLED: the set holds class4_cl4_v9_20260824.cm and NOT cl4.cm; the md5sum line in README_261015-261019 lists both, which is why the count read as eight. THREE CORRECTIONS TO THE E6 PLAN. (1) THERE IS NO cm_set_<yymmdd> ON THE CLUSTER: CMDIR is $ROOT/work/06_infernal/cm, flat, and the annotating set is defined ONLY by the $CMS list, so 'the predecessor must be physically absent from cm_set_261117' is wrong -- nothing is deleted or moved, the predecessor stays on disk as the provenance of its .tbl, and dropping its name from $CMS is the whole of the replacement. The cm_set_ scheme is a laptop convention that does not travel. (2) $DS MUST BE BUMPED or the 261021 annotation is OVERWRITTEN: DS=261021_flaviLib_150x150 drives POSTPROC_BASE=$ROOT/work/07_postproc/$DS and LOG, so re-running 11b under the same DS writes over the annotation this file's gap counts rest on. Set DS=261117_flaviLib_150x150 and point ANNOT_OLD at the 261021 outputs, which is what the file already does for the superseded 260903 run. (3) THE ENV FILE VERIFIES THE SWAP FOR FREE: its closing loop checks $TBLOUT/${_cm}.tbl for every $CMS entry and prints 'cmsearch still needed: <model>' or 'all 7 CM .tbl present', so after the swap it names class1b_v2_inf112.cm until step 10 runs -- no extra check needed. Also noted: the file WARNS AND NEVER EXITS by design, since exiting a sourced file would close the login shell, so a missing path stops nothing and the warnings must be read; and TBLOUT is keyed to the REFERENCE (260807_trueRef), shared across runs, so the old Class_1b .tbl stays as provenance and the new one is added beside it. E6 rewritten as block A on the laptop (stage the .cm, class1b_groups.tsv and MANIFEST.tsv, record md5 and builder version, scp to $CMDIR) and block B on the cluster (copy env_261021 to env_261117, sed the three lines, source, step 10 which skips existing .tbl so only the new model is searched, then 11b per condition under the new DS). The cluster's own Infernal version is to be recorded in MANIFEST, since it produces the .tbl |
| 2026-11-17 | E6 block A written as a script; two bugs in it worth recording | cm_deploy_class1b_v2.sh stages the three files for transfer and is check-only by default, because the two likeliest failures are silent: $C5.cm might not be the accepted 11-02 model, and class1b_groups.tsv might still be in ~/Downloads rather than at its Part 9 home in $CMDIR. It verifies both, resolves the conda env from the model header via cm_env_require, warns if cmstat is not nseq 94 / clen 81, and with --stage writes MANIFEST.tsv with md5, builder version, the five cmstat fields and the build_path the deployed name drops. BUG 1, instructive: the variable holding the groups-file path was named GROUPS, which is a BASH BUILTIN ARRAY of the caller's group IDs -- the assignment is silently ignored and ${GROUPS} expands to the primary GID, so the script reported 'ok groups 0' and would have tried to copy a file named 0. Renamed GROUPSFILE. Same class of error as BASE=$C5_library_tbl in e8, where the underscore made one identifier: a name that LOOKS like a variable reference and is not. BUG 2: cm_env_require prints its refusal on stdout and returns non-zero, so MENV=$(cm_env_require ...) \|\| fail=1 assigned the FATAL text to MENV and then printed it as though it were the env name; the status now decides and MENV is cleared on failure |
| 2026-11-18 | E6 section was DUPLICATED in this file; plus three clarifications asked for: what block B is, which cmsearch runs, and when model names change | DUPLICATION, my error: the splice that inserted 'Where E6 actually runs' used the index of the FIRST '#### Deployed name' heading, which sits BEFORE the block being replaced, so everything from that heading onward was re-appended. The file carried two 'Deployed name' headings and two 'The commands' blocks, the second still showing the superseded cm_set_$V scheme, 'rm $CMDIR/cm_set_$V/CL_Class_1b_xrRNA_final.cm' and a grep against the nonexistent laptop env path -- i.e. the stale copy actively contradicted the corrected one. Deduplicated, with the three unique paragraphs salvaged into 'The three follow-ups'. Same class as the 29->56 splice error earlier in this project: a string index taken without checking it falls where the edit is meant to go. CLARIFICATION 1, BLOCK B is the CLUSTER half of E6 -- dated copy of env_261021_flaviLib.sh, three seds (CMS swap, DS bump, ANNOT_OLD), source, step 10, step 11b per condition. Block A is the laptop half and is now cm_deploy_class1b_v2.sh. CLARIFICATION 2, THE DEPLOYED CMSEARCH IS NOT THE DEVELOPMENT ONE: step 10 runs 'cmsearch --tblout ... --cpu 8 <cm> <fa>' with NO --toponly, so BOTH STRANDS are searched, and with the default --incE 0.01; every search in Parts 1-8 used --toponly, and cm_iterate.sh uses --incE 1e-10 while the reciprocal checks use -E 100. The six existing .tbl were made the same plain way so the annotation is internally consistent, but deployed tables and this file's development numbers are NOT directly comparable. Check after step 10: plus-strand included hits in the deployed .tbl should equal the development count, and any difference should be minus-strand artefacts of the library's plus-strand tiles. CLARIFICATION 3, WHEN NAMES CHANGE: the annotation column IS the .tbl basename, which is the model's filename, so a filename is a schema and not a label. Rule now written: a model's filename changes when, and only when, the MODEL changes. Renaming an unchanged model costs a cmsearch, a new column everywhere and edits to every consumer, and buys only tidiness; renaming a rebuilt model costs the same but the alternative is a new model under an old name. So class1b is renamed at E6 and nothing else is, even though three of the seven do not conform: CL_Class_1a_xrRNA_final.cm and CL_Class_2_xrRNA_final.cm are provided-model names, cl3_NAR_2025.align.mpkadded.edited.confident.dedup.IDcurated.SS_cons.cm is a 56-character BUILD NAME that leaked into deployment and is the clearest case of the rule being broken -- rename it when cl3 is next rebuilt, not before -- and class4_cl4_v9_20260824.cm carries a version and a build date. TWO NAMES, NOT ONE: a model also has an internal NAME that cmsearch writes into the tblout's query column, and those are already clean (class1a class1b class2 class3 class1c cl4_v9 Flavivirus_DB), so the ugliness is confined to filenames. The successor's NAME is probably still class1b and would then disagree with its filename -- harmless, since the column keys on the filename, but it must go in MANIFEST rather than be discovered later, and changing it means cmbuild -n plus recalibration, hence different bytes and md5, so it is changed BEFORE staging or not at all. cm_deploy_class1b_v2.sh now prints NAME, flags the mismatch, and carries cm_name as a MANIFEST column |
| 2026-11-18 | a script that uses flavi_env.sh must PRINT the paths it resolved | cm_deploy_class1b_v2.sh ran correctly on its first use -- it confirmed the model is the accepted one (nseq 94, eff_nseq 50.24, clen 81, 19 bp, 2 bif, the exact 11-02 signature) and resolved infernal112 from the model's own 1.1.2 header, then refused to stage because class1b_groups.tsv was not found. Two faults in it, both mine. (1) THE SEARCH LIST OMITTED $INFERNAL, which is flaviLib/work/infernal and is where the file actually is; it now looks in $CMDIR, $INFERNAL, $FLAVI/work/infernal, $PWD, ~/Downloads and the scripts dir, takes --groups <path> for anywhere else, and lists every location it tried when it fails. With --stage it also installs the tsv at its Part 9 home in $CMDIR if absent, and if a DIFFERENT copy is already there it leaves it alone and says so rather than overwriting. (2) IT NAMED $CMDIR IN AN ERROR WITHOUT SAYING WHAT $CMDIR IS. The env script is what keeps paths consistent, and the price is that a command's target is invisible to whoever runs it; flavi_env.sh --check prints its paths and every other script here must do the same. This one now prints FLAVI, INFERNAL, VIR_INF, CMDIR, CMSET, C5 and STAGE before any check. FOR THE RECORD, the path that causes the confusion: $CMDIR is viromelib/work/infernal/cm, the SHARED viromelib tree, NOT flaviLib/work -- the models and MANIFEST.tsv are shared with viromelib, while the flaviLib build tree under $INFERNAL (flaviLib/work/infernal) is where candidates are developed. $CMSET is $CMDIR/cm_set_261021, the laptop mirror of the cluster's flat cm/ directory |
| 2026-11-18 | local vs cluster written down: two env scripts, two trees, and $CMDIR resolves differently on each | Asked after the tsv was moved. THERE ARE TWO MACHINES AND TWO ENV SCRIPTS. LAPTOP: flaviLib/scripts/flavi_env.sh, root ~/Desktop/viromelib, CMDIR=work/infernal/cm, the seven models in $CMDIR/cm_set_261021 as a snapshot, and this is where candidates are built, calibrated, searched for development and clustered. CLUSTER: scripts/env_261021_flaviLib.sh, root /groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib, CMDIR=work/06_infernal/cm with the seven models FLAT and no cm_set_ directories, TBLOUT=work/06_infernal/260807_trueRef, and this is where the ANNOTATION happens: step 10 cmsearch and step 11b post_process_peaks.py, i.e. the cm_hit columns. $CMS is defined on the cluster and ONLY there. THE TRAP: both env scripts define $CMDIR, to different paths, under trees with different names -- work/infernal against work/06_infernal -- so a command copied from one machine's notes to the other RESOLVES and is WRONG. Same for $ROOT. When writing a cluster command, spell the path out or name the machine in the same breath. WHAT IS SHARED is the model bytes: cm_set_261021's seven are byte-identical to the cluster's work/06_infernal/cm (Part 6, Model identity, 10-27), so the laptop mirror is faithful and development comparisons here are meaningful, but it is a snapshot in a differently-named directory, not a synced copy. WHICH BLOCK RUNS WHERE: block A is the laptop (cm_deploy_class1b_v2.sh, staging and scp), block B is the cluster (dated env copy, three seds, step 10, step 11b). class1b_groups.tsv goes to BOTH -- its Part 9 home is the laptop's $CMDIR and a copy travels in the scp to the cluster's $CMDIR beside the models. SCRIPT: cm_deploy_class1b_v2.sh now also searches $INFERNAL/cm and $VIR_INF, and its path banner states that it is the LAPTOP and warns that the cluster's $CMDIR is a different path |
| 2026-11-18 | checks pass; the staged model's internal NAME is set to class1b_v2 by editing the header, not by rebuilding | cm_deploy_class1b_v2.sh ran clean on the laptop: model and seed present, class1b_groups.tsv found at flaviLib/work/infernal/cm/class1b_groups.tsv (20 rows), env resolved to infernal112 from the model's 1.1.2 header, and cmstat exactly the accepted signature -- nseq 94, eff_nseq 50.24, clen 81, 19 bp, 2 bif. ONE DECISION SURFACED: the model's internal NAME is still the build name class1b_plusFJIS_cluster5_inf112, which cmsearch writes into every tblout row's query column -- a build name surviving into the DATA, which is worse than one surviving into a filename. DECIDED: NAME becomes class1b_v2. Not the filename class1b_v2_inf112: the set's NAME convention is a SHORT CLASS LABEL and never the filename, as Part 6 records -- class1a class1b class2 class3 class1c cl4_v9 Flavivirus_DB -- and CL_Class_1b_xrRNA_final.cm itself carries NAME class1b, so the two names have never matched and are not meant to. The decisive reason for _v2 rather than plain class1b is that BOTH .tbl files live in the one shared TBLOUT=work/06_infernal/260807_trueRef, so NAME class1b in two of them would make the query column ambiguous. METHOD: edit the NAME header line of the STAGED copy. NOT cmbuild -n plus cmcalibrate, which would also work and must not be used, because recalibration is STOCHASTIC -- it rewrites the ECM lines and shifts E-values, and seven of the ten cluster-5 sites sit at 23.4-27.7 b where a shift can change inclusion. Editing one header line cannot move a score. The build artefact at $C5.cm keeps its build NAME so provenance is untouched. --set-name verifies two invariants before accepting the change: that diff of everything except the NAME line is empty, and that cmstat is identical; it restores the pre-edit copy and exits non-zero if either fails. The md5 changes, which is why the NAME is set BEFORE the md5 goes into MANIFEST |
| 2026-11-18 | staging ran; two MANIFEST bugs, one of which would have looked like a corrupted transfer | --stage --set-name class1b_v2 worked: class1b_groups.tsv installed at its Part 9 home in the laptop's $CMDIR, NAME changed from class1b_plusFJIS_cluster5_inf112 to class1b_v2 with both invariants verified (no line but NAME differs; cmstat identical at 94 50.24 81 19 2), and the three files written to flaviLib/work/infernal/deploy_261117. TWO BUGS IN MANIFEST.tsv, both mine. (1) THE DANGEROUS ONE: the MANIFEST block stood ABOVE the --set-name block, so MANIFEST recorded the PRE-rename md5 2cc8ae65aa95e45a46f91c5b5eb8e8a8 while the script printed the POST-rename md5 fa9768bce80ba3b6cbc57e9f238c097d as the value to verify after transfer. Running md5sum on the cluster and comparing against MANIFEST would have shown a mismatch and read as a corrupted scp, when in fact both files were fine and the manifest simply described a file that no longer existed. This directly contradicted the rule written the same day -- set NAME BEFORE the md5 goes into MANIFEST -- which the code did not implement. Reordered: --set-name now runs first and MANIFEST describes the file that actually ships. (2) The printf header lacked cm_name while the data row carried it, so the emitted table was 9 header fields against 10 data fields and every column after model was shifted by one -- md5 displayed under md5 was really the NAME, built_by_infernal was the md5, nseq was 1.1.2, and so on. An earlier edit meant to add cm_name had silently failed to apply because the search string had a trailing space, the same failure mode that left the NAME advice stale an hour earlier; fixed by editing on line ranges and verifying the field counts match. Also added head -1 to the cmstat captures, which were picking up a trailing line and printing 'cmstat identical (94 50.24 81 19 2\n)'. LESSON RECORDED IN PART 9: read MANIFEST.tsv BEFORE the scp, not after -- it is the thing that says what you are shipping, and a manifest that disagrees with its artefact is worse than none |
| 2026-11-18 | E6 BLOCK A COMPLETE and verified | Re-staged with the corrected script (md5 280f9dfc6480d8f7edb7a36d9e918581). class1b_groups.tsv now found at its Part 9 home, the laptop's $CMDIR = viromelib/work/infernal/cm, 20 rows, installed by the previous run. NAME changed class1b_plusFJIS_cluster5_inf112 -> class1b_v2 with both invariants verified: no line but NAME differs, and cmstat identical at 94 50.24 81 19 2 (the stray newline in that message is gone too). MANIFEST.tsv now has 10 header fields against 10 data fields, aligned: model class1b_v2_inf112.cm, cm_name class1b_v2, md5 fa9768bce80ba3b6cbc57e9f238c097d, built_by_infernal 1.1.2, nseq 94, eff_nseq 50.24, clen 81, bps 19, bifs 2, build_path pointing at the 11-02 build artefact. CRUCIALLY the MANIFEST md5 and the printed verify-after-transfer md5 are now the SAME number, which is the check that the manifest describes the file that ships. Staged in flaviLib/work/infernal/deploy_261117: class1b_v2_inf112.cm, class1b_groups.tsv, MANIFEST.tsv. TWO LIMITS OF THIS MANIFEST, to close on the cluster rather than now: it carries ONE ROW for the new model where Part 9 wants the whole set, and built_by_infernal is the LAPTOP's 1.1.2 while the .tbl will be produced by the CLUSTER's Infernal, whose version is recorded nowhere yet -- both fixable there, where cmstat can run over all seven. NEXT IS BLOCK B, on the cluster. <user> is almost certainly jgg2144, since the cluster root is /groups/as6282_gp/scratch_bkup/jgg2144/, so only the hostname is missing. Before the scp, check the cluster's cm/ for an existing MANIFEST.tsv or class1b_groups.tsv: neither should exist yet and the transfer would overwrite either |
| 2026-11-18 | cluster cm/ inspected before the scp: nothing to overwrite, and an undocumented vintage/ convention | ls of work/06_infernal/cm on the cluster shows the seven .cm files matching $CMS exactly and FLAT, confirming there are no cm_set_ directories there, plus a vintage/ subdirectory dated Oct 21. NO MANIFEST.tsv and NO class1b_groups.tsv, so the scp overwrites nothing. Dates: the three CL_Class_* and cl3 are Apr 24 2026, dumbbell_RF00525 Jun 11, class4_cl4_v9_20260824 Aug 25, class1c Oct 15 -- consistent with Part 6. cm/vintage/ IS UNDOCUMENTED: this file records vintage_md/ for superseded workflow documents but has never mentioned a vintage/ beside the models, so if that is where superseded models go, the obvious gesture at E6 would be to move CL_Class_1b_xrRNA_final.cm into it. DECIDED: DO NOT MOVE IT. env_261021_flaviLib.sh still lists that model in its $CMS and is the record of the 261021 run; moving the file makes re-running step 10 from that env fail on a missing .cm and the old run stops being reproducible. The replacement is enforced by the NEW env's $CMS, not by the filesystem. One command to learn the convention anyway, since it should be written down: ls -l $CMDIR/vintage/ |
| 2026-11-18 | cm/vintage/ documented; the scp landed one level too deep | VINTAGE: $CMDIR/vintage on the cluster holds cl1a.cm cl1b.cm cl2.cm cl3.cm cl4.cm cl5.cm cl5.picorna.merge.dedup.cm and seven picorna* models. So it is the attic for superseded models and the convention is real -- it already contains an EARLIER cl1b.cm, meaning a Class_1b model has been superseded here before and its predecessor went there. Two notes: the names in the attic are CLEANER than the names in service (cl1b.cm against CL_Class_1b_xrRNA_final.cm), so the naming drift documented in 'When a model's filename changes' ran the wrong way over time; and it is a mixed attic, the picorna* models belonging to another family and to no flavi set. The decision not to move CL_Class_1b_xrRNA_final.cm stands unchanged: env_261021_flaviLib.sh still names it in $CMS and is the record of the 261021 run, so moving it breaks that run's reproducibility. It can go to vintage/ later, once no live env script names it. TRANSFER LANDED WRONG: the three files arrived at $CMDIR/deploy_261117/ instead of in $CMDIR itself. That does not work, because $CMS holds BARE BASENAMES and step 10 resolves each as "$CMDIR/$CM", so cmsearch would look for $CMDIR/class1b_v2_inf112.cm and not find it; class1b_groups.tsv and MANIFEST.tsv belong directly in $CMDIR too, per Part 9. The staging directory is a LAPTOP-SIDE holding area with no counterpart on the cluster -- only its contents travel, which the scp line in this file should have made unmistakable. Fix: mv -n the three files up one level so nothing already there can be clobbered, rmdir rather than rm -r so it fails loudly if anything is left behind, then re-verify md5 fa9768bce80ba3b6cbc57e9f238c097d and NAME class1b_v2 in place |
| 2026-11-18 | why the cluster cm/ stays flat rather than nested per deployment | Asked whether nesting would be better organisation. Answered mechanically rather than by taste. $CMS entries are bare basenames and two things depend on that. (1) cmsearch --tblout "$TBLOUT/${CM}.tbl" with a $CM of deploy_261117/class1b_v2_inf112.cm resolves to $TBLOUT/deploy_261117/class1b_v2_inf112.cm.tbl, and cmsearch cannot create a file in a directory that does not exist, so the nesting would have to be MIRRORED under $TBLOUT and again in the env file's own check loop [ -e "$TBLOUT/${_cm}.tbl" ]. (2) the annotation column is the .tbl BASENAME, so the column itself survives nesting -- that is NOT what breaks, and saying so would have been wrong. CONCLUSION: nesting is possible at the price of keeping two directory trees in step, and buys little, because the project already has an organisation scheme here -- one flat directory of models in service plus vintage/ for superseded ones -- whereas per-deployment subdirectories would scatter the in-service set across dated directories so that answering 'what is annotating?' means looking in several places. Note the laptop DOES nest, as cm_set_261021, which is the asymmetry already recorded in 'Local or cluster'. ONE CONSEQUENCE EITHER WAY: after this deployment $CMDIR holds EIGHT .cm files while $CMS names SEVEN, so ls $CMDIR/*.cm stops being the list of what annotates; that list is $CMS and MANIFEST.tsv is what documents it, which is the argument for extending MANIFEST to all seven on the cluster rather than leaving it at the single new row. The filename is descriptive enough on its own terms -- class1b_v2_inf112.cm carries family, version and builder version, exactly what 'Versions of an existing model' asks a deployed name to carry -- and the directory was never meant to supply that information |
| 2026-11-18 | transfer verified in place; the cluster runs Infernal 1.1.5 while the model was built by 1.1.2, so MANIFEST gains searched_by_infernal | After mv up one level: md5 fa9768bce80ba3b6cbc57e9f238c097d at work/06_infernal/cm/class1b_v2_inf112.cm, matching MANIFEST exactly, and NAME class1b_v2 in place. CLUSTER INFERNAL IS 1.1.5 (Sep 2023), the model was BUILT by 1.1.2. That split is neither a problem nor new: it is the whole Class_1b line's situation and precisely what cm_env_require exists to manage -- 1.1.2 for cmbuild, whatever is current for the search. The laptop's development searches also ran under 1.1.5, so the deployed search matches them in version, and the six existing .tbl were searched the same way on this cluster, so the set is internally consistent. BUT built_by_infernal alone UNDER-DESCRIBES a .tbl, and this file has been bitten by exactly that distinction before: E1's apparent loss of AB021287 was a FILTER ARTEFACT -- no hit by default, 30.0/30.2 b under --max -- and filter behaviour is the part of cmsearch most likely to differ between versions. So MANIFEST gains a second version column, searched_by_infernal, recording who searched as well as who built, appended with awk from cmsearch -h before step 10 runs. Still open and to be closed on the cluster: MANIFEST carries one row where Part 9 wants all seven models |
| 2026-11-18 | env_261117_flaviLib.sh created and the swap confirmed; $CMS must be verified by word-splitting, not by reading | The three seds applied cleanly: DS=261117_flaviLib_150x150 at line 24, ANNOT_OLD pointing at 07_postproc/261021_flaviLib_150x150 at line 36, and CMS at line 72 with class1b_v2_inf112.cm in place of CL_Class_1b_xrRNA_final.cm. Sourcing printed exactly the expected proof -- 'cmsearch still needed: class1b_v2_inf112.cm', one line and only one -- and POSTPROC_BASE and LOG both moved to 261117, so the 261021 annotation is safe, which was the entire point of the DS bump. A SCARE WORTH RECORDING: the grep of line 72 DISPLAYED cl3_NAR_2025...SS_cons.cm and class4_cl4_v9_20260824.cm run together with no space, which would mean six models annotating with one of them nonexistent, silently dropping cl3 and class4. It was a terminal or paste artefact, and the proof is that the env's check loop reported ONE model still needing a search rather than two -- a merged entry's .tbl does not exist either, so it would have been named as well. NEW REQUIRED CHECK BEFORE STEP 10, because that inference is too load-bearing to rely on: word-split $CMS and count it. 'for CM in $CMS; do printf %s\\n "$CM"; done \| nl' must give exactly 7 lines, and 'for CM in $CMS; do [ -e "$CMDIR/$CM" ] ...' must report no MISSING. The reason this check is needed at all is that the env file's own closing loop tests the .tbl and NOT the .cm, so it cannot catch a corrupted model name -- it would just report one more 'cmsearch still needed', which reads like progress. $CMS is a quoted space-separated list inside a sed-edited file, 200 characters long with two names of 25 and 56 characters, so a lost or doubled space is the likeliest silent failure and the hardest to see |
| 2026-11-18 | step 10 ran; the deployed tbl does NOT include five of the ten gains, so 11b is blocked pending the hit definition | $CMS WAS INTACT -- five 'exists, skipping' plus 1a, and class1b_v2_inf112.cm searched -- so the apparent SS_cons.cm/class4 merge was a display artefact and the word-split check predicted that correctly. Search: 18.85 s CPU, 439 target sequences, 370,484 residues, 165 hits reported, 4 truncated. THE PROBLEM: the newly-annotated sites come back '?' rather than '!'. Bit scores match this file EXACTLY, so model and sequences are right and only inclusion differs -- AB981186 23.4, NC_012671 23.4, LR694076 23.4, MH237596 23.4 (the two CFAV xr3) and OP860412 23.2 are all '?' in the deployed tbl at E 0.017-0.019, where this file records them as '!'; NC_008604 20.9 and NC_005064 18.5 were already '?' in both. The cause is that INCLUSION IS AN E-VALUE TEST AND THE E-VALUE DEPENDS ON THE DATABASE SEARCHED, so a bit score that cleared the threshold in the development search does not clear it here. This is the concrete form of the warning already written under 'The step-10 cmsearch is NOT the cmsearch used in development', and sharper than that warning implied: not merely that deployed and development numbers are incomparable, but that '10 gained, 0 lost' was MEASURED UNDER A THRESHOLD THE DEPLOYED SEARCH DOES NOT APPLY. CONSEQUENCE: the whole gain now rests on whether post_process_peaks.py honours the inc column, which this file never recorded -- Part 7 says only that presence is 'taken from each .cm_hit column being non-NA', which does not say whether a '?' row produces a value. If it takes every row, the ten sites annotate and nothing is wrong; if it filters $17=="!", five of the ten gains vanish and class1b_v2_inf112.cm_hit would annotate FEWER sites than its predecessor's column, which must not be deployed. Settle by reading the script and by comparing the two tbls' inclusion counts -- the predecessor's tbl was built the same plain way and is the control. 11B IS BLOCKED until that is answered. Also noted, not acted on: the filter statistics show local HMM Forward passing 620 windows (0.196) against an expected 0.02 and local CM CYK 279 (0.0426) against 0.0001, a model of low information content letting far more through than typical -- the same property as eff_nseq 50.24 over 94 sequences and the 23-27 b marginal band, which is why this model has a long tail rather than a fault. And the re-source failed only because the shell was in viromelib rather than $ROOT/scripts: source $ROOT/scripts/env_261117_flaviLib.sh |
| 2026-11-18 | the inc column is never read; the deployed counts favour the successor; what decides E6 is now --evalue and a re-run of the no-loss rule | post_process_peaks.py DOES NOT USE !/? AT ALL. Its parser is parse_tbl(tbl_path, evalue_threshold) -- it reads the E-VALUE and applies its own --evalue threshold, passed at the 11b call site as annotate_infernal(df, infernal_tbl, evalue, downstream, min_downstream_frac). So cmsearch's inclusion verdict is discarded and the '?' rows are not excluded by it; the alarm raised an hour earlier was misdirected, though the underlying fact -- that development and deployed thresholds differ -- stands. The script emits FOUR diagnostic columns per tbl plus one any_hit across all of them, matches the peak accession VERBATIM against the tbl's target name, and _tbl_stem strips .tbl, which is what makes the column class1b_v2_inf112.cm_hit. DEPLOYED COUNTS, and they favour the successor: CL_Class_1b_xrRNA_final.cm has 129 included and 32 reported-only, total 161; class1b_v2_inf112.cm has 134 included and 31 reported-only, total 165 -- so +5 INCLUDED and +4 reported, and the 165 agrees with the search's own 'Total CM hits reported: 165', so nothing is unaccounted for. Four of the 165 are MINUS-STRAND, as expected from the deployed search having no --toponly. WHAT NOW DECIDES E6, two things. (1) The --evalue the 261021 run passed: the gains sit at E 0.017-0.019, so an --evalue below that filters them in the SCRIPT regardless of cmsearch; the same threshold applied to the predecessor's column, so the comparison stays fair but the gains may not appear. Take it from the recorded invocation in README_261021_flaviLib_150x150.md and from $LOG, never from the default, and REUSE IT UNCHANGED -- it is part of what the existing annotation means, and changing it would alter all seven columns rather than this one. Note the caution cuts both ways: because the script ignores inc, a LOOSE --evalue admits rows cmsearch marked ?, including the four minus-strand hits and this model's long filter tail (local CM CYK passed 279 envelopes against an expected 0.0001). (2) The no-loss rule must be RE-ESTABLISHED on the DEPLOYED tbls, since this file's '0 lost' was measured on development tbls under a different threshold. Compare by ACCESSION, not by coordinate: the two models place boundaries a few nt apart, so exact coordinate matching would invent losses -- the same trap as the +/-1 tolerance in hits_at_stall. comm -23 of the included accession sets must print nothing, and a per-accession count join shows where the five gains and any loss sit |
| 2026-11-18 | NO-LOSS RULE HOLDS ON THE DEPLOYED TBLS: +5 included, nothing lost; and the E-value does not depend on the searching Infernal | comm -23 on the included-accession sets printed NOTHING, so no accession with an included hit under the predecessor lacks one under the successor. The per-accession count join shows FIVE INCREASES AND NO DECREASE, accounting for 129 -> 134 exactly: MH827524 Quang Binh virus 4->5, NC_021069 mosquito flavivirus 4->5, NC_024299 Nienokoue virus 4->5 (all three the fifth array copy), NC_027817 Parramatta River virus 3->4 (PaRV xr4 RECOVERED), and NC_027819 MECDV 0->1 (MECDV xr1 recovered, and the old model found NOTHING AT ALL in that genome). So the deployment is net additive in the annotation itself, not only in the development comparison. The other five gains in this file (AB981186, NC_012671, both CFAV xr3 isolates, OP860412, E 0.017-0.019) are '?' here and depend on --evalue. THREE THINGS LEARNED FROM READING post_process_peaks.py, two of which retire earlier worries. (1) THE SCRIPT DISCARDS MINUS-STRAND HITS ITSELF -- 'if strand != "+": continue' at line 192 -- so the four minus-strand hits are dropped before anything else and the absence of --toponly in step 10 is HARMLESS; the strand half of the step-10 warning is withdrawn and only the threshold half stands. (2) THE _hit COLUMN HOLDS A BEST E-VALUE, NOT A BOOLEAN: df[hit_col] = best_evalue taken as min(candidates, key E), NaN where there is no candidate -- which is what Part 7's 'presence taken from each .cm_hit column being non-NA' means. (3) EACH TBL PRODUCES FOUR COLUMNS, NOT ONE: <stem>_hit, _start, _end, _tile_truncated, plus one any_hit across all tbls, so renaming a model renames FOUR columns; the 11-17 sweep still stands because it matched the shared stem rather than _hit, but 'the column' elsewhere in this file should be read as four. E-VALUE AND INFERNAL VERSION, asked today: an E-value comes from the bit score, the model's OWN STORED CALIBRATION (the ECM lines cmcalibrate writes into the .cm) and the effective database size. The calibration TRAVELS WITH THE FILE -- written once under 1.1.2, and cmsearch reads lambda and mu rather than recomputing them -- so the version doing the SEARCH does not move the E-value, the same reason cmalign to a fixed model is version-stable while cmbuild is not. Database size does move it. The version doing the CALIBRATION does matter but is already fixed and IDENTICAL for both models here: both built and calibrated under 1.1.2, both searched by the cluster's 1.1.5 against the same reference, so the comparison is controlled and any residual version effect is common to both columns. AND IT PROBABLY WAS NOT THE E-VALUE THAT CHANGED AT ALL: !/? is a threshold verdict, not a score, so if the laptop's development search used the same library the E-values are identical and the flip is only that ${C5}_library.tbl was made with a looser --incE than the step-10 default. One line on the laptop settles it: grep -v '^#' "${C5}_library.tbl" and read AB981186's E-value; if it is also 0.017, nothing about the statistics changed |
| 2026-11-18 | RESOLVED: the '?' verdicts are the missing --toponly and nothing else; the factor is exactly 2. 11b's invocation passes no --evalue | MEASURED: the development tbl gives AB981186 590-666 as 23.4 b, E = 0.0086, '!'; the deployed tbl gives the same locus as 23.4 b, E = 0.017, '?'. Identical bit score, E-value EXACTLY DOUBLED. Not a version effect and not a different database: an E-value scales with the effective size of the database searched, and searching BOTH STRANDS instead of one doubles it. Development used --toponly; step 10 does not. With the default --incE 0.01 that gives 0.0086 < 0.01 -> '!' and 0.017 > 0.01 -> '?', which is exactly what was seen. Every other site agrees: OP860412 23.2 at 0.019 implies ~0.0095 development, NC_008604 20.9 at 0.053 implies ~0.027 and was '?' both sides, NC_005064 18.5 at 0.16 implies ~0.08 and was '?' both sides. So the five sites that flipped are precisely those whose development E fell between 0.005 and 0.01, where doubling crosses the threshold, and the two already-'?' sites stay '?'. NOTHING about the model, the sequences, the statistics or the Infernal versions changed -- the answer to 'does the E-value depend on which Infernal is used?' is NO; a FLAG accounts for all of it. Note the consequence for the existing annotation, which is a property of it rather than anything introduced here: because post_process_peaks.py discards minus-strand hits itself, the strand doubling inflates every E-value in every deployed tbl by 2 while contributing no usable hits, and since all six predecessor tbls were made the same plain way the factor is UNIFORM across all seven columns, so comparisons between them are unaffected. 11B'S INVOCATION PASSES NO --evalue: README_261021_flaviLib_150x150.md step 11b (10-21 21:06, $LOG/step11b_annotate.txt) calls post_process_peaks.py with --out-raw, --out-collapsed, --family-csv and $INFERNAL_ARGS only, so the SCRIPT'S OWN DEFAULT produced the existing annotation and reusing the invocation verbatim reuses it. Read the default and redo the comparison AT THAT THRESHOLD with the script's two filters -- plus-strand and E <= default -- rather than at cmsearch's '!', which is a different test. The 129/134 figures recorded earlier used '!' and so correspond to a threshold of 0.01; a looser default admits more of the ten gains and a tighter one fewer, in either case applied IDENTICALLY to both columns, which is why the no-loss result holds regardless |
| 2026-11-18 | --evalue default is 0.01 (its help text says 0.001, a 10x error); --toponly is the right correction but belongs in its own step, not E6 | READ: evalue: float = typer.Option(0.01, '--evalue', help='Infernal E-value threshold (default 0.001).') -- THE DEFAULT IS 0.01 AND THE HELP TEXT SAYS 0.001, a tenfold documentation error in the script. Harmless to behaviour but anyone reconstructing the annotation from --help would get the threshold wrong by 10x; worth fixing in the script and worth not trusting that string. Also read: --downstream 20 and --min-downstream-frac 0.5 are further PER-PEAK filters applied after the E-value one, so tbl counts are an UPPER BOUND on what annotates. CONSEQUENCE: at 0.01 the five doubled sites -- AB981186, NC_012671, both CFAV xr3 isolates, OP860412 at E 0.017-0.019 -- DO NOT ANNOTATE; the five that do are the ones the per-accession join found, MH827524, NC_021069, NC_024299, NC_027817 (PaRV xr4) and NC_027819 (MECDV xr1). Since 0.01 is also what cmsearch's '!' corresponds to, the 129/134 comparison already recorded IS the right comparison: +5, nothing lost, applied identically to both columns. THE QUESTION ASKED -- since the script discards minus-strand hits, what is the doubling buying? -- IS RIGHT, AND THE ANSWER IS NOTHING. --toponly would give identical hits with E-values halved, and five genuine recoveries including both CFAV xr3 isolates would stop being lost to an artefact. So --toponly is a CORRECTION, not a preference. BUT IT MUST NOT BE APPLIED TO THIS MODEL ALONE: all six predecessor tbls were searched without it, so their E-values carry the same 2x inflation, and re-searching only class1b_v2_inf112.cm would put one column on a 1x scale and six on a 2x scale while one --evalue 0.01 is applied to all seven, silently making the threshold twice as permissive for Class_1b as for every other class -- worse than the artefact it fixes. DECISION: deploy as scoped now (option A), and open --toponly as ITS OWN STEP with its own $DS (option B). Not because B is wrong -- it is right and cheap, seven searches at about 19 s each -- but because the 2x inflation is a PRE-EXISTING SYSTEMATIC PROPERTY OF ALL SEVEN COLUMNS rather than a Class_1b matter, and rolling it into E6 would make it impossible to attribute any difference in the 261117 output to either change. The no-loss rule has been applied one change at a time throughout this file for exactly this reason. B can be QUANTIFIED WITHOUT ANY RE-SEARCH, since the factor is measured at exactly 2: for each of the seven tbls, count plus-strand hits at E<=0.01 and again at E/2<=0.01 and take the difference. If the gain across the other six is negligible B is a small correction; if it is large, B is a finding about the whole annotation and belongs in Part 7 |
| 2026-11-18 | correction: the 0.01 vs 0.001 mismatch is not an 'error' I can call, and it is NOT cosmetic -- at 0.001 four of the five gains vanish | Challenged on whether the mismatch is an error or deliberate stringency, and the challenge lands twice over. FIRST, I had the direction backwards: 0.001 is the STRICTER value and it is the one in the HELP TEXT, not in the code, so the behaviour is MORE PERMISSIVE than the documentation promises -- a stringency rationale would require the code to say 0.001. All I can state as fact is that the two disagree and that typer.Option(0.01, ...) is what runs; which was intended is not readable from the script, so calling it an error was guessing at intent. There IS an argument it is deliberate: 0.01 is Infernal's own default --incE, which makes the script's filter agree exactly with the '!' column in every tbl, and that coherence suggests 0.01 is the operative policy with the help string left stale when the default was loosened. SECOND, and more important, I said the difference might be cosmetic. IT IS NOT. The five gains sit precisely in the band the two thresholds disagree about: NC_024299 Nienokoue virus 30.1 b E 0.00079 survives both; NC_027817 PaRV xr4 28.3 b E 0.0018, NC_027819 MECDV xr1 27.7 b E 0.0023, MH827524 Quang Binh virus 26.6 b E 0.0038 and NC_021069 mosquito flavivirus 24.9 b E 0.0084 all survive 0.01 and ALL FAIL 0.001. So AT 0.001 FOUR OF THE FIVE GAINS VANISH, INCLUDING BOTH RECOVERIES, and the deployment's entire benefit rests on the operative threshold being 0.01 -- which it is. The five doubled sites at 0.017-0.019 fail both thresholds and are unaffected. CONSEQUENCE: the discrepancy must be settled by deciding the policy, not by editing a help string, and if 0.001 were ever the intended policy then this deployment needs re-arguing from scratch and so do the predecessor's 129 hits. Quantify across all seven columns by counting plus-strand hits at E<=0.01 and at E<=0.001 and taking the difference -- no re-search needed |
| 2026-11-18 | both CFAV xr3 isolates fail to annotate on a flag; --toponly moved BEFORE 11b, into a separate TBLOUT. class 4's zero count retracted as a concern | TWO CORRECTIONS. (1) CLASS 4'S ZERO HITS ARE CORRECT, NOT A PROBLEM: class 4 is not a flaviviral element, so in flaviLib class4_cl4_v9_20260824.cm is a built-in NEGATIVE CONTROL and 0 hits at either threshold is the expected result; treating it as something to confirm was my error. It is also informative for the threshold question -- if --evalue 0.01 were too permissive, the class with no true positives is where spurious hits would appear first, and it reports ZERO at 0.01 rather than merely few, which is evidence FOR 0.01. Specificity check and sensitivity argument agree. (2) THE xr3/xr4 QUESTION, and it is the sharpest statement of what the strand doubling costs. Of the eleven sites: NC_024299 10746 fifth copy E 0.00079, NC_027817 10756 PaRV xr4 E 0.0018, NC_027819 MECDV xr1 E 0.0023, MH827524 10760 fifth copy E 0.0038 and NC_021069 10737 fifth copy E 0.0084 ANNOTATE at 0.01; AB981186 10733 and NC_012671 10736 fifth copies at E 0.017, LR694076 10565 and MH237596 10555 -- BOTH CFAV xr3 -- at E 0.017, and OP860412 at E 0.019 DO NOT; NC_008604 10709 at E 0.053 does not and would not even at half. So PaRV xr4 and MECDV xr1 annotate but BOTH CFAV xr3 ISOLATES DO NOT, failing by a factor of two on a FLAG rather than on their merits, and AEFV xr3 NC_012932 is separately out of reach at 13.2 b. That is not tolerable: CFAV xr3 is the PUBLISHED TYPE EXAMPLE of this element -- PMC7527734's P1-deviant downstream copy, the basis of E8's whole positional argument -- and CFAV_NC_001564-2_10555-10632_xr3 is a named sequence of the PROVIDED Class_1b seed, so a deployment whose purpose includes recovering it and which then fails to annotate it has not done the job. 5 of 11 annotate now; 10 of 11 would under --toponly. DECISION REVISED, superseding this morning's 'deploy as scoped now, --toponly as its own step': the reason for separating them was ATTRIBUTION, and that is already satisfied without running 11b twice, because THE .tbl FILES ARE THE EVIDENCE AND BOTH SETS CAN BE KEPT. Search all seven with --toponly into a NEW directory, work/06_infernal/260807_trueRef_toponly, which preserves the both-strand tbls so the two changes stay separately quantifiable from the tbls while the annotation is produced ONCE. Expect class1b_v2 to gain about five and dumbbell a little, and the five step-function classes to gain nothing -- a halved E-value can only matter where a marginal population exists, and the exposure table shows only Class_1b and dumbbell have one; if any of the other five moves, that is unexpected and must be read before going further. The predecessor is no longer in $CMS so the loop will not touch it: search CL_Class_1b_xrRNA_final.cm into the new directory by hand if the old-versus-new comparison is to be redone on the --toponly footing. Point 11b at whichever directory is chosen by setting TBLOUT before building INFERNAL_ARGS, record the choice in MANIFEST, and note the decision is reversible without re-searching anything |
| 2026-11-18 | --toponly searches done: Class_1b +5 exactly as predicted, class1c +1 unexpectedly, every other class unmoved | Counts of plus-strand hits at E<=0.01, both-strand against --toponly: CL_Class_1a 84/84, class1b_v2_inf112 134/139 (+5), CL_Class_2 39/39, cl3 5/5, class4_cl4_v9 0/0, class1c 46/47 (+1), dumbbell_RF00525 91/91. CLASS_1B GAINS EXACTLY THE PREDICTED FIVE. The halving of the effective database size is confirmed directly in the search statistics rather than inferred: 185,242 residues searched against 370,484 both-strand, exactly half. CLASS1C GAINED ONE AND DUMBBELL GAINED NONE, the opposite of the guess made from the exposure table, and the discrepancy is instructive rather than contradictory: the exposure table counted hits between 0.001 and 0.01 while this gain counts hits between 0.01 and 0.02 where halving crosses the threshold -- different bands, so dumbbell's 2 marginal hits sat in the first and none in the second while class1c's sat the other way round. A MARGINAL POPULATION IN ONE DECADE SAYS NOTHING ABOUT THE NEXT, which is worth remembering before using any single threshold sweep as a proxy for breadth. The class1c +1 is small but not ignorable because class1c is the nearest neighbour Class_1b was tested against (guided-seed scores 1.55 / 1.33 / -2.14 bits), so a site newly claimed by both models is precisely the collision case the permissive threshold was warned about. Identify the class1c site and confirm the five Class_1b sites by comm of the two tbl sets before 11b runs; the five are expected to be AB981186, NC_012671, LR694076, MH237596 and OP860412, both CFAV xr3 isolates among them |
| 2026-11-18 | the five Class_1b gains confirmed as the predicted sites, both CFAV xr3 included; the class1c +1 is KY370101 12807, a documented collision candidate in frozen cluster 131 | CLASS_1B GAINED EXACTLY THE FIVE PREDICTED: AB981186.1 590-666, NC_012671.1 545-621, OP860412.1 297-372, and BOTH CFAV xr3 ISOLATES, LR694076.1 476-553 and MH237596.1 478-555. So the --toponly correction did what it was meant to and nothing else, and the published type example of the downstream subtype now annotates. CLASS1C GAINED ONE: KY370101.1\|12448-13220_inferred_3UTR 361-453, which converts through the sequence name's offset to genomic 12808-12900 -- a site this file ALREADY TRACKS. Part 5 records 'KY370101 12807 \| 1 site, SF 0.924 \| sub-threshold class1c (14.9 b); class1c question closed \| stays open as a site; inside the PLPV pool'. TWO THINGS FOLLOW AND THEY DO NOT CONFLICT. First, the 10-30 class1c decision STANDS: it was about whether to add KY370101 to the class1c SEED, a model-building question, closed with no variant accepted because gains did not reach E 1e-10; whether the EXISTING class1c model annotates the site is a different question, which is exactly why Part 5 wrote 'class1c question closed, stays open as a site'. --toponly answers the second: at the halved E-value it now does. Second, it IS a collision candidate and a documented one: E5 placed the node at 12807 in FROZEN CLUSTER 131, a MAIN Class_1b cluster, with cls None found -- so the clustering calls the site Class_1b-like while the only CM that reaches it is class1c, weakly. KY370101 is Pestivirus Q, one of the thirteen non-Flavivirus genomes this file had never discussed, so the site belongs to the PLPV pool rather than the ISF story. The clan rule resolves overlaps by LOWER E-VALUE, not raw bits, so read both models at that locus: if class1b_v2 reports no plus-strand hit at 361-453 there is no collision and the only consequence is one more class1c annotation in a pestivirus; if it does, the lower E wins and the outcome must be recorded against the cluster-131 membership rather than quietly accepted, because a main-Class_1b-cluster site annotated as class1c is a finding about the CLUSTER, not about this deployment |
| 2026-11-18 | NO COLLISION: the class1c and Class_1b hits in KY370101 are 82 nt apart and annotate different array copies. E6 clear to proceed | Both models read at the locus: class1b_v2_inf112.cm takes rel 173-279 at 42.5 b, E 1.3e-06, included; class1c.cm takes rel 361-453 at 14.9 b, E 0.0082, included. THE SPANS DO NOT OVERLAP -- 82 nt apart -- so the clan rule has nothing to resolve and the two models annotate TWO DIFFERENT COPIES of the same array. Converted through the sequence name's offset (12448), they are E5's own nodes: class1b_v2 takes genomic 12620-12726 = the node at 12621 (fz 131, cls 1b) and class1c takes 12808-12900 = the node at 12807 (fz 131, cls None found), the two copies E8 view 1 listed for KY370101 beside a third at 13029 that is unclustered and was flagged '3'-most copy is UNCLUSTERED -- still a candidate'. So the permissiveness worry does not materialise here: the one site the looser threshold added is a locus no other model contests, and E6 IS CLEAR TO PROCEED to 11b with TBLOUT pointed at the --toponly directory. ONE OBSERVATION TO CARRY FORWARD, about the clustering rather than this deployment: BOTH COPIES SIT IN FROZEN CLUSTER 131, yet one is strong Class_1b at 42.5 b and the other is reached only weakly and by a DIFFERENT CLASS at 14.9 b. A single frozen cluster holding two copies from one genome that get different class calls is the same shape as the satellite finding -- a main-cluster copy and a deviant one -- but in Pestivirus Q rather than an ISF, so it belongs with the PLPV pool and the thirteen non-Flavivirus genomes and not with E7 |
| 2026-11-18 | 11b RAN: E6 is complete. Next is Track B on the remaining build-stage alignments, which have never been searched library-wide | STEP 11B COMPLETE with TBLOUT overridden to 260807_trueRef_toponly and all seven --infernal-tbl paths confirmed under it. 10 mM: 34,102 peaks in, 34,102 through the filters (all thresholds at 0, as in the 261021 run), raw output written and collapsed to 439 accessions. 1 mM: 40,324 peaks, collapsed to 438 accessions. Those input counts MATCH the 261021 run recorded in README_261021_flaviLib_150x150.md exactly (34,102 and 40,324), so the peak input is identical and only the ANNOTATION changed -- which is the control that makes the old-versus-new comparison meaningful. Outputs under work/07_postproc/261117_flaviLib_150x150/{10mM,01mM}/, with the 261021 annotation untouched as ANNOT_OLD intended. ONE PRE-EXISTING WARNING, not caused by E6 and worth a row of its own later: 3,111 peaks across 28 accessions at 10 mM and 3,254 across 27 at 1 mM have NO ENTRY in virus_taxonomy_flaviLib_261021.csv, so family, genus and species are NaN for them -- examples MT084113.1, AB698917.1, BK071951.1, MW808978.1. Any per-genus or per-family count drawn from this annotation silently omits those accessions. Also benign: a pandas DtypeWarning on column 25 of the peak CSV, present in the 261021 run too. NEXT WORK, asked today: the remaining build-stage .stk alignments have never been turned into CMs and searched library-wide, so the question 'how many gaps do they fill' is unanswered. That is Track B, cm_candidate.sh build, and it needs an INVENTORY first rather than a guess at what is on disk -- new script cm_stk_inventory.sh reports, per alignment, nseq, whether SS_cons and RF are present, whether SS_cons carries pseudoknot letters (i.e. whether MATER has been applied), and whether a .cm and a .tbl already exist beside it. The .tbl column is the one that answers the question directly |
| 2026-11-18 | priority list revised after E6; three register rows updated by today's findings | DONE SINCE THE 11-16 LIST: item 1 (B4) was answered by E5 -- main Class_1b clusters are 131 and 133, every B1/B2 site carries its frozen cluster, and the OP860412 297 conflict was settled by E3 -- and item 7 (Class_1b E6) is COMPLETE, with class1b_v2_inf112.cm deployed, searched library-wide with --toponly, and 11b re-annotating both conditions under DS=261117_flaviLib_150x150. REVISED ORDER: (1) close out E6's bookkeeping -- write the DEPLOYED outcome into class1b_groups.tsv, which of the eleven sites annotate and which only after --toponly, resolve the four rows with unmeasured groups (NC_027817, NC_027819, OP860412, OM030319), confirm NC_005064.1's version, and extend MANIFEST.tsv from one row to all seven with both built_by_infernal and searched_by_infernal; (2) cluster 106 provisional model, since the 'align alone at 80 nt' step is DONE -- cluster106_edit261117_triple.stk is the corrected alignment -- leaving cm_candidate.sh build, then RNAvirus DB, then E7, with no model accepted from 3 sequences; (3) FJJI 41 then 44; (4) FJTB 64 and PLLG 117 position checks; (5) HPPV 39; (6) the two DB results and step 14a; (7) E7; (8) clade pools. THREE REGISTER ROWS UPDATED. HPPV cluster 39 now reads 39 + 135 at 4 + 4 sites and says ALIGN THE TWO TOGETHER, because E8 showed they are two positions in ONE rodent-pegivirus array -- 39 5'-terminal and 135 3'-terminal in LC602141, MT210614 and MT210620, with a fourth 135 copy in MW897328 -- so aligning 39 alone would split an array the clustering has already shown to be one thing. KY370101 12807 is now ANNOTATED by the existing class1c model (14.9 b, E 0.0082) once --toponly halved the E-values, with NO collision since the Class_1b hit in that genome is 82 nt away at 12621 (42.5 b) and is a different array copy; the 10-30 class1c SEED decision is unaffected, and what stays open is that both copies sit in frozen cluster 131 yet get different class calls. FJIS cluster 106 records the 11-17 alignment and points at the provisional model rather than at aligning. NOT ON THE LIST DELIBERATELY, each recorded elsewhere: the --evalue 0.01-against-0.001 policy question; the taxonomy gap, 3,111 peaks across 28 accessions at 10 mM having no virus_taxonomy entry so any per-genus count omits them; and the tile-collapse and Part 7 recount, which are E6's follow-ups rather than cluster work |
| 2026-11-18 | cluster 106: library search before the DB, and cm_candidate.sh gains --library-only | Asked for, and right: the library is 439 sequences and takes seconds while the RNAvirus DB does not, so the cheap search should be READ before the expensive one is started. cm_candidate.sh build already ran 'library first (cheap)' then the DB, but ran straight through; it now takes --library-only and stops after the library with the three readings spelled out -- seed-only hits mean saturation and make the DB search the whole point rather than a formality; hits beyond the seed mean the library already holds relatives, which must be read with their frozen clusters checked before the DB adds more; and no hits at all, not even the seed, mean the model is broken and nothing further should run. Invocation: cm_candidate.sh build --library-only cand_FJIS_c106_261118 cluster106_edit261117_triple.stk. TWO NOTES ON THE BUILD. It is CALIBRATED by cmcalibrate in the same step, without which the E-values are meaningless and the E-value is the whole basis on which the result will be judged. And it is built under the DEFAULT Infernal, 1.1.5, NOT 1.1.2: the 1.1.2 constraint belongs to the Class_1b line because the PROVIDED seed was built that way, and this is a new model with no such inheritance, so per 'Versions of an existing model' it carries NO _inf suffix. No model is accepted from 3 sequences in any case -- the build is a search tool, not a claim |
| 2026-11-18 | cluster 106 model built and searched library-wide: SATURATED, 0 novel | cand_FJIS_c106_261118 built from cluster106_edit261117_triple.stk under Infernal 1.1.5, the default, so no _inf suffix. GATE 2: nseq 3, eff_nseq 1.62, clen 80, W 111, bps 13, bifs 1, relent_cm 0.708, relent_hmm 0.568. EFF_NSEQ 1.62 SITS JUST ABOVE THE RECORDED REJECTION CASE, cand_PLLG_260915_cmalign at 1.55, and far below Class_2's curated 3.58, class1c's 9.54 and hepaci_hits_v2's 19.93 -- not a surprise or a fault but the arithmetic consequence of three near-identical sequences, and exactly why Part 3 records that no model is accepted from 3 sequences. 13 BP AND 1 BIFURCATION MATCH THE ALIGNMENT EXACTLY: counting the nested structure in SS_cons and ignoring the pseudoknot letters cmbuild does not read gives 9 + 4 opening pairs against 7 + 4 + 2 closings, 13 pairs, with the two inner stems nested inside the outer one producing the single bifurcation -- so the model encodes P1, P2 and P3 and NOT PK1, PK2 or the U-(A-U) triple, which is why it cannot by itself describe the fold. NO #=GC RF LINE, so cmbuild ran plain and re-inferred match columns by occupancy, 80 from the alignment's 84, which means THE CM NUMBERING DOES NOT MAP 1:1 ONTO THE ALIGNMENT COLUMNS -- locating the triple in cm coordinates will need the mapping, unlike the cluster-5 work where C/G/C at cm 7/29/43 could be read directly because RF fixed the columns; add an RF line and rebuild with --hand before anything depends on cm positions. LIBRARY SEARCH: 3 included hits over 3 accessions, all 3 passing coverage >= 0.85, 0 NOVEL vs seed, reported as SATURATED on library. The model recovers its own three sequences and nothing else, which is the seed-only reading: the library holds no further cluster-106 relatives, so the RNAvirus DB search becomes the point of the exercise rather than a formality, and it confirms from the model's side what the explorer said from the clustering's. ONE CHEAP CHECK FIRST: cm_iterate.sh searched at --incE 1e-10, very strict, so '0 novel' is a statement at that threshold and not a statement that the model is selective. Read the reported-but-not-included tail of the same tbl: if it is Class_1b sites the models compete and that must be known before E7 brings in more sequences, since any new class built from this seed inherits the overlap; if it is unrelated or empty, cluster 106 is genuinely isolated in this library and E7 is the only way to test it |
| 2026-11-18 | cluster 106's sub-threshold tail is class1c pestiviruses, not Class_1b, and it is STRONGER than the pooled FJIS model's; one unknown, MK636875 | '0 NOVEL' WAS ENTIRELY AN ARTEFACT OF --incE 1e-10. The reported list holds the 3 seeds at 84.9-102.3 b (NC_034017 Xishuangbanna aedes flavivirus 4.3e-29, NC_034204 Menghai flavivirus 6.4e-29, ON949931 Kilpisjarvi flavivirus 1.2e-23) and then six substantial non-seed hits: MK636875 28.6 b E 4.2e-06, ON024101 26.1, ON024090 21.7, ON024102 20.7, ON024097 20.7, ON024104 15.9, with MN587678/MN587686/MN587661/MN564793 at 14.0-8.8 b and E 0.15-6.2 as noise. At any conventional threshold there are six novel library hits and MK636875 is strong by ordinary standards. THE ON024* SERIES ARE PANGOLIN PESTIVIRUSES AND THEY ARE CLASS1C SEED MEMBERS: Part 5 already records the 10-29/30 reciprocal, 'FJIS model on the 46 class1c seeds -- 12 hits: 8 pangolin pestiviruses full-length, 12.5-21.9 bits (ON024090 E 6.8e-06)' against 'class1c on the 8 FJIS seeds -- only ON949931, 13.3 bits', concluding 'weak one way, moderate the other: siblings, not one family'. THAT CONCLUSION USED THE POOLED FJIS MODEL, cluster 5 AND 106 together; CLUSTER 106 ALONE HITS THE SAME VIRUSES HARDER, 15.9-26.1 b plus MK636875 at 28.6, so separating 106 from 5 SHARPENED the relationship to class1c's pestivirus subset rather than diluting it. The asymmetry is unchanged in direction -- five or six hits one way against a single 13.3 b hit the other -- but the moderate side is now moderately stronger, and it was measured on a model with eff_nseq 1.62, which if anything understates it. THREE CONSEQUENCES. (1) The collision risk is with CLASS1C, NOT Class_1b, which was the thing worth knowing before E7: nothing here competes with class1b_v2_inf112.cm. (2) DO NOT ADD THE PANGOLIN PESTIVIRUSES TO THE CLUSTER-106 SEED -- they are already class1c seed sequences, so adding them would not expand cluster 106 but merge it into class1c, exactly what the reciprocal says is wrong; the sibling reading must be tested with sequences belonging to neither, which is E7. (3) MK636875 IS THE ONE GENUINE UNKNOWN, the strongest non-seed hit, and appears nowhere in this file; its 3'UTR span 11978-12446 puts the genome near 12.4 kb, the pestivirus range and well above the ISFs' 10.9 kb, so another pestivirus is the expectation but must be read rather than assumed. If it is NOT a class1c seed member it is the first novel sequence this model has found and the one that would raise eff_nseq above 1.62 without merging cluster 106 into class1c. BEARS ON THE class1d QUESTION: the nearest neighbour is class1c, not Class_1b, which is consistent with a class1d naming but means the deciding comparison is against class1c and the deciding test is still E7 |
| 2026-11-18 | could class1c encompass cluster 106? Three lines of evidence say no, and a new cluster-137 entry falls out of asking | MK636875 IS Dongyang pangolin virus, genus Pestivirus -- same group as the ON024* series, not a novel sequence type, so the 'one genuine unknown' framing from an hour earlier is narrowed: it is unknown to THIS FILE, not unknown as a virus. THE HYPOTHESIS IS FAIR BUT THE EVIDENCE POINTS AGAINST, three ways. (1) THE DIRECT TEST WAS ALREADY RUN AND FAILED: Part 3 records cluster 106 as 'not class1c (guided seed 1.55 / 1.33 / -2.14 bits)', i.e. its three sequences scored against a class1c seed GUIDED TO INCLUDE THEM, one of them at NEGATIVE bits -- a sequence scoring below zero against a model built to contain it is not encompassed by it. (2) THE RECIPROCAL IS ASYMMETRIC IN THE WRONG DIRECTION FOR NESTING: class1c on the 8 FJIS seeds reaches only ON949931 at 13.3 bits, so it does not find two of cluster 106's three sequences at all, whereas nesting would require the parent to reach its members. (3) NEW AND SHARPEST: THE PESTIVIRUS SITES CLUSTER 106 FINDS ARE NOT CLASS1C SITES. Every one is cls None found in the node table and sits in FROZEN CLUSTER 137 -- MK636875 Dongyang pangolin virus 3 copies, ON024097 4, ON024102 4, ON024104 3, all Pestivirus, all unassigned. cls None found means NO model in the annotating set calls these stalls, class1c included; if class1c encompassed cluster 106 the sites cluster 106 reaches should already be class1c's, and they are not. AND THEY ARE ARRAYS WITH CLUSTER 106 HITTING ONE COPY EACH: converting through each sequence name's offset against the explorer nodes, MK636875 12148-12227 is copy 2 of 3, ON024097 12021-12102 is copy 1 of 4, ON024102 12006-12081 is copy 1 of 4, ON024104 12036-12114 is copy 1 of 3 -- mostly the 5'-MOST copy. THE E8 PATTERN A THIRD TIME: tandem arrays whose copies get different treatment, now in Pestivirus after ISFs (clusters 5 and 21, 3'-terminal) and rodent pegiviruses (clusters 39 and 135, both ends). BETTER READING: not that class1c encompasses cluster 106 but that the two are SIBLINGS REACHING DIFFERENT COPIES OF THE SAME PESTIVIRUS ARRAYS, which is testable in one command before E7 rather than after -- read class1c's hits in those genomes in genomic coordinates and compare with the copy table. Different copy = the two models partition one array, the sibling reading, a positive result for class1d, and the pangolin pestiviruses become a SHARED target rather than class1c's property; same copy but stronger = cluster 106 is reaching class1c's own sites weakly, the clan rule gives them to class1c and the sibling claim weakens; no 3'UTR hits at all = the 8 pangolin pestiviruses in class1c's seed come from a different region or a looser search, which needs explaining first. NEW REGISTER ENTRY EITHER WAY: cluster 137 is a 4-genome pestivirus array cluster that NO model annotates, reached only by a 3-sequence candidate, and it belongs in the gap register beside HPPV 39 + 135 at priority 3 rather than in the undifferentiated clade pools |
| 2026-11-18 | proposal: merge the cluster-106 and cluster-137 gaps. Large specific payoff, but conditional on an untested word | THE PROPOSAL: cluster 137 is orphaned, cluster 106 is orphaned, cluster 106's model reaches 137, so treat them as one gap and align them together. THE PAYOFF IS LARGE AND IS NOT MERELY 'MORE SEQUENCES'. Cluster 106 is stuck for one reason recorded repeatedly here -- three near-identical sequences cannot support a model or pass a covariation gate, eff_nseq 1.62 against the 1.55 rejection case, R-scape with ZERO power because 16 of 21 pairs are invariant. A merged alignment is 3 ISF sequences plus 4 pestivirus genomes' copies, and those pestiviruses are DIVERGENT -- 15.9-28.6 bits against an 80-column model -- which is exactly the divergence that produces covariation signal. So the merge is the one route that could make GATE 1 APPLICABLE FOR THE FIRST TIME, and it does so WITHOUT E7, the expensive step this has been waiting on. BUT THERE IS A CONTRADICTION ON THE WORD 'ORPHANED': Part 5 records the 8 pangolin pestiviruses as class1c SEED members, and a genome cannot be both in class1c's seed and orphaned, yet every explorer node in those genomes reads cls None found. Three non-equivalent readings: (1) class1c's seed spans are at DIFFERENT LOCI than the explorer's nodes, i.e. class1c holds a different copy of the same arrays -- then 137's copies genuinely are orphaned, the merge is sound and the sibling reading is confirmed; (2) class1c hits these SAME copies but below the explorer's cls threshold -- then they are not orphaned but class1c's weak tail, and merging them into cluster 106 builds a model from another class's sequences, the same error as adding the pestiviruses to the seed arrived at from a different direction; (3) class1c's seed came from a search against something other than this library, so cls None found says nothing about its claim and the question stays open. ONLY READING 1 LICENSES THE MERGE, and the class1c-locus command already written distinguishes all three, so it must run before any alignment work -- readings 1 and 2 differ in whether the result is a new class or a corner of class1c. IF READING 1 HOLDS, MERGE BY RE-ALIGNMENT, NOT BY GRAFTING: cmalign --mapali onto the 3-sequence model would force the pestivirus copies into columns three near-identical ISF sequences defined, which is exactly the failure mode recorded for the Class_1b marginal band -- added sequences conforming to the model instead of informing it. Go back to cm_candidate.sh align with all sequences together, then MATER, then R-scape, at which point GATE 1 means something. NAMING: the two clusters come from DIFFERENT POOLS so cand_<pool>_<cluster>_<yymmdd> does not fit; follow the pooled precedent cand_FJJI_cluster41-44_pooled_261029 and use cand_c106-137_pooled_261118 with NO pool prefix, the absent prefix being itself the finding -- this candidate crosses pools, which no accepted class in this file does. CAUTION ON WHAT SUCCESS WOULD MEAN: passing GATE 1 would establish that the ISF cluster-106 element and the pangolin-pestivirus element SHARE A STRUCTURE, not that they are one class. Part 6's reciprocal tests exist because shared structure across distant genera is precisely how class1c and Class_1b were found to be siblings rather than one family, so the merged model needs the same reciprocal treatment against class1c before any class1d claim |
| 2026-11-18 | RETRACTION: the merge should follow the documented class1c lineage, which grafts with cmalign. My 're-align, do not graft' advice was an invention | Asked whether to cmalign the pangolin sequences, hand-edit in MATER and rebuild, or else follow whatever the doc records for class1c. THE TWO ARE THE SAME THING, and the doc's answer is the one to follow. The class1c lineage is: cmbuild from hand-edited seqs; cmsearch library-wide; fetch list from $17=='!' and esl-sfetch -Cf; CMALIGN WITH THAT MODEL; dedup_stockholm.py; MANUAL MATER + CaCoFold; cmbuild -F -n + cmcalibrate; cmsearch library-wide. So grafting IS the documented method and my objection an hour earlier -- that cmalign makes added sequences conform to the model rather than inform it -- is answered by step 6 being a real manual re-examination rather than a formality: the alignment that became class1c is the MATER-refined one, not the cmalign output. WHAT THE LINEAGE ACTUALLY WARNS AGAINST IS ITERATING, NOT GRAFTING: the same section records that class1c 'was never realigned on its own hits and never rebuilt -- one round only, no self-refitting', and contrasts it with class4_cl4_v9_20260824, flagged under decision 35 for NINE rounds of taking a model's own hits, realigning and rebuilding, 'the same procedure that drove clusterA_refined.cm to eff_nseq 1.55'. That is why class1c's nseq 46 / eff_nseq 9.54 is called legitimate rather than a converged artefact. ONE ROUND; do not repeat it on the result. ONE DELIBERATE CHANGE TO THE RECIPE, recorded rather than slipped in: step 3 takes the fetch list from $17=='!', but here nothing but the seed is included because cm_iterate.sh searched at --incE 1e-10, so the criterion becomes an explicit E cut. The data separates cleanly -- six hits at E 4.2e-06 to 0.038 (MK636875, ON024101, ON024090, ON024102, ON024097, ON024104), then a gap to E 0.15 and worse (MN587678, MN587686, MN587661, MN564793) at 14.0 bits and below -- so E <= 0.05 takes the six and none of the noise, giving 9 sequences for the alignment. WHAT TO WATCH AT STEP 7: eff_nseq is the number that says whether the merge did anything, the cluster-106-only model sitting at 1.62 against the 1.55 rejection case, and nine sequences spanning two genera should move it substantially; if it does not, the pangolin copies were aligned into conformity rather than contributing diversity and step 6 is where to look. GATE 1 also becomes meaningful for the first time, since R-scape had no power on three near-identical sequences but does across ISFs and pestiviruses. PRECONDITION UNCHANGED: none of this runs until the class1c locus check says these copies are not class1c's own |
| 2026-11-18 | sourcing flavi_env.sh does not activate the conda env; the first hand-typed Infernal command fails | The fetchlist came out at 9 lines as predicted (3 seed + 6 pangolin), then esl-sfetch failed with 'command not found' in an interactive (base) shell. CAUSE: flavi_env.sh sets paths at top level but its conda activate lives inside flavi_conda, which only runs when flavi_require calls it, and flavi_require runs from SCRIPTS rather than from sourcing. So a shell that has sourced the env file has $FA, $CPU and $INFERNAL and still has no esl-sfetch, cmalign or cmsearch on PATH -- every script so far worked because it activates internally, and the first command typed BY HAND is the one that fails. Fix is one line, conda activate viromelib, and the env to activate depends on the MODEL rather than on preference, which is why cm_env_require reads the builder version from the .cm header. Recorded in Part 9's invocation section beside the bash-vs-zsh and md5-against-the-installed-file traps |
| 2026-11-18 | cmalign of the merged 9: all six pangolin copies clear the PP bar, bits are low, and two 3'-truncations are a FETCH artefact | cand_FJIS_c106_261118.cm over the 9 fetched spans. The three ISF seeds align at 90.58, 90.02 and 73.16 bits with PP 1.000, 1.000 and 0.994. The six pangolin copies: MK636875 16.98 b PP 0.968, ON024101 14.47 PP 0.953, ON024102 11.32 PP 0.743 (3' trunc, cm 1-78), ON024090 10.41 PP 0.866 (3' trunc, cm 1-74), ON024097 8.99 PP 0.898, ON024104 4.25 PP 0.861. THE PP RESULT IS THE SIGNIFICANT ONE AND IT IS FAVOURABLE: every pangolin copy aligns at 0.743-0.968, where this file's recorded failure case is 'hits lost and PP still < 0.7' and E2b's rejection of cluster 106 into Class_1b was at PP 0.397 / 0.465 / 0.424. These are roughly twice that and all clear 0.7, so cmalign is placing them confidently rather than forcing them into the model's columns -- which was the objection to grafting, and it is answered by measurement rather than by argument. THE BITS ARE LOW and much lower than the search reported: cmsearch gave MK636875 28.6 and ON024104 15.9 against cmalign's 16.98 and 4.25, a drop that is expected since cmsearch finds optimal local boundaries while cmalign is global to the model, but 4.25 b for ON024104 is weak enough to be a candidate for exclusion at MATER rather than carried automatically. THE TWO 3' TRUNCATIONS ARE A FETCH ARTEFACT, NOT BIOLOGY: their windows are 74 and 76 nt against an 80-column model, so the sequence ran out before the model did. The fetch list took the cmsearch envelope exactly, following the class1c lineage's step 3, and for these two the envelope is shorter than the model. Re-fetch with a 12 nt 3' margin on the pangolins only -- bits < 50 separates them cleanly from the seeds at 73-102, and the seeds keep exact spans since they define the model -- then re-align and read the new table against the old: truncation gone with PP holding means the windows were tight and that alignment goes to MATER; still truncated with the extra 12 nt means the pestivirus element genuinely ends earlier than the ISF one, a real structural difference belonging in the MATER edit and in the eventual class1c comparison; PP dropping with the margin means the extra sequence is not part of the element and the original windows were right |
| 2026-11-18 | the +12 margin: revert to the original windows. All three predicted outcomes occurred, one per sequence, and the bit drop was a length artefact | MK636875 and ON024101 were ALREADY COMPLETE at cm 1-80 and the margin BROKE them, truncating at 78 and 79 -- the extra 12 nt is not element and pulled the 3' end off, so the original windows were right. ON024090 was GENUINELY 6 NT SHORT: with the margin it completes cm 1-80, so its element extends past the cmsearch envelope. ON024102 IS GENUINELY TRUNCATED: twelve more nucleotides and it still stops at cm 78, so the pestivirus element there really does lack the last two model columns -- a structural observation, not a fetch problem, belonging in the MATER edit. ON024097 and ON024104 were unchanged in fit. METHODOLOGICAL POINT WORTH KEEPING: DO NOT COMPARE BIT SCORES BETWEEN THE TWO RUNS. cmalign is global, so every added nucleotide that is not model-like is absorbed as an insert and counted against the null; scores fell 8-10 bits across the board BECAUSE THE SEQUENCES GOT 12 NT LONGER, not because the alignments got worse. PP is the length-robust comparison and it moved by at most 0.04 -- MK636875 -0.010, ON024101 -0.003, ON024090 +0.022, ON024102 +0.042, ON024097 +0.012, ON024104 -0.020 -- so alignment quality is essentially identical and only the flanking changed. Reading that bit drop as evidence about the element would have been the same category of error as reading cmsearch bits against cmalign bits. DECISION: use hits_aligned.stk, the original, and fix two sequences by hand -- ON024090 needs about 6 nt more at its 3' end, ON024102 is correct as fetched and its short 3' end is a feature to record. A per-sequence fetchlist would be tidier but this is exactly what the manual MATER step exists for, which is why the class1c lineage puts the hand edit after cmalign. STATE OF THE MERGE: PP across the six pangolin copies is 0.74-0.97 in both runs against E2b's 0.397-0.465 rejection, so the alignment holds; bits are low and ON024104 is marginal at 4.25 b, weakest either way. Neither is decided here -- eff_nseq after the rebuild says whether nine sequences across two genera bought anything over 1.62, and GATE 1 on the MATER-refined alignment says whether the structure is shared, and both come after the hand edit |
| 2026-11-18 | dedup_stockholm.py takes two arguments; my redirect wrote its usage string into the output file | python3 dedup_stockholm.py hits_aligned.stk > hits_aligned_dedup.stk printed 'Usage: dedup_stockholm.py <input.stk> <output.stk>' INTO the output file, which then existed, was non-empty, and was not an alignment -- nothing failed loudly, and the sequence count came back 0. The correct form is two positional arguments. SAME SHAPE AS THE hits_at_stall SIGNATURE ERROR: assuming an interface rather than reading it, and this time the failure was silent because a usage message goes to stdout. Recorded in Part 9's invocation section with the general rule -- check what a script expects before piping into or out of it, and verify the output is what it should be rather than merely present, e.g. by counting sequence names with awk '!/^#/ && !/^\\/\\// && NF>=2' rather than assuming the file is an alignment |
| 2026-11-18 | cluster 106 step reordered: build and calibrate, then LIBRARY search, then the RNAvirus DB | Corrected on the point that there is no cluster-106 model yet and that the library search should come before the DB. Both are right, and the second matches cm_candidate.sh build's own order. THE LIBRARY COMES FIRST because every other model's hits are measured there, so a cluster-106 result is immediately comparable against Class_1b, class1c and the rest; the RNAvirus DB is both an outside set and a demonstrably narrow one -- 4 of the 8 FJIS seed genomes score 52-79 bits in the library and do not appear in the DB at all -- so it is the weaker test and belongs after. Search --toponly, as everything does from today on. BUILD UNDER THE DEFAULT 1.1.5, NOT 1.1.2: the 1.1.2 constraint is specific to the Class_1b line because that model was built under it, whereas cluster 106 is a NEW model with no predecessor to stay comparable with, so Part 9's scheme gives it a plain name with no _inf suffix since that suffix marks a non-default builder. WHAT THE SEARCH IS FOR AND WHAT IT CANNOT SETTLE: no model is accepted from 3 near-identical sequences, the build is a search tool rather than a claim, and R-scape has no power here with 16 of 21 pairs invariant. The prediction to judge the library search against is specific -- it should recruit its own three sites strongly, and the question is whether it recruits ANYTHING ELSE. Nothing else means the library holds no more of this element and E7 is required rather than optional; Class_1b sites would mean cluster 106 is not distinct after all, contradicting E2b and needing an explanation rather than acceptance. Note also that cmcalibrate on a 3-sequence alignment gives E-values that should be read with the same caution as the model itself |
| 2026-11-16 | cm_set_261021 mixes Infernal builder versions | Headers read by flavi_env.sh --check: CL_Class_1a, CL_Class_1b and CL_Class_2 are all 1.1.2 (provided); class1c.cm is 1.1.5 (built here); class1b_plusFJIS_cluster5_inf112.cm is 1.1.2. There is therefore no single correct env for the deployed set, which is the reason the env is derived per model from its header instead of being configured once. Any future class1c rebuild or extension must run in viromelib, not infernal112, and cm_env_for now selects that automatically |

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
- ~~`build_candidate_cm.sh` defects~~ **closed 2026-11-16**: all six (GATE 1 passing on an energy
  parse failure; the alifold regex missing mlocarna's line format and space-padded energies;
  mlocarna's exit status unchecked; dedup producing no output while the manual-step banner prints;
  R-scape's outdir not created; the tblout path not printed) are fixed in `cm_candidate.sh`, which
  replaces it. `dedup_stockholm.py` is not run — it read the two-block file as twice the rows and
  removed nothing in any run. Delete `build_candidate_cm.sh` once `cm_candidate.sh` has run once.
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
