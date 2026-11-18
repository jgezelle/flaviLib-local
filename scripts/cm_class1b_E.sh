#!/usr/bin/env bash
# E1-E5 of "Where Class_1b expansion goes" (CM_CANDIDATES.md Part 1).
# Usage: bash cm_class1b_E.sh e1 | e2 | e2b | e3 | e4 | e5
#        e2b decides whether cluster 106 is Class_1b -- run it before Track B on 106.
# Run from anywhere. Each step writes under $PLUS/E<n>/ and prints what to log.
set -uo pipefail

# ---------- env ----------
source "$(dirname "${BASH_SOURCE[0]}")/flavi_env.sh"

# ---------- E1: is AB021287's loss a filter artefact? ----------
e1() {
  local OUT=$PLUS/E1; mkdir -p "$OUT"
  flavi_require cmsearch esl-sfetch
  need "$FA" "$CL1B" || return 1
  local STRONG=$AH112/strong/class1b_alignHits_strong_inf112.cm
  local NEWV=$AH112/newvirus/class1b_alignHits_newvirus_inf112.cm
  need "$STRONG" "$NEWV" || { echo "check $AH112 for the 1.1.2 model names"; return 1; }

  [ -f "$FA.ssi" ] || esl-sfetch --index "$FA"
  local T; T=$(grep -m1 '^>AB021287' "$FA" | sed 's/^>//; s/ .*//')
  [ -n "$T" ] || { echo "AB021287 not in $FA"; return 1; }
  echo "target: $T"
  esl-sfetch "$FA" "$T" > "$OUT/AB021287.fa" || return 1

  printf '%-46s %-7s %s\n' model mode "cm_span  hit_span  bits  E  inc"
  for M in "$CL1B" "$STRONG" "$NEWV"; do
    for MODE in default max; do
      local OPT=""; [ "$MODE" = max ] && OPT="--max"
      printf '%-46s %-7s ' "$(basename "$M" .cm)" "$MODE"
      cmsearch --toponly $OPT -E 100 --cpu $CPU -o /dev/null \
        --tblout "$OUT/$(basename "$M" .cm).$MODE.tbl" "$M" "$OUT/AB021287.fa" 2>/dev/null
      awk '$1!~/^#/ {print "cm "$6"-"$7, $8"-"$9, $15" bits", "E "$16, $17; f=1; exit}
           END{if(!f) print "NO HIT"}' "$OUT/$(basename "$M" .cm).$MODE.tbl"
    done
  done | tee "$OUT/e1_summary.txt"

  cat <<'EOF'

READ IT:
  scores under --max only          -> filter artefact; AB021287 is not really lost. Go to e2.
  NO HIT under --max in strong/newvirus -> both rejected, as the September merge was.
                                          Library-internal Class_1b expansion is CLOSED.
                                          Skip e2; go to e3.
EOF
  echo "then: clog class1b 'E1 AB021287 --max' '<one line from e1_summary.txt>'"
}

# ---------- E2: rebuild strong/newvirus on the cluster-5 seed ----------
e2() {
  flavi_require cmalign cmsearch esl-sfetch conda
  need "$FA" "$C5.cm" "$C5.stk" "${C5}_library.tbl" || return 1
  local MENV; MENV=$(cm_env_require "$C5.cm")
  echo "model built by Infernal $(cm_version "$C5.cm") -> cmalign/cmbuild in env $MENV"

  for SUBSET in strong newvirus; do
    local OUT=$PLUS/E2/$SUBSET; mkdir -p "$OUT"
    local MODEL=class1b_c5plus_${SUBSET}_inf112

    # the novel-hit fetchlists from the 10-30 work; confirm the names once
    local FL; FL=$(ls "$AH"/*"$SUBSET"*.fetchlist "$AH"/**/*"$SUBSET"*.fetchlist 2>/dev/null | head -1)
    if [ -z "$FL" ]; then
      echo "no fetchlist matching '*$SUBSET*.fetchlist' under $AH"
      echo "  what is there:"
      find "$AH" -maxdepth 2 \( -name '*.fetchlist' -o -name '*fetch*' -o -name 'hits.novel*' \) \
        2>/dev/null | sed 's|^|    |' | head -20
      echo "  the 10-30 subsets were: strong = the 38 novel hits at E<=1e-5;"
      echo "  newvirus = those 34 of them from accessions with no sequence in the seed."
      echo "  If no list survives, rebuild it from $SAT/r0/hits.novel.tsv, then set FL by hand."
      continue
    fi
    echo "== $SUBSET  from $FL  ($(wc -l < "$FL") rows)"

    esl-sfetch -Cf "$FA" "$FL" > "$OUT/${MODEL}_added.fa" || continue
    conda run -n "$MENV" cmalign --cpu $CPU --mapali "$C5.stk" -o "$OUT/$MODEL.stk" "$C5.cm" \
      "$OUT/${MODEL}_added.fa" > "$OUT/${MODEL}_cmalign.log" || continue
    echo "-- added sequences on the cluster-5 model (name, cm span, trunc, bits, avg PP)"
    grep -v '^#' "$OUT/${MODEL}_cmalign.log" | awk 'NF>=8 {print $2, $4"-"$5, $6, $7, $8}'

    conda run -n "$MENV" cmbuild --hand -F -n "$MODEL" "$OUT/$MODEL.cm" "$OUT/$MODEL.stk" \
      > "$OUT/${MODEL}_cmbuild.log" || continue
    conda run -n "$MENV" cmcalibrate --cpu $CPU "$OUT/$MODEL.cm" \
      > "$OUT/${MODEL}_cmcalibrate.log" || continue
    conda run -n "$MENV" cmstat "$OUT/$MODEL.cm" | grep -v '^#'
    cmsearch --toponly --incE 0.01 --cpu $CPU -o /dev/null \
      --tblout "$OUT/${MODEL}_library.tbl" "$OUT/$MODEL.cm" "$FA" || continue

    echo "-- vs the CLUSTER-5 baseline (not the original model)"
    python3 "$FLAVISCRIPTS/cm_round_stats.py" compare "${C5}_library.tbl" "$OUT/${MODEL}_library.tbl"
    grep -E 'NEW|LOST' "$OUT/${MODEL}_library.tbl.compare.tsv" | head -20
    echo "-- the three hits that decide it"
    grep -E 'AB021287|OP860412|MH307700|MH282908' "$OUT/${MODEL}_library.tbl.compare.tsv"
  done

  cat <<'EOF'

ACCEPT only if: lost = 0, clen/bps/bifs equal the baseline's (81/19/2),
each added sequence aligns full length at high PP, and the 3 stall-anchored gains hold
(OM030319 11865, MN587651 9782, OP860412 10802).
EOF
  echo "then: clog class1b 'E2 strong/newvirus rebuilt on the cluster-5 seed' '<cmstat; matched/lost/gained/lower/worst>'"
}

# ---------- E2b: cluster 106 ALONE on the cluster-5 baseline ----------
# The test that decides whether cluster 106 is Class_1b. Every earlier rejection used the
# ORIGINAL 88-seq model and added 106 pooled with cluster 5. Run this before Track B on 106.
e2b() {
  local OUT=$PLUS/E2b; mkdir -p "$OUT"
  local MODEL=class1b_c5plus_c106_inf112
  flavi_require cmalign cmsearch conda
  need "$FA" "$C5.cm" "$C5.stk" "${C5}_library.tbl" "$FA106" || return 1

  # the 3 cluster-106 explorer 80-nt windows; genomic stalls 10511 / 10523 / 10608
  grep -c '^>' "$FA106"
  cp "$FA106" "$OUT/${MODEL}_added.fa"

  # Which Infernal built this model is READ FROM ITS HEADER, not assumed: realigning a
  # 1.1.2-built model with 1.1.5 is not the same model (Part 2, documented 2026-10-30).
  local MENV; MENV=$(cm_env_require "$C5.cm")
  echo "model built by Infernal $(cm_version "$C5.cm") -> cmalign/cmbuild in env $MENV"
  conda run -n "$MENV" cmalign --cpu $CPU --mapali "$C5.stk" -o "$OUT/$MODEL.stk" "$C5.cm" \
    "$OUT/${MODEL}_added.fa" > "$OUT/${MODEL}_cmalign.log" || return 1

  echo "== how the 3 sequences aligned (name, cm span, trunc, bits, avg PP)"
  echo "   the number that matters: avg PP. The old model gave 0.38-0.47, 5'-truncated."
  grep -v '^#' "$OUT/${MODEL}_cmalign.log" | awk 'NF>=8 {print $2, $4"-"$5, $6, $7, $8}'

  conda run -n "$MENV" cmbuild --hand -F -n "$MODEL" "$OUT/$MODEL.cm" "$OUT/$MODEL.stk" \
    > "$OUT/${MODEL}_cmbuild.log" || return 1
  conda run -n "$MENV" cmcalibrate --cpu $CPU "$OUT/$MODEL.cm" > "$OUT/${MODEL}_cmcalibrate.log" || return 1
  conda run -n "$MENV" cmstat "$OUT/$MODEL.cm" | grep -v '^#'
  echo "   baseline for comparison: 94 seqs, eff_nseq 50.24, clen 81, 19 bp, 2 bif"
  echo "   new model built by Infernal $(cm_version "$OUT/$MODEL.cm")"

  cmsearch --toponly --incE 0.01 --cpu $CPU -o /dev/null \
    --tblout "$OUT/${MODEL}_library.tbl" "$OUT/$MODEL.cm" "$FA" || return 1

  echo "== per hit vs the CLUSTER-5 baseline"
  python3 "$FLAVISCRIPTS/cm_round_stats.py" compare "${C5}_library.tbl" "$OUT/${MODEL}_library.tbl"
  grep -E 'NEW|LOST' "$OUT/${MODEL}_library.tbl.compare.tsv"
  echo "== did the 3 cluster-106 sites come in AT THEIR STALLS?"
  echo "   (an accession can 'come in' at another locus 80 nt away -- these genomes carry several"
  echo "    elements, so this checks by position, which a grep by accession does not)"
  hits_at_stall "$OUT/${MODEL}_library.tbl" \
    NC_034017.1:10511 NC_034204.1:10523 ON949931.1:10608
  echo "== the marginal hit, every variant so far has lost it"
  grep OP860412 "$OUT/${MODEL}_library.tbl.compare.tsv" || echo "  OP860412 not in the compare"

  cat <<'EOF'

READ IT (Part 1, "Is cluster 106 really not Class_1b?"):
  0 lost AND PP >= 0.7 full length -> it IS Class_1b. Merge; label transition:106 (own frozen
                                      cluster). The old rejection was an artefact of the old seed.
  0-2 lost, PP >= 0.7              -> borderline. The no-loss rule rejects it, but record that it
                                      now aligns. Kamiti was rejected for exactly one lost hit.
  lost AND PP still < 0.7          -> Class_1b cannot reach it on the best baseline. Go to Track B
                                      (cm_candidate.sh align) and then E7. The negative is now real.
EOF
  echo "then: clog class1b 'E2b cluster 106 alone on the cluster-5 baseline' '<PP and span of the 3; matched/lost/gained; OP860412>'"
}

# ---------- E3: the OP860412 297 count conflict ----------
e3() {
  need "${C5}_library.tbl.compare.tsv" || {
    echo "re-run the comparison first:"
    echo "  python3 $FLAVISCRIPTS/cm_round_stats.py compare \\"
    echo "    $INFERNAL/build/class1b/iter_v1_saturation/r0/search.tbl ${C5}_library.tbl"
    return 1; }
  echo "== all NEW / LOST rows of the accepted cluster-5 model"
  grep -E 'NEW|LOST' "${C5}_library.tbl.compare.tsv"
  echo "== count"
  grep -c NEW "${C5}_library.tbl.compare.tsv"
  echo "== is OP860412 297 among them?"
  grep OP860412 "${C5}_library.tbl.compare.tsv" || echo "  not present -> the Part 3 attribution is wrong, the gains are the 10 listed"
  echo "then: clog class1b 'E3 OP860412 297 attribution' '<NEW count; OP860412 present or not>'"
}

# ---------- E4: pp_check and insertcheck on the accepted baseline ----------
e4() {
  local OUT=$PLUS/E4; mkdir -p "$OUT"
  flavi_require cmalign
  local MENV; MENV=$(cm_env_require "$C5.cm")
  echo "model built by Infernal $(cm_version "$C5.cm") -> cmalign in env $MENV"
  need "$C5.cm" "${C5}_added.fa" "${C5}_library.tbl" "$FA" || return 1

  echo "== pp_check: PP of the 6 added sequences, aligned WITHOUT --mapali"
  conda run -n "$MENV" cmalign --cpu $CPU -o "$OUT/pp_check.stk" "$C5.cm" "${C5}_added.fa" \
    > "$OUT/pp_check.log" || return 1
  python3 - "$OUT/pp_check.stk" <<'PY'
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
cons=[i for i,c in enumerate(rf) if c.isalpha()]       # uppercase AND lowercase RF = match column
assert len(cons)==81, f"clen {len(cons)}, expected 81"
print("PP key: '*' = >0.95, '9' = 0.85-0.95, digits below that are lower; '.' = gap")
print("the triple column is the MIDDLE one of each 5-wide window\n")
for n in seqs:
    print(n)
    for k in (7,29,43):
        a = max(k-3, 0)                      # 0-indexed consensus col for cm k-2
        b = min(k+1, len(cons)-1)            # 0-indexed consensus col for cm k+2
        lo, hi = cons[a], cons[b]
        # the triple column itself, and its own PP
        t = cons[k-1]
        tpp = pp[n][t] if n in pp else '?'
        print(f"  cm {a+1}-{b+1}  RF {rf[lo:hi+1]}  seq {seqs[n][lo:hi+1]}"
              + (f"  PP {pp[n][lo:hi+1]}" if n in pp else "  PP (none)")
              + f"   | cm {k} = {seqs[n][t]} PP {tpp}")
PY
  echo "   expect: no insertions, PP >= 0.95 at cm 7/29/43. An occupied insert column"
  echo "   next to cm 29 or 43 with PP <~ 0.6 means that readout is unreadable, not absent."

  echo
  echo "== insertcheck: do included library sites occupy the insert columns beside cm 29 / 43?"
  # cm_round_stats.py fetch writes to its OUT argument EXACTLY -- no suffix is added.
  # Passing "$OUT/insertcheck" and then looking for insertcheck.fetchlist is what failed on 11-17.
  local FL2=$OUT/insertcheck.fetchlist
  python3 "$FLAVISCRIPTS/cm_round_stats.py" fetch "${C5}_library.tbl" 81 0.70 "$FL2" || return 1
  need "$FL2" || return 1
  echo "fetch list: $FL2  ($(wc -l < "$FL2") rows, >=70% model coverage, ! plus-strand only)"
  esl-sfetch -Cf "$FA" "$FL2" > "$OUT/insertcheck.fa" || return 1
  conda run -n "$MENV" cmalign --cpu $CPU -o "$OUT/insertcheck.stk" "$C5.cm" "$OUT/insertcheck.fa" \
    > "$OUT/insertcheck.log" || return 1
  python3 - "$OUT/insertcheck.stk" <<'PY'
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
  cat <<'EOF'
   a handful occupied  -> sequence-level variation; seed layout stands, go to e5.
   a large fraction    -> the seed misdescribes the family there: add a column (edit RF in
                          the .sto, cmbuild --hand) and re-run the whole comparison BEFORE E6.
EOF
  echo "then: clog class1b 'E4 pp_check + insertcheck' '<PP at cm 7/29/43; insert occupancy>'"
}

# ---------- E5: main Class_1b clusters, and the cluster of every B1/B2 site ----------
e5() {
  need "$EXPLORER" || { find "$ROOT" -name flavi150_explorer.html; return 1; }
  local X=$SCAN
  # explorer_cm_scan.py extract is the VALIDATED parser -- it derives the frozen cluster `fz`
  # per node and produced the memberships recorded in Part 3 (41 12/12, 44 8/8, 5 5/5, 106 3/3).
  # Prefer its node table; `fz` is not a raw field on DATA.nodes.
  # prefer the PLAIN node table: nodes_class1c.tsv / nodes_cl3.tsv are annotated variants and an
  # mtime-ordered glob picks whichever was written last (it picked nodes_cl3.tsv on 2026-11-17).
  local TSV=""
  for c in "$X/nodes.tsv" "$X/nodes_all.tsv"; do [ -s "$c" ] && { TSV=$c; break; }; done
  [ -n "$TSV" ] || TSV=$(ls -t "$X"/nodes*.tsv 2>/dev/null | head -1)
  if [ -z "$TSV" ]; then
    cat <<'EOF'
No node table under $SCAN.
  `explorer_cm_scan.py extract` would normally write it, but on the REGENERATED explorer it
  raises KeyError: 'fz' -- its nodes no longer carry that field (the assignment moved to
  DATA.sets[].cl). Apply scripts/explorer_cm_scan_fz.patch first, then re-run e5.
  Falling back to reading DATA.sets directly; check the chosen set before trusting the numbers.
EOF
    python3 "$FLAVISCRIPTS/explorer_class1b_clusters.py" "$EXPLORER" --list-sets
    python3 "$FLAVISCRIPTS/explorer_class1b_clusters.py" "$EXPLORER" \
      | tee "$PLUS/E5_class1b_clusters.txt"
    return 0
  fi
  if [ -n "$TSV" ]; then
    echo "node table: $TSV"
    python3 "$FLAVISCRIPTS/explorer_class1b_clusters.py" "$TSV" | tee "$PLUS/E5_class1b_clusters.txt"
  else
    echo "extract wrote no node table; falling back to reading DATA.sets directly."
    echo "Check the set it picks against --list-sets before trusting the numbers."
    python3 "$FLAVISCRIPTS/explorer_class1b_clusters.py" "$EXPLORER" --list-sets
    python3 "$FLAVISCRIPTS/explorer_class1b_clusters.py" "$EXPLORER" \
      | tee "$PLUS/E5_class1b_clusters.txt"
  fi
  echo
  echo "then: fill frozen_cluster/group in Part 1 B1-B2 and the <B4> rows of Part 9's"
  echo "class1b_groups.tsv, and: clog class1b 'E5 main Class_1b clusters' '<clusters; labels>'"
}

e8() {
  flavi_require
  OUT=$PLUS/E8_downstream; mkdir -p "$OUT"
  echo "== E8. Is the unit positional? 'the 3'-most copy of every ISF array'"
  echo "   Untested by E2 (a bit-score cut), by newvirus (a novelty cut) and by"
  echo "   the 11-03 sub-threshold tests (one site at a time). E5's satellite"
  echo "   pattern is the reason to think this set is the real one."
  echo

  # view 1: the explorer's clustering, which knows nothing about any CM
  TSV=$SCAN/nodes.tsv
  if [ -s "$TSV" ]; then
    echo "-- view 1: explorer nodes (CM-independent)"
    ( cd "$OUT" && python3 -I "$FLAVISCRIPTS/class1b_arrays.py" nodes "$TSV" ) \
      | tee "$OUT/arrays_from_nodes.txt"
  else
    echo "no $TSV -- run e5 first (or explorer_cm_scan.py extract)"
  fi
  echo

  # view 2: the deployed baseline's own tbl, which carries bits and inclusion
  BASE=${C5}_library.tbl
  if [ -s "$BASE" ]; then
    echo "-- view 2: the accepted model's library tbl ($BASE)"
    # --seed excludes loci already in the accepted seed; --satellites lets the
    # CM-independent clustering exempt a candidate from the bit floor
    ( cd "$OUT" && python3 -I "$FLAVISCRIPTS/class1b_arrays.py" tbl "$BASE" \
        --seed "$C5.stk" --satellites satellites.tsv ) \
      | tee "$OUT/arrays_from_tbl.txt"
  else
    echo "no library tbl for $C5 -- expected ${C5}_library.tbl"
    return 1
  fi

  echo
  echo "READING THE TWO VIEWS: they do NOT enumerate the same population, so"
  echo "copy COUNTS are expected to differ -- view 1 lists explorer features,"
  echo "view 2 lists CM hits, and a locus can be in either alone. Compare by"
  echo "POSITION, which is what --satellites does. Known counterexample from E5:"
  echo "MW897328's odd copy (10653, fz 135) is UPSTREAM of its main-cluster copy"
  echo "(11228, fz 133)."
  echo
  echo "then: e8b   (builds the positional set and runs the no-loss rule)"
}

e8b() {
  flavi_require
  OUT=$PLUS/E8_downstream
  FL=$OUT/positional_candidates.fetchlist
  [ -s "$FL" ] || { echo "no $FL -- run e8 first"; return 1; }
  echo "== E8b. seed the positional set and apply the no-loss rule"
  wc -l "$FL"
  MENV=$(cm_env_require "$C5.cm") || return 1
  MODEL=class1b_v3_downstream_inf112

  esl-sfetch -Cf "$FA" "$FL" > "$OUT/${MODEL}_added.fa"
  # --mapali against the ACCEPTED seed, not the provided one: this tests whether
  # the positional set adds to the model being deployed, which is the question.
  cmalign --cpu "$CPU" --mapali "$C5.stk" -o "$OUT/$MODEL.stk" \
    "$C5.cm" "$OUT/${MODEL}_added.fa" > "$OUT/${MODEL}_cmalign.log"
  echo "-- added sequences, aligned (cm from-to, trunc, bits, avg PP)"
  grep -v '^#' "$OUT/${MODEL}_cmalign.log" | awk 'NF>=8 {print $2, $4"-"$5, $6, $7, $8}'

  conda run -n "$MENV" cmbuild --hand -F -n "$MODEL" "$OUT/$MODEL.cm" "$OUT/$MODEL.stk" \
    > "$OUT/${MODEL}_cmbuild.log"
  conda run -n "$MENV" cmcalibrate --cpu "$CPU" "$OUT/$MODEL.cm" > "$OUT/${MODEL}_cmcalibrate.log"
  cmsearch --toponly --incE 0.01 --cpu "$CPU" -o /dev/null \
    --tblout "$OUT/${MODEL}_library.tbl" "$OUT/$MODEL.cm" "$FA"

  echo "-- cmstat: nseq eff_nseq clen bps bifs (watch eff_nseq against 50.24)"
  conda run -n "$MENV" cmstat "$OUT/$MODEL.cm" | grep -v '^#'
  echo "-- compare against the accepted baseline"
  python3 "$FLAVISCRIPTS/cm_round_stats.py" compare \
    "${C5}_library.tbl" "$OUT/${MODEL}_library.tbl"
  echo "-- the nine marginal sites E2 found are the ones to watch"
  grep -E 'AB021287|NC_027819|MH827524|MH307700|NC_021069|AB981186|NC_012671|LR694076|MH237596|LOST|NEW' \
    "$OUT/${MODEL}_library.tbl.compare.tsv"

  echo
  echo "DECISION RULE, same as every merge here: accept only if no included hit"
  echo "is lost. E2 predicts failure -- eff_nseq fell 50.24 -> 25.58 on 38 similar"
  echo "sequences and the marginal band went with it. But this set is small and"
  echo "coherent rather than a bit-score cut, so the prediction is worth testing:"
  echo "if a few positionally-defined sequences DEFINE the subtype, scores rise"
  echo "where a broad cut flattens them. Either result settles what v2 deploys."
  echo
  echo "then: clog class1b 'E8 positional downstream set' '<nseq/eff_nseq; lost; verdict>'"
}

case "${1:-}" in
  e1|e2|e2b|e3|e4|e5|e8|e8b) "$1" ;;
  *) sed -n '2,4p' "$0"; exit 2 ;;
esac
