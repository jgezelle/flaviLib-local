#!/bin/bash
# count_accessions_v3.sh
# Counts the number of unique accessions in the reference file.
# looks for '|' which comes after the accession in the FASTA header
# Currently for pilot virome lib, but can change to put a variable there or change out the oligo library CSV file

grep "^>" pilot_library_20260319_uniqueIDs.fa | sed 's/^>//' | cut -d'|' -f1 | sort -u | wc -l

# grep "^>" — pulls only the header lines
# sed 's/^>//' — strips the leading >
# cut -d'|' -f1 — keeps everything before the | (the accession)
# sort -u — sorts and deduplicates
# wc -l — counts the result