#!/usr/bin/env bash
# cm_iterate.sh -- search -> saturation check -> cmalign -> rebuild -> re-search, logged live
# to CM_CANDIDATES.md.
#
# Round r:
#   1. cmsearch --toponly --incE $INCE  CM_r  vs TARGET           -> r<r>/search.tbl
#   2. fetch `!` hits covering >= MINFRAC of the model            -> r<r>/hits.fa
#   3. NOVELTY: a hit is novel if < NOVEL_C (0.80) of its 15-mers occur in the sequences the
#      current model was built from (round 0: the seed). 0.80 tolerates a hit span running
#      ~10 nt past the seed span; a new strain at 95 % identity shares only ~45 % of 15-mers. 0 novel hits = the model is SATURATED on
#      this target: realigning would only re-fit the seed. Stop.
#   4. r > 0: per-hit bit-score change against round r-1 (matched on target + seq-from +/-10)
#   5. otherwise: [cd-hit-est] -> cmalign to CM_r -> cmbuild [--hand] -> cmcalibrate -> CM_r+1
#
# Every round appends one row to the run-log table `### \`<name>\`` in --doc.
#
# Usage:
#   cm_iterate.sh --name class1c --cm cm/class1c.cm --seed seed/pesti_20260917_edit.stk \
#       --target fa/flavi_library_..._uniqueIDs.fa --workdir build/class1c/iter_v2_cmalign \
#       --doc ~/Desktop/viromelib/flaviLib/workflows/CM_CANDIDATES.md
#
# Options (defaults): --rounds 3  --incE 1e-10  --minfrac 0.85  --cpu 4  --dedup 0.98
#   --dedup none     skip cd-hit-est
#   --no-hand        plain cmbuild (re-infers match columns; clen may change)
#   --calib "ARGS"   extra cmcalibrate arguments (testing only, e.g. "-L 0.04")
#   --novel-c X      k-mer containment below which a hit counts as novel (0.80)
#   --label TEXT     added to each log row, e.g. the target name ("library", "RNAvirusDB")
#   --check-only     run round 0 (search + saturation) and stop, whatever the result
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PY="python3 $HERE/cm_round_stats.py"
LOG="python3 $HERE/cm_log.py"

ROUNDS=3; INCE=1e-10; MINFRAC=0.85; CPU=4; DEDUP=0.98; HAND=--hand; CALIB=""; DOC=""
LABEL=""; CHECK_ONLY=0; NOVEL_C=0.80
while [ $# -gt 0 ]; do
  case "$1" in
    --name) NAME=$2; shift 2;; --cm) CM=$2; shift 2;; --seed) SEED=$2; shift 2;;
    --target) TARGET=$2; shift 2;; --workdir) WORK=$2; shift 2;; --doc) DOC=$2; shift 2;;
    --rounds) ROUNDS=$2; shift 2;; --incE) INCE=$2; shift 2;; --minfrac) MINFRAC=$2; shift 2;;
    --cpu) CPU=$2; shift 2;; --dedup) DEDUP=$2; shift 2;; --no-hand) HAND=""; shift;;
    --calib) CALIB=$2; shift 2;; --label) LABEL=$2; shift 2;; --check-only) CHECK_ONLY=1; shift;;
    --novel-c) NOVEL_C=$2; shift 2;;
    -h|--help) sed -n '2,36p' "$0"; exit 0;;
    *) echo "unknown option $1" >&2; exit 2;;
  esac
done
for v in NAME CM SEED TARGET WORK; do
  [ -n "${!v:-}" ] || { echo "missing --$(echo $v | tr A-Z a-z)" >&2; exit 2; }
done
for f in "$CM" "$SEED" "$TARGET"; do [ -s "$f" ] || { echo "not found or empty: $f" >&2; exit 1; }; done
for t in cmsearch cmalign cmbuild cmcalibrate cmstat esl-sfetch; do
  command -v $t >/dev/null || { echo "$t not on PATH (conda activate viromelib?)" >&2; exit 1; }
done
grep -q '^ECMLC' "$CM" || { echo "$CM is not calibrated (no ECM lines); run cmcalibrate first" >&2; exit 1; }
[ -z "$DOC" ] || [ -w "$DOC" ] || { echo "--doc not writable: $DOC" >&2; exit 1; }

log() {  # log STEP RESULT
  echo "[$NAME] $1: $2"
  [ -z "$DOC" ] || $LOG "$DOC" --model "$NAME" --step "$1" --result "$2" >/dev/null
}

mkdir -p "$WORK"
TGT=$(basename "$TARGET"); TGT=${LABEL:-$TGT}
[ -f "$TARGET.ssi" ] || esl-sfetch --index "$TARGET" >/dev/null

CUR_CM="$CM"
KNOWN="$WORK/seed_ungapped.fa"
nseed=$($PY stk2fa "$SEED" "$KNOWN")
PREV_TBL=""

for r in $(seq 0 "$ROUNDS"); do
  R="$WORK/r$r"; mkdir -p "$R"
  cmstat "$CUR_CM" > "$R/cmstat.txt"
  STAT=$($PY cmstat "$R/cmstat.txt")
  CLEN=$(sed -E 's/.*clen=([0-9]+).*/\1/' <<<"$STAT")

  cmsearch --toponly --incE "$INCE" --cpu "$CPU" --tblout "$R/search.tbl" "$CUR_CM" "$TARGET" > "$R/search.out"
  nfetch=$($PY fetch "$R/search.tbl" "$CLEN" "$MINFRAC" "$R/hits.fetchlist")
  ninc=$(awk '$1!~/^#/ && $17=="!"' "$R/search.tbl" | wc -l)
  nacc=$(awk '$1!~/^#/ && $17=="!"{split($1,a,"|"); print a[1]}' "$R/search.tbl" | sort -u | wc -l)
  if [ "$nfetch" -eq 0 ]; then
    log "r$r cmsearch vs $TGT" "$(basename "$CUR_CM"): $STAT. $ninc ! hits, 0 pass the ${MINFRAC} model-coverage filter. Stopped."
    exit 0
  fi
  esl-sfetch -Cf "$TARGET" "$R/hits.fetchlist" > "$R/hits.fa"
  nfa=$(grep -c '^>' "$R/hits.fa")
  [ "$nfa" -eq "$nfetch" ] || { echo "fetched $nfa of $nfetch; check $R/hits.fetchlist" >&2; exit 1; }
  nnov=$($PY novel "$R/hits.fa" "$KNOWN" 15 "$NOVEL_C")

  cmp=""
  if [ -n "$PREV_TBL" ]; then cmp=" vs r$((r-1)): $($PY compare "$PREV_TBL" "$R/search.tbl")."; fi
  known_what=$([ "$r" -eq 0 ] && echo "seed ($nseed seqs)" || echo "r$((r-1)) alignment")

  if [ "$nnov" -eq 0 ]; then
    log "r$r cmsearch vs $TGT, --toponly --incE $INCE" \
        "$(basename "$CUR_CM"): $STAT. $ninc ! hits / $nacc accessions; $nfetch pass coverage >= $MINFRAC; **0 novel** vs $known_what.$cmp SATURATED on $TGT -- a cmalign round would only re-fit $known_what. Detail: $R/hits.novel.tsv"
    exit 0
  fi
  log "r$r cmsearch vs $TGT, --toponly --incE $INCE" \
      "$(basename "$CUR_CM"): $STAT. $ninc ! hits / $nacc accessions; $nfetch pass coverage >= $MINFRAC; **$nnov novel** vs $known_what.$cmp Detail: $R/hits.novel.tsv"

  if [ "$CHECK_ONLY" -eq 1 ] || [ "$r" -eq "$ROUNDS" ]; then
    echo "[$NAME] stopping after r$r ($([ "$CHECK_ONLY" -eq 1 ] && echo check-only || echo round limit))"
    exit 0
  fi

  IN="$R/hits.fa"
  if [ "$DEDUP" != none ] && command -v cd-hit-est >/dev/null; then
    cd-hit-est -i "$R/hits.fa" -o "$R/hits_nr.fa" -c "$DEDUP" -n 10 -M 0 -T "$CPU" -d 0 > "$R/cdhit.log"
    IN="$R/hits_nr.fa"
  fi
  nin=$(grep -c '^>' "$IN")

  NEXT="$R/${NAME}_r$((r+1)).cm"
  cmalign --cpu "$CPU" --outformat Stockholm -o "$R/aligned.stk" "$CUR_CM" "$IN" > "$R/cmalign.log"
  cmbuild $HAND -F -n "${NAME}_r$((r+1))" "$NEXT" "$R/aligned.stk" > "$R/cmbuild.log"
  cmcalibrate --cpu "$CPU" $CALIB "$NEXT" > "$R/cmcalibrate.log"
  cmstat "$NEXT" > "$R/cmstat_next.txt"
  log "r$r -> r$((r+1)) rebuild" \
      "$nin seqs (cd-hit ${DEDUP}) cmalign to $(basename "$CUR_CM"), cmbuild ${HAND:-(no --hand)}: $($PY cmstat "$R/cmstat_next.txt"). Model: $NEXT"

  CUR_CM="$NEXT"; KNOWN="$IN"; PREV_TBL="$R/search.tbl"
done
