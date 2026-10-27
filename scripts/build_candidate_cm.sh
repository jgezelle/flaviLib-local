#!/usr/bin/env bash
# Build a CANDIDATE covariance model from a cluster of unclassified stall windows, and STOP at the
# first point where the evidence says it is not worth continuing.
#
# TWO STAGES, SPLIT AT THE MANUAL STEP. The workflow in
# flaviLib/workflows/260914-260917_cm_expansion.md is:
#
#   fasta -> mlocarna -> dedup -> [ MANUAL: inspect for pseudoknots, hand-edit SS_cons in MATER,
#                                   wiggle-refine, CaCoFold ] -> cmbuild -> cmcalibrate -> cmsearch
#
# The manual step is where the structural judgement happens and must not be automated around.
# cmbuild reads only the primary SS_cons, so building before the hand-edit builds from alifold's
# nested guess instead of the annotated structure -- and crossing pairs (pseudoknots) can never be
# represented in a CM anyway, which is exactly why the hand annotation matters for deciding what
# the nested portion should be.
#
#   --stage align   fasta -> mlocarna -> dedup -> consensus (GATE 1), then STOP and hand off
#   --stage build   edited .stk -> cmbuild -> cmcalibrate -> cmstat (GATE 2) -> cmsearch
#
# Run `align`, do the manual work on the dedup alignment, then run `build` pointing at the edited
# file. The two gates sit either side of the manual step on purpose: gate 1 tells you whether the
# cluster is worth hand-editing at all, gate 2 tells you whether the edited model is worth
# searching with.
#
# GATE 1 -- alifold consensus. Pegivirus produced a single weak stem-loop (-3.56 total, -1.55
#   covariance) and was correctly set aside, while hepaci gave -24.24 and pesti -11.61. A consensus
#   near zero means the input is not one structural family; splitting further or adding sequences is
#   the answer, not pressing on.
#
# cmstat eff_nseq is REPORTED, NOT A GATE BY DEFAULT. An earlier version of this script blocked
#   below eff_nseq 5, which was wrong: that number was generalised from a single case
#   (clusterA_refined, nseq 24 / eff_nseq 1.55, judged overfit from CONTEXT -- it recovered little
#   beyond its own training set). The curated Class_2 model is nseq 38 / eff_nseq 3.58 and would
#   have been rejected by that gate.
#
#   eff_nseq is Infernal's entropy-weighting target: it down-weights similar sequences so the
#   model's information content per position hits a set value. A low value means the training
#   sequences are closely related, which for flavivirus 3' UTRs is a fact about the biology, not a
#   defect. Useful as context next to what the model then DOES -- a low eff_nseq together with hits
#   confined to the training set is the overfitting signature; a low eff_nseq with hits on new
#   accessions is not.
#
#   Reference values measured in this project:
#     Class_1a  75 / 9.31  / clen 74     Class_1b  88 / 48.62 / clen 81
#     Class_2   38 / 3.58  / clen 93     class1c   46 / 9.54  / clen 84
#     hepaci_hits_v2 55 / 19.93          clusterA_refined 24 / 1.55 (abandoned)
#
#   Pass --min-eff-nseq N explicitly to make it blocking.
#
# Two search settings are NOT the Infernal defaults, both from this project's own findings:
#   --toponly   the library is +ssRNA, so a minus-strand hit is never biological. cmsearch searches
#               both strands by default and a model whose stem is partly self-complementary matches
#               the reverse complement of its own site (PLLG: ranks 25-48 were minus-strand
#               self-hits of the same 24 accessions).
#   --incE      the default 0.01 is too permissive on this reference. The PLLG data showed a clean
#               gap with nothing between 1.7e-22 and 1.4e-04.
#
# NOTE ON THE INPUT POOL. Cluster FASTAs are built from windows around CALLED stalls, so an
# accession with no called stall cannot contribute. That is correct for discovery but means the
# pool inherits the detectability floor: the 9 not_assayed accessions (8 Orthohepacivirus +
# 1 Guaicovirus, see the run log) are absent by construction, not by choice.
set -euo pipefail

usage () {
  cat <<'USAGE'
usage:
  STAGE 1, before any hand-editing:
    build_candidate_cm.sh --stage align --fasta <cluster.fa> --name <label> --out-dir <dir>

  then: inspect the dedup alignment for pseudoknots, hand-edit SS_cons (MATER), wiggle-refine,
        CaCoFold -- the script does none of this and should not

  STAGE 2, on the edited alignment:
    build_candidate_cm.sh --stage build --stk <edited.stk> --name <label> --out-dir <dir>
                                 [--search-fasta <library.fa>] [--min-eff-nseq 5] [--inc-e 1e-10]

  --fasta          ungapped FASTA of the cluster (stage align)
  --stk            hand-edited / CaCoFold Stockholm alignment (stage build)
  --name           short label, used for the model name and filenames (e.g. orthoflavi_c2)
  --out-dir        working directory; created if absent
  --search-fasta   library reference to search, once the model passes gate 2
  --min-eff-nseq   OPTIONAL hard stop below this value. Off by default: eff_nseq is reported
                   with reference values, not used as a gate (Class_2 is 3.58 and is fine)

GATE 1 (stage align) stops before you invest manual effort in a cluster that is not one family.
cmstat is reported in stage build for context; it blocks only if --min-eff-nseq is given.
USAGE
  exit 1
}

STAGE=""; FASTA=""; STK_IN=""; NAME=""; OUTDIR=""; SEARCH_FA=""; MIN_EFF=0; INC_E="1e-10"; CPU=4
while [ $# -gt 0 ]; do
  case "$1" in
    --stage) STAGE="$2"; shift 2;;
    --fasta) FASTA="$2"; shift 2;;
    --stk) STK_IN="$2"; shift 2;;
    --name) NAME="$2"; shift 2;;
    --out-dir) OUTDIR="$2"; shift 2;;
    --search-fasta) SEARCH_FA="$2"; shift 2;;
    --min-eff-nseq) MIN_EFF="$2"; shift 2;;
    --inc-e) INC_E="$2"; shift 2;;
    --cpu) CPU="$2"; shift 2;;
    *) usage;;
  esac
done
[ -n "$NAME" ] && [ -n "$OUTDIR" ] || usage
case "$STAGE" in
  align) [ -f "${FASTA:-}" ] || { echo "stage align needs --fasta; no such file: ${FASTA:-}" >&2; exit 1; };;
  build) [ -f "${STK_IN:-}" ] || { echo "stage build needs --stk; no such file: ${STK_IN:-}" >&2; exit 1; };;
  *) echo "--stage must be 'align' or 'build'" >&2; usage;;
esac

mkdir -p "$OUTDIR"
if [ "$STAGE" = "align" ]; then
N_IN=$(grep -c '^>' "$FASTA")
echo "=== $NAME : $N_IN input sequences (stage: align) ==="

# ---------------------------------------------------------------- 1. structural alignment
STK="$OUTDIR/mlocarna/results/result.stk"
echo "--- mlocarna (probabilistic + consistency transformation, as used for clusterA)"
mlocarna "$FASTA" --stockholm --consensus-structure=alifold \
         --probabilistic --consistency-transformation \
         --tgtdir "$OUTDIR/mlocarna" > "$OUTDIR/mlocarna.log" 2>&1
[ -f "$STK" ] || { echo "no alignment at $STK -- see $OUTDIR/mlocarna.log" >&2; exit 1; }

# ---------------------------------------------------------------- 2. GATE 1: consensus structure
CONS=$(grep -E '^[.()<>{}\[\]_,:-]+ *\(' "$OUTDIR/mlocarna.log" | tail -1 || true)
echo "--- alifold consensus: ${CONS:-<none found in log>}"
ENERGY=$(printf '%s' "${CONS:-}" | sed -n 's/.*(\(-\?[0-9.]*\) *=.*/\1/p')
COVAR=$(printf '%s' "${CONS:-}"  | sed -n 's/.*= *-\?[0-9.]* *+ *\(-\?[0-9.]*\).*/\1/p')
if [ -n "${ENERGY:-}" ]; then
  echo "    total ${ENERGY}  covariance ${COVAR:-?}"
  if awk -v e="$ENERGY" 'BEGIN{exit !(e > -8)}'; then
    cat <<EOF

GATE 1 FAILED: consensus energy ${ENERGY} is weak.
  For scale, from 260914-260917_cm_expansion.md: hepaci -24.24, pesti -11.61, pegivirus -3.56
  (set aside), pooled 59-sequence attempt -3.25 (split by genus instead).
  A weak consensus means the input is probably not ONE structural family. Options, in order:
    * split this cluster further (sub-genus, or by stall position)
    * ADD sequences rather than realign -- low diversity is the usual cause
    * try structure-based comparison for members with no sequence-identity partner
  Not proceeding to cmbuild.
EOF
    exit 2
  fi
fi

# ---------------------------------------------------------------- 3. dedup, then build
DEDUP="$OUTDIR/mlocarna/results/result-dedup.stk"
if command -v python3 >/dev/null && [ -n "${FLAVISCRIPTS:-}" ] && [ -f "$FLAVISCRIPTS/dedup_stockholm.py" ]; then
  python3 "$FLAVISCRIPTS/dedup_stockholm.py" "$STK" "$DEDUP"
  echo "    deduplicated -> $DEDUP"
else
  echo "    (dedup_stockholm.py not found via \$FLAVISCRIPTS; using the raw alignment)"
  DEDUP="$STK"
fi

cat <<EOF

GATE 1 PASSED. Alignment ready for the manual step:
  $DEDUP

NOW, BY HAND -- the script deliberately stops here:
  * open the dedup alignment (MATER, C. Langeberg) and look for pseudoknots
  * hand-edit SS_cons; cmbuild reads ONLY the primary SS_cons line, so crossing pairs
    ([[[[...]]]] , AAAA...aaaa) are annotation for you, not for the model -- decide what the
    NESTED structure should be, which is the judgement cmbuild cannot make
  * wiggle-refine, then CaCoFold / R-scape (-s --cacofold = "improve given structure")
  * save the edited alignment, then:

  build_candidate_cm.sh --stage build --stk <edited.stk> --name $NAME --out-dir $OUTDIR \\
      --search-fasta <library.fa>

EOF
exit 0
fi

# ================================================================ stage: build
echo "=== $NAME (stage: build) from $STK_IN ==="
DEDUP="$STK_IN"
echo "--- cmbuild / cmcalibrate"
CM="$OUTDIR/${NAME}.cm"
cmbuild -F -n "$NAME" "$CM" "$DEDUP" > "$OUTDIR/cmbuild.log" 2>&1
cmcalibrate --cpu "$CPU" "$CM" > "$OUTDIR/cmcalibrate.log" 2>&1

# ---------------------------------------------------------------- 4. GATE 2: eff_nseq
echo "--- cmstat"
cmstat "$CM" | grep -v '^#' | tee "$OUTDIR/cmstat.txt"
read -r _ _ _ NSEQ EFFN CLEN _ <<<"$(cmstat "$CM" | grep -v '^#' | head -1)"
cat <<EOF
    nseq ${NSEQ}  eff_nseq ${EFFN}  clen ${CLEN}
    for context: Class_1a 75/9.31/74 · Class_1b 88/48.62/81 · Class_2 38/3.58/93
                 class1c 46/9.54/84 · hepaci_hits_v2 55/19.93 · clusterA_refined 24/1.55 (abandoned)
    A low eff_nseq means the training sequences are closely related. That is not a defect on its
    own -- Class_2 is 3.58 and is one of the curated models. It matters only together with what
    the model then does: few hits beyond the training set is the overfitting signature.
EOF
if [ "$MIN_EFF" != "0" ] && awk -v e="$EFFN" -v m="$MIN_EFF" 'BEGIN{exit !(e < m)}'; then
  echo
  echo "STOPPING: eff_nseq ${EFFN} is below the --min-eff-nseq ${MIN_EFF} you asked for."
  exit 3
fi

# ---------------------------------------------------------------- 5. search
if [ -n "$SEARCH_FA" ]; then
  echo "--- cmsearch --toponly --incE $INC_E"
  cmsearch --toponly --incE "$INC_E" --cpu "$CPU" \
           --tblout "$OUTDIR/${NAME}.tbl" "$CM" "$SEARCH_FA" > "$OUTDIR/cmsearch.log" 2>&1
  HITS=$(grep -vc '^#' "$OUTDIR/${NAME}.tbl" || true)
  ACCS=$(grep -v '^#' "$OUTDIR/${NAME}.tbl" | awk '$17=="!"{print $1}' | cut -d'|' -f1 | sort -u | wc -l)
  echo "    $HITS rows, $ACCS distinct accessions at inclusion threshold"
  echo
  echo "NEXT, BY HAND (these need judgement, not automation):"
  echo "  * does it recover at least the sequences it was built from? if not, the calibration or"
  echo "    the model is wrong"
  echo "  * overlap with the existing set -- comm against the 1a/1b/2/class1c/class4 hit lists."
  echo "    Zero overlap means a genuinely new class; heavy overlap means it should be MERGED,"
  echo "    and a merge that degrades the parent model is evidence to keep them separate"
  echo "    (the class1b merge attempt cost AB021287.1 full-model coverage, 18.17 -> 14.12 bits)"
  echo "  * if the hit set is much larger than the training set, re-align the hits with cmalign"
  echo "    and hand-edit again before rebuilding -- that iteration is what produced class1c"
fi
echo
echo "=== $NAME: model at $CM ==="
