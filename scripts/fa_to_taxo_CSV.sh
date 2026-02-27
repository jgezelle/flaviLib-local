#!/usr/bin/env bash
set -euo pipefail

########################################
# FASTA -> accession taxonomy CSV
# Usage:
#   ./fasta_to_taxonomy_csv.sh input.fasta output.csv
########################################

FASTA="${1:?Provide input FASTA}"
OUT="${2:-accession_taxonomy.csv}"

echo "Input FASTA: $FASTA"
echo "Output CSV : $OUT"

WORKDIR=$(mktemp -d)
cd "$WORKDIR"

########################################
# 1) Extract accession.version
########################################
echo "[1/4] Extracting accessions..."

grep '^>' "$FASTA" \
  | sed 's/^>//' \
  | cut -d'_' -f1 \
  | sort -u > accessions.txt

echo "Unique accessions: $(wc -l < accessions.txt)"

########################################
# 2) accession -> TaxID
########################################
echo "[2/4] Querying nuccore..."

split -l 200 accessions.txt acc_chunk_

: > acc_tax_map.tsv
for f in acc_chunk_*; do
  epost -db nuccore -input "$f" \
    | esummary \
    | xtract -pattern DocumentSummary \
        -element AccessionVersion TaxId Title \
    >> acc_tax_map.tsv
done

########################################
# 3) TaxID -> taxonomy ranks
########################################
echo "[3/4] Fetching taxonomy..."

cut -f2 acc_tax_map.tsv | sort -u > taxids.txt
split -l 200 taxids.txt tax_chunk_

: > tax_table.tsv
for f in tax_chunk_*; do
  ids=$(paste -sd, "$f")
  efetch -db taxonomy -id "$ids" -format xml \
    | xtract \
        -pattern Taxon \
        -element TaxId ScientificName \
        -block "LineageEx/Taxon" -if Rank -equals family -element ScientificName \
        -block "LineageEx/Taxon" -if Rank -equals genus  -element ScientificName \
    >> tax_table.tsv
done

########################################
# 4) Merge + write CSV
########################################
echo "[4/4] Writing CSV..."

python3 - <<PY
import csv

tax = {}
with open("tax_table.tsv") as f:
    for line in f:
        p = line.rstrip("\\n").split("\\t")
        taxid = p[0]
        organism = p[1] if len(p)>1 else ""
        family  = p[2] if len(p)>2 else ""
        genus   = p[3] if len(p)>3 else ""
        tax[taxid]=(organism,genus,family)

rows=[]
with open("acc_tax_map.tsv") as f:
    for line in f:
        acc,taxid,title=(line.rstrip("\\n").split("\\t",2)+[""])[:3]
        organism,genus,family=tax.get(taxid,("","",""))
        rows.append([acc,taxid,organism,genus,family,title])

with open("$OUT","w",newline="") as out:
    w=csv.writer(out)
    w.writerow(["accession","taxid","organism","genus","family","title"])
    w.writerows(rows)

print("Wrote",len(rows),"rows")
PY

########################################
# cleanup
########################################
cd -
rm -rf "$WORKDIR"

echo "Done."