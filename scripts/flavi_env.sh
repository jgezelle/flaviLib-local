#!/usr/bin/env bash
# Shared paths and helpers for the flaviLib CM scripts. Edit paths HERE, nowhere else.
#   source "$(dirname "${BASH_SOURCE[0]}")/flavi_env.sh"
#   bash flavi_env.sh --check     # verify every path exists, print what is missing
#
# Override any value from the caller's environment, e.g.
#   ROOT=/Volumes/backup/viromelib bash cm_class1b_E.sh e1
#   ITER=iter_v2_explorer80 bash cm_candidate.sh build aln_FJJI_c41_261029 <stk>

# ---- roots ----
: "${ROOT:=$HOME/Desktop/viromelib}"
: "${FLAVI:=$ROOT/flaviLib}"
: "${INFERNAL:=$FLAVI/work/infernal}"          # flaviLib-specific infernal work
: "${VIR_INF:=$ROOT/work/infernal}"            # shared across datasets
: "${FLAVISCRIPTS:=$FLAVI/scripts}"
: "${DOC:=$FLAVI/workflows/CM_CANDIDATES.md}"
: "${BUILD:=$INFERNAL/build}"
: "${ARCH:=$BUILD/archive_superseded}"

# ---- sequence targets ----
: "${FA:=$INFERNAL/fa/flavi_library_20260228pretile20260818_TRUEordered_uniqueIDs.fa}"
: "${DB:=$VIR_INF/fa/RNAvirus_CompleteAssem_No_CoV-2.fa}"
: "${REF:=$FLAVI/data/reference/flavi_reference_genomes.fa}"   # confirm this name once

# ---- models ----
: "${CMSET:=$VIR_INF/cm/cm_set_261021}"        # the 7 deployed models
: "${CMDIR:=$VIR_INF/cm}"                      # MANIFEST.tsv, class1b_groups.tsv live here
: "${CL1A:=$CMSET/CL_Class_1a_xrRNA_final.cm}"
: "${CL1B:=$CMSET/CL_Class_1b_xrRNA_final.cm}"
: "${CL2:=$CMSET/CL_Class_2_xrRNA_final.cm}"
: "${CL1C:=$CMSET/class1c.cm}"                 # confirm whether it sits in cm_set_261021

# ---- Class_1b expansion (Track A) ----
: "${AH:=$INFERNAL/build/class1b/iter_v2_alignHits}"            # 1.1.5 builds + novel-hit fetchlists
: "${AH112:=$INFERNAL/build/class1b/iter_v2_alignHits_inf112}"  # 1.1.2 strong/all/newvirus
: "${SAT:=$INFERNAL/build/class1b/iter_v1_saturation}"          # r0/search.tbl = the original baseline
: "${PLUS:=$INFERNAL/build/class1b/iter_v3_plusFJIS}"
: "${C5:=$PLUS/cluster5/class1b_plusFJIS_cluster5_inf112}"      # accepted baseline, no extension
: "${SEED1B:=$INFERNAL/build/class1b/seed/class1b_seed88.stk}"  # confirm this name once

# ---- explorer / clustering ----
: "${EXPLORER:=$FLAVI/figures/clustering/flavi150_explorer.html}"
: "${SCAN:=$INFERNAL/build/class1c/explorer_scan_261029}"       # the explorer 80-nt FASTAs
: "${FA106:=$SCAN/FJIS_fz106_explorer80.fa}"                    # old `fz` spelling, kept
: "${FA5:=$SCAN/FJIS_fz5_explorer80.fa}"

# ---- run parameters ----
: "${CPU:=4}"
: "${ITER:=iter_v1_explorer80}"                # working subdir; Nov-2 folders use iter_v2_explorer80
: "${CONDA112:=infernal112}"                   # conda env holding Infernal 1.1.2
: "${CONDA_ENV:=viromelib}"                    # conda env holding mlocarna, R-scape, easel, Infernal 1.1.5

# ---- helpers ----
clog() {  # clog <model> <step> <result>
  python3 "$FLAVISCRIPTS/cm_log.py" "$DOC" --model "$1" --step "$2" --result "$3"
}

need() { local f ok=0; for f in "$@"; do [ -e "$f" ] || { echo "MISSING: $f"; ok=1; }; done; return $ok; }
have() { command -v "$1" >/dev/null || { echo "not on PATH: $1"; return 1; }; }

# ---- environment: ESTABLISH it, do not merely report on it ----
# A partially-populated base env is the dangerous case: cmalign present but esl-sfetch absent
# means tools are being picked up from wherever, and an Infernal version mismatch between
# cmalign and cmbuild silently changes the model (Part 2: 1.1.2 and 1.1.5 differ).
flavi_conda() {  # flavi_conda <env>
  [ "${CONDA_DEFAULT_ENV:-}" = "$1" ] && return 0
  local base
  base=$(conda info --base 2>/dev/null) || { echo "FATAL: conda not on PATH"; return 1; }
  [ -f "$base/etc/profile.d/conda.sh" ] || { echo "FATAL: no $base/etc/profile.d/conda.sh"; return 1; }
  # shellcheck disable=SC1091
  . "$base/etc/profile.d/conda.sh" || return 1
  conda activate "$1" || { echo "FATAL: conda activate $1 failed"; return 1; }
  echo "env: activated $1"
}

# The version that BUILT a model, read from its own header line:
#   INFERNAL1/a [1.1.2 | July 2016]   ->   1.1.2
# Documented for CL_Class_1b_xrRNA_final.cm since 2026-10-30 (Part 2). Read it, do not assume it.
cm_version() {
  local f=$1
  [ -s "$f" ] || { echo "unknown"; return 1; }
  local v
  v=$(head -1 "$f" | sed -nE 's/.*\[([0-9]+\.[0-9]+\.[0-9]+)[^]]*\].*/\1/p')
  [ -n "$v" ] && echo "$v" || { echo "unknown"; return 1; }
}

# Which conda env's Infernal matches the version that built this model. Empty = no match.
cm_env_for() {
  local built; built=$(cm_version "$1") || { echo ""; return 1; }
  case "$built" in
    1.1.2) echo "$CONDA112" ;;
    1.1.5) echo "$CONDA_ENV" ;;
    *)     echo "" ; return 1 ;;
  esac
}

# Print, and return, the env to run cmalign/cmbuild in for this model. Exits if none matches,
# because realigning a 1.1.2-built model with 1.1.5 is not the same model (Part 2).
cm_env_require() {
  local f=$1 built env
  built=$(cm_version "$f")
  env=$(cm_env_for "$f")
  if [ -z "$env" ]; then
    echo "FATAL: $(basename "$f") was built by Infernal $built, and no configured env matches."
    echo "  CONDA_ENV=$CONDA_ENV ($(infernal_version cmalign)), CONDA112=$CONDA112"
    exit 1
  fi
  echo "$env"
}

infernal_version() {  # prints e.g. "INFERNAL 1.1.5 (Sep 2023)"
  local c=${1:-cmalign}
  command -v "$c" >/dev/null || { echo "unknown (no $c)"; return 1; }
  "$c" -h 2>&1 | grep -m1 -Eo '# INFERNAL [0-9.]+ \([^)]*\)' | sed 's/^# //'
}

# flavi_require <tool> [tool ...] -- activate CONDA_ENV, verify every tool, EXIT if any is absent,
# and print the Infernal version actually in use so it goes in the log.
flavi_require() {
  flavi_conda "$CONDA_ENV" || exit 1
  local miss=0 c
  for c in "$@"; do
    command -v "$c" >/dev/null || { echo "FATAL: $c absent from env $CONDA_DEFAULT_ENV"; miss=1; }
  done
  if [ $miss -ne 0 ]; then
    echo "Nothing was run. Install the missing tools into $CONDA_ENV, or set CONDA_ENV to the env that has them."
    exit 1
  fi
  echo "env: $CONDA_DEFAULT_ENV   cmalign: $(infernal_version cmalign)"
}

# join LocARNA's unseparated blocks into one (R-scape rejects the raw file: duplicate seq name)
stk_oneblock() {
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

# "<structure> (<total> = <energy> + <covariance>)" from a wrapped, space-padded mlocarna log
alifold_line() {
  awk -v re='\\( *-?[0-9.]+ *= *-?[0-9.]+ *\\+ *-?[0-9.]+\\)' '
    /^alifold/{s=$2; f=1; if(match($0,re)){e=substr($0,RSTART,RLENGTH); f=0}; next}
    f && /^ +[.()]/{s=s $1; if(match($0,re)){e=substr($0,RSTART,RLENGTH); f=0}}
    END{print s, e}' "$1"
}

if [ "${1:-}" = --check ]; then
  echo "ROOT         $ROOT"
  echo "ITER         $ITER   (override per folder)"
  echo
  miss=0
  for v in FLAVI INFERNAL VIR_INF FLAVISCRIPTS DOC BUILD FA DB REF CMSET CMDIR \
           CL1A CL1B CL2 CL1C AH AH112 SAT PLUS EXPLORER SCAN FA106 FA5 SEED1B; do
    p=${!v}
    if [ -e "$p" ]; then printf 'ok      %-13s %s\n' "$v" "$p"
    else                 printf 'MISSING %-13s %s\n' "$v" "$p"; miss=$((miss+1)); fi
  done
  for p in "$C5.cm" "$C5.stk" "${C5}_library.tbl"; do
    [ -e "$p" ] && printf 'ok      %-13s %s\n' C5 "$p" || { printf 'MISSING %-13s %s\n' C5 "$p"; miss=$((miss+1)); }
  done
  echo
  # Activate FIRST, then report -- checking the tools of whatever env happens to be active
  # (usually base) says nothing about the env the scripts actually run in.
  started_in=${CONDA_DEFAULT_ENV:-<none>}
  if ! flavi_conda "$CONDA_ENV"; then
    echo
    echo "COULD NOT ACTIVATE $CONDA_ENV. Everything below describes env '$started_in' instead,"
    echo "which is NOT what the scripts run in -- treat absent tools below as unknown, not missing."
  fi
  echo "started in: $started_in   now in: ${CONDA_DEFAULT_ENV:-<none>}   (CONDA_ENV=$CONDA_ENV, CONDA112=$CONDA112)"
  tmiss=0
  for c in cmsearch cmalign cmbuild cmcalibrate cmstat esl-sfetch mlocarna R-scape conda; do
    if command -v "$c" >/dev/null; then printf 'ok      %s\n' "$c"
    else printf 'ABSENT  %s\n' "$c"; tmiss=$((tmiss+1)); fi
  done
  echo
  echo "Model build versions, read from each .cm header (Part 2):"
  for m in "$CL1A" "$CL1B" "$CL2" "$CL1C" "$C5.cm"; do
    [ -s "$m" ] && printf '  %-34s built by %s -> run cmalign/cmbuild in: %s\n' \
      "$(basename "$m")" "$(cm_version "$m")" "$(cm_env_for "$m" || echo 'NO MATCHING ENV')"
  done
  echo
  echo "Infernal in this env:"
  printf '  cmalign      %s\n' "$(infernal_version cmalign)"
  printf '  cmbuild      %s\n' "$(infernal_version cmbuild)"
  printf '  cmsearch     %s\n' "$(infernal_version cmsearch)"
  if command -v conda >/dev/null; then
    printf '  %-12s %s\n' "$CONDA112" "$(conda run -n "$CONDA112" cmbuild -h 2>&1 | grep -m1 -Eo '# INFERNAL [0-9.]+ \([^)]*\)' | sed 's/^# //' || echo 'env not found')"
  fi
  echo
  echo "$miss path(s) missing, $tmiss tool(s) absent."
  cat <<'EOF'
cmalign and cmbuild MUST report the same version, and a model built under 1.1.2 must be realigned
with 1.1.2 (Part 2). The run stages activate $CONDA_ENV themselves and exit if a tool is absent.
EOF
  exit $(( miss > 0 || tmiss > 0 ))
fi
