#!/bin/bash
# count_accessions.sh
# Counts the number of unique accessions in an oligo library CSV file
# Usage: ./count_accessions.sh <input.csv> [accession_column]

set -euo pipefail

# --- Arguments ---
INPUT_FILE="${1:-}"
ACCESSION_COL="${2:-accession}"  # default column name

# --- Validation ---
if [[ -z "$INPUT_FILE" ]]; then
    echo "Usage: $0 <input.csv> [accession_column]"
    echo "  accession_column: column name to count (default: 'accession')"
    exit 1
fi

if [[ ! -f "$INPUT_FILE" ]]; then
    echo "Error: File not found: $INPUT_FILE"
    exit 1
fi

# --- Get column index (1-based) from header ---
HEADER=$(head -1 "$INPUT_FILE")
COL_INDEX=$(echo "$HEADER" | tr ',' '\n' | grep -nx "^${ACCESSION_COL}$" | cut -d: -f1)

if [[ -z "$COL_INDEX" ]]; then
    echo "Error: Column '${ACCESSION_COL}' not found in header."
    echo "Available columns: $HEADER"
    exit 1
fi

# --- Count unique accessions ---
TOTAL=$(tail -n +2 "$INPUT_FILE" \
    | cut -d',' -f"$COL_INDEX" \
    | sort -u \
    | wc -l \
    | tr -d ' ')

echo "File:              $INPUT_FILE"
echo "Accession column:  $ACCESSION_COL (column $COL_INDEX)"
echo "Unique accessions: $TOTAL"
