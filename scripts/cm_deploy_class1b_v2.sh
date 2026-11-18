#!/usr/bin/env bash
# E6 block A -- stage the Class_1b successor for transfer to the cluster.
#
#   bash cm_deploy_class1b_v2.sh                       # check inputs only, copy nothing
#   bash cm_deploy_class1b_v2.sh --stage               # check, then build the staging dir
#   bash cm_deploy_class1b_v2.sh --groups <path> ...   # say where class1b_groups.tsv is
#   bash cm_deploy_class1b_v2.sh --stage --set-name class1b_v2
#                                                      # also set the STAGED copy's NAME
#
# Every path this script uses is printed before it does anything, because they come from
# flavi_env.sh and are otherwise invisible.
#
# This does NOT touch the cluster. It prepares $INFERNAL/deploy_261117 and prints the
# scp line to run. Block B (on the cluster) is in CM_CANDIDATES.md, Part 1, "The commands".
#
# Nothing here deletes or overwrites anything outside the staging directory.
set -u

HERE=$(cd "$(dirname "$0")" && pwd)
. "$HERE/flavi_env.sh"

NEW=class1b_v2_inf112
STAGE=$INFERNAL/deploy_261117
DO_STAGE=0
GROUPSARG=""
SETNAME=""
while [ $# -gt 0 ]; do
  case $1 in
    --stage)  DO_STAGE=1; shift ;;
    --groups) GROUPSARG=${2:-}; shift 2 ;;
    --set-name) SETNAME=${2:-}; shift 2 ;;
    *) echo "unknown argument: $1"; exit 2 ;;
  esac
done

echo "== paths, as flavi_env.sh resolves them"
printf '  %-10s %s\n' \
  'FLAVI'    "$FLAVI" \
  'INFERNAL' "$INFERNAL" \
  'VIR_INF'  "$VIR_INF" \
  'CMDIR'    "$CMDIR" \
  'CMSET'    "$CMSET" \
  'C5'       "$C5" \
  'STAGE'    "$STAGE"
echo "  This is the LAPTOP. CMDIR here is viromelib/work/infernal/cm -- the shared viromelib"
echo "  tree, not flaviLib/work -- and it is where MANIFEST.tsv and class1b_groups.tsv live."
echo "  WARNING: the CLUSTER env script defines CMDIR as work/06_infernal/cm, a DIFFERENT"
echo "  path under a differently-laid-out tree. Never carry a \$CMDIR command between them."
echo

# md5 is BSD on macOS, md5sum on Linux
md5of() {
  if command -v md5 >/dev/null 2>&1; then md5 -q "$1"
  else md5sum "$1" | awk '{print $1}'; fi
}

echo "== inputs"
fail=0

# 1. the accepted model
if [ -s "$C5.cm" ]; then
  echo "  ok    model     $C5.cm"
else
  echo "  MISS  model     $C5.cm"; fail=1
fi

# 2. its seed alignment, for the MANIFEST's build_path and for provenance
[ -s "$C5.stk" ] && echo "  ok    seed      $C5.stk" \
                 || { echo "  MISS  seed      $C5.stk"; fail=1; }

# 3. class1b_groups.tsv. Part 9 puts it at $CMDIR; it may still be wherever it was
#    downloaded to, so look there too rather than failing on a one-line copy.
#    NOT named GROUPS: that is a bash builtin array of the caller's group IDs, so the
#    assignment is silently ignored and ${GROUPS} expands to the primary GID.
GROUPSFILE=""
for g in "$GROUPSARG" "$CMDIR/class1b_groups.tsv" "$INFERNAL/cm/class1b_groups.tsv" \
         "$INFERNAL/class1b_groups.tsv" "$VIR_INF/class1b_groups.tsv" \
         "$PWD/class1b_groups.tsv" "$HOME/Downloads/class1b_groups.tsv" \
         "$HERE/class1b_groups.tsv"; do
  [ -n "$g" ] && [ -s "$g" ] && { GROUPSFILE=$g; break; }
done
if [ -n "$GROUPSFILE" ]; then
  echo "  ok    groups    $GROUPSFILE  ($(grep -vc '^#' "$GROUPSFILE") rows)"
  [ "$GROUPSFILE" = "$CMDIR/class1b_groups.tsv" ] || \
    echo "        note: not yet at its Part 9 home, $CMDIR/class1b_groups.tsv"
else
  echo "  MISS  groups    class1b_groups.tsv. Looked in, in order:"
  for g in "$CMDIR" "$INFERNAL/cm" "$INFERNAL" "$VIR_INF" "$PWD" "$HOME/Downloads" "$HERE"; do
    printf '                    %s/class1b_groups.tsv\n' "$g"
  done
  echo "                  If it is elsewhere: --groups /full/path/to/class1b_groups.tsv"
  fail=1
fi

# 4. the conda env that matches the model's builder version. cm_env_require prints its
#    refusal on stdout and returns non-zero, so the status decides -- assigning its output
#    unconditionally would print the FATAL message as though it were the env name.
if MENV=$(cm_env_require "$C5.cm" 2>&1); then
  echo "  ok    env       $MENV  (model built by $(cm_version "$C5.cm"))"
else
  echo "  MISS  env       $MENV"; MENV=""; fail=1
fi

echo
echo "== internal NAME (cmsearch writes this into the tblout's query column)"
grep -m1 '^NAME' "$C5.cm" 2>/dev/null | awk '{print "  NAME      "$2}'
grep -m1 '^NAME' "$C5.cm" 2>/dev/null | awk '$2 != "class1b_v2" {
  print "        The set uses a SHORT CLASS LABEL here, not the filename:";
  print "        class1a class1b class2 class3 class1c cl4_v9 Flavivirus_DB (Part 6).";
  print "        The predecessor carries NAME class1b, so the successor is class1b_v2:";
  print "        both .tbl share one TBLOUT, so the query column must tell them apart.";
  print "        Set it on the staged copy:  --stage --set-name class1b_v2" }'

echo
echo "== model statistics (expect nseq 94, eff_nseq 50.24, clen 81, 19 bp, 2 bif)"
if [ -s "$C5.cm" ] && [ -n "${MENV:-}" ]; then
  STAT=$(conda run -n "$MENV" cmstat "$C5.cm" | grep -v '^#' | head -1)
  echo "$STAT" | awk '{printf "  nseq %s  eff_nseq %s  clen %s  bps %s  bifs %s\n",$4,$5,$6,$8,$9}'
  echo "$STAT" | awk '$4!=94 || $6!=81 {print "  WARNING: this is not the accepted 11-02 model"}'
fi

if [ "$fail" -ne 0 ]; then
  echo
  echo "inputs missing -- nothing staged. Fix the lines marked MISS and run again."
  exit 1
fi
if [ "$DO_STAGE" -ne 1 ]; then
  echo
  echo "checks pass. Re-run with --stage to build $STAGE"
  exit 0
fi

echo
echo "== staging into $STAGE"
mkdir -p "$STAGE" || exit 1
cp "$C5.cm"  "$STAGE/$NEW.cm"
cp "$GROUPSFILE" "$STAGE/class1b_groups.tsv"

# and put it at its Part 9 home if it is not there yet -- never overwrite a different copy
if [ ! -e "$CMDIR/class1b_groups.tsv" ]; then
  mkdir -p "$CMDIR" && cp "$GROUPSFILE" "$CMDIR/class1b_groups.tsv" \
    && echo "  installed $CMDIR/class1b_groups.tsv (its Part 9 home)"
elif ! cmp -s "$GROUPSFILE" "$CMDIR/class1b_groups.tsv"; then
  echo "  NOTE: $CMDIR/class1b_groups.tsv exists and DIFFERS from $GROUPSFILE"
  echo "        left untouched. Diff them and decide which is current before the scp."
fi

# Set the model's internal NAME on the STAGED copy only. The build artefact keeps its
# build NAME, so provenance is untouched. Done by editing the header line rather than
# `cmbuild -n` + `cmcalibrate`, because recalibration is stochastic: it rewrites the ECM
# lines, shifts E-values, and seven of the ten cluster-5 sites sit at 23.4-27.7 b where a
# shift can change inclusion. Editing one header line cannot move a score.
if [ -n "$SETNAME" ]; then
  OLDNAME=$(grep -m1 '^NAME' "$STAGE/$NEW.cm" | awk '{print $2}')
  cp "$STAGE/$NEW.cm" "$STAGE/.$NEW.cm.prename"
  awk -v n="$SETNAME" '!done && $1=="NAME" {printf "NAME     %s\n", n; done=1; next} {print}' \
      "$STAGE/.$NEW.cm.prename" > "$STAGE/$NEW.cm"

  echo "  NAME: $OLDNAME -> $SETNAME"
  # 1. nothing but the NAME line may differ
  if diff <(grep -v '^NAME' "$STAGE/.$NEW.cm.prename") <(grep -v '^NAME' "$STAGE/$NEW.cm") >/dev/null; then
    echo "    verified: every line except NAME is unchanged"
  else
    echo "    FAILED: more than the NAME line changed -- restoring"; mv "$STAGE/.$NEW.cm.prename" "$STAGE/$NEW.cm"; exit 1
  fi
  # 2. the model must still parse and score identically
  A=$(conda run -n "$MENV" cmstat "$STAGE/.$NEW.cm.prename" | grep -v '^#' | head -1 | awk '{print $4,$5,$6,$8,$9}')
  B=$(conda run -n "$MENV" cmstat "$STAGE/$NEW.cm"           | grep -v '^#' | head -1 | awk '{print $4,$5,$6,$8,$9}')
  if [ "$A" = "$B" ]; then echo "    verified: cmstat identical ($B)"
  else echo "    FAILED: cmstat changed -- restoring"; mv "$STAGE/.$NEW.cm.prename" "$STAGE/$NEW.cm"; exit 1; fi
  rm -f "$STAGE/.$NEW.cm.prename"
fi

{
  printf 'model\tcm_name\tmd5\tbuilt_by_infernal\tnseq\teff_nseq\tclen\tbps\tbifs\tbuild_path\n'
  printf '%s\t%s\t%s\t%s\t%s\t%s\n' \
    "$NEW.cm" "$(grep -m1 '^NAME' "$STAGE/$NEW.cm" | awk '{print $2}')" \
    "$(md5of "$STAGE/$NEW.cm")" "$(cm_version "$STAGE/$NEW.cm")" \
    "$(conda run -n "$MENV" cmstat "$STAGE/$NEW.cm" | grep -v '^#' | head -1 \
        | awk '{print $4"\t"$5"\t"$6"\t"$8"\t"$9}')" \
    "$C5.cm"
} > "$STAGE/MANIFEST.tsv"


echo "  wrote $STAGE/$NEW.cm"
echo "  wrote $STAGE/class1b_groups.tsv"
echo "  wrote $STAGE/MANIFEST.tsv"
echo
column -t -s "$(printf '\t')" "$STAGE/MANIFEST.tsv" 2>/dev/null || cat "$STAGE/MANIFEST.tsv"

echo
echo "== md5 to verify after transfer -- this is also the md5 in MANIFEST.tsv"
md5of "$STAGE/$NEW.cm"
echo
echo "== then, filling in <user>@<cluster>:"
cat <<EOF
scp "$STAGE"/{$NEW.cm,class1b_groups.tsv,MANIFEST.tsv} \\
  <user>@<cluster>:/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib/work/06_infernal/cm/
EOF
echo
echo "Block B (on the cluster) is in CM_CANDIDATES.md, Part 1 -> 'The commands'."
echo "Record the CLUSTER's Infernal version in MANIFEST too: it produces the .tbl."
