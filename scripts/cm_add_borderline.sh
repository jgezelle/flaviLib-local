#!/usr/bin/env bash
# cm_add_borderline.sh -- step 17: does adding sub-threshold hits to a CM's seed help or hurt?
#
# For each variant (v0 = seed only, plus one per --add):
#   1. the variant's sub-threshold spans are taken from the model's own library tblout
#      (`?` rows, plus strand, model coverage >= --minfrac), fetched with esl-sfetch -C
#   2. cmalign --mapali SEED: the added sequences are aligned to the model and appended to the
#      seed unchanged (MATER / CaCoFold edits kept); v0 is the seed itself
#   3. cmbuild -> cmcalibrate -> cmsearch --toponly vs the library.
#      v0 = plain cmbuild on the seed, exactly how class1c was built, so v0 reproduces the
#      annotating model (checked: clen must equal the input CM's).
#      variants = cmbuild --hand on the --mapali output, whose #=GC RF is the model's own match
#      columns, so consensus columns are identical to v0's and only the added sequences differ.
#      (Tested 2026-10-29: plain cmbuild on the --mapali output moves clen 84 -> 85, because
#      cmalign re-lays out the seed's insert columns and one crosses the 50 % occupancy line;
#      --hand on the raw seed gives 83, because the seed's own RF line is not the model's.)
#   4. compared with v0: cmstat, included hits / accessions, per-hit bit-score change on v0's
#      included hits (lost / lower / worst delta), included hits that are neither in v0 nor
#      among the added sequences, each added sequence's own score, and its mean alignment
#      posterior probability (PP) from cmalign
# One run-log row per variant goes to --doc.
#
# Usage:
#   cm_add_borderline.sh --name class1c --cm $CMSET/class1c.cm --seed $C1C/seed/pesti_20260917_edit.stk \
#     --tbl $C1C/tblout/class1c_20260917.tbl --target $FA --workdir $C1C/iter_v2_borderline \
#     --add ky=KY370101 --add on=ON949931 --add nc=NC_025677 --add ky_on=KY370101,ON949931 \
#     --doc $DOC
# Options (defaults): --minfrac 0.85 --cpu 4 --calib "" (extra cmcalibrate args, testing only)
# Judge on the comparison, not on the added sequences' own scores: a sequence in the seed
# always scores well against the model built from it.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PY="python3 $HERE/cm_round_stats.py"; LOG="python3 $HERE/cm_log.py"
MINFRAC=0.85; CPU=4; CALIB=""; DOC=""; ADDS=()
while [ $# -gt 0 ]; do
  case "$1" in
    --name) NAME=$2; shift 2;; --cm) CM=$2; shift 2;; --seed) SEED=$2; shift 2;;
    --tbl) TBL=$2; shift 2;; --target) TARGET=$2; shift 2;; --workdir) WORK=$2; shift 2;;
    --add) ADDS+=("$2"); shift 2;; --doc) DOC=$2; shift 2;; --minfrac) MINFRAC=$2; shift 2;;
    --cpu) CPU=$2; shift 2;; --calib) CALIB=$2; shift 2;;
    -h|--help) sed -n '2,26p' "$0"; exit 0;;
    *) echo "unknown option $1" >&2; exit 2;;
  esac
done
for v in NAME CM SEED TBL TARGET WORK; do [ -n "${!v:-}" ] || { echo "missing --$(echo $v | tr A-Z a-z)" >&2; exit 2; }; done
for f in "$CM" "$SEED" "$TBL" "$TARGET"; do [ -s "$f" ] || { echo "not found or empty: $f" >&2; exit 1; }; done
[ ${#ADDS[@]} -gt 0 ] || { echo "no --add variants" >&2; exit 2; }
for h in cm_round_stats.py cm_log.py; do [ -s "$HERE/$h" ] || { echo "$h missing from $HERE" >&2; exit 1; }; done
for t in cmalign cmbuild cmcalibrate cmsearch cmstat esl-sfetch; do command -v $t >/dev/null || { echo "$t not on PATH" >&2; exit 1; }; done
log() { echo "[$NAME] $1: $2"; [ -z "$DOC" ] || $LOG "$DOC" --model "$NAME" --step "$1" --result "$2" >/dev/null; }

mkdir -p "$WORK"; [ -f "$TARGET.ssi" ] || esl-sfetch --index "$TARGET" >/dev/null
CLEN=$(cmstat "$CM" | awk '$1!~/^#/ && NF>5 {print $6; exit}')

# all sub-threshold, plus-strand, near-full-length rows of the model's own search
awk -v c="$CLEN" -v f="$MINFRAC" '$1!~/^#/ && $17=="?" && $10=="+" && ($7-$6+1)>=f*c {print $1"/"$8"-"$9, $8, $9, $1}' \
  "$TBL" > "$WORK/subthreshold.fetchlist"
echo "sub-threshold full-length spans in $(basename "$TBL"):"; cat "$WORK/subthreshold.fetchlist"

build() {  # build VARIANT STK [--hand]; reuses a finished earlier build of the same variant
  if [ -s "$WORK/$1/search.tbl" ] && [ -s "$WORK/$1/cmstat.txt" ] && tail -1 "$WORK/$1/search.tbl" | grep -q '^# \[ok\]'; then
    echo "[$NAME] $1: reusing $WORK/$1 (delete the directory to rebuild)"; return 0
  fi
  cmbuild ${3:-} -F -n "${NAME}_$1" "$WORK/$1/${NAME}_$1.cm" "$2" > "$WORK/$1/cmbuild.log"
  cmcalibrate --cpu "$CPU" $CALIB "$WORK/$1/${NAME}_$1.cm" > "$WORK/$1/cmcalibrate.log"
  cmsearch --toponly --cpu "$CPU" --tblout "$WORK/$1/search.tbl" "$WORK/$1/${NAME}_$1.cm" "$TARGET" > /dev/null
  cmstat "$WORK/$1/${NAME}_$1.cm" > "$WORK/$1/cmstat.txt"
}
counts() {  # counts TBL -> "<n> ! hits / <n> accessions"
  echo "$(awk '$1!~/^#/ && $17=="!"' "$1" | wc -l | tr -d ' ') ! hits / $(awk '$1!~/^#/ && $17=="!"{split($1,a,"|"); print a[1]}' "$1" | sort -u | wc -l | tr -d ' ') accessions"
}

# v0: the seed, built with the same flags as every variant
mkdir -p "$WORK/v0"; build v0 "$SEED"
log "step 17 v0 (seed only, plain cmbuild = how the model was built)" "$($PY cmstat "$WORK/v0/cmstat.txt"); $(counts "$WORK/v0/search.tbl")"

for spec in "${ADDS[@]}"; do
  V=${spec%%=*}; ACCS=${spec#*=}; mkdir -p "$WORK/$V"
  : > "$WORK/$V/add.fetchlist"
  for A in ${ACCS//,/ }; do
    grep "^$A" "$WORK/subthreshold.fetchlist" >> "$WORK/$V/add.fetchlist" || { echo "$A: no full-length sub-threshold span in $TBL" >&2; exit 1; }
  done
  esl-sfetch -Cf "$TARGET" "$WORK/$V/add.fetchlist" > "$WORK/$V/add.fa"
  cmalign --cpu "$CPU" --mapali "$SEED" -o "$WORK/$V/merged.stk" "$CM" "$WORK/$V/add.fa" > "$WORK/$V/cmalign.log"
  build "$V" "$WORK/$V/merged.stk" --hand
  CMP=$($PY compare "$WORK/v0/search.tbl" "$WORK/$V/search.tbl")
  # added sequences: own score in this variant, mean PP in the merged alignment
  OWN=$(while read -r nm from to acc; do
          sc=$(awk -v t="$acc" -v f="$from" '$1==t && ($8-f)^2<=100 {print $15"b/"$16"/"$17; exit}' "$WORK/$V/search.tbl")
          pp=$(awk -v n="$nm" '$1=="#=GR" && $2==n && $3=="PP" {printf "%s", $4}' "$WORK/$V/merged.stk" \
               | python3 -c "import sys; s=sys.stdin.read(); v=[0.975 if c=='*' else int(c)/10+0.05 for c in s if c=='*' or c.isdigit()]; print(f'{sum(v)/len(v):.2f}' if v else 'NA')")
          printf '%s %s PP %s; ' "${acc%%|*}" "${sc:-not hit}" "$pp"
        done < "$WORK/$V/add.fetchlist")
  # included hits that are neither v0 hits nor the added sequences
  NEW=$(awk '$1!~/^#/ && $17=="!" {print $1, $8}' "$WORK/$V/search.tbl" | while read -r t s; do
          awk -v t="$t" -v s="$s" '$1==t && ($8-s)^2<=100 && $17=="!"{f=1} END{exit !f}' "$WORK/v0/search.tbl" && continue
          awk -v t="$t" -v s="$s" '$4==t && ($2-s)^2<=100 {f=1} END{exit !f}' "$WORK/$V/add.fetchlist" && continue
          printf '%s:%s ' "${t%%|*}" "$s"
        done)
  log "step 17 $V (+$ACCS, cmalign --mapali, cmbuild --hand)" \
      "$($PY cmstat "$WORK/$V/cmstat.txt"); $(counts "$WORK/$V/search.tbl"); vs v0: $CMP; added: ${OWN}other new ! hits: ${NEW:-none}. Per-hit: $WORK/$V/search.tbl.compare.tsv"
done
V0CLEN=$(awk '$1!~/^#/ && NF>5 {print $6; exit}' "$WORK/v0/cmstat.txt")
[ "$V0CLEN" = "$CLEN" ] || echo "WARNING: v0 clen $V0CLEN differs from $(basename "$CM") clen $CLEN -- v0 does not reproduce the model"
for spec in "${ADDS[@]}"; do V=${spec%%=*}
  c=$(awk '$1!~/^#/ && NF>5 {print $6; exit}' "$WORK/$V/cmstat.txt")
  [ "$c" = "$V0CLEN" ] || echo "WARNING: $V clen $c != v0 clen $V0CLEN -- comparison not column-consistent"
done
echo "Accept a variant only if v0's hits show lost=0 and no large lower_bits/worst_delta, clen/bps/bifs unchanged, and the added sequence aligns with high PP."
