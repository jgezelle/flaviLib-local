#!/usr/bin/env bash
# The new-candidate track, split at YOUR manual step (CM_CANDIDATES.md Part 8).
#
#   cm_candidate.sh align <CAND> <explorer80.fa> [more.fa ...]   -> GATE 1, stops at MATER
#   ----- MANUAL: MATER pseudoknots -> hand-edit SS_cons -> wiggle-refine -> R-scape -----
#   cm_candidate.sh build <CAND> <refined.stk>                   -> GATE 2, model, searches
#   cm_candidate.sh build --library-only <CAND> <refined.stk>    -> stop after the library search
#
#   cm_candidate.sh subset <NEW> <refined.stk> keep|drop <names> -> rebuild an existing refined
#       alignment minus some sequences, reusing its hand-made structure and cm numbering. No
#       manual step. Use when the question is "the same model, without those sequences".
#
# Replaces build_candidate_cm.sh, whose recorded defects this fixes: GATE 1 passing on an
# energy parse failure, the alifold regex missing mlocarna's line format and space-padded
# energies, mlocarna's exit status unchecked, R-scape's outdir not created, the tblout path
# not printed. Candidate naming: cand_<CLADE>_<yymmdd> (Part 9).
set -uo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/flavi_env.sh"

align() {
  local CAND=$1; shift
  if [ $# -lt 1 ]; then
    cat <<EOF
give at least one seed FASTA.

Variables such as \$FA106 live in flavi_env.sh and are NOT in your interactive shell unless you
source it. Either source it once per terminal:
    source \$FLAVISCRIPTS/flavi_env.sh
    bash \$FLAVISCRIPTS/cm_candidate.sh align $CAND \$FA106
or pass the literal path:
    bash \$FLAVISCRIPTS/cm_candidate.sh align $CAND \\
      $SCAN/FJIS_fz106_explorer80.fa

Known cluster FASTAs in \$SCAN:
EOF
    ls "$SCAN"/*explorer80.fa 2>/dev/null | sed 's|^|    |' || echo "    (none found in $SCAN)"
    return 1
  fi
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

# ---------- subset: rebuild an existing hand-refined alignment minus some sequences ----------
# For "the same model, without cluster 5". Reuses the pooled MATER/CaCoFold alignment instead of
# re-deriving a consensus, so the hand work and the cm column numbering are both preserved.
#
#   cm_candidate.sh subset <NEWNAME> <pooled_refined.stk> <keep|drop> <name-or-prefix> [more ...]
#
# keep = keep only these sequences; drop = keep everything else. Names may be full Stockholm
# sequence names or unambiguous prefixes (an accession is usually enough).
subset() {
  local KEEPCOLS=0
  if [ "${1:-}" = --keep-columns ]; then KEEPCOLS=1; shift; fi
  local NEW=$1 STK=$2 MODE=$3; shift 3
  [ $# -ge 1 ] || { echo "name at least one sequence"; return 1; }
  case "$MODE" in keep|drop) ;; *) echo "mode must be keep or drop"; return 1 ;; esac
  need "$STK" || return 1

  local B=$INFERNAL/build/$NEW/$ITER; mkdir -p "$B/cm"
  local SUB=$B/${NEW}.stk

  # resolve the named prefixes against the alignment's actual sequence names
  grep -vE '^(#|//|$)' "$STK" | awk 'NF==2{print $1}' | sort -u > "$B/all_names.txt"
  : > "$B/named.txt"
  local n
  for n in "$@"; do
    if ! grep -F "$n" "$B/all_names.txt" >> "$B/named.txt"; then
      echo "no sequence in $STK matches '$n'"; return 1
    fi
  done
  sort -u "$B/named.txt" -o "$B/named.txt"
  if [ "$MODE" = keep ]; then cp "$B/named.txt" "$B/keep.txt"
  else comm -23 "$B/all_names.txt" "$B/named.txt" > "$B/keep.txt"; fi
  echo "alignment has $(wc -l < "$B/all_names.txt") sequences; keeping $(wc -l < "$B/keep.txt"):"
  sed 's|^|    |' "$B/keep.txt"
  [ -s "$B/keep.txt" ] || { echo "nothing left to keep"; return 1; }

  flavi_require esl-alimanip cmbuild cmcalibrate cmstat cmsearch
  esl-alimanip --seq-k "$B/keep.txt" -o "$SUB" "$STK" > "$B/alimanip.log" 2>&1 \
    || { echo "esl-alimanip FAILED, see $B/alimanip.log"; return 1; }

  # Columns are NOT trimmed. With #=GC RF present, cmbuild --hand keeps every RF column as a
  # consensus column even where the retained sequences gap it, so clen and the cm numbering stay
  # identical to the pooled model -- which is what makes cm 7 / 29 / 43 comparable across the two.
  local HAND=""
  if grep -q '^#=GC RF' "$SUB"; then
    HAND="--hand"
    echo "RF present -> cmbuild --hand: clen and cm column numbering preserved from the source alignment"
  elif [ $KEEPCOLS -eq 1 ]; then
    # Synthesise RF over every column the SOURCE alignment occupies, so --hand keeps the full
    # column set and cm numbering matches the source model. Costs model size: columns gapped in
    # the retained sequences become consensus columns carrying prior-only emissions.
    python3 -I - "$STK" "$SUB" <<'PYEOF'
import sys, collections
def read(p):
    seqs=collections.OrderedDict(); gc=collections.OrderedDict(); order=[]
    for line in open(p):
        l=line.rstrip('\n')
        if l.startswith('#=GC'):
            k=l.split()[1]; gc[k]=gc.get(k,'')+l.split(None,2)[2]; continue
        if l.startswith('#') or l.startswith('//') or not l.strip(): continue
        f=l.split()
        if len(f)==2:
            if f[0] not in seqs: order.append(f[0])
            seqs[f[0]]=seqs.get(f[0],'')+f[1]
    return seqs, gc, order
src,_,_   = read(sys.argv[1])
sub,gc,order = read(sys.argv[2])
L=len(next(iter(sub.values())))
rf=''.join('x' if any(s[i] not in '-.~' for s in src.values()) else '.' for i in range(L))
with open(sys.argv[2],'w') as o:
    o.write('# STOCKHOLM 1.0\n')
    w=max([len(n) for n in order]+[len('#=GC '+k) for k in list(gc)+['RF']])
    for n in order: o.write(f'{n:<{w}}  {sub[n]}\n')
    for k,v in gc.items(): o.write(f'{"#=GC "+k:<{w}}  {v}\n')
    o.write(f'{"#=GC RF":<{w}}  {rf}\n//\n')
print(f'synthesised #=GC RF over {rf.count("x")} of {L} columns (occupied in the source alignment)')
PYEOF
    HAND="--hand"
    echo "-> cmbuild --hand on the synthesised RF: cm numbering matches $(basename "$STK")"
  else
    cat <<EOF
WARNING: no #=GC RF in $(basename "$STK").
  Match columns will be re-inferred by occupancy, so clen WILL move and cm coordinates will NOT be
  comparable with the source model -- which is usually the whole point of taking a subset.
  Either re-run with --keep-columns (synthesises RF over the source's occupied columns), or feed
  the R-scape / CaCoFold output, which carries RF.
  Continuing without --hand.
EOF
  fi

  local CM=$B/cm/$NEW.cm
  cmbuild $HAND -F -n "$NEW" "$CM" "$SUB" > "$B/cm/cmbuild.log" || return 1
  cmcalibrate --cpu $CPU "$CM" > "$B/cm/cmcalibrate.log" || return 1
  echo "GATE 2"; cmstat "$CM" | grep -v '^#'
  echo "built by Infernal $(cm_version "$CM")"

  echo
  echo "== library search"
  cmsearch --toponly --incE 0.01 --cpu $CPU -o /dev/null --tblout "$B/${NEW}_library.tbl" "$CM" "$FA" || return 1
  echo "   included hits: $(awk '$1!~/^#/ && $17=="!"' "$B/${NEW}_library.tbl" | wc -l)"
  echo "   seed-only here is the SATURATION signal: it says the blocker is sequences, not modelling."
  echo "   tblout: $B/${NEW}_library.tbl"

  cat <<EOF

NEXT -- the reciprocal test, which is the point of building subsets (Part 8 overlap check):
  build the complementary subset the same way, then score each seed with the other's model and
  compare BIT SCORES in both directions. A pair of elements that are one family scores well both
  ways; siblings score moderately; unrelated score not at all.
  Then: hits_at_stall "$B/${NEW}_library.tbl" <ACC:stall> ...   to check by position, not accession.
EOF
  echo "then: clog $NEW 'subset of $(basename "$STK") ($MODE: $*)' '<cmstat; included hits; reciprocal bits>'"
}

build() {
  LIBRARY_ONLY=0
  if [ "${1:-}" = "--library-only" ]; then LIBRARY_ONLY=1; shift; fi
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

  if [ "${LIBRARY_ONLY:-0}" = 1 ]; then
    echo
    echo "== stopping after the library search (--library-only)"
    echo "Read $B/search_library/r0/search.tbl before spending time on the wider target:"
    echo "  * hits that are ONLY the seed sequences = saturation, and the DB search is the"
    echo "    whole point rather than a formality -- the model has nothing to find here."
    echo "  * hits beyond the seed = the library already contains relatives, and those should"
    echo "    be read (and their frozen clusters checked) BEFORE the DB adds more."
    echo "  * no hits at all, not even the seed = the model is broken; do not search further."
    echo
    echo "then, when ready:"
    echo "  bash \$FLAVISCRIPTS/cm_candidate.sh build $CAND $STK   # without --library-only"
    return 0
  fi

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
  align|build|subset) cmd=$1; shift; "$cmd" "$@" ;;
  *) sed -n '2,8p' "$0"; exit 2 ;;
esac
