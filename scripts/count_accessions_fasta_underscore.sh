#!/bin/bash
# count_accessions_fasta_underscore.sh
# Counts unique accessions from FASTA headers (everything preceding the first _)
# Usage: ./count_accessions_fasta_underscore.sh <input.fa>
# WARNING -     | cut -d'_' -f1 \ assumes that the accession is everything before the first underscore. THIS WILL CUT ACCESSIONS WITH "NC_"
set -euo pipefail

# --- Arguments ---
INPUT_FILE="${1:-}"

# --- Validation ---
if [[ -z "$INPUT_FILE" ]]; then
    echo "Usage: $0 <input.fa>"
    exit 1
fi

if [[ ! -f "$INPUT_FILE" ]]; then
    echo "Error: File not found: $INPUT_FILE"
    exit 1
fi

# --- Count unique accessions ---
TOTAL=$(grep "^>" "$INPUT_FILE" \
    | sed 's/^>//' \
    | cut -d'_' -f1 \
    | sort -u \
    | wc -l \
    | tr -d ' ')

echo "File:              $INPUT_FILE"
echo "Unique accessions: $TOTAL"
