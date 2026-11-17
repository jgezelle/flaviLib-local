#!/usr/bin/env bash
# The new-candidate track, split at YOUR manual step (CM_CANDIDATES.md Part 8).
#
#   cm_candidate.sh align <CAND> <explorer80.fa> [more.fa ...]   -> GATE 1, stops at MATER
#   ----- MANUAL: MATER pseudoknots -> hand-edit SS_cons -> wiggle-refine -> R-scape -----
#   cm_candidate.sh build <CAND> <refined.stk>                   -> GATE 2, model, searches
#
# Replaces build_candidate_cm.sh, whose recorded defects this fixes: GATE 1 passing on an
# energy parse failure, the alifold regex missing mlocarna's line format and space-padded
# energies, mlocarna's exit status unchecked, R-scape's outdir not created, the tblout path
# not printed. Candidate naming: cand_<CLADE>_<yymmdd> (Part 9).
set -uo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/flavi_env.sh"

align() {
  local CAND=$1; shift
  [ $# -ge 1 ] || { echo "give at least one seed FASTA"; return 1; }
  flavi_require mlocarna R-scape

  local B=$INFERNAL/build/$CAND/$ITER
  [ -d "$B/mlocarna" ] && { echo "$B/mlocarna already exists -- align has run here."
    echo "  To redo it, move it aside. To continue from it, go to the MANUAL step on"
    echo "  $B/mlocarna/results/result-oneblock.stk"; return 1; }
  mkdir -p "$B/mlocarna" "$B/rscape" "$(dirname "$B")/seed"
  local SEED=$(dirname "$B")/seed/$CAND.fa
  : > "$SEED"
  local f
  for f in "$@"; do [ -s "$f" ] || { echo "MISSING: $f"; return 1; }; cat "$f" >> "$SEED"; done
  local NSEQ=$(grep -c '^>' "$SEED")
  echo "== $CAND: $NSEQ seqs from $*"
  [ "$NSEQ" -ge 3 ] || { echo "fewer than 3 sequences: no covariation is possible"; return 1; }

  mlocarna --stockholm --consensus-structure=alifold --probabilistic --consistency-transformation \
    --tgtdir "$B/mlocarna" "$SEED" > "$B/mlocarna.log" 2>&1 \
    || { echo "mlocarna FAILED, see $B/mlocarna.log"; return 1; }   # exit status checked

  local RES=$B/mlocarna/results
  [ -s "$RES/result.stk" ] || { echo "no $RES/result.stk"; return 1; }
  stk_oneblock "$RES/result.stk" "$RES/result-oneblock.stk"

  # ---- GATE 1: the alifold COVARIANCE term, per base pair ----
  local ALI; ALI=$(alifold_line "$B/mlocarna.log")
  local ENER; ENER=$(printf '%s' "$ALI" | grep -oE '\( *-?[0-9.]+ *= *-?[0-9.]+ *\+ *-?[0-9.]+\)')
  if [ -z "$ENER" ]; then
    echo "GATE 1 CANNOT BE READ: no energy triple in $B/mlocarna.log."
    echo "  Take the line from mlocarna's terminal output by hand. NOT a pass."
    return 1                                        # the recorded defect: never pass on a parse failure
  fi
  local STRUCT=${ALI%% *}
  local BP=$(printf '%s' "$STRUCT" | tr -cd '(' | wc -c | tr -d ' ')
  local COV=$(printf '%s' "$ENER" | awk -F'+' '{gsub(/[) ]/,"",$2); print $2}')
  echo "GATE 1  $ENER   bp $BP   covariance/bp $(awk -v c="$COV" -v b="$BP" 'BEGIN{if(b>0)printf "%.2f", c/b; else print "n/a"}')"
  echo "  references, per bp: cluster106 -0.69, cluster5 -0.53, hepaci ~-0.5 (kept), clusterA -0.90"
  echo "  pegivirus was SET ASIDE on a weak covariance term. Weak => add sequences or split,"
  echo "  do not hand-edit it into shape."

  R-scape -s --outdir "$B/rscape" "$RES/result-oneblock.stk" > "$B/rscape/rscape_s.log" 2>&1
  ls "$B"/rscape/*.cov >/dev/null 2>&1 && head -12 "$B"/rscape/*.cov

  clog "$CAND" "mlocarna --probabilistic --consistency-transformation, $NSEQ seqs from $*" \
       "alifold $ALI; $BP bp; R-scape -s: <significant pairs>, power <range>"

  cat <<EOF

---- STOP. YOUR MANUAL STEP ----
Open in MATER:   $RES/result-oneblock.stk
  1. MATER: find the pseudoknots (label-pair notation, AAAA...aaaa)
  2. hand-edit SS_cons        -> save as result-oneblock_edit\$(date +%y%m%d).stk
  3. MATER wiggle-refine      -> *-MATER-wiggle-refined.stk      <- this is the seed
  4. R-scape -s --cacofold (or R-scape inside MATER, -s --onemsa) on the refined file
Then log what changed -- the gap recorded for class1c and clusterA, which is why neither
is reproducible:
  clog $CAND 'MATER + CaCoFold' 'PK <cols>; SS_cons edits <cols>; R-scape <n> bp, <n> covarying, avgid <x>'
Then:
  bash \$FLAVISCRIPTS/cm_candidate.sh build $CAND $RES/<refined>.stk
EOF
}

build() {
  local CAND=$1 STK=$2
  [ -s "$STK" ] || { echo "MISSING: $STK"; return 1; }
  flavi_require cmbuild cmcalibrate cmstat cmsearch
  local B=$INFERNAL/build/$CAND/$ITER
  mkdir -p "$B/cm"
  local CM=$B/cm/$CAND.cm

  # --hand ONLY on an alignment carrying RF (R-scape output, or a previous cmalign).
  # A raw mlocarna / MATER-edited Stockholm has none and --hand fails.
  local HAND=""
  if grep -q '^#=GC RF' "$STK"; then
    HAND="--hand"; echo "RF present -> cmbuild --hand (consensus columns fixed by RF)"
  else
    echo "no RF line -> plain cmbuild (match columns re-inferred by occupancy; clen may move)"
  fi

  # A new candidate has no prior model, so it is built with $CONDA_ENV's Infernal, and the
  # version is recorded in its own header for every later step to read (cm_version).
  cmbuild $HAND -F -n "$CAND" "$CM" "$STK" > "$B/cm/cmbuild.log" || return 1
  cmcalibrate --cpu $CPU "$CM" > "$B/cm/cmcalibrate.log" || return 1
  echo "built by Infernal $(cm_version "$CM"); realign it later in env $(cm_env_for "$CM")"

  # ---- GATE 2: cmstat eff_nseq (reported, not enforced) ----
  echo "GATE 2"; cmstat "$CM" | grep -v '^#'
  echo "  references: Class_2 3.58 (curated), class1c 9.54, hepaci_hits_v2 19.93;"
  echo "  REJECTION case cand_PLLG_260915_cmalign 1.55. A low eff_nseq only matters together"
  echo "  with what the model then does: few hits beyond the training set = overfitting."

  echo
  echo "== library first (cheap; a seed-only result here is EXPECTED and is the saturation signal)"
  "$FLAVISCRIPTS/cm_iterate.sh" --name "$CAND" --cm "$CM" --seed "$STK" \
    --target "$FA" --label library --workdir "$B/search_library" --doc "$DOC" --check-only
  echo "   tblout: $B/search_library/r0/search.tbl"

  echo
  echo "== then the wider target (long). --toponly --incE 1e-10 are fixed by default."
  "$FLAVISCRIPTS/cm_iterate.sh" --name "$CAND" --cm "$CM" --seed "$STK" \
    --target "$DB" --label RNAvirusDB --workdir "$B/search_RNAvirusDB" --doc "$DOC" --check-only
  echo "   tblout: $B/search_RNAvirusDB/r0/search.tbl"

  cat <<EOF

NEXT, before this stops being a candidate (Part 3 card + Part 8 overlap check):
  - reciprocal scoring against class1c and Class_1b seeds, both directions
  - per-site overlap with the 7 models by POSITION, not accession membership
    (python3 \$FLAVISCRIPTS/cm_round_stats.py overlap A.tbl B.tbl $CAND other)
  - compare bit scores, never E-values, between searches of different targets
  - if the DB is saturated at the seed, the blocker is sequences: a targeted NCBI set (E7)
  - name it only on acceptance: class<N>, not cand_
EOF
}

case "${1:-}" in
  align|build) cmd=$1; shift; "$cmd" "$@" ;;
  *) sed -n '2,8p' "$0"; exit 2 ;;
esac
