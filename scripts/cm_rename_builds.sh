#!/usr/bin/env bash
# Rename build folders to the stage-prefixed scheme (CM_CANDIDATES.md Part 9 -> Naming).
#
#   bash cm_rename_builds.sh            # check only: print what would move (DEFAULT)
#   bash cm_rename_builds.sh --apply    # do it, write the mapping, log one run-log row
#
# Never overwrites and never deletes: an existing destination is skipped with a warning.
# Writes build/RENAMES.tsv (old -> new -> date -> why) so run-log rows written under the old
# names stay traceable. Run-log rows are records and are NOT rewritten (Part 9 precedent:
# the 2026-11-02 fz41 -> cluster41 rename).
set -uo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/flavi_env.sh"
B=$BUILD          # the build dir; ARCH comes from flavi_env.sh
APPLY=0; [ "${1:-}" = --apply ] && APPLY=1

# old_folder <TAB> new_path_relative_to_build <TAB> why
MAP=$(cat <<'EOF'
cand_FJIS_fz106_261029	archive_superseded/aln_FJIS_c106_171nt_261029	superseded: 171-nt windows, covariation 60-130 nt past the stall
cand_FJIS_fz5_261029	archive_superseded/aln_FJIS_c5_171nt_261029	superseded: 171-nt windows
cand_FJJI_cluster41-44_pooled_261029	archive_superseded/aln_FJJI_c41+c44_261029	closed: pooling weaker than either cluster alone, 0 significant pairs
cand_FJIS_261029	conf_FJIS_c5+c106_261029	confident build: covariation + saturation + per-site separation all passed; cluster 5 absorbed into class1b_plusFJIS_cluster5_inf112, Track A input
cand_FJJI_cluster41_261029	aln_FJJI_c41_261029	aligned only, no model yet; at the manual MATER step
cand_FJJI_cluster44_261029	aln_FJJI_c44_261029	aligned only, no model yet; at the manual MATER step
cand_FJTB_261026	cand_FJTB_c3_261026	model built, gates incomplete: diversity-blocked, RNAvirus DB result unrecorded
cand_PLLG_260915	cand_PLLG_vsA_260915	model built, gates incomplete; vsA = vsearch clusterA, not a frozen cluster
EOF
)

[ -d "$B" ] || { echo "MISSING: $B"; exit 1; }
[ $APPLY -eq 1 ] && mkdir -p "$ARCH"
echo "build dir: $B"
[ $APPLY -eq 1 ] && echo "MODE: apply" || echo "MODE: check only (pass --apply to move)"
echo

n_move=0; n_skip=0; n_absent=0
while IFS=$'\t' read -r OLD NEW WHY; do
  [ -n "${OLD:-}" ] || continue
  if [ ! -d "$B/$OLD" ]; then
    printf 'absent   %s\n' "$OLD"; n_absent=$((n_absent+1)); continue
  fi
  if [ -e "$B/$NEW" ]; then
    printf 'SKIP     %s -> %s  (destination exists)\n' "$OLD" "$NEW"; n_skip=$((n_skip+1)); continue
  fi
  printf 'move     %s\n      -> %s\n         %s\n' "$OLD" "$NEW" "$WHY"
  n_move=$((n_move+1))
  if [ $APPLY -eq 1 ]; then
    mkdir -p "$(dirname "$B/$NEW")"
    mv "$B/$OLD" "$B/$NEW" || { echo "  mv FAILED"; continue; }
    printf '%s\t%s\t%s\t%s\n' "$OLD" "$NEW" "$(date +%Y-%m-%d)" "$WHY" >> "$B/RENAMES.tsv"
    printf 'renamed from %s on %s\n%s\n' "$OLD" "$(date +%Y-%m-%d)" "$WHY" > "$B/$NEW/RENAMED_FROM.txt"
  fi
done <<< "$MAP"

echo
echo "would move $n_move, skip $n_skip, absent $n_absent"

if [ $APPLY -eq 1 ] && [ $n_move -gt 0 ]; then
  echo
  echo "== paths inside this file that still carry an old folder name"
  while IFS=$'\t' read -r OLD NEW WHY; do
    [ -n "${OLD:-}" ] || continue
    # grep -c prints 0 and exits 1 when nothing matches, so take the first line only
    c=$(grep -c "$OLD" "$DOC" 2>/dev/null | head -1); c=${c:-0}
    [ "$c" -gt 0 ] && printf '  %-40s %s mention(s)\n' "$OLD" "$c"
  done <<< "$MAP"
  echo "  Interpretive text should be updated; run-log rows are records -- leave them."
  python3 "$FLAVISCRIPTS/cm_log.py" "$DOC" --model build_layout \
    --step "build folders renamed to the stage-prefixed scheme (cm_rename_builds.sh --apply)" \
    --result "$n_move moved, $n_skip skipped; mapping in build/RENAMES.tsv, RENAMED_FROM.txt in each; run-log rows keep the old names"
fi

cat <<'EOF'

SCHEME (Part 9 -> Naming)
  <stage>_<CLADE>_<members>_<yymmdd>
  stage    aln_   alignment only, no model
           cand_  model built and calibrated (GATE 2 reported), gates incomplete
           conf_  CONFIDENT BUILD: covariation gate passed, searched to saturation or
                  novel hits resolved, per-site separation from the existing models shown
           class<N>  accepted and deployed in a cm_set (no prefix, no date)
  members  c<N>   frozen cluster N (explorer, 2026-10-28 clustering); c5+c106 = pooled
           vs<X>  vsearch cluster X -- a different numbering, never written as c<N>
  date     always last, always 6 digits yymmdd
  NOT in the name: the alignment round. That is the directory, iter_v<n>_<window>.
  Models only: _inf<ver> when built by a non-default Infernal (e.g. _inf112).

PROMOTION is by gates already defined in this file, so nothing new has to be judged:
  aln_  -> cand_   a model exists: cmbuild + cmcalibrate, cmstat recorded
  cand_ -> conf_   R-scape significant pairs with every nested helix supported, library AND
                   wider-target searches run, position overlap with the 7 models checked
  conf_ -> class<N>  deployed: MANIFEST, new cm_set, annotation re-run
Renaming a folder on promotion is the point: the name then states the state.
EOF
