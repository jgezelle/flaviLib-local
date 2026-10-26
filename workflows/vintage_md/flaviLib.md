# analysis of xrn1 resistant products in the *Flaviviridae* specific input library 

## Environment

```bash

srun --pty -t 06:00:00 -c 4 --mem=16G \
    --chdir=/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib \
    /bin/bash -l

conda activate viromelib

ROOT=/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib
RAW="$ROOT/work/01_raw"
cd "$RAW"
```
## 01_raw 
link files from the data directory to their corresponding sample names 
### symlink 

```bash
export SRC=/groups/as6282_gp/data_bkup/jgg2144/20260602_Aviti_FlaviLib_reads
ls $SRC/*.fastq.gz
```
8 samples, 2 replicates each condition: 10 = 10 mM MgCl2 for the Xrn1 experiment, 01 = 1 mM. X = Xrn1, R = no Xrn1, RppH only 

```bash 
cd "$RAW"

### (from `RAW` dir):
```bash
ln -s $SRC/A3498_R1.fastq.gz  260602-r0416-10-R-1-A3498_R1.fastq.gz
ln -s $SRC/A3479_R1.fastq.gz  260602-r0416-10-X-1-A3479_R1.fastq.gz

ln -s $SRC/A3478_R1.fastq.gz  260602-r0416-10-R-2-A3478_R1.fastq.gz
ln -s $SRC/A3476_R1.fastq.gz  260602-r0416-10-X-2-A3476_R1.fastq.gz

ln -s $SRC/A3467_R1.fastq.gz  260602-r0416-01-R-1-A3467_R1.fastq.gz
ln -s $SRC/A3462_R1.fastq.gz  260602-r0416-01-X-1-A3462_R1.fastq.gz

ln -s $SRC/A3434_R1.fastq.gz  260602-r0416-01-R-2-A3434_R1.fastq.gz
ln -s $SRC/A3427_R1.fastq.gz  260602-r0416-01-X-2-A3427_R1.fastq.gz
```

**check symlinks worked:**<br>
```bash
ls -lh
```

## 02_trim

loop through trimming for all samples in `01_raw/260602-*_R1.fastq.gz`<br>
- (`for SAMPLE in "$RAW"/260602-*_R1.fastq.gz;`) <br>


```bash
conda activate viromelib

ROOT=/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib
RAW=$ROOT/work/01_raw
TRIM=$ROOT/work/02_trim
LOGS=$TRIM/logs

mkdir -p "$TRIM" "$LOGS"

END3=AAAGAAACAACAACAACAAC
LEAD5=GGATTAATATAAT

cd "$TRIM"

for SAMPLE in "$RAW"/260602-*_R1.fastq.gz; do
  BASENAME=$(basename "$SAMPLE" .fastq.gz)

  # 3' end trim (trim if present, do NOT require)
  cutadapt -j 8 -n 3 -O 10 -e 0.1 \
    -a "$END3" \
    -m 20 \
    -o "$TRIM/${BASENAME}.insert.fastq.gz" \
    "$SAMPLE" \
    > "$LOGS/${BASENAME}.cutadapt.3p.txt"

  # 5' leader split (HASLEAD vs NOLEAD)
  cutadapt -j 8 \
    -b "$LEAD5" \
    -e 0.12 \
    --action=none \
    -o "$TRIM/${BASENAME}.insert.HASLEAD.fastq.gz" \
    --untrimmed-output "$TRIM/${BASENAME}.insert.NOLEAD.fastq.gz" \
    "$TRIM/${BASENAME}.insert.fastq.gz" \
    > "$LOGS/${BASENAME}.split_by_leader.txt"

  echo "Finished: $BASENAME"
done
```
check log using `less`

### make a trim summary table 
```bash
#!/usr/bin/env bash

# summary table
SUMMARY="$TRIM/leader_summary_260602.tsv" # change for date

# Header
echo -e "Sample\tHASLEAD\tNOLEAD\tTotal\tLeaderFraction" > "$SUMMARY"

# Loop over new 260602 samples only
for HAS in "$TRIM"/260602-*.insert.HASLEAD.fastq.gz; do

  BASE=$(basename "$HAS" .insert.HASLEAD.fastq.gz)

  NOLEAD="$TRIM/${BASE}.insert.NOLEAD.fastq.gz"

  # Count reads (lines / 4)
  HAS_COUNT=$(( $(zcat "$HAS" | wc -l) / 4 ))
  NO_COUNT=$(( $(zcat "$NOLEAD" | wc -l) / 4 ))

  TOTAL=$(( HAS_COUNT + NO_COUNT ))

  if [ "$TOTAL" -gt 0 ]; then
    FRACTION=$(python3 -c "print(f'{$HAS_COUNT / $TOTAL:.4f}')")
  else
    FRACTION=0
  fi

  echo -e "${BASE}\t${HAS_COUNT}\t${NO_COUNT}\t${TOTAL}\t${FRACTION}" >> "$SUMMARY"

done

echo "Summary table written to $SUMMARY"
```

## 03_qc
```bash
QC=$ROOT/work/03_qc/260602
mkdir -p "$QC"

# all reads
fastqc -t 8 -o "$QC" "$TRIM"/260602-*.fastq.gz
```
compile in multiqc: 
```bash
multiqc -o "$QC" "$QC"
```
## 04_align 

## align to the "pre-tile" file using `Bowtie2`:
### alignment file `flavi_library_20260228.fa`
sanitize the names first with `"$SCRIPTS/rename_pretile_fa.py”` to have non-ambiguous headers, add uniqueIDs suffix. 
 
```bash
ROOT=/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib
SCRIPTS="$ROOT/scripts"

FA_IN="$ROOT/data/refseqs/pre_tile_refseqs/flavi_library_20260228.fa"
FA_FIX="$ROOT/data/refseqs/pre_tile_refseqs/flavi_library_20260228.uniqueIDs.fa"

"$SCRIPTS/rename_pretile_fa.py" "$FA_IN" "$FA_FIX"

# check - should have nothing 
grep "^>" "$FA_FIX" | sed 's/^>//' | cut -d" " -f1 | sort | uniq -d | head

head -100 "$FA_FIX"
```

```bash
ROOT=/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib
REFDIR="$ROOT/data/refseqs/pre_tile_refseqs"
PRETILE_FA="$REFDIR/flavi_library_20260228.uniqueIDs.fa"
```


## run Bowtie
### compare `-k 1` and `-k 2`, and MAPQ filter vs no MAPQ filter
```bash
ROOT=/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib
TRIM=$ROOT/work/02_trim
OUT=$ROOT/work/04_align/20260605_flaviLib
mkdir -p "$OUT"

IDX_DIR="$OUT/index"
IDX="$IDX_DIR/flavi_library_20260228.uniqueIDs"
mkdir -p "$IDX_DIR"

PRETILE_FA="$ROOT/data/refseqs/pre_tile_refseqs/flavi_library_20260228.uniqueIDs.fa"

export TMPDIR="/localscratch/$USER/${SLURM_JOB_ID:-manual}"
mkdir -p "$TMPDIR"

# Build index (haven't done yet)
bowtie2-build --threads 8 "$PRETILE_FA" "$IDX"

for R1 in "$TRIM"/260602-*_R1.insert.fastq.gz; do
  BASE=$(basename "$R1" .fastq.gz)
  echo "  Aligning: $BASE    "

  for K in 1 2; do
    for MQ in 0 25; do

      TAG="k${K}.mq${MQ}"
      echo "  -> $TAG"

      bowtie2 --very-sensitive-local -k $K -p 8 \
        -x "$IDX" -U "$R1" \
        2> "$OUT/${BASE}.${TAG}.bowtie2.log" \
      | samtools view -b -q $MQ -o "$OUT/${BASE}.${TAG}.unsorted.bam" -

      samtools sort -@ 4 -m 2G -T "$TMPDIR/${BASE}.${TAG}.sort" \
        -o "$OUT/${BASE}.${TAG}.bam" "$OUT/${BASE}.${TAG}.unsorted.bam"
      samtools index "$OUT/${BASE}.${TAG}.bam"
      rm "$OUT/${BASE}.${TAG}.unsorted.bam"
      echo "  -> Done: $TAG"
    done
  done

done
```
in future, just do `-k1` and `mq0`

check reads in each of the alignments 


---

## 05 — Fragment files (for filter `v7`)
```bash
ROOT=/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib
ALIGN=$ROOT/work/04_align/20260605_flaviLib
FRAG=$ROOT/work/05_fragments/260602
SCRIPTS=$ROOT/scripts
FA_FIX=$ROOT/data/refseqs/pre_tile_refseqs/flavi_library_20260228.uniqueIDs.fa

mkdir -p "$FRAG"

# --- generate BED using awk 
awk '/^>/{if(seq) print name"\t0\t"length(seq)"\t"name; name=substr($1,2); seq=""} \
     !/^>/{seq=seq$0} \
     END{if(seq) print name"\t0\t"length(seq)"\t"name}' "$FA_FIX" \
     > "$FRAG/flavi_library_20260228.uniqueIDs.bed"

wc -l "$FRAG/flavi_library_20260228.uniqueIDs.bed"
head -5 "$FRAG/flavi_library_20260228.uniqueIDs.bed"


# make fragment file with python script 
TILES="$FRAG/flavi_library_20260228.uniqueIDs.bed"

for BAM in "$ALIGN"/260602-*k1.mq0.bam; do
    BASE=$(basename "$BAM" .bam)
    echo "Fragmenting: $BASE"
    python3 "$SCRIPTS/make_fragment_file.py" "$BAM" \
        > "$FRAG/${BASE}.csv"
done

# check outputs
ls -lh "$FRAG"/*.csv
```

notable things: <br>
X samples have about 2x more unique fragments than R samples ; maybe  expected, since Xrn1 digestion should generate more distinct 5′ ends by stalling at multiple positions


## 06 — Filter: v7 stall-fraction
### combine peak calling and bedGraph generation into single loop 
```bash
FILTER=$ROOT/work/06_filter_v7.3
TRACKS=$ROOT/work/05_tracks/260602
mkdir -p "$FILTER/10mM" "$FILTER/01mM" "$TRACKS"

for MG in 10 01; do
    OUTDIR="$FILTER/${MG}mM"
    for REP in 1 2; do
        X_CSV=$(ls "$FRAG"/260602-r0416-${MG}-X-${REP}-*k1.mq0.csv)
        R_CSV=$(ls "$FRAG"/260602-r0416-${MG}-R-${REP}-*k1.mq0.csv)
        X_BASE=$(basename "$X_CSV" .csv)
        R_BASE=$(basename "$R_CSV" .csv)
        echo "Peak calling: ${MG}mM rep${REP}"

        python3 "$SCRIPTS/filterPeaks_normtoCTRL_v7.3.py" \
            "$X_CSV" "$R_CSV" "$TILES" \
            "$OUTDIR/rep${REP}_peaks.csv" \
            --out-accession-csv "$OUTDIR/rep${REP}_accessions.csv" \
            --out-gtf           "$OUTDIR/rep${REP}_peaks.gtf" \
            --no-pvalue-gate

        python3 "$SCRIPTS/fragments_to_tracks.py" "$X_CSV" \
            --tile-bed      "$TILES" \
            --out-bedgraph  "$TRACKS/${X_BASE}.5p.bedgraph" \
            --out-tile-bed  "$TRACKS/${X_BASE}.tiles.bed" \
            --track-name    "${MG}mM_X_rep${REP}"

        python3 "$SCRIPTS/fragments_to_tracks.py" "$R_CSV" \
            --tile-bed      "$TILES" \
            --out-bedgraph  "$TRACKS/${R_BASE}.5p.bedgraph" \
            --out-tile-bed  "$TRACKS/${R_BASE}.tiles.bed" \
            --track-name    "${MG}mM_R_rep${REP}"

        echo "Done: ${MG}mM rep${REP}"
    done
done
```

still need to double check the file quality and 3' end snapping (how much tile mapping ambiguity?)

so far, peak calls are very consistent within each condition:

- 10mM: 977 / 974 stall sites, 465/463 accessions passing = replicate concordance
- 01mM: 731 / 736 stall sites, 426/421 accessions passing =  consistent

10mM gives notably more peaks than 01mM (977 vs 731) — higher Mg <br>


## Now run the annotation step  
(`filterPeaks_normtoCTRL_v7_criteria.md`)

### build the taxo csv using entrez (new library, new accessions)
```bash
# make a simple input CSV with just the accession column
echo "accession" > /tmp/flavi_accs_input.csv
cat /tmp/flavi_accessions.txt >> /tmp/flavi_accs_input.csv
wc -l /tmp/flavi_accs_input.csv  # should be 624 (header + 623)
```
run annotation script with cache: 
```bash
VIRUS_STATS="$ROOT/data/virus_stats_flaviLib_20260602.csv"
CACHE="$ROOT/data/virus_stats_flaviLib_20260602.cache.json"

python3 "$SCRIPTS/annot_counts_taxo_3.5.py" \
    --in-csv     /tmp/flavi_accs_input.csv \
    --out-csv    "$VIRUS_STATS" \
    --cache-file "$CACHE" \
    --chunk-size 10 \
    --delay      1 \
    --verbose
```

### run an infernal search against the flaviLib input to use in annotation 
```bash
TBLOUT="$ROOT/work/06_infernal/260602"
mkdir -p "$TBLOUT"
CMDIR="$ROOT/work/06_infernal/cm"

CMS=(
    "CL_Class_1a_xrRNA_final.cm"
    "CL_Class_1b_xrRNA_final.cm"
    "CL_Class_2_xrRNA_final.cm"
    "cl3_NAR_2025.align.mpkadded.edited.confident.dedup.IDcurated.SS_cons.cm"
    "cl4.cm"
)


for CM in "${CMS[@]}"; do
    echo "Searching: $CM"
    cmsearch --tblout "$TBLOUT/${CM}.tbl" \
             --cpu 8 \
             "$CMDIR/$CM" "$FA_FIX"
    echo "Done: $CM"
done
```


cl3 found 6 hits — all in OL344 accessions and J04357, which are the Tombusviridae contaminants 

### run annotation once coverage of taxo is good in the csv. 
```bash
ANNOUT=$ROOT/work/07_postproc/260602
VIRUS_STATS="$ROOT/data/virus_stats_flaviLib_20260602.csv"
mkdir -p "$ANNOUT"

CMS=(
    "CL_Class_1a_xrRNA_final.cm"
    "CL_Class_1b_xrRNA_final.cm"
    "CL_Class_2_xrRNA_final.cm"
    "cl3_NAR_2025.align.mpkadded.edited.confident.dedup.IDcurated.SS_cons.cm"
    "cl4.cm"
)

INFERNAL_ARGS=$(printf -- "--infernal-tbl $TBLOUT/%s.tbl " "${CMS[@]}")

for MG in 10 01; do
    for REP in 1 2; do
        echo "Annotating: ${MG}mM rep${REP}"
        python3 "$SCRIPTS/post_process_peaks.py" \
            "$FILTER/${MG}mM/rep${REP}_peaks.csv" \
            --out-raw       "$ANNOUT/${MG}mM_rep${REP}_peaks_annotated.csv" \
            --out-collapsed "$ANNOUT/${MG}mM_rep${REP}_peaks_per_accession.csv" \
            --family-csv    "$VIRUS_STATS" \
            $INFERNAL_ARGS
    done
done

echo "Done. Check outputs:"
wc -l "$ANNOUT"/*.csv
```

impression  — ambiguous mapping / low SF issue. 

151nt (the read length), 

196nt tiles and 20nt step, so consecutive tiles overlap by 176nt 

### ah - the BED file I made was wrong. needs to match the tile construction... 

## get accurate bed file based on the 20-shift size of the tiled library 
```bash
ROOT=/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib
ALIGN=$ROOT/work/04_align/20260605_flaviLib
FRAG=$ROOT/work/05_fragments/260602
SCRIPTS=$ROOT/scripts
FA_FIX=$ROOT/data/refseqs/pre_tile_refseqs/flavi_library_20260228.uniqueIDs.fa

# find the tiled FA on cluster
find "$ROOT/data/refseqs" -name "*tile20*" 2>/dev/null

# generate BED directly - the name field is accession_start_end
grep '^>' "$ROOT/data/refseqs/library_mifsud_simmonds_EDIT_tile20_with_jeanine_new_genomes_20260225.dupsremoved.fa" \
    | sed 's/^>//' \
    | awk '{
        if (match($1, /^(.+)_([0-9]+)_([0-9]+)$/, a))
            print a[1] "\t" a[2] "\t" a[3] "\t" $1
      }' \
    > "$ROOT/data/refseqs/library_mifsud_simmonds_EDIT_tile20_with_jeanine_new_genomes_20260225.dupsremoved.bed"

wc -l "$ROOT/data/refseqs/library_mifsud_simmonds_EDIT_tile20_with_jeanine_new_genomes_20260225.dupsremoved.bed"
cut -f1 "$ROOT/data/refseqs/library_mifsud_simmonds_EDIT_tile20_with_jeanine_new_genomes_20260225.dupsremoved.bed" | sort -u | wc -l
head -3 "$ROOT/data/refseqs/library_mifsud_simmonds_EDIT_tile20_with_jeanine_new_genomes_20260225.dupsremoved.bed"
```
### the names are plain accessions in the bed, but BAM alignment file has uniqueID format. need to remap column 1 of the bed using the pretile FA: 
```bash
TILED_BED="$ROOT/data/refseqs/library_mifsud_simmonds_EDIT_tile20_with_jeanine_new_genomes_20260225.dupsremoved.bed"
UID_BED="$ROOT/data/refseqs/library_mifsud_simmonds_EDIT_tile20_with_jeanine_new_genomes_20260225.dupsremoved.uniqueIDs.bed"

# build plain->uniqueID map from reference FA, then remap BED column 1
python3 - <<'EOF'
import re

# build mapping
plain_to_uid = {}
for line in open("/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib/data/refseqs/pre_tile_refseqs/flavi_library_20260228.uniqueIDs.fa"):
    if not line.startswith('>'): continue
    uid = line[1:].strip().split()[0]
    plain = uid.split('|')[0]
    plain_to_uid[plain] = uid

# remap BED
tiled_bed = "/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib/data/refseqs/library_mifsud_simmonds_EDIT_tile20_with_jeanine_new_genomes_20260225.dupsremoved.bed"
uid_bed   = "/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib/data/refseqs/library_mifsud_simmonds_EDIT_tile20_with_jeanine_new_genomes_20260225.dupsremoved.uniqueIDs.bed"

n_written = n_missing = 0
missing = set()
with open(uid_bed, 'w') as out:
    for line in open(tiled_bed):
        f = line.strip().split('\t')
        uid = plain_to_uid.get(f[0])
        if uid is None:
            missing.add(f[0])
            n_missing += 1
            continue
        out.write(f"{uid}\t{f[1]}\t{f[2]}\t{uid}_{f[1]}_{f[2]}\n")
        n_written += 1

print(f"Written: {n_written}  Missing: {n_missing} from {len(missing)} accessions")
if missing: print(f"  Examples: {sorted(missing)[:5]}")
uids = set(l.split('\t')[0] for l in open(uid_bed))
print(f"Unique uniqueIDs in BED: {len(uids)}")
EOF

head -3 "$UID_BED"

```
## rerun peak calling with the correct BED 
```bash
ROOT=/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib
FILTER=$ROOT/work/06_filter_v7
TRACKS=$ROOT/work/05_tracks/260602
FRAG=$ROOT/work/05_fragments/260602
SCRIPTS=$ROOT/scripts
ALIGN=$ROOT/work/04_align/20260605_flaviLib
TBLOUT=$ROOT/work/06_infernal/260602
TILES20="$ROOT/data/refseqs/library_mifsud_simmonds_EDIT_tile20_with_jeanine_new_genomes_20260225.dupsremoved.uniqueIDs.bed"
mkdir -p "$FILTER/10mM" "$FILTER/01mM" "$TRACKS"

ANNOUT=$ROOT/work/07_postproc/260602
VIRUS_STATS="$ROOT/data/virus_stats_flaviLib_20260602.csv"
TBLOUT="$ROOT/work/06_infernal/260602"
CMDIR="$ROOT/work/06_infernal/cm"

# verify it matches BAM reference names
samtools view -H "$ALIGN/260602-r0416-10-X-1-A3479_R1.insert.k1.mq0.bam" \
    | grep "^@SQ" | head -3 | cut -f2 | sed 's/SN://'
cut -f1 "$TILES20" | head -3
```
```bash
#rerun postproc
CMS=(
    "CL_Class_1a_xrRNA_final.cm"
    "CL_Class_1b_xrRNA_final.cm"
    "CL_Class_2_xrRNA_final.cm"
    "cl3_NAR_2025.align.mpkadded.edited.confident.dedup.IDcurated.SS_cons.cm"
    "cl4.cm"
)
INFERNAL_ARGS=$(printf -- "--infernal-tbl $TBLOUT/%s.tbl " "${CMS[@]}")

for MG in 10 01; do
    OUTDIR="$FILTER/${MG}mM"
    for REP in 1 2; do
        X_CSV=$(ls "$FRAG"/260602-r0416-${MG}-X-${REP}-*k1.mq0.csv)
        R_CSV=$(ls "$FRAG"/260602-r0416-${MG}-R-${REP}-*k1.mq0.csv)
        X_BASE=$(basename "$X_CSV" .csv)
        R_BASE=$(basename "$R_CSV" .csv)
        echo "Peak calling: ${MG}mM rep${REP}"

        python3 "$SCRIPTS/filterPeaks_normtoCTRL_v7.3.py" \
            "$X_CSV" "$R_CSV" "$TILES20" \
            "$OUTDIR/rep${REP}_peaks.csv" \
            --out-accession-csv "$OUTDIR/rep${REP}_accessions.csv" \
            --out-gtf           "$OUTDIR/rep${REP}_peaks.gtf" \
            --no-pvalue-gate

        python3 "$SCRIPTS/fragments_to_tracks.py" "$X_CSV" \
            --tile-bed      "$TILES20" \
            --out-bedgraph  "$TRACKS/${X_BASE}.5p.bedgraph" \
            --out-tile-bed  "$TRACKS/${X_BASE}.tiles.bed" \
            --track-name    "${MG}mM_X_rep${REP}"

        python3 "$SCRIPTS/fragments_to_tracks.py" "$R_CSV" \
            --tile-bed      "$TILES20" \
            --out-bedgraph  "$TRACKS/${R_BASE}.5p.bedgraph" \
            --out-tile-bed  "$TRACKS/${R_BASE}.tiles.bed" \
            --track-name    "${MG}mM_R_rep${REP}"

        echo "Done: ${MG}mM rep${REP}"
    done
done
```

### check read distributions per accession in input and output for qc
```bash
python3 - <<'EOF'
import csv, collections, statistics

frag_dir = "/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib/work/05_fragments/260602"
tiles = "/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib/data/refseqs/library_mifsud_simmonds_EDIT_tile20_with_jeanine_new_genomes_20260225.dupsremoved.uniqueIDs.bed"

# accessions actually in the library
lib_accs = set()
for row in csv.reader(open(tiles), delimiter='\t'):
    lib_accs.add(row[0])

samples = {
    '10mM_X1': '260602-r0416-10-X-1-A3479_R1.insert.k1.mq0.csv',
    '10mM_R1': '260602-r0416-10-R-1-A3498_R1.insert.k1.mq0.csv',
    '01mM_X1': '260602-r0416-01-X-1-A3462_R1.insert.k1.mq0.csv',
    '01mM_R1': '260602-r0416-01-R-1-A3467_R1.insert.k1.mq0.csv',
}

for name, fname in samples.items():
    acc_reads = collections.Counter()
    for r in csv.DictReader(open(f"{frag_dir}/{fname}"), delimiter='\t'):
        if r['accession'] in lib_accs:
            acc_reads[r['accession']] += int(r['count'])

    counts = list(acc_reads.values())
    n_accs = len(acc_reads)
    n_zero = len(lib_accs) - n_accs  # in library but no reads

    print(f"\n=== {name} ===")
    print(f"  lib accessions with reads: {n_accs}/{len(lib_accs)} ({100*n_accs/len(lib_accs):.1f}%)")
    print(f"  lib accessions with 0 reads: {n_zero}")
    print(f"  total reads (lib accs): {sum(counts):,}")
    print(f"  reads/accession: median={statistics.median(counts):.0f}  mean={statistics.mean(counts):.0f}  min={min(counts)}  max={max(counts)}")

    # distribution bins
    bins = [(1,10),(10,100),(100,1000),(1000,10000),(10000,999999)]
    print(f"  read count distribution:")
    for lo,hi in bins:
        n = sum(1 for c in counts if lo <= c < hi)
        print(f"    {lo}-{hi}: {n} accessions ({100*n/n_accs:.1f}%)")
EOF
```
```
=== 10mM_X1 ===
  lib accessions with reads: 438/439 (99.8%)
  lib accessions with 0 reads: 1
  total reads (lib accs): 6,524,708
  reads/accession: median=4742  mean=14897  min=2  max=262622
  read count distribution:
    1-10: 10 accessions (2.3%)
    10-100: 18 accessions (4.1%)
    100-1000: 80 accessions (18.3%)
    1000-10000: 167 accessions (38.1%)
    10000-999999: 163 accessions (37.2%)

=== 10mM_R1 ===
  lib accessions with reads: 436/439 (99.3%)
  lib accessions with 0 reads: 3
  total reads (lib accs): 6,348,253
  reads/accession: median=5402  mean=14560  min=1  max=242599
  read count distribution:
    1-10: 9 accessions (2.1%)
    10-100: 14 accessions (3.2%)
    100-1000: 74 accessions (17.0%)
    1000-10000: 178 accessions (40.8%)
    10000-999999: 161 accessions (36.9%)

=== 01mM_X1 ===
  lib accessions with reads: 438/439 (99.8%)
  lib accessions with 0 reads: 1
  total reads (lib accs): 6,001,086
  reads/accession: median=3900  mean=13701  min=1  max=383020
  read count distribution:
    1-10: 9 accessions (2.1%)
    10-100: 19 accessions (4.3%)
    100-1000: 100 accessions (22.8%)
    1000-10000: 168 accessions (38.4%)
    10000-999999: 142 accessions (32.4%)

=== 01mM_R1 ===
  lib accessions with reads: 433/439 (98.6%)
  lib accessions with 0 reads: 6
  total reads (lib accs): 7,805,066
  reads/accession: median=4629  mean=18026  min=1  max=387879
  read count distribution:
    1-10: 4 accessions (0.9%)
    10-100: 22 accessions (5.1%)
    100-1000: 90 accessions (20.8%)
    1000-10000: 174 accessions (40.2%)
    10000-999999: 143 accessions (33.0%)
(viromelib) 13:24:32 jgg2144@c0201:viromelib# 
```
missing accession - NC_031950.1 Guereza hepacivirus, complete sequence
Accessions with <100 reads in 10mM X rep1: 28
  KM461670.1|1079-1260_inferred_3UTR: 2
  MN712204.1|9442-9678_3UTR: 3
  NC_009827.1|9399-9628_3UTR: 3
  MH427312.1|9334-9625_inferred_3UTR: 5
  NC_009823.1|9442-9711_3UTR: 5
  MN025515.1|2491-2701_inferred_3UTR: 6
  NC_024018.2|12063-12273_3UTR: 6
  KR902733.1|26026-26315_inferred_3UTR: 7
  MK618726.1|11986-12173_inferred_3UTR: 8
  NC_038425.1|9213-9531_3UTR: 8
  NC_002657.1|12070-12301_3UTR: 10
  NC_004102.1|9377-9646_3UTR: 11
  KM408491.1|12063-12281_3UTR: 12
  NC_018713.1|12065-12292_3UTR: 18
  NC_034222.1|2786-2963_inferred_3UTR: 22
  BK067812.1|17033-17240_inferred_3UTR: 23
  AF144618.2|12008-12318_inferred_3UTR: 32
  MT210609.1|9609-9825_inferred_3UTR: 45
  MT210613.1|10343-10586_inferred_3UTR: 45
  MZ664274.1|12009-12286_inferred_3UTR: 52
  MW341210.1|2786-2963_inferred_3UTR: 59
  BK071945.1|3118-3373_inferred_3UTR: 62
  MN095532.1|2349-2706_inferred_3UTR: 69
  MK721863.1|2442-2724_inferred_3UTR: 72
  LC505055.1|1936-2152_inferred_3UTR: 75
  KP890673.1|9029-9247_inferred_3UTR: 81
  MW341212.1|2477-2670_inferred_3UTR: 81
  MN095531.1|2818-3025_inferred_3UTR: 89

  ### try taxo/CM annotation, even though sf signal seems low for many due to read distribution across overlapping tiles.. 
  ```bash
  # set environment 
ANNOUT=$ROOT/work/07_postproc/260602
VIRUS_STATS="$ROOT/data/virus_stats_flaviLib_20260602.csv"
TBLOUT="$ROOT/work/06_infernal/260602"
CMDIR="$ROOT/work/06_infernal/cm"
mkdir -p "$ANNOUT"
mkdir -p "$TBLOUT" 
FA_FIX="$ROOT/data/refseqs/pre_tile_refseqs/flavi_library_20260228.uniqueIDs.fa"

# define CMs: 
CMS=(
    "CL_Class_1a_xrRNA_final.cm"
    "CL_Class_1b_xrRNA_final.cm"
    "CL_Class_2_xrRNA_final.cm"
    "cl3_NAR_2025.align.mpkadded.edited.confident.dedup.IDcurated.SS_cons.cm"
    "cl4.cm"
)
INFERNAL_ARGS=$(printf -- "--infernal-tbl $TBLOUT/%s.tbl " "${CMS[@]}")

# cmsearch Infernal
for CM in "${CMS[@]}"; do
    echo "Searching: $CM"
    cmsearch --tblout "$TBLOUT/${CM}.tbl" \
             --cpu 8 \
             "$CMDIR/$CM" "$FA_FIX"
    echo "Done: $CM"
done

# peak annotation
for MG in 10 01; do
    for REP in 1 2; do
        echo "Annotating: ${MG}mM rep${REP}"
        python3 "$SCRIPTS/post_process_peaks.py" \
            "$FILTER/${MG}mM/rep${REP}_peaks.csv" \
            --out-raw       "$ANNOUT/${MG}mM_rep${REP}_peaks_annotated.csv" \
            --out-collapsed "$ANNOUT/${MG}mM_rep${REP}_peaks_per_accession.csv" \
            --family-csv    "$VIRUS_STATS" \
            $INFERNAL_ARGS
    done
done
  ```

  ```
  === 10mM rep1 (passing=8369) ===
  CM: {'cl1a': 411, 'cl1b': 527, 'cl2': 134, 'cl3': 8, 'cl4': 0}  any_hit=1080  no_hit=7289
  SF all:    median=0.111
  SF hit:    median=0.657
  SF no_hit: median=0.101

=== 10mM rep2 (passing=8090) ===
  CM: {'cl1a': 396, 'cl1b': 519, 'cl2': 143, 'cl3': 9, 'cl4': 0}  any_hit=1067  no_hit=7023
  SF all:    median=0.116
  SF hit:    median=0.660
  SF no_hit: median=0.104

=== 01mM rep1 (passing=7545) ===
  CM: {'cl1a': 353, 'cl1b': 489, 'cl2': 82, 'cl3': 0, 'cl4': 0}  any_hit=924  no_hit=6621
  SF all:    median=0.089
  SF hit:    median=0.497
  SF no_hit: median=0.083

=== 01mM rep2 (passing=7649) ===
  CM: {'cl1a': 360, 'cl1b': 493, 'cl2': 84, 'cl3': 0, 'cl4': 0}  any_hit=937  no_hit=6712
  SF all:    median=0.085
  SF hit:    median=0.436
  SF no_hit: median=0.080
(viromelib) 15:03:59 jgg2144@c0201:viromelib# 
  ```

  next step before downstream analysis should be to collapse peaks across overlapping tiles at the same stall position per accession

  also -- organism name in annotation

  ## organism name /taxid did not make it from virus stats csv into final annot csv - grab that info : 
  ```bash 
python3 - <<'EOF'
import csv, os

VIRUS_STATS = "/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib/data/virus_stats_flaviLib_20260602.csv"
ANNOUT = "/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib/work/07_postproc/260602"

org_map = {}
for r in csv.DictReader(open(VIRUS_STATS)):
    org_map[r['accession']] = r.get('organism', '')

for mg in ['10','01']:
    for rep in ['1','2']:
        for suffix in ['peaks_annotated', 'peaks_per_accession']:
            fin  = f"{ANNOUT}/{mg}mM_rep{rep}_{suffix}.csv"
            fout = fin + ".tmp"
            with open(fin) as f, open(fout, 'w', newline='') as out:
                reader = csv.DictReader(f)
                fields = ['family','genus','organism'] + \
                         [c for c in reader.fieldnames if c not in ('family','genus','organism')]
                writer = csv.DictWriter(out, fieldnames=fields)
                writer.writeheader()
                for r in reader:
                    plain = r['accession'].split('|')[0]
                    r['organism'] = org_map.get(plain, '')
                    writer.writerow(r)
            os.replace(fout, fin)
            print(f"Updated: {mg}mM rep{rep} {suffix}")
EOF

# verify
head -1 "$ANNOUT/10mM_rep1_peaks_annotated.csv" | tr ',' '\n' | grep -n "organism\|family\|genus"
  ```

  ### get 'best sf' tiles for each class 1a CM hit, to rank those by sf and align for PK examination -- 
  ```bash
  python3 - <<'EOF'
import csv, collections

ANNOUT  = "/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib/work/07_postproc/260602"
FA_FIX  = "/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib/data/refseqs/pre_tile_refseqs/flavi_library_20260228.uniqueIDs.fa"
OUT_FA  = "/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib/work/07_postproc/260602/cl1a_stall_sites.fa"
OUT_TSV = "/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib/work/07_postproc/260602/cl1a_stall_sites.tsv"

cl1a_col = "CL_Class_1a_xrRNA_final.cm_hit"
UPSTREAM   = 5
DOWNSTREAM = 80

# collect best SF per (accession, stall_position) across all conditions
best = {}  # (acc, stall_pos) -> dict
for mg in ['10','01']:
    for rep in ['1','2']:
        f = f"{ANNOUT}/{mg}mM_rep{rep}_peaks_annotated.csv"
        for r in csv.DictReader(open(f)):
            if r['peak_pass'] != 'True': continue
            if r.get(cl1a_col, '') == '': continue
            acc   = r['accession']
            stall = int(float(r['stall_position']))
            sf    = float(r['treated_sf'])
            key   = (acc, stall)
            if key not in best or sf > best[key]['sf']:
                best[key] = {
                    'accession': acc,
                    'stall':     stall,
                    'sf':        sf,
                    'tile_start': int(r['tile_start']),
                    'tile_end':   int(r['tile_end']),
                    'cm_start':  r.get('CL_Class_1a_xrRNA_final.cm_start',''),
                    'cm_end':    r.get('CL_Class_1a_xrRNA_final.cm_end',''),
                    'organism':  r.get('organism',''),
                    'family':    r.get('family',''),
                    'condition': f'{mg}mM',
                }

print(f"Unique cl1a stall sites: {len(best)}")

# load reference sequences
seqs = {}
current_id = None
current_seq = []
for line in open(FA_FIX):
    line = line.strip()
    if line.startswith('>'):
        if current_id: seqs[current_id] = ''.join(current_seq)
        current_id = line[1:].split()[0]
        current_seq = []
    else:
        current_seq.append(line)
if current_id: seqs[current_id] = ''.join(current_seq)

# extract sequences and write outputs
written = 0
skipped = 0
with open(OUT_FA, 'w') as fa, open(OUT_TSV, 'w', newline='') as tsv:
    w = csv.writer(tsv, delimiter='\t')
    w.writerow(['peak_id','accession','stall','seq_start','seq_end',
                'sf','cm_start','cm_end','pk_length','organism','family','condition'])
    
    for (acc, stall), d in sorted(best.items(), key=lambda x: -x[1]['sf']):
        seq = seqs.get(acc)
        if seq is None:
            skipped += 1
            continue
        
        seq_start = max(0, stall - UPSTREAM)
        seq_end   = min(len(seq), stall + DOWNSTREAM)
        extract   = seq[seq_start:seq_end]
        
        # pseudoknot length = cm_end - stall position (within extracted seq)
        pk_len = ''
        if d['cm_end']:
            try:
                pk_len = int(float(d['cm_end'])) - stall
            except: pass
        
        peak_id = f"{acc}:{stall}"
        fa.write(f">{peak_id} sf={d['sf']:.3f} organism={d['organism']}\n{extract}\n")
        w.writerow([peak_id, acc, stall, seq_start, seq_end,
                    f"{d['sf']:.4f}", d['cm_start'], d['cm_end'],
                    pk_len, d['organism'], d['family'], d['condition']])
        written += 1

print(f"Written: {written}  Skipped (no seq): {skipped}")
print(f"FASTA: {OUT_FA}")
print(f"TSV:   {OUT_TSV}")
EOF
  ```
  ```
  Written: 283  Skipped (no seq): 0
FASTA: /groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib/work/07_postproc/260602/cl1a_stall_sites.fa
TSV:   /groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib/work/07_postproc/260602/cl1a_stall_sites.tsv
  ```

  ### investigate CL class 1a CMs - distance of the PK regions, from the SS cons in the stockholm file 
```python
python3 - <<'EOF'
ss = "AA-<<<<<<<<<<.<<<<....---------.........................................................................>>>>>>>.>>-<<<<<<<<----BBBBBBB.---->>>>>>>>aa>>>>>----------bbbbbbb---------<.<<<-<<<<<<<<------------>>>>>>>.>-->>->->--"

# positions of each annotation (0-based)
A_pos = [i for i,c in enumerate(ss) if c == 'A']
a_pos = [i for i,c in enumerate(ss) if c == 'a']
B_pos = [i for i,c in enumerate(ss) if c == 'B']
b_pos = [i for i,c in enumerate(ss) if c == 'b']

print(f"A (p3 loop, pseudoknot stem 1): {len(A_pos)} positions at cols {A_pos}")
print(f"a (downstream partner):          {len(a_pos)} positions at cols {a_pos}")
print(f"B (pseudoknot stem 2):           {len(B_pos)} positions at cols {B_pos}")
print(f"b (downstream partner):          {len(b_pos)} positions at cols {b_pos}")

# distance between A block and a block = span of the pseudoknot
print(f"\nSpan A->a: cols {A_pos[0]} to {a_pos[-1]} = {a_pos[-1] - A_pos[0] + 1} consensus positions")
print(f"Span B->b: cols {B_pos[0]} to {b_pos[-1]} = {b_pos[-1] - B_pos[0] + 1} consensus positions")

# number of paired positions
print(f"\nPK stem 1 pairs: {len(A_pos)} (A=a, must be equal: {len(A_pos)==len(a_pos)})")
print(f"PK stem 2 pairs: {len(B_pos)} (B=b, must be equal: {len(B_pos)==len(b_pos)})")
EOF
```

gives CM column positions of the pseudoknot. 

Then cmalign on cl1a sequences will give per-sequence alignments -- 

- read off which actual bases occupy those columns 
— and count how many potential WC pairs exist between the B and b columns (PK 2) in each sequence.

### try cmalign 
```
STALL_FA="$ANNOUT/cl1a_stall_sites.fa"
CM="$CMDIR/CL_Class_1a_xrRNA_final.cm"
ALN_OUT="$ANNOUT/cl1a_stall_sites_aligned.sto"

cmalign --cpu 8 --outformat stockholm \
    "$CM" "$STALL_FA" \
    > "$ALN_OUT"

echo "Done"
wc -l "$ALN_OUT"
```

```
SS_CONS = "AA-<<<<<<<<<<.<<<<....---------.........................................................................>>>>>>>.>>-<<<<<<<<----BBBBBBB.---->>>>>>>>aa>>>>>----------bbbbbbb---------<.<<<-<<<<<<<<------------>>>>>>>.>-->>->->--"

```

### check for dumbbell structure in hits: 
```bash
srun --pty -t 06:00:00 -c 4 --mem=16G \
    --chdir=/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib \
    /bin/bash -l

conda activate viromelib

ROOT=/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib

# first calibrate a new CM taken from the seed alignment in rfam 
cmbuild "$ROOT/work/06_infernal/cm/dumbbell_RF00525.cm" \
        "$ROOT/work/06_infernal/stockholm/dumbbell_RF00525.sto"

# calibrate
cmcalibrate --cpu 8 "$ROOT/work/06_infernal/cm/dumbbell_RF00525.cm"

ROOT=/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib
FA_FIX="$ROOT/data/refseqs/pre_tile_refseqs/flavi_library_20260228.uniqueIDs.fa"
TBLOUT="$ROOT/work/06_infernal/260602"
CMDIR="$ROOT/work/06_infernal/cm"
ANNOUT="$ROOT/work/07_postproc/260602"
SCRIPTS="$ROOT/scripts"
FILTER="$ROOT/work/06_filter_v7"
FRAG="$ROOT/work/05_fragments/260602"
TILES20="$ROOT/data/refseqs/library_mifsud_simmonds_EDIT_tile20_with_jeanine_new_genomes_20260225.dupsremoved.uniqueIDs.bed"
VIRUS_STATS="$ROOT/data/virus_stats_flaviLib_20260602.csv"

# check CM hits in the input.. 
cmsearch --tblout "$TBLOUT/dumbbell_RF00525.cm.tbl" \
         --cpu 8 \
         "$CMDIR/dumbbell_RF00525.cm" \
         "$FA_FIX"
```

### check CM hits in the stall sites: 
### (quick python best sf in all conditions peak window extract) - replace later with the pipeline script. 
```bash
python3 - <<'EOF'
import csv

ANNOUT  = "/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib/work/07_postproc/260602"
FA_FIX  = "/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib/data/refseqs/pre_tile_refseqs/flavi_library_20260228.uniqueIDs.fa"
OUT_FA  = "/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib/work/07_postproc/260602/all_stall_sites.fa"

UPSTREAM   = 5
DOWNSTREAM = 80

# collect best SF per (accession, stall_position) across all conditions

best = {}
for mg in ['10','01']:
    for rep in ['1','2']:
        f = f"{ANNOUT}/{mg}mM_rep{rep}_peaks_annotated.csv"
        for r in csv.DictReader(open(f)):
            if r['peak_pass'] != 'True': continue
            acc   = r['accession']
            stall = int(float(r['stall_position']))
            sf    = float(r['treated_sf'])
            key   = (acc, stall)
            if key not in best or sf > best[key]['sf']:
                best[key] = {
                    'accession': acc,
                    'stall': stall,
                    'sf': sf,
                    'organism': r.get('organism',''),
                    'any_hit': r.get('any_hit',''),
                }

print(f"Unique stall sites: {len(best)}")

# load reference sequences

seqs = {}
current_id = None
current_seq = []
for line in open(FA_FIX):
    line = line.strip()
    if line.startswith('>'):
        if current_id: seqs[current_id] = ''.join(current_seq)
        current_id = line[1:].split()[0]
        current_seq = []
    else:
        current_seq.append(line)
if current_id: seqs[current_id] = ''.join(current_seq)

written = skipped = 0
with open(OUT_FA, 'w') as fa:
    for (acc, stall), d in sorted(best.items(), key=lambda x: -x[1]['sf']):
        seq = seqs.get(acc)
        if seq is None:
            skipped += 1
            continue
        seq_start = max(0, stall - UPSTREAM)
        seq_end   = min(len(seq), stall + DOWNSTREAM)
        extract   = seq[seq_start:seq_end]
        peak_id   = f"{acc}:{stall}"
        fa.write(f">{peak_id} sf={d['sf']:.3f} organism={d['organism']}\n{extract}\n")
        written += 1

print(f"Written: {written}  Skipped: {skipped}")
print(f"FASTA: {OUT_FA}")
EOF

cmsearch --tblout "$TBLOUT/dumbbell_RF00525_all_stalls.cm.tbl" \
         -o "$TBLOUT/dumbbell_RF00525_all_stalls.cm.out" \
         --cpu 8 \
         "$CMDIR/dumbbell_RF00525.cm" \
         "$ANNOUT/all_stall_sites.fa"
```
### merge dumbbell hits with annotated peaks: 
```bash
python3 - <<'EOF'
import re, csv

TBLOUT  = "/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib/work/06_infernal/260602"
ANNOUT  = "/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib/work/07_postproc/260602"
OUT     = f"{ANNOUT}/dumbbell_hits_annotated.tsv"

# parse tbl - just get seq_name, seq_from, seq_to, evalue

db_hits = {}  # seq_name -> best evalue hit
for line in open(f"{TBLOUT}/dumbbell_RF00525_all_stalls.cm.tbl"):
    if line.startswith('#'): continue
    f = line.split()
    if len(f) < 10: continue
    seq_name = f[0]
    # find evalue - it's the float with e- in it
    evalue = next((float(x) for x in f if 'e-' in x or 'e+' in x), None)
    seq_from = next((int(x) for x in f[5:12] if x.lstrip('-').isdigit()), None)
    seq_to   = next((int(x) for x in f[6:13] if x.lstrip('-').isdigit() and int(x) > (seq_from or 0)), None)
    if seq_name not in db_hits or (evalue and evalue < db_hits[seq_name]['evalue']):
        db_hits[seq_name] = {'evalue': evalue, 'seq_from': seq_from, 'seq_to': seq_to}

print(f"DB hits: {len(db_hits)}")

# join to annotated peaks

with open(OUT, 'w', newline='') as out:
    w = csv.writer(out, delimiter='\t')
    w.writerow(['accession','stall_position','tile_start','tile_end',
                'treated_sf','organism','family','any_hit',
                'db_evalue','db_seq_from','db_seq_to'])

    for mg in ['10','01']:
        for rep in ['1','2']:
            f = f"{ANNOUT}/{mg}mM_rep{rep}_peaks_annotated.csv"
            for r in csv.DictReader(open(f)):
                if r['peak_pass'] != 'True': continue
                acc   = r['accession']
                stall = r['stall_position']
                key   = f"{acc}:{int(float(stall))}"
                if key not in db_hits: continue
                h = db_hits[key]
                w.writerow([acc, stall, r['tile_start'], r['tile_end'],
                            r['treated_sf'], r.get('organism',''),
                            r.get('family',''), r.get('any_hit',''),
                            h['evalue'], h['seq_from'], h['seq_to']])

print(f"Output: {OUT}")
EOF
```

# current issue with genomic position and biological interpretation: need to consolidate overlapping stall hits to their genomic position, and add a column for stop # in genome (e.g. xr1, 2, db, etc... )
### make python script: 

```bash
```bash
srun --pty -t 06:00:00 -c 4 --mem=16G \
    --chdir=/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib \
    /bin/bash -l

conda activate viromelib

ROOT=/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib
FA_FIX="$ROOT/data/refseqs/pre_tile_refseqs/flavi_library_20260228.uniqueIDs.fa"
TBLOUT="$ROOT/work/06_infernal/260602"
CMDIR="$ROOT/work/06_infernal/cm"
ANNOUT="$ROOT/work/07_postproc/260602"
SCRIPTS="$ROOT/scripts"
FILTER="$ROOT/work/06_filter_v7"
FRAG="$ROOT/work/05_fragments/260602"
TILES20="$ROOT/data/refseqs/library_mifsud_simmonds_EDIT_tile20_with_jeanine_new_genomes_20260225.dupsremoved.uniqueIDs.bed"
VIRUS_STATS="$ROOT/data/virus_stats_flaviLib_20260602.csv"

python3 "$SCRIPTS/consolidate_stalls.py" \
    --annout     "$ANNOUT" \
    --tblout     "$TBLOUT" \
    --db-tbl     "dumbbell_RF00525_all_stalls.cm.tbl" \
    --db-evalue  1e-5 \
    --conditions 10 01 \
    --replicates 1 2 \
    --out        "$ANNOUT/best_stalls_consolidated.tsv"

```
```
[consolidate] Unique (accession, stall) pairs: 12458

[consolidate] CM class distribution:
  unannotated: 11044
  dumbbell: 636
  cl1b: 348
  cl1a: 283
  cl2: 141
  cl3: 6
```
```bash
# try filtering sf only above 0.2, dumbbells go way down, as do unannotated. : 
# filter by min SF then rerun
python3 "$SCRIPTS/consolidate_stalls.py" \
    --annout     "$ANNOUT" \
    --tblout     "$TBLOUT" \
    --db-tbl     "dumbbell_RF00525_all_stalls.cm.tbl" \
    --db-evalue  1e-5 \
    --conditions 10 01 \
    --replicates 1 2 \
    --out        "$ANNOUT/best_stalls_consolidated.tsv" 2>&1 | tail -20

# then filter the output by SF >= 0.2
awk -F'\t' 'NR==1 || $8 >= 0.2' "$ANNOUT/best_stalls_consolidated.tsv" \
    > "$ANNOUT/best_stalls_consolidated_sf0.2.tsv"

wc -l "$ANNOUT/best_stalls_consolidated_sf0.2.tsv"

# check CM distribution after SF filter
tail -n +2 "$ANNOUT/best_stalls_consolidated_sf0.2.tsv" \
    | cut -f12 | sort | uniq -c | sort -rn

```
```
1856 /groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib/work/07_postproc/260602/best_stalls_consolidated_sf0.2.tsv
   1430 unannotated
    139 cl1b
    107 cl1a
    100 dumbbell
     73 cl2
      6 cl3
```
### actually, do a separate analysis for the two Mg conditions. 
```bash
python3 "$SCRIPTS/consolidate_stalls.py" \
    --annout     "$ANNOUT" \
    --tblout     "$TBLOUT" \
    --db-tbl     "dumbbell_RF00525_all_stalls.cm.tbl" \
    --db-evalue  1e-5 \
    --conditions 10 \
    --replicates 1 2 \
    --out        "$ANNOUT/best_stalls_10mM.tsv"

python3 "$SCRIPTS/consolidate_stalls.py" \
    --annout     "$ANNOUT" \
    --tblout     "$TBLOUT" \
    --db-tbl     "dumbbell_RF00525_all_stalls.cm.tbl" \
    --db-evalue  1e-5 \
    --conditions 01 \
    --replicates 1 2 \
    --out        "$ANNOUT/best_stalls_01mM.tsv"

# filter by SF >= 0.2
for f in "$ANNOUT/best_stalls_10mM.tsv" "$ANNOUT/best_stalls_01mM.tsv"; do
    awk -F'\t' 'NR==1 || $8 >= 0.2' "$f" > "${f%.tsv}_sf0.2.tsv"
    echo "$(basename ${f%.tsv}_sf0.2.tsv):"
    tail -n +2 "${f%.tsv}_sf0.2.tsv" | cut -f12 | sort | uniq -c | sort -rn
    echo "total: $(tail -n +2 ${f%.tsv}_sf0.2.tsv | wc -l)"
    echo
done
```
```
[consolidate] Written 8449 rows -> /groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib/work/07_postproc/260602/best_stalls_01mM.tsv
best_stalls_10mM_sf0.2.tsv:
   1139 unannotated
    126 cl1b
     96 cl1a
     81 dumbbell
     54 cl2
      6 cl3
total: 1502

best_stalls_01mM_sf0.2.tsv:
    709 unannotated
    115 cl1b
     85 cl1a
     42 dumbbell
     28 cl2
total: 979

```
### get genus and CM info for plotting: 
(extract columns)
```bash
for MG in 10mM 01mM; do
    echo "=== $MG ==="
    tail -n +2 "$ANNOUT/best_stalls_${MG}_sf0.2.tsv" \
        | awk -F'\t' '{
            genus = $18
            if (genus == "") genus = "Unclassified"
            print genus"\t"$12
          }' \
        | sort | uniq -c | sort -rn | head -25
    echo
done
```
```
=== 10mM ===
    397 Unclassified    unannotated
    276 Orthoflavivirus unannotated
    137 Orthohepacivirus        unannotated
    110 Pegivirus       unannotated
     91 Orthopestivirus unannotated
     81 Jingmenvirus    unannotated
     79 Orthoflavivirus cl1a
     68 Orthoflavivirus dumbbell
     54 Orthoflavivirus cl2
     38 Orthoflavivirus cl1b
     38 Boletivirus     unannotated
     30 Orthohepacivirus        cl1b
     28 Pegivirus       cl1b
     19 Unclassified    cl1b
     17 Unclassified    cl1a
     13 Unclassified    dumbbell
      9 Orthopestivirus cl1b
      6 Unclassified    cl3
      4 Chrysopivirus   unannotated
      3 Guaicovirus     unannotated
      2 Tamanavirus     cl1b
      2 Koshovirus      unannotated

=== 01mM ===
    209 Unclassified    unannotated
    193 Orthoflavivirus unannotated
    101 Orthohepacivirus        unannotated
     76 Orthopestivirus unannotated
     68 Orthoflavivirus cl1a
     66 Pegivirus       unannotated
     35 Orthoflavivirus dumbbell
     34 Jingmenvirus    unannotated
     30 Orthohepacivirus        cl1b
     29 Orthoflavivirus cl1b
     28 Orthoflavivirus cl2
     27 Pegivirus       cl1b
     25 Boletivirus     unannotated
     18 Unclassified    cl1b
     17 Unclassified    cl1a
      9 Orthopestivirus cl1b
      7 Unclassified    dumbbell
      2 Tamanavirus     cl1b
      2 Guaicovirus     unannotated
      2 Chrysopivirus   unannotated
      1 Koshovirus      unannotated

```
### take this data into an R plotting notebook. 
locally copy the necessary CSVs and run locally (but also copied the .rmd here in workflows:)
`~/Desktop/viromelib/flaviLib/workflows`
`CMdist-postXrn1.rmd`
```

```
overall, need to make sure the biological reasoning dominates: 
- we are interested in the strongest stops as they occur in the genome (xr1, xr2,... )
- if there is a CM hit, it should be proximal to the stall (beginning within 20 bases - default?)
- many tiles overlap. they will have different stall positions relative to their tile, but the genomic position will be the same. this needs to be consolidated. 
- we need a new column specifically for genomic position to make pulling from the csv easier 
- we need a column that assumes based on where it is in genome its xr number (xr 1 is the most 5')
- similarly need to always carry over taxo: family, genus, organism
- compare sf value (mean) to e-value range for a given CM (expect mean sf to be highest for class 1a/1b, then 2, then dumbbell)
    - are some class 1/2 being hit by dumbbell? - checked - 4 class 1a overlap, otherwise db hits unique. 
    - they are not occuring at particularly strong sfs, which fits biology. 
- still need metagenome info (distance from CDS - will be more targeted when mapping is definite with next seq. paired end run.)
- are these hit counts per CM unique spots in a given genome or could many be the same stall relative to the whole genome? and, is it possible to filter out hits occuring on an sf below a certain value? maybe 0.2?
    - i think they are indeed unique genomic positions (see tsv: `Written 12458 rows -> /groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib/work/07_postproc/260602/best_stalls_consolidated.tsv` )
- also recall mis-mapping issue of overlapping tiles: exactly how many do we think are improper alignments? how do we determine this? 

---------- 

# analysis of 75x75 sequencing run on Aug 12, 2026

----------
## Environment

```bash
srun --pty -t 06:00:00 -c 4 --mem=16G \
    --chdir=/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib \
    /bin/bash -l

conda activate viromelib
ROOT=/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib
RAW="$ROOT/work/01_raw"
cd "$RAW"
```

```bash
export SRC=/groups/as6282_gp/data_bkup/jgg2144/20260807_Aviti_75x75_FlaviLib-DMS
cd "$RAW"   # your 01_raw directory

```
### symlink based on each sample's conditions 

#### convention: 
`YYMMDD`-`r####(JGG RNA ID)`-`10` or `01` ([mg] used for folding RNA)-`R` or `X` (for RppH ctrl vs Xrn1)-`#`(replicate)-`A####_R#.fastq.gz`(index code and read direction 1 or 2)

```bash
ln -s $SRC/A3413/A3413_R1.fastq.gz  260807-r0441-10-R-3-A3413_R1.fastq.gz
ln -s $SRC/A3413/A3413_R2.fastq.gz  260807-r0441-10-R-3-A3413_R2.fastq.gz

ln -s $SRC/A3429/A3429_R1.fastq.gz  260807-r0441-10-X-3-A3429_R1.fastq.gz
ln -s $SRC/A3429/A3429_R2.fastq.gz  260807-r0441-10-X-3-A3429_R2.fastq.gz

ln -s $SRC/A3419/A3419_R1.fastq.gz  260807-r0441-10-R-4-A3419_R1.fastq.gz
ln -s $SRC/A3419/A3419_R2.fastq.gz  260807-r0441-10-R-4-A3419_R2.fastq.gz

ln -s $SRC/A3499/A3499_R1.fastq.gz  260807-r0441-10-X-4-A3499_R1.fastq.gz
ln -s $SRC/A3499/A3499_R2.fastq.gz  260807-r0441-10-X-4-A3499_R2.fastq.gz

ln -s $SRC/A3485/A3485_R1.fastq.gz  260807-r0441-01-R-3-A3485_R1.fastq.gz
ln -s $SRC/A3485/A3485_R2.fastq.gz  260807-r0441-01-R-3-A3485_R2.fastq.gz

ln -s $SRC/A3484/A3484_R1.fastq.gz  260807-r0441-01-X-3-A3484_R1.fastq.gz
ln -s $SRC/A3484/A3484_R2.fastq.gz  260807-r0441-01-X-3-A3484_R2.fastq.gz

ln -s $SRC/A3483/A3483_R1.fastq.gz  260807-r0441-01-R-4-A3483_R1.fastq.gz
ln -s $SRC/A3483/A3483_R2.fastq.gz  260807-r0441-01-R-4-A3483_R2.fastq.gz

ln -s $SRC/A3466/A3466_R1.fastq.gz  260807-r0441-01-X-4-A3466_R1.fastq.gz
ln -s $SRC/A3466/A3466_R2.fastq.gz  260807-r0441-01-X-4-A3466_R2.fastq.gz

ln -s $SRC/A3498/A3498_R1.fastq.gz  260807-r0416-10-R-1-A3498_R1.fastq.gz
ln -s $SRC/A3498/A3498_R2.fastq.gz  260807-r0416-10-R-1-A3498_R2.fastq.gz

ln -s $SRC/A3479/A3479_R1.fastq.gz  260807-r0416-10-X-1-A3479_R1.fastq.gz
ln -s $SRC/A3479/A3479_R2.fastq.gz  260807-r0416-10-X-1-A3479_R2.fastq.gz

ln -s $SRC/A3478/A3478_R1.fastq.gz  260807-r0416-10-R-2-A3478_R1.fastq.gz
ln -s $SRC/A3478/A3478_R2.fastq.gz  260807-r0416-10-R-2-A3478_R2.fastq.gz

ln -s $SRC/A3476/A3476_R1.fastq.gz  260807-r0416-10-X-2-A3476_R1.fastq.gz
ln -s $SRC/A3476/A3476_R2.fastq.gz  260807-r0416-10-X-2-A3476_R2.fastq.gz

ln -s $SRC/A3467/A3467_R1.fastq.gz  260807-r0416-01-R-1-A3467_R1.fastq.gz
ln -s $SRC/A3467/A3467_R2.fastq.gz  260807-r0416-01-R-1-A3467_R2.fastq.gz

ln -s $SRC/A3462/A3462_R1.fastq.gz  260807-r0416-01-X-1-A3462_R1.fastq.gz
ln -s $SRC/A3462/A3462_R2.fastq.gz  260807-r0416-01-X-1-A3462_R2.fastq.gz

ln -s $SRC/A3434/A3434_R1.fastq.gz  260807-r0416-01-R-2-A3434_R1.fastq.gz
ln -s $SRC/A3434/A3434_R2.fastq.gz  260807-r0416-01-R-2-A3434_R2.fastq.gz

ln -s $SRC/A3427/A3427_R1.fastq.gz  260807-r0416-01-X-2-A3427_R1.fastq.gz
ln -s $SRC/A3427/A3427_R2.fastq.gz  260807-r0416-01-X-2-A3427_R2.fastq.gz
```

look at reads: 
first and last 30 bases of both mates across 10 reads: 
```bash
cd "$RAW"

for SAMPLE in A3413 A3429; do
  R1=$(ls 260807-*-${SAMPLE}_R1.fastq.gz)
  R2=$(ls 260807-*-${SAMPLE}_R2.fastq.gz)

  echo "=== $SAMPLE ($R1) ==="

  echo "--- R1, first 10 reads, first 30bp ---"
  zcat "$R1" | head -40 | awk 'NR%4==2' | cut -c1-30

  echo "--- R1, first 10 reads, last 30bp ---"
  zcat "$R1" | head -40 | awk 'NR%4==2' | rev | cut -c1-30 | rev

  echo "--- R2, first 10 reads, first 30bp ---"
  zcat "$R2" | head -40 | awk 'NR%4==2' | cut -c1-30

  echo "--- R2, first 10 reads, last 30bp ---"
  zcat "$R2" | head -40 | awk 'NR%4==2' | rev | cut -c1-30 | rev

  echo
done
```
as expected, the R1 for  R sample (which should not be degraded at all) still has its universal leader (that is, the GGATTAATATAAT downstream of the ~8 bases NNNNNNNN added during ligation step)

however, the R1 for X sample (which has been degraded to a certain point in the sequence) does not have the leader. And for both R and X, the R2, first 30 bp, the reverse complement of the universal 3' end is there. 

one thing to caution – some of the Xrn1 samples seem to have readthrough 



# 02_trim
```bash
# assumes conda activate viromelib
ROOT=/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib
RAW=$ROOT/work/01_raw
TRIM=$ROOT/work/02_trim
LOGS=$TRIM/logs

mkdir -p "$TRIM" "$LOGS"

#quick check for adapter seq 
cd "$RAW"
zcat 260807-r0441-10-X-3-A3429_R2.fastq.gz | head -40 | awk 'NR%4==2' | grep -o 'AGATCGGAAGAGC.\{0,20\}'  # change for sample 
```

```bash
LEAD5=GGATTAATATAAT
END3=AAAGAAACAACAACAACAAC
# LEAD5_RC=ATTATATTAATCC - not necessary for this sequencing read length because R samples won't reach the RC of the leader seq. 
END3_RC=GTTGTTGTTGTTGTTTCTTT
PLATFORM_ADAPTER=AGATCGGAAGAGC
# actual trim adapter for R2's readthrough case is -A "$PLATFORM_ADAPTER" ; R2 reads through the insert and if it passes through all the insert (which should be rare...) runs straight into the sequencer's adapter (AGATCGGAAGAGC); this eliminates the adapter and everything following, to prevent adapter contamination/readthrough

cd "$TRIM"

for R1 in "$RAW"/260807-*_R1.fastq.gz; do
  R2=${R1/_R1.fastq.gz/_R2.fastq.gz} # string substitution syntax: ${variable/find/replace}
  BASENAME=$(basename "$R1" _R1.fastq.gz)

  echo "=== $BASENAME ==="


  # --- Step 1: paired trim ---
  # R1: trim END3 + anything after (adapter readthrough)
  # R2: trim PLATFORM_ADAPTER + anything after (adapter readthrough)
  cutadapt -j 8 \
    -a "$END3" -A "$PLATFORM_ADAPTER" \
    -m 20 \
    --pair-filter=any \
    -o "$TRIM/${BASENAME}_R1.insert.fastq.gz" \
    -p "$TRIM/${BASENAME}_R2.insert.fastq.gz" \
    "$R1" "$R2" \
    > "$LOGS/${BASENAME}.cutadapt.paired.txt"

  # --- Step 2a: classify R1 by 5' leader presence ---
  cutadapt -j 8 \
    -g "$LEAD5" \
    -e 0.12 \
    --action=none \
    -o "$TRIM/${BASENAME}_R1.insert.HASLEAD.fastq.gz" \
    --untrimmed-output "$TRIM/${BASENAME}_R1.insert.NOLEAD.fastq.gz" \
    "$TRIM/${BASENAME}_R1.insert.fastq.gz" \
    > "$LOGS/${BASENAME}.R1_split_by_leader.txt"

  # --- Step 2b: classify R2 by 5' END3_RC presence (QC sanity check, both conditions) ---
  cutadapt -j 8 \
    -g "$END3_RC" \
    -e 0.12 \
    --action=none \
    -o "$TRIM/${BASENAME}_R2.insert.HASEND3.fastq.gz" \
    --untrimmed-output "$TRIM/${BASENAME}_R2.insert.NOEND3.fastq.gz" \
    "$TRIM/${BASENAME}_R2.insert.fastq.gz" \
    > "$LOGS/${BASENAME}.R2_split_by_end3.txt"

  echo "Finished: $BASENAME"
done

```
check logs for retention, seems in X samples, more lost following the filtering of reads less than 20. make sure those aren't real signal. 

need to do qc 

pull the fragment-length distribution out of the alignment itself
# 03_qc
```bash
ROOT=/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib
TRIM=$ROOT/work/02_trim
QC=$ROOT/work/03_qc/260807
mkdir -p "$QC"

fastqc -t 8 -o "$QC" "$TRIM"/260807-*.insert.fastq.gz

multiqc -o "$QC" "$QC"
```


# 04_align 
```bash
# conda activate viromelib

ROOT=/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib
TRIM=$ROOT/work/02_trim
OUT=$ROOT/work/04_align/20260812_flaviLib_75x75
mkdir -p "$OUT"

IDX="$ROOT/work/04_align/20260605_flaviLib/index/flavi_library_20260228.uniqueIDs"

export TMPDIR="/localscratch/$USER/${SLURM_JOB_ID:-manual}"
mkdir -p "$TMPDIR"

for R1 in "$TRIM"/260807-*_R1.insert.fastq.gz; do
  R2=${R1/_R1.insert.fastq.gz/_R2.insert.fastq.gz}
  BASE=$(basename "$R1" _R1.insert.fastq.gz)

  echo "=== $BASE ==="

  # --- SE: R1 only, no pairing constraint ---
  bowtie2 --very-sensitive-local -k 1 -p 8 \
    -x "$IDX" -U "$R1" \
    2> "$OUT/${BASE}.SE.bowtie2.log" \
  | samtools view -b -q 0 -o "$OUT/${BASE}.SE.unsorted.bam" -
  samtools sort -@ 4 -m 2G -T "$TMPDIR/${BASE}.SE.sort" \
    -o "$OUT/${BASE}.SE.bam" "$OUT/${BASE}.SE.unsorted.bam"
  samtools index "$OUT/${BASE}.SE.bam"
  rm "$OUT/${BASE}.SE.unsorted.bam"

  # --- PE: R1+R2, forced pairing ---
  # -X 250 allows fragment lengths up to the longest possible tile (196nt) + extra
  bowtie2 --very-sensitive-local -k 1 -p 8 \
    -x "$IDX" -1 "$R1" -2 "$R2" \
    --no-mixed --no-discordant \
    -X 250 \
    2> "$OUT/${BASE}.PE.bowtie2.log" \
  | samtools view -b -q 0 -o "$OUT/${BASE}.PE.unsorted.bam" -
  samtools sort -@ 4 -m 2G -T "$TMPDIR/${BASE}.PE.sort" \
    -o "$OUT/${BASE}.PE.bam" "$OUT/${BASE}.PE.unsorted.bam"
  samtools index "$OUT/${BASE}.PE.bam"
  rm "$OUT/${BASE}.PE.unsorted.bam"

  echo "Done: $BASE"
done
```

get fragment length dist
```bash
FRAGDIST="$OUT/fragment_length_distributions.tsv"
echo -e "Sample\tTLEN" > "$FRAGDIST"

for BAM in "$OUT"/260807-*.PE.bam; do
  BASE=$(basename "$BAM" .PE.bam)
  samtools view -f 0x2 "$BAM" | awk -v s="$BASE" '$9 > 0 {print s"\t"$9}' >> "$FRAGDIST"
done

python3 - <<'EOF'
import statistics, collections

data = collections.defaultdict(list)
with open("/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib/work/04_align/20260812_flaviLib_75x75/fragment_length_distributions.tsv") as f:
    next(f)
    for line in f:
        s, tlen = line.strip().split('\t')
        data[s].append(int(tlen))

for s, vals in sorted(data.items()):
    print(f"{s}\tn={len(vals)}\tmedian={statistics.median(vals):.0f}\tmean={statistics.mean(vals):.1f}\tmin={min(vals)}\tmax={max(vals)}")
EOF
```

compare SE vs PE alignment rates for x v r 
```bash
OUT=$ROOT/work/04_align/20260812_flaviLib_75x75

echo -e "Sample\tSE_overall_pct\tPE_concordant_pct\tDrop_pct" > "$OUT/se_vs_pe_summary.tsv"

for LOG in "$OUT"/260807-*.SE.bowtie2.log; do
  BASE=$(basename "$LOG" .SE.bowtie2.log)
  PE_LOG="$OUT/${BASE}.PE.bowtie2.log"

  SE_PCT=$(grep "overall alignment rate" "$LOG" | grep -oP '[\d.]+(?=%)')
  PE_PCT=$(grep "overall alignment rate" "$PE_LOG" | grep -oP '[\d.]+(?=%)')

  DROP=$(python3 -c "print(f'{${SE_PCT} - ${PE_PCT}:.2f}')")

  echo -e "${BASE}\t${SE_PCT}\t${PE_PCT}\t${DROP}" >> "$OUT/se_vs_pe_summary.tsv"
done

column -t "$OUT/se_vs_pe_summary.tsv"
```

remember soft-clipping is happening for sequences containing leader and the 8-mer 

`TLEN` field samtools reports includes the full unclipped read length, not just the aligned/matched span. 

note to check X-HASLEAD 

do a quick check of R1 only alignment with -k 2 allowing 2 possible alignments..(more as a diagnostic)

```bash
IDX="$ROOT/work/04_align/20260605_flaviLib/index/flavi_library_20260228.uniqueIDs"

bowtie2 --very-sensitive-local -k 2 -p 1 \
    -x "$IDX" -U /tmp/single_read.fastq \
    2> /tmp/single_read.bowtie2.log \
    | samtools view -

echo "--- log ---"
cat /tmp/single_read.bowtie2.log
```
remember the alignment file `"$FA_FIX"` is not the file we ordered for the library. we should use the deduplicated file. 

see the file pairs throughout "$FA_FIX": 
```bash
ROOT=/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib
FA_FIX=$ROOT/data/refseqs/pre_tile_refseqs/flavi_library_20260228.uniqueIDs.fa

seqkit rmdup -s "$FA_FIX" -D /tmp/dup_report.txt -o /dev/null
wc -l /tmp/dup_report.txt
head -20 /tmp/dup_report.txt
```
output: [INFO] 86 duplicated records removed
86 /tmp/dup_report.txt
2       D17763.1|9405-9425_3UTR, NC_009824.1|9405-9425_3UTR
2       DQ525916.1|10341-10940_inferred_3UTR, NC_007580.2|10341-10940_inferred_3UTR
2       KJ950914.1|12480-12983_3UTR, NC_025677.1|12480-12983_3UTR
2       KT439329.1|9503-9538_3UTR, NC_038436.1|9503-9538_3UTR
2       KC815310.1|8649-8879_3UTR, NC_021153.1|8649-8879_3UTR
2       AF161266.1|10350-11014_inferred_3UTR, NC_000943.1|10350-11014_inferred_3UTR
2       JX390986.2|2786-2963_inferred_3UTR, NC_034222.1|2786-2963_inferred_3UTR
2       GU566734.1|9367-9630_3UTR, NC_030291.1|9367-9630_3UTR
2       AB262759.2|10133-10837_inferred_3UTR, NC_008604.2|10133-10837_inferred_3UTR
2       EF108306.2|9381-9418_3UTR, NC_030791.1|9381-9418_3UTR
2       KF726084.1|18018-19199_inferred_3UTR, NC_024077.1|18018-19199_inferred_3UTR
2       KT192549.1|10214-10893_inferred_3UTR, NC_027817.1|10214-10893_inferred_3UTR
2       KX907452.1|10354-10897_3UTR, NC_034204.1|10354-10897_3UTR
2       KY345399.1|10222-10370_3UTR, NC_034242.1|10222-10370_3UTR
2       M18370.1|10344-10976_inferred_3UTR, NC_001437.1|10344-10976_inferred_3UTR
2       KC551802.1|10272-10471_3UTR, NC_031950.1|10272-10471_3UTR
2       KR902731.1|17863-18697_inferred_3UTR, NC_028376.1|17863-18697_inferred_3UTR
2       KC796076.1|10459-10767_3UTR, NC_038435.1|10459-10767_3UTR
2       L06436.1|10309-10839_inferred_3UTR, NC_003687.1|10309-10839_inferred_3UTR
2       AY632542.4|10320-10794_inferred_3UTR, NC_040776.1|10320-10794_inferred_3UTR

sequences in "$FA_FIX"
```bash
grep -c "^>" "$FA_FIX"
```
623

# 04_align with true pre-tile reference: 
### alignment file `flavi_library_20260228.fa`
sanitize the names first with `"$SCRIPTS/rename_pretile_fa.py”` to have non-ambiguous headers, add uniqueIDs suffix. 
 
```bash
# assumes conda env viromelib 
ROOT=/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib
SCRIPTS="$ROOT/scripts"

FA_IN="$ROOT/data/refseqs/pre_tile_refseqs/flavi_library_20260228pretile20260818_TRUEordered.fa"
FA_FIX="$ROOT/data/refseqs/pre_tile_refseqs/flavi_library_20260228pretile20260818_TRUEordered_uniqueIDs.fa"

"$SCRIPTS/rename_pretile_fa.py" "$FA_IN" "$FA_FIX"

# check, should have nothing 
grep "^>" "$FA_FIX" | sed 's/^>//' | cut -d" " -f1 | sort | uniq -d | head

# examine new format 
head -100 "$FA_FIX"
```

### rebuild new index for bowtie 
```bash
ROOT=/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib
FA_FIX="$ROOT/data/refseqs/pre_tile_refseqs/flavi_library_20260228pretile20260818_TRUEordered_uniqueIDs.fa"

OUT=$ROOT/work/04_align/20260812_flaviLib_75x75
IDX_DIR="$OUT/index"
IDX="$IDX_DIR/flavi_library_20260228pretile20260818_TRUEordered_uniqueIDs"
mkdir -p "$IDX_DIR"

bowtie2-build --threads 8 "$FA_FIX" "$IDX"
```
### move index file to logical spot 
```bash
ROOT=/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib
OLD_IDX_DIR="$ROOT/work/04_align/20260812_flaviLib_75x75/index"
NEW_IDX_DIR="$ROOT/data/refseqs/pre_tile_refseqs/index"

mkdir -p "$NEW_IDX_DIR"
mv "$OLD_IDX_DIR"/flavi_library_20260228pretile20260818_TRUEordered_uniqueIDs* "$NEW_IDX_DIR/"
```
```bash
# confirm the move worked and nothing's missing
ls -la "$NEW_IDX_DIR"
```
## alignment 
```bash
ROOT=/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib
IDX="$ROOT/data/refseqs/pre_tile_refseqs/index/flavi_library_20260228pretile20260818_TRUEordered_uniqueIDs"
TRIM=$ROOT/work/02_trim
OUT=$ROOT/work/04_align/20260818_flaviLib_75x75_trueRef
mkdir -p "$OUT"

export TMPDIR="/localscratch/$USER/${SLURM_JOB_ID:-manual}"
mkdir -p "$TMPDIR"

for R1 in "$TRIM"/260807-*_R1.insert.fastq.gz; do
  R2=${R1/_R1.insert.fastq.gz/_R2.insert.fastq.gz}
  BASE=$(basename "$R1" _R1.insert.fastq.gz)

  echo "=== $BASE ==="

  bowtie2 --very-sensitive-local -k 1 -p 8 \
    -x "$IDX" -U "$R1" \
    2> "$OUT/${BASE}.SE.bowtie2.log" \
  | samtools view -b -q 0 -o "$OUT/${BASE}.SE.unsorted.bam" -
  samtools sort -@ 4 -m 2G -T "$TMPDIR/${BASE}.SE.sort" \
    -o "$OUT/${BASE}.SE.bam" "$OUT/${BASE}.SE.unsorted.bam"
  samtools index "$OUT/${BASE}.SE.bam"
  rm "$OUT/${BASE}.SE.unsorted.bam"

  bowtie2 --very-sensitive-local -k 1 -p 8 \
    -x "$IDX" -1 "$R1" -2 "$R2" \
    --no-mixed --no-discordant \
    -X 250 \
    2> "$OUT/${BASE}.PE.bowtie2.log" \
  | samtools view -b -q 0 -o "$OUT/${BASE}.PE.unsorted.bam" -
  samtools sort -@ 4 -m 2G -T "$TMPDIR/${BASE}.PE.sort" \
    -o "$OUT/${BASE}.PE.bam" "$OUT/${BASE}.PE.unsorted.bam"
  samtools index "$OUT/${BASE}.PE.bam"
  rm "$OUT/${BASE}.PE.unsorted.bam"

  echo "Done: $BASE"
done
```

### same quality checks as before: 

#### use a virus that had a duplicate with the old ref, Quang Binh virus: 
```bash
ROOT=/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib
IDX="$ROOT/data/refseqs/pre_tile_refseqs/index/flavi_library_20260228pretile20260818_TRUEordered_uniqueIDs"

READID="AV100007:080626_Sternberg_Aviti:2521664905:1:21604:2445:2926"
zcat "$ROOT/work/02_trim"/260807-r0416-01-X-1-A3462_R1.insert.fastq.gz \
    | grep -A3 "^@${READID}" > /tmp/single_read.fastq

bowtie2 --very-sensitive-local -k 2 -p 1 \
    -x "$IDX" -U /tmp/single_read.fastq \
    2> /tmp/single_read.bowtie2.log \
    | samtools view -

echo "--- log ---"
cat /tmp/single_read.bowtie2.log
```
Expect: only one SAM line now (not two tied alignments)
Output:  tied duplicate (FJ644291.1, AS:136) is gone entirely from the output ; no longer in the reference. 
```
NC_012671.1   AS:136   (perfect match, 0 mismatches)
NC_021069.1   AS:67    (XS, 9 mismatches — genuinely worse, so that's just a similar seq with less successful alignment)
```


#### compare SE and PE alignment rates: 
```bash
OUT=$ROOT/work/04_align/20260818_flaviLib_75x75_trueRef

echo -e "Sample\tSE_overall_pct\tPE_concordant_pct\tDrop_pct" > "$OUT/se_vs_pe_summary.tsv"

for LOG in "$OUT"/260807-*.SE.bowtie2.log; do
  BASE=$(basename "$LOG" .SE.bowtie2.log)
  PE_LOG="$OUT/${BASE}.PE.bowtie2.log"

  SE_PCT=$(grep "overall alignment rate" "$LOG" | grep -oP '[\d.]+(?=%)')
  PE_PCT=$(grep "overall alignment rate" "$PE_LOG" | grep -oP '[\d.]+(?=%)')

  DROP=$(python3 -c "print(f'{${SE_PCT} - ${PE_PCT}:.2f}')")

  echo -e "${BASE}\t${SE_PCT}\t${PE_PCT}\t${DROP}" >> "$OUT/se_vs_pe_summary.tsv"
done

column -t "$OUT/se_vs_pe_summary.tsv"
```
as expected, basically the same as with the old reference. 


#### fragment length distribution: 
```bash
FRAGDIST="$OUT/fragment_length_distributions.tsv"
echo -e "Sample\tTLEN" > "$FRAGDIST"

for BAM in "$OUT"/260807-*.PE.bam; do
  BASE=$(basename "$BAM" .PE.bam)
  samtools view -f 0x2 "$BAM" | awk -v s="$BASE" '$9 > 0 {print s"\t"$9}' >> "$FRAGDIST"
done

python3 - <<EOF
import statistics, collections

data = collections.defaultdict(list)
with open("$FRAGDIST") as f:
    next(f)
    for line in f:
        s, tlen = line.strip().split('\t')
        data[s].append(int(tlen))

for s, vals in sorted(data.items()):
    print(f"{s}\tn={len(vals)}\tmedian={statistics.median(vals):.0f}\tmean={statistics.mean(vals):.1f}\tmin={min(vals)}\tmax={max(vals)}")
EOF
```

R vs X median fragment length (237 vs ~120) is now validated against the corrected reference

# 05_fragments 
### make a new python script for paired end `--max-fraglen` allows for longest boundary based on alignment fragment lengths 
try with one sample first: 
```bash
ROOT=/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib
OUT=$ROOT/work/04_align/20260818_flaviLib_75x75_trueRef
FRAG=$ROOT/work/05_fragments/260807_trueRef
SCRIPTS=$ROOT/scripts
mkdir -p "$FRAG"

BAM="$OUT/260807-r0416-01-X-1-A3462.PE.bam"
BASE=$(basename "$BAM" .PE.bam)

python3 "$SCRIPTS/make_fragment_file_pe.py" "$BAM" \
    --max-fraglen 250 \
    > "$FRAG/${BASE}.csv" \
    2> "$FRAG/${BASE}.stats.txt"

cat "$FRAG/${BASE}.stats.txt"
echo "---"
head -5 "$FRAG/${BASE}.csv"
wc -l "$FRAG/${BASE}.csv"
```
output - 
```
 (n_total_proper_pairs=3801540)
  (n_bad_orientation_skipped=48286)
  (n_ambiguous_multimap=1682)
  (n_fraglen_over_250bp=496)
  (n_fragments_used=3751117)
  (n_unique_fragment_positions=645121)
---
accession       fiveprime       threeprime      count
AB018667.1|8866-9228_inferred_3UTR      50      223     1
AB018667.1|8866-9228_inferred_3UTR      61      240     1
AB018667.1|8866-9228_inferred_3UTR      62      243     1
AB018667.1|8866-9228_inferred_3UTR      64      242     1
```
there were about 50,000 reads with -tlen 75 that had read orientation problems..... 

Any R1 record with TLEN ≤ 0 was thrown out, (assumed a non-positive TLEN always meant a mis-oriented/broken pair).

The problem : one specific case — when R1 and its mate map to the exact same start coordinate, a tied start :  naturally occurs for short-to-medium fragments where R2's alignment start lands right on top of R1's.

In the tie, bowtie2's TLEN sign convention is ambiguous by spec, and it assigns R1 a negative value here, even though the read is a completely normal, correctly-placed fragment

update fragment script to allow this 

try again: 
```bash
BAM="$OUT/260807-r0416-01-X-1-A3462.PE.bam"
BASE=$(basename "$BAM" .PE.bam)

python3 "$SCRIPTS/make_fragment_file_pe_v2.py" "$BAM" \
    --max-fraglen 250 \
    > "$FRAG/${BASE}.csv" \
    2> "$FRAG/${BASE}.stats.txt"

cat "$FRAG/${BASE}.stats.txt"
echo "---"
head -5 "$FRAG/${BASE}.csv"
wc -l "$FRAG/${BASE}.csv"
```
## 05_fragments – Loop across all samples 
```bash
for BAM in "$OUT"/260807-*.PE.bam; do
    BASE=$(basename "$BAM" .PE.bam)
    echo "Fragmenting: $BASE"
    python3 "$SCRIPTS/make_fragment_file_pe_v2.py" "$BAM" \
        --max-fraglen 250 \
        > "$FRAG/${BASE}.csv" \
        2> "$FRAG/${BASE}.stats.txt"
done

# quick summary across all 16
for f in "$FRAG"/*.stats.txt; do
    BASE=$(basename "$f" .stats.txt)
    TOTAL=$(grep n_total_proper_pairs "$f" | grep -oP '\d+')
    RECOVERED=$(grep n_recovered_tied_start "$f" | grep -oP '\d+')
    PCT=$(python3 -c "print(f'{100*$RECOVERED/$TOTAL:.3f}')")
    echo -e "${BASE}\t${TOTAL}\t${RECOVERED}\t${PCT}%"
done
```

# 06_filter
## make a new updated BED file reflecting the reference: 
```bash
ROOT=/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib

TILE_FA="$ROOT/data/refseqs/library_mifsud_simmonds_EDIT_tile20_with_jeanine_new_genomes_20260225.dupsremoved.fa"
PRETILE_UID_FA="$ROOT/data/refseqs/pre_tile_refseqs/flavi_library_20260228pretile20260818_TRUEordered_uniqueIDs.fa"

TILED_BED="$ROOT/data/refseqs/library_mifsud_simmonds_EDIT_tile20_with_jeanine_new_genomes_20260225.dupsremoved.bed"
UID_BED="$ROOT/data/refseqs/library_mifsud_simmonds_EDIT_tile20_with_jeanine_new_genomes_20260225.dupsremoved.trueRef.uniqueIDs.bed"

# 1. build plain BED from tile headers (accession_start_end -> chrom, start, end, name)
grep '^>' "$TILE_FA" \
    | sed 's/^>//' \
    | awk '{
        if (match($1, /^(.+)_([0-9]+)_([0-9]+)$/, a))
            print a[1] "\t" a[2] "\t" a[3] "\t" $1
      }' \
    > "$TILED_BED"

wc -l "$TILED_BED"
cut -f1 "$TILED_BED" | sort -u | wc -l

# 2. remap column 1 to the uniqueIDs naming from the new pretile reference
python3 - <<EOF
plain_to_uid = {}
for line in open("$PRETILE_UID_FA"):
    if not line.startswith('>'): continue
    uid = line[1:].strip().split()[0]
    plain = uid.split('|')[0]
    plain_to_uid[plain] = uid

n_written = n_missing = 0
missing = set()
with open("$UID_BED", 'w') as out:
    for line in open("$TILED_BED"):
        f = line.strip().split('\t')
        uid = plain_to_uid.get(f[0])
        if uid is None:
            missing.add(f[0])
            n_missing += 1
            continue
        out.write(f"{uid}\t{f[1]}\t{f[2]}\t{uid}_{f[1]}_{f[2]}\n")
        n_written += 1

print(f"Written: {n_written}  Missing: {n_missing} from {len(missing)} accessions")
if missing:
    print(f"  Examples: {sorted(missing)[:10]}")
EOF

head -3 "$UID_BED"
wc -l "$UID_BED"
```
## run filter script 
### Aug 25, 2026 
# 06_filter: null calibration before filtering

Note updated **TILES** file to be used: 
`.bed` based on ordered library reference. 


```bash
ROOT=/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib
FRAG=$ROOT/work/05_fragments/260807_trueRef
TILES="$ROOT/data/refseqs/library_mifsud_simmonds_EDIT_tile20_with_jeanine_new_genomes_20260225.dupsremoved.trueRef.uniqueIDs.bed"
SCRIPTS=$ROOT/scripts
CALOUT=$ROOT/work/06_filter_v7_75x75/calibration
mkdir -p "$CALOUT"

replicates=(1 2 3 4)
mm=(10 01)

for m in "${mm[@]}"; do
  for r in "${replicates[@]}"; do
    X_CSV=$(ls "$FRAG"/260807-*-${m}-X-${r}-*.csv 2>/dev/null)
    if [ -z "$X_CSV" ]; then
      echo "Skipping ${m}mM rep${r} (no X file found)"
      continue
    fi
    echo "Calibrating: ${m}mM rep${r}  ($X_CSV)"
    python3 "$SCRIPTS/calibratePeakNull.py" \
        "$X_CSV" \
        "$TILES" \
        "$CALOUT/${m}mM_rep${r}_calibrate" \
        | tee "$CALOUT/${m}mM_rep${r}_calibrate.out.txt"
  done
done
```


## filter: post-null calibration, sf cutoff 0.3
```bash
ROOT=/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib
FRAG=$ROOT/work/05_fragments/260807_trueRef
TILES="$ROOT/data/refseqs/library_mifsud_simmonds_EDIT_tile20_with_jeanine_new_genomes_20260225.dupsremoved.trueRef.uniqueIDs.bed"
FILTER=$ROOT/work/06_filter_v7_75x75_final
SCRIPTS=$ROOT/scripts
mkdir -p "$FILTER/10mM" "$FILTER/01mM"

declare -A ALPHAS=(
  [10mM_1]=2.8230  [10mM_2]=2.7632  [10mM_3]=2.6135  [10mM_4]=2.4986
  [01mM_1]=2.1955  [01mM_2]=2.1214  [01mM_3]=2.2325  [01mM_4]=2.1296
)

for MG in 10 01; do
    OUTDIR="$FILTER/${MG}mM"
    for REP in 1 2 3 4; do
        X_CSV=$(ls "$FRAG"/260807-*-${MG}-X-${REP}-*.csv 2>/dev/null)
        R_CSV=$(ls "$FRAG"/260807-*-${MG}-R-${REP}-*.csv 2>/dev/null)
        [ -z "$X_CSV" ] || [ -z "$R_CSV" ] && { echo "Skipping ${MG}mM rep${REP}"; continue; }

        KEY="${MG}mM_${REP}"
        ALPHA="${ALPHAS[$KEY]}"
        echo "Peak calling: ${MG}mM rep${REP}  (alpha=$ALPHA)"

        python3 "$SCRIPTS/filterPeaks_normtoCTRL_v7.3.py" \
            "$X_CSV" "$R_CSV" "$TILES" \
            "$OUTDIR/rep${REP}_peaks.csv" \
            --out-accession-csv "$OUTDIR/rep${REP}_accessions.csv" \
            --out-gtf           "$OUTDIR/rep${REP}_peaks.gtf" \
            --min-sf-treated 0.3 \
            --null negbinom \
            --nb-alpha "$ALPHA"
    done
done
```
### Run **`combine_replicates.py`**
```bash
ROOT=/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib
FILTER=$ROOT/work/06_filter_v7_75x75_final
SCRIPTS=$ROOT/scripts

for MG in 10 01; do
    OUTDIR="$FILTER/${MG}mM"
    echo "Combining ${MG}mM across all 4 reps..."

    python3 "$SCRIPTS/combine_replicates.py" \
        "$OUTDIR/rep1_peaks.csv" "$OUTDIR/rep2_peaks.csv" \
        "$OUTDIR/rep3_peaks.csv" "$OUTDIR/rep4_peaks.csv" \
        --labels R1 R2 R3 R4 \
        --out "$OUTDIR/1234_peaks_combined_with_seqs.csv" \
        --fasta "$ROOT/data/refseqs/pre_tile_refseqs/flavi_library_20260228pretile20260818_TRUEordered_uniqueIDs.fa" \
        --upstream 0
done
```

output: 
```
/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib/work/06_filter_v7_75x75_final/01mM/1234_peaks_combined_with_seqs.csv
```

# 06_infernal
### `cmsearch` against ordered library: 

`cmsearch` runs once against the entire reference FASTA (all 439 accessions, full-length features), producing a `.tbl` of every CM hit anywhere in the library, independent of any peak calling

where `FA_FIX="$ROOT/data/refseqs/pre_tile_refseqs/flavi_library_20260228pretile20260818_TRUEordered_uniqueIDs.fa"`


```bash
ROOT=/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib
FA_FIX="$ROOT/data/refseqs/pre_tile_refseqs/flavi_library_20260228pretile20260818_TRUEordered_uniqueIDs.fa"
TBLOUT="$ROOT/work/06_infernal/260807_trueRef"
CMDIR="$ROOT/work/06_infernal/cm"
mkdir -p "$TBLOUT"

CMS=(
    "CL_Class_1a_xrRNA_final.cm"
    "CL_Class_1b_xrRNA_final.cm"
    "CL_Class_2_xrRNA_final.cm"
)

for CM in "${CMS[@]}"; do
    echo "Searching: $CM"
    cmsearch --tblout "$TBLOUT/${CM}.tbl" \
             --cpu 8 \
             "$CMDIR/$CM" "$FA_FIX"
    echo "Done: $CM"
done
```
how many hit lines in the library? 

```bash
ROOT=/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib
TBLOUT="$ROOT/work/06_infernal/260807_trueRef"

ls -la "$TBLOUT"
for f in "$TBLOUT"/*.tbl; do
    echo "$f: $(grep -vc '^#' "$f") hit lines"
done
```
```
/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib/work/06_infernal/260807_trueRef/CL_Class_1a_xrRNA_final.cm.tbl: 84 hit lines
/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib/work/06_infernal/260807_trueRef/CL_Class_1b_xrRNA_final.cm.tbl: 161 hit lines
/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib/work/06_infernal/260807_trueRef/CL_Class_2_xrRNA_final.cm.tbl: 53 hit lines
```
#### 298 CM hits, out of 439 accessions

## virus_stats coverage – double check unique accession count: 
```bash
python3 - <<'EOF'
import csv

all_accs = set(l.strip() for l in open('/tmp/tile20_unique_accessions.txt'))
stats_accs = set()
for r in csv.DictReader(open("/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib/data/virus_stats_flaviLib_20260602.csv")):
    stats_accs.add(r['accession'])

missing = all_accs - stats_accs
print(f"Library accessions: {len(all_accs)}")
print(f"Covered by virus_stats: {len(all_accs & stats_accs)}")
print(f"Missing from virus_stats: {len(missing)}")
if missing:
    print(sorted(missing)[:20])
EOF
```
Wrote 439 accessions

## `virus_stats.csv` (from RZ – *insert repo information here*)
```bash
ROOT=/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib
VIRUS_STATS="$ROOT/data/virus_stats_flaviLib_tiled_subset_20260826.csv"

file "$VIRUS_STATS"   # check if it still says CRLF
```
#### again, coverage check: 
```bash
VIRUS_STATS="/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib/data/virus_stats_flaviLib_tiled_subset_20260826.csv"

python3 - <<EOF
import csv
covered = set()
unannotated = 0
for r in csv.DictReader(open("$VIRUS_STATS")):
    covered.add(r['accession'])
    if r['family'] == 'Unannotated':
        unannotated += 1
print(f"Accessions covered: {len(covered)}")
print(f"Rows with Unannotated family: {unannotated}")
EOF
```
# 07_postproc 
### annotate with the `virus_stats.csv`; merge peak hits with CM hit data
```bash
ROOT=/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib
FILTER=$ROOT/work/06_filter_v7_75x75_final
ANNOUT=$ROOT/work/07_postproc/260807_trueRef_final
SCRIPTS=$ROOT/scripts
TBLOUT="$ROOT/work/06_infernal/260807_trueRef"
mkdir -p "$ANNOUT"

CMS=(
    "CL_Class_1a_xrRNA_final.cm"
    "CL_Class_1b_xrRNA_final.cm"
    "CL_Class_2_xrRNA_final.cm"
)
INFERNAL_ARGS=$(printf -- "--infernal-tbl $TBLOUT/%s.tbl " "${CMS[@]}")

for MG in 10 01; do
    OUTDIR="$FILTER/${MG}mM"
    echo "Annotating: ${MG}mM"
    python3 "$SCRIPTS/post_process_peaks.py" \
        "$OUTDIR/1234_peaks_combined_with_seqs.csv" \
        --out-raw       "$ANNOUT/${MG}mM_1234_peaks_annotated.csv" \
        --out-collapsed "$ANNOUT/${MG}mM_1234_peaks_per_accession.csv" \
        --family-csv    "$VIRUS_STATS" \
        $INFERNAL_ARGS
done
```
Note about the 0.3 sf cutoff: The 0.3 threshold is factored into how many replicates count as "passing" for each site, but every candidate site is still kept in the file, regardless of how many replicates passed.
- `filterPeaks_normtoCTRL_v7.3.py` `--min-sf-treated 0.3` ; set `peak_pass=False` on any individual replicate's peak with SF below 0.3 (that's G2, enforced per-rep).

I will manually filter the table to at least two replicates passing then save as an excel `.xlsx`.

# downstream analyses 

### fail reason distribution 
```bash
ROOT=/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib
FILTER=$ROOT/work/06_filter_v7_75x75_final

python3 - <<'EOF'
import pandas as pd

FILTER = "/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib/work/06_filter_v7_75x75_final"

for MG in ["10", "01"]:
    print(f"\n{'='*20} {MG}mM {'='*20}")

    acc_dfs = [pd.read_csv(f"{FILTER}/{MG}mM/rep{r}_accessions.csv") for r in [1,2,3,4]]
    for i, df in enumerate(acc_dfs, 1):
        df['rep'] = i

    all_acc = pd.concat(acc_dfs)

    # accessions that never pass in ANY of the 4 reps
    never_pass = all_acc.groupby('accession')['pass'].any()
    zero_accs = never_pass[~never_pass].index
    print(f"Accessions with zero passing reps: {len(zero_accs)} / {never_pass.shape[0]}")

    zero_df = all_acc[all_acc['accession'].isin(zero_accs)]

    # primary fail reason per row, tally across reps
    primary = zero_df['fail_reason'].str.split(';').str[0].str.replace(r'\(.*\)', '', regex=True)
    print("\nPrimary fail reason (across all rep-rows for zero-pass accessions):")
    print(primary.value_counts())

    # input coverage context
    print("\nMean tiles-with-reads per accession (coverage proxy):")
    print(zero_df.groupby('accession')['n_tiles_with_reads'].mean().describe())
EOF
```

check the higher read depth failures: 
### `zero_pass_accessions` summary 
```bash
python3 - <<'EOF'
import pandas as pd

FILTER = "/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib/work/06_filter_v7_75x75_final"
VIRUS_STATS = "/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib/data/virus_stats_flaviLib_tiled_subset_20260826.csv"
POSTPROC = "/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib/work/07_postproc/260807_trueRef_final"
OUT = f"{POSTPROC}/zero_pass_accessions_summary_v3.csv"

tax = pd.read_csv(VIRUS_STATS)
tax_map = tax.set_index('accession')[['family', 'genus', 'species']].to_dict('index')

rows = []
for MG in ["10", "01"]:
    acc_dfs = [pd.read_csv(f"{FILTER}/{MG}mM/rep{r}_accessions.csv") for r in [1,2,3,4]]
    for i, df in enumerate(acc_dfs, 1):
        df['rep'] = str(i)
    all_acc = pd.concat(acc_dfs)

    peaks_dfs = [pd.read_csv(f"{FILTER}/{MG}mM/rep{r}_peaks.csv") for r in [1,2,3,4]]
    for i, df in enumerate(peaks_dfs, 1):
        df['rep'] = str(i)
    all_peaks = pd.concat(peaks_dfs)

    never_pass = all_acc.groupby('accession')['pass'].any()
    zero_accs = set(never_pass[~never_pass].index)

    zero_peaks = all_peaks[all_peaks['accession'].isin(zero_accs)].copy()

    best_peak_idx = zero_peaks.groupby('accession')['tile_reads_control'].idxmax()
    best_peaks = zero_peaks.loc[best_peak_idx].copy()

    for _, r in best_peaks.iterrows():
        plain_acc = r['accession'].split('|')[0]
        taxo = tax_map.get(plain_acc, {})
        ctrl_reads = r['tile_reads_control']
        treat_reads = r['tile_reads_treated']
        tier = ("Underpowered (control <100)" if ctrl_reads < 100 else
                "Ambiguous (control 100-1000)" if ctrl_reads < 1000 else
                "Well-powered, real digestion (control >=1000)")
        rows.append({
            'condition': f"{MG}mM",
            'accession': r['accession'],
            'plain_accession': plain_acc,
            'best_tile_reads_control': int(ctrl_reads),
            'best_tile_reads_treated': int(treat_reads),
            'treated_to_control_ratio': round(treat_reads / ctrl_reads, 4) if ctrl_reads > 0 else None,
            'best_tile_treated_sf': round(r['treated_sf'], 4),
            'best_tile_control_sf': round(r['control_sf'], 4),
            'best_tile_stall_reads': int(r['stall_reads_treated']),
            'depth_tier': tier,
            'primary_fail_reason': (r['peak_fail_reason'].split(';')[0].split('(')[0]
                                     if pd.notna(r.get('peak_fail_reason')) else ''),
            'best_rep': r['rep'],
            'family': taxo.get('family', ''), 'genus': taxo.get('genus', ''), 'species': taxo.get('species', ''),
        })

    accs_with_peaks = set(zero_peaks['accession'])
    no_candidate = zero_accs - accs_with_peaks
    for acc in no_candidate:
        plain_acc = acc.split('|')[0]
        taxo = tax_map.get(plain_acc, {})
        rows.append({
            'condition': f"{MG}mM", 'accession': acc, 'plain_accession': plain_acc,
            'best_tile_reads_control': None, 'best_tile_reads_treated': None,
            'treated_to_control_ratio': None, 'best_tile_treated_sf': None, 'best_tile_control_sf': None,
            'best_tile_stall_reads': None, 'depth_tier': 'No candidate peak formed',
            'primary_fail_reason': 'no_peaks_above_min_adj_sf', 'best_rep': None,
            'family': taxo.get('family',''), 'genus': taxo.get('genus',''), 'species': taxo.get('species',''),
        })

out_df = pd.DataFrame(rows).sort_values(['condition', 'depth_tier', 'best_tile_reads_control'],
                                          ascending=[True, True, False])
out_df.to_csv(OUT, index=False)
print(f"Wrote {len(out_df)} rows -> {OUT}")
print(out_df.groupby(['condition','depth_tier']).size())
EOF
```



# postproc, incorporating dumbbell CM. 
```bash 
ROOT=/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib
FA_FIX="$ROOT/data/refseqs/pre_tile_refseqs/flavi_library_20260228pretile20260818_TRUEordered_uniqueIDs.fa"
TBLOUT="$ROOT/work/06_infernal/260807_trueRef"
CMDIR="$ROOT/work/06_infernal/cm"

cmsearch --tblout "$TBLOUT/dumbbell_RF00525.cm.tbl" \
         --cpu 8 \
         "$CMDIR/dumbbell_RF00525.cm" "$FA_FIX"
```

```bash
FILTER=$ROOT/work/06_filter_v7_75x75_final
ANNOUT=$ROOT/work/07_postproc/260807_trueRef_final
SCRIPTS=$ROOT/scripts
VIRUS_STATS="$ROOT/data/virus_stats_flaviLib_tiled_subset_20260826.csv"

CMS=(
    "CL_Class_1a_xrRNA_final.cm"
    "CL_Class_1b_xrRNA_final.cm"
    "CL_Class_2_xrRNA_final.cm"
    "dumbbell_RF00525.cm"
)
INFERNAL_ARGS=$(printf -- "--infernal-tbl $TBLOUT/%s.tbl " "${CMS[@]}")

for MG in 10 01; do
    OUTDIR="$FILTER/${MG}mM"
    python3 "$SCRIPTS/post_process_peaks.py" \
        "$OUTDIR/1234_peaks_combined_with_seqs.csv" \
        --out-raw       "$ANNOUT/${MG}mM_1234_peaks_annotated.csv" \
        --out-collapsed "$ANNOUT/${MG}mM_1234_peaks_per_accession.csv" \
        --family-csv    "$VIRUS_STATS" \
        $INFERNAL_ARGS
done
```

## local analysis in R
download `"*_1234_peaks_annotated.csv"` to local `~/Desktop/virome/figures/flaviLib/inputs`

use .Rmd - `~/Desktop/virome/figures/flaviLib/cm_class_distribution_75x75.Rmd` (also now saved under /groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib/plots/flaviLib)

TODO:
1. clustering 
2. phylogeny RdRp of represented accessions 
3. phylogeny (tanglegram) with xrRNA or 3UTR relatedness. 

----------
# analysis of the same samples resequenced, 150x150, on Sep 3, 2026
----------
### Sep 3, 2026

#### refer to metadata sheet in `data/metadata`
#### also a README file in `/groups/as6282_gp/data_bkup/jgg2144/20260903_Aviti_150x150_flaviLib-DMS/` describing file transfer from `manifest.tsv` for Aviti Run. 

```bash
srun --pty -t 06:00:00 -c 4 --mem=16G \
    --chdir=/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib \
    /bin/bash -l

conda activate viromelib

```
# 01_raw
```bash
SRC=/groups/as6282_gp/data_bkup/jgg2144/20260903_Aviti_150x150_flaviLib-DMS/ngs_data/Element_Biosciences_Aviti/AV100007/20260829_AV100007_082926_Sternberg_Aviti/083126_Bases2FastQ/Samples
VIROMERAW=/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib/work/01_raw
DMSRAW=/groups/as6282_gp/scratch_bkup/jgg2144/xrRNASHAPE/DMS/work/01_raw

mkdir -p "$VIROMERAW" "$DMSRAW"

ln -s ${SRC}/A3413/A3413_R1.fastq.gz $VIROMERAW/260903-r0441-10-R-3-A3413_R1.fastq.gz
ln -s ${SRC}/A3413/A3413_R2.fastq.gz $VIROMERAW/260903-r0441-10-R-3-A3413_R2.fastq.gz
ln -s ${SRC}/A3429/A3429_R1.fastq.gz $VIROMERAW/260903-r0441-10-X-3-A3429_R1.fastq.gz
ln -s ${SRC}/A3429/A3429_R2.fastq.gz $VIROMERAW/260903-r0441-10-X-3-A3429_R2.fastq.gz
ln -s ${SRC}/A3419/A3419_R1.fastq.gz $VIROMERAW/260903-r0441-10-R-4-A3419_R1.fastq.gz
ln -s ${SRC}/A3419/A3419_R2.fastq.gz $VIROMERAW/260903-r0441-10-R-4-A3419_R2.fastq.gz
ln -s ${SRC}/A3499/A3499_R1.fastq.gz $VIROMERAW/260903-r0441-10-X-4-A3499_R1.fastq.gz
ln -s ${SRC}/A3499/A3499_R2.fastq.gz $VIROMERAW/260903-r0441-10-X-4-A3499_R2.fastq.gz
ln -s ${SRC}/A3485/A3485_R1.fastq.gz $VIROMERAW/260903-r0441-01-R-3-A3485_R1.fastq.gz
ln -s ${SRC}/A3485/A3485_R2.fastq.gz $VIROMERAW/260903-r0441-01-R-3-A3485_R2.fastq.gz
ln -s ${SRC}/A3484/A3484_R1.fastq.gz $VIROMERAW/260903-r0441-01-X-3-A3484_R1.fastq.gz
ln -s ${SRC}/A3484/A3484_R2.fastq.gz $VIROMERAW/260903-r0441-01-X-3-A3484_R2.fastq.gz
ln -s ${SRC}/A3483/A3483_R1.fastq.gz $VIROMERAW/260903-r0441-01-R-4-A3483_R1.fastq.gz
ln -s ${SRC}/A3483/A3483_R2.fastq.gz $VIROMERAW/260903-r0441-01-R-4-A3483_R2.fastq.gz
ln -s ${SRC}/A3466/A3466_R1.fastq.gz $VIROMERAW/260903-r0441-01-X-4-A3466_R1.fastq.gz
ln -s ${SRC}/A3466/A3466_R2.fastq.gz $VIROMERAW/260903-r0441-01-X-4-A3466_R2.fastq.gz
ln -s ${SRC}/A3498/A3498_R1.fastq.gz $VIROMERAW/260903-r0416-10-R-1-A3498_R1.fastq.gz
ln -s ${SRC}/A3498/A3498_R2.fastq.gz $VIROMERAW/260903-r0416-10-R-1-A3498_R2.fastq.gz
ln -s ${SRC}/A3479/A3479_R1.fastq.gz $VIROMERAW/260903-r0416-10-X-1-A3479_R1.fastq.gz
ln -s ${SRC}/A3479/A3479_R2.fastq.gz $VIROMERAW/260903-r0416-10-X-1-A3479_R2.fastq.gz
ln -s ${SRC}/A3478/A3478_R1.fastq.gz $VIROMERAW/260903-r0416-10-R-2-A3478_R1.fastq.gz
ln -s ${SRC}/A3478/A3478_R2.fastq.gz $VIROMERAW/260903-r0416-10-R-2-A3478_R2.fastq.gz
ln -s ${SRC}/A3476/A3476_R1.fastq.gz $VIROMERAW/260903-r0416-10-X-2-A3476_R1.fastq.gz
ln -s ${SRC}/A3476/A3476_R2.fastq.gz $VIROMERAW/260903-r0416-10-X-2-A3476_R2.fastq.gz
ln -s ${SRC}/A3467/A3467_R1.fastq.gz $VIROMERAW/260903-r0416-01-R-1-A3467_R1.fastq.gz
ln -s ${SRC}/A3467/A3467_R2.fastq.gz $VIROMERAW/260903-r0416-01-R-1-A3467_R2.fastq.gz
ln -s ${SRC}/A3462/A3462_R1.fastq.gz $VIROMERAW/260903-r0416-01-X-1-A3462_R1.fastq.gz
ln -s ${SRC}/A3462/A3462_R2.fastq.gz $VIROMERAW/260903-r0416-01-X-1-A3462_R2.fastq.gz
ln -s ${SRC}/A3434/A3434_R1.fastq.gz $VIROMERAW/260903-r0416-01-R-2-A3434_R1.fastq.gz
ln -s ${SRC}/A3434/A3434_R2.fastq.gz $VIROMERAW/260903-r0416-01-R-2-A3434_R2.fastq.gz
ln -s ${SRC}/A3427/A3427_R1.fastq.gz $VIROMERAW/260903-r0416-01-X-2-A3427_R1.fastq.gz
ln -s ${SRC}/A3427/A3427_R2.fastq.gz $VIROMERAW/260903-r0416-01-X-2-A3427_R2.fastq.gz
ln -s ${SRC}/A3422/A3422_R1.fastq.gz $DMSRAW/260903-r0328-c-02-A3422_R1.fastq.gz
ln -s ${SRC}/A3422/A3422_R2.fastq.gz $DMSRAW/260903-r0328-c-02-A3422_R2.fastq.gz
ln -s ${SRC}/A3464/A3464_R1.fastq.gz $DMSRAW/260903-r0328-c-03-A3464_R1.fastq.gz
ln -s ${SRC}/A3464/A3464_R2.fastq.gz $DMSRAW/260903-r0328-c-03-A3464_R2.fastq.gz
ln -s ${SRC}/A3494/A3494_R1.fastq.gz $DMSRAW/260903-r0328-m-01-A3494_R1.fastq.gz
ln -s ${SRC}/A3494/A3494_R2.fastq.gz $DMSRAW/260903-r0328-m-01-A3494_R2.fastq.gz
ln -s ${SRC}/A3465/A3465_R1.fastq.gz $DMSRAW/260903-r0328-m-02-A3465_R1.fastq.gz
ln -s ${SRC}/A3465/A3465_R2.fastq.gz $DMSRAW/260903-r0328-m-02-A3465_R2.fastq.gz
ln -s ${SRC}/A3442/A3442_R1.fastq.gz $DMSRAW/260903-r0328-m-03-A3442_R1.fastq.gz
ln -s ${SRC}/A3442/A3442_R2.fastq.gz $DMSRAW/260903-r0328-m-03-A3442_R2.fastq.gz
ln -s ${SRC}/A3513/A3513_R1.fastq.gz $DMSRAW/260903-r0427-c-01-A3513_R1.fastq.gz
ln -s ${SRC}/A3513/A3513_R2.fastq.gz $DMSRAW/260903-r0427-c-01-A3513_R2.fastq.gz
ln -s ${SRC}/A3458/A3458_R1.fastq.gz $DMSRAW/260903-r0427-c-02-A3458_R1.fastq.gz
ln -s ${SRC}/A3458/A3458_R2.fastq.gz $DMSRAW/260903-r0427-c-02-A3458_R2.fastq.gz
ln -s ${SRC}/A3432/A3432_R1.fastq.gz $DMSRAW/260903-r0427-c-03-A3432_R1.fastq.gz
ln -s ${SRC}/A3432/A3432_R2.fastq.gz $DMSRAW/260903-r0427-c-03-A3432_R2.fastq.gz
ln -s ${SRC}/A3424/A3424_R1.fastq.gz $DMSRAW/260903-r0427-m-01-A3424_R1.fastq.gz
ln -s ${SRC}/A3424/A3424_R2.fastq.gz $DMSRAW/260903-r0427-m-01-A3424_R2.fastq.gz
ln -s ${SRC}/A3415/A3415_R1.fastq.gz $DMSRAW/260903-r0427-m-02-A3415_R1.fastq.gz
ln -s ${SRC}/A3415/A3415_R2.fastq.gz $DMSRAW/260903-r0427-m-02-A3415_R2.fastq.gz
ln -s ${SRC}/A3414/A3414_R1.fastq.gz $DMSRAW/260903-r0427-m-03-A3414_R1.fastq.gz
ln -s ${SRC}/A3414/A3414_R2.fastq.gz $DMSRAW/260903-r0427-m-03-A3414_R2.fastq.gz
ln -s ${SRC}/A3472/A3472_R1.fastq.gz $DMSRAW/260903-r0367-c-01-A3472_R1.fastq.gz
ln -s ${SRC}/A3472/A3472_R2.fastq.gz $DMSRAW/260903-r0367-c-01-A3472_R2.fastq.gz
ln -s ${SRC}/A3469/A3469_R1.fastq.gz $DMSRAW/260903-r0367-c-02-A3469_R1.fastq.gz
ln -s ${SRC}/A3469/A3469_R2.fastq.gz $DMSRAW/260903-r0367-c-02-A3469_R2.fastq.gz
ln -s ${SRC}/A3468/A3468_R1.fastq.gz $DMSRAW/260903-r0367-c-03-A3468_R1.fastq.gz
ln -s ${SRC}/A3468/A3468_R2.fastq.gz $DMSRAW/260903-r0367-c-03-A3468_R2.fastq.gz
ln -s ${SRC}/A3457/A3457_R1.fastq.gz $DMSRAW/260903-r0367-m-01-A3457_R1.fastq.gz
ln -s ${SRC}/A3457/A3457_R2.fastq.gz $DMSRAW/260903-r0367-m-01-A3457_R2.fastq.gz
ln -s ${SRC}/A3455/A3455_R1.fastq.gz $DMSRAW/260903-r0367-m-02-A3455_R1.fastq.gz
ln -s ${SRC}/A3455/A3455_R2.fastq.gz $DMSRAW/260903-r0367-m-02-A3455_R2.fastq.gz
ln -s ${SRC}/A3453/A3453_R1.fastq.gz $DMSRAW/260903-r0367-m-03-A3453_R1.fastq.gz
ln -s ${SRC}/A3453/A3453_R2.fastq.gz $DMSRAW/260903-r0367-m-03-A3453_R2.fastq.gz
```
**Note that** New sequencing data is 150x150, so reads are twice as long, and while the trimming/classification steps (LEAD5, END3 cutadapt logic) will still apply conceptually, things like -X 250, expected TLEN ranges, and maybe the -m 20 minimum-length filter after trimming will need to be reconsidered. 

```bash
ROOT=/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib
RAW="$ROOT/work/01_raw"
cd "$RAW"
```
Look at reads: 
```bash
cd "$RAW"

for SAMPLE in A3413 A3429; do
  R1=$(ls 260903-*-${SAMPLE}_R1.fastq.gz)
  R2=$(ls 260903-*-${SAMPLE}_R2.fastq.gz)

  echo "=== $SAMPLE ($R1) ==="

  echo "--- R1, first 10 reads, first 30bp ---"
  zcat "$R1" | head -40 | awk 'NR%4==2' | cut -c1-30

  echo "--- R1, first 10 reads, last 30bp ---"
  zcat "$R1" | head -40 | awk 'NR%4==2' | rev | cut -c1-30 | rev

  echo "--- R2, first 10 reads, first 30bp ---"
  zcat "$R2" | head -40 | awk 'NR%4==2' | cut -c1-30

  echo "--- R2, first 10 reads, last 30bp ---"
  zcat "$R2" | head -40 | awk 'NR%4==2' | rev | cut -c1-30 | rev

  echo
done
```

### get read info on samples with seqkit 
```bash
cd "$RAW"

seqkit stats -T 260903-*_R1.fastq.gz 260903-*_R2.fastq.gz > read_counts_R1R2.tsv

python3 - <<'EOF'
import csv
from collections import defaultdict

rows = defaultdict(dict)
with open('read_counts_R1R2.tsv') as f:
    reader = csv.DictReader(f, delimiter='\t')
    for row in reader:
        fname = row['file']
        sample = fname.split('_R')[0]
        mate = 'R1' if '_R1.' in fname else 'R2'
        rows[sample][mate] = int(row['num_seqs'])

print(f"{'sample':<35}{'R1_reads':>12}{'R2_reads':>12}{'match':>8}")
for sample, d in sorted(rows.items()):
    r1 = d.get('R1', '?')
    r2 = d.get('R2', '?')
    match = 'OK' if r1 == r2 else 'MISMATCH'
    print(f"{sample:<35}{r1:>12}{r2:>12}{match:>8}")
EOF
```

```
processed files:  32 / 32 [======================================] ETA: 0s. done
sample                                 R1_reads    R2_reads   match
260903-r0416-01-R-1-A3467              10753729    10753729      OK
260903-r0416-01-R-2-A3434              10910685    10910685      OK
260903-r0416-01-X-1-A3462              11976510    11976510      OK
260903-r0416-01-X-2-A3427              13039757    13039757      OK
260903-r0416-10-R-1-A3498               8631298     8631298      OK
260903-r0416-10-R-2-A3478              10453873    10453873      OK
260903-r0416-10-X-1-A3479              12616754    12616754      OK
260903-r0416-10-X-2-A3476              12842885    12842885      OK
260903-r0441-01-R-3-A3485               9831111     9831111      OK
260903-r0441-01-R-4-A3483              10524570    10524570      OK
260903-r0441-01-X-3-A3484               9556650     9556650      OK
260903-r0441-01-X-4-A3466               9545797     9545797      OK
260903-r0441-10-R-3-A3413               8967396     8967396      OK
260903-r0441-10-R-4-A3419               7324374     7324374      OK
260903-r0441-10-X-3-A3429              10428087    10428087      OK
260903-r0441-10-X-4-A3499              10104584    10104584      OK 
```

every R1/R2 pair matches exactly, so no truncated downloads or corrupted files. 

depth spread - samples range from ~7.3M to ~13.0M read pairs, roughly a 1.8x spread across the set

# 02_trim 
```bash
ROOT=/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib
RAW=$ROOT/work/01_raw
TRIM=$ROOT/work/02_trim
LOGS=$TRIM/logs

mkdir -p "$TRIM" "$LOGS"

LEAD5=GGATTAATATAAT
END3=AAAGAAACAACAACAACAAC
LEAD5_RC=ATTATATTAATCC
END3_RC=GTTGTTGTTGTTGTTTCTTT
PLATFORM_ADAPTER=AGATCGGAAGAGC

cd "$TRIM"

for R1 in "$RAW"/260903-*_R1.fastq.gz; do
  R2=${R1/_R1.fastq.gz/_R2.fastq.gz}
  BASENAME=$(basename "$R1" _R1.fastq.gz)

  echo "=== $BASENAME ==="

  # --- Step 1: paired trim ---
  # R1: trim END3 + anything after (adapter readthrough)
  # R2: trim LEAD5_RC or PLATFORM_ADAPTER + anything after
  cutadapt -j 8 \
    -a "$END3" \
    -A "$LEAD5_RC" -A "$PLATFORM_ADAPTER" \
    -m 20 \
    --pair-filter=any \
    -o "$TRIM/${BASENAME}_R1.insert.fastq.gz" \
    -p "$TRIM/${BASENAME}_R2.insert.fastq.gz" \
    "$R1" "$R2" \
    > "$LOGS/${BASENAME}.cutadapt.paired.txt"

  # --- Step 2a: classify R1 by 5' leader presence ---
  cutadapt -j 8 \
    -g "$LEAD5" \
    -e 0.12 \
    --action=none \
    -o "$TRIM/${BASENAME}_R1.insert.HASLEAD.fastq.gz" \
    --untrimmed-output "$TRIM/${BASENAME}_R1.insert.NOLEAD.fastq.gz" \
    "$TRIM/${BASENAME}_R1.insert.fastq.gz" \
    > "$LOGS/${BASENAME}.R1_split_by_leader.txt"

  # --- Step 2b: classify R2 by 5' END3_RC presence (QC sanity check, both conditions) ---
  cutadapt -j 8 \
    -g "$END3_RC" \
    -e 0.12 \
    --action=none \
    -o "$TRIM/${BASENAME}_R2.insert.HASEND3.fastq.gz" \
    --untrimmed-output "$TRIM/${BASENAME}_R2.insert.NOEND3.fastq.gz" \
    "$TRIM/${BASENAME}_R2.insert.fastq.gz" \
    > "$LOGS/${BASENAME}.R2_split_by_end3.txt"

  echo "Finished: $BASENAME"
done
```
inspect:
```bash
for f in "$LOGS"/*.cutadapt.paired.txt; do
  BASE=$(basename "$f" .cutadapt.paired.txt)
  PASS=$(grep "Pairs written" "$f")
  echo -e "$BASE\t$PASS"
done | column -t -s$'\t'
```

interestingly sample retention is higher for the 150x150 (this set of) reads, can investigate in logs. 


# 03_qc
```bash
ROOT=/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib
TRIM=$ROOT/work/02_trim
QC=$ROOT/work/03_qc/260903
mkdir -p "$QC"

fastqc -t 8 -o "$QC" "$TRIM"/260903-*.insert.fastq.gz

multiqc -o "$QC" "$QC"
```

# 04_align
```bash
ROOT=/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib
IDX="$ROOT/data/refseqs/pre_tile_refseqs/index/flavi_library_20260228pretile20260818_TRUEordered_uniqueIDs"
TRIM=$ROOT/work/02_trim
OUT=$ROOT/work/04_align/20260903_flaviLib_150x150_trueRef
mkdir -p "$OUT"

export TMPDIR="/localscratch/$USER/${SLURM_JOB_ID:-manual}"
mkdir -p "$TMPDIR"

for R1 in "$TRIM"/260903-*_R1.insert.fastq.gz; do
  R2=${R1/_R1.insert.fastq.gz/_R2.insert.fastq.gz}
  BASE=$(basename "$R1" _R1.insert.fastq.gz)

  echo "=== $BASE ==="

  # --- SE: R1 only, no pairing constraint ---
  bowtie2 --very-sensitive-local -k 1 -p 8 \
    -x "$IDX" -U "$R1" \
    2> "$OUT/${BASE}.SE.bowtie2.log" \
  | samtools view -b -q 0 -o "$OUT/${BASE}.SE.unsorted.bam" -
  samtools sort -@ 4 -m 2G -T "$TMPDIR/${BASE}.SE.sort" \
    -o "$OUT/${BASE}.SE.bam" "$OUT/${BASE}.SE.unsorted.bam"
  samtools index "$OUT/${BASE}.SE.bam"
  rm "$OUT/${BASE}.SE.unsorted.bam"

  # --- PE: R1+R2, forced pairing ---
  bowtie2 --very-sensitive-local -k 1 -p 8 \
    -x "$IDX" -1 "$R1" -2 "$R2" \
    --no-mixed --no-discordant \
    -X 250 \
    2> "$OUT/${BASE}.PE.bowtie2.log" \
  | samtools view -b -q 0 -o "$OUT/${BASE}.PE.unsorted.bam" -
  samtools sort -@ 4 -m 2G -T "$TMPDIR/${BASE}.PE.sort" \
    -o "$OUT/${BASE}.PE.bam" "$OUT/${BASE}.PE.unsorted.bam"
  samtools index "$OUT/${BASE}.PE.bam"
  rm "$OUT/${BASE}.PE.unsorted.bam"

  echo "Done: $BASE"
done
```
# 05_fragments 
### check TLEN 

try script version: 
```bash
cat > /tmp/extract_tlen.sh << 'SCRIPTEOF'
#!/usr/bin/env bash
set -x
ROOT=/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib
OUT=$ROOT/work/04_align/20260903_flaviLib_150x150_trueRef
FRAG=$ROOT/work/05_fragments/260903_trueRef
mkdir -p "$FRAG"

for BAM in "$OUT"/260903-*.PE.bam; do
  BASE=$(basename "$BAM" .PE.bam)
  samtools view -@ 4 -f 0x2 "$BAM" | awk -v s="$BASE" '$9 > 0 {print s"\t"$9}' > "$FRAG/${BASE}.tlen.tsv" &
done
wait

echo "=== checking output files ==="
ls -la "$FRAG"/*.tlen.tsv
SCRIPTEOF

bash /tmp/extract_tlen.sh
```

concatenate: 
```bash
FRAG=/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib/work/05_fragments/260903_trueRef

{ echo -e "Sample\tTLEN"; cat "$FRAG"/260903-*.tlen.tsv; } > "$FRAG/fragment_length_distributions.tsv"

# verify before deleting the per-sample files
tail -c 1 "$FRAG/fragment_length_distributions.tsv" | xxd    # should show 0a
cut -f1 "$FRAG/fragment_length_distributions.tsv" | tail -n +2 | uniq -c    # 16 samples, all with large counts
```
#### clean up old files, summarize TLEN: 
```bash
rm "$FRAG"/260903-*.tlen.tsv
```
```bash
cat > /tmp/summarize_tlen.py << 'PYEOF'
import statistics, collections, sys

fragdist = sys.argv[1]
data = collections.defaultdict(list)
with open(fragdist) as f:
    next(f)
    for line in f:
        s, tlen = line.strip().split('\t')
        data[s].append(int(tlen))

for s, vals in sorted(data.items()):
    print(f"{s}\tn={len(vals)}\tmedian={statistics.median(vals):.0f}\tmean={statistics.mean(vals):.1f}\tmin={min(vals)}\tmax={max(vals)}")
PYEOF

python3 /tmp/summarize_tlen.py "$FRAG/fragment_length_distributions.tsv"
```
```
260903-r0416-01-R-1-A3467       n=10689093      median=237      mean=231.0      min=48  max=433
260903-r0416-01-R-2-A3434       n=10837151      median=237      mean=230.8      min=46  max=413
260903-r0416-01-X-1-A3462       n=11144763      median=124      mean=130.5      min=42  max=412
260903-r0416-01-X-2-A3427       n=12129687      median=124      mean=130.0      min=42  max=393
260903-r0416-10-R-1-A3498       n=8588074       median=237      mean=232.4      min=49  max=416
260903-r0416-10-R-2-A3478       n=10401413      median=237      mean=231.9      min=43  max=395
260903-r0416-10-X-1-A3479       n=11862538      median=128      mean=132.3      min=44  max=392
260903-r0416-10-X-2-A3476       n=12162500      median=128      mean=132.1      min=45  max=386
260903-r0441-01-R-3-A3485       n=9777665       median=237      mean=228.6      min=47  max=394
260903-r0441-01-R-4-A3483       n=10472823      median=237      mean=229.4      min=45  max=453
260903-r0441-01-X-3-A3484       n=8656266       median=116      mean=122.0      min=44  max=397
260903-r0441-01-X-4-A3466       n=8705252       median=118      mean=123.2      min=42  max=391
260903-r0441-10-R-3-A3413       n=8892713       median=237      mean=225.3      min=46  max=391
260903-r0441-10-R-4-A3419       n=7272233       median=237      mean=225.9      min=49  max=398
260903-r0441-10-X-3-A3429       n=9515806       median=117      mean=122.3      min=43  max=429
260903-r0441-10-X-4-A3499       n=9236530       median=118      mean=123.1      min=42  max=391
```
### make a new fragment file: 
```bash
ROOT=/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib
OUT=$ROOT/work/04_align/20260903_flaviLib_150x150_trueRef
FRAG=$ROOT/work/05_fragments/260903_trueRef
SCRIPTS=$ROOT/scripts
mkdir -p "$FRAG"

for BAM in "$OUT"/260903-*.PE.bam; do
    BASE=$(basename "$BAM" .PE.bam)
    echo "Fragmenting: $BASE"
    python3 "$SCRIPTS/make_fragment_file_pe_v2.py" "$BAM" \
        --max-fraglen 250 \
        > "$FRAG/${BASE}.csv" \
        2> "$FRAG/${BASE}.stats.txt"
done

# quick summary across all 16
for f in "$FRAG"/*.stats.txt; do
    BASE=$(basename "$f" .stats.txt)
    TOTAL=$(grep n_total_proper_pairs "$f" | grep -oP '\d+')
    RECOVERED=$(grep n_recovered_tied_start "$f" | grep -oP '\d+')
    PCT=$(python3 -c "print(f'{100*$RECOVERED/$TOTAL:.3f}')")
    echo -e "${BASE}\t${TOTAL}\t${RECOVERED}\t${PCT}%"
done
```
```
260903-r0416-01-R-1-A3467       10689093        6034    0.056%
260903-r0416-01-R-2-A3434       10837151        6168    0.057%
260903-r0416-01-X-1-A3462       11144763        168723  1.514%
260903-r0416-01-X-2-A3427       12129687        207395  1.710%
260903-r0416-10-R-1-A3498       8588074 3268    0.038%
260903-r0416-10-R-2-A3478       10401413        4823    0.046%
260903-r0416-10-X-1-A3479       11862538        189512  1.598%
260903-r0416-10-X-2-A3476       12162500        197511  1.624%
260903-r0441-01-R-3-A3485       9777665 10618   0.109%
260903-r0441-01-R-4-A3483       10472823        10253   0.098%
260903-r0441-01-X-3-A3484       8656266 172860  1.997%
260903-r0441-01-X-4-A3466       8705252 187175  2.150%
260903-r0441-10-R-3-A3413       8892713 14992   0.169%
260903-r0441-10-R-4-A3419       7272233 12943   0.178%
260903-r0441-10-X-3-A3429       9515806 181066  1.903%
260903-r0441-10-X-4-A3499       9236530 168305  1.822%
```
### null calibration 
```bash
ROOT=/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib
FRAG=$ROOT/work/05_fragments/260903_trueRef
TILES="$ROOT/data/refseqs/library_mifsud_simmonds_EDIT_tile20_with_jeanine_new_genomes_20260225.dupsremoved.trueRef.uniqueIDs.bed"
SCRIPTS=$ROOT/scripts
CALOUT=$ROOT/work/06_filter_v7_150x150/calibration
mkdir -p "$CALOUT"

replicates=(1 2 3 4)
mm=(10 01)

for m in "${mm[@]}"; do
  for r in "${replicates[@]}"; do
    X_CSV=$(ls "$FRAG"/260903-*-${m}-X-${r}-*.csv 2>/dev/null)
    if [ -z "$X_CSV" ]; then
      echo "Skipping ${m}mM rep${r} (no X file found)"
      continue
    fi
    echo "Calibrating: ${m}mM rep${r}  ($X_CSV)"
    python3 "$SCRIPTS/calibratePeakNull.py" \
        "$X_CSV" \
        "$TILES" \
        "$CALOUT/${m}mM_rep${r}_calibrate" \
        | tee "$CALOUT/${m}mM_rep${r}_calibrate.out.txt"
  done
done
```

pull the alpha values to apply for filtering: 
```bash
for f in "$CALOUT"/*_calibrate_summary.txt; do
  BASE=$(basename "$f" _calibrate_summary.txt)
  ALPHA=$(grep "α̂ (variance" "$f" | grep -oP '[\d.]+(?=$)' | head -1)
  VERDICT=$(grep "Primary   (" "$f")
  echo -e "$BASE\talpha=$ALPHA\t$VERDICT"
done
```
output: 
```
01mM_rep1      alpha=2.252       Primary   ( negbinom):  PASS — Negative Binomial null is well calibrated. Use this null for p-values.
01mM_rep2       alpha=2.205       Primary   ( negbinom):  PASS — Negative Binomial null is well calibrated. Use this null for p-values.
01mM_rep3       alpha=2.355       Primary   ( negbinom):  PASS — Negative Binomial null is well calibrated. Use this null for p-values.
01mM_rep4       alpha=2.29        Primary   ( negbinom):  PASS — Negative Binomial null is well calibrated. Use this null for p-values.
10mM_rep1       alpha=2.601       Primary   ( negbinom):  PASS — Negative Binomial null is well calibrated. Use this null for p-values.
10mM_rep2       alpha=2.56        Primary   ( negbinom):  PASS — Negative Binomial null is well calibrated. Use this null for p-values.
10mM_rep3       alpha=2.591       Primary   ( negbinom):  PASS — Negative Binomial null is well calibrated. Use this null for p-values.
10mM_rep4       alpha=2.533       Primary   ( negbinom):  PASS — Negative Binomial null is well calibrated. Use this null for p-values.
```
# 06_filter_v7_150x150
## peak calling 
```bash
ROOT=/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib
FRAG=$ROOT/work/05_fragments/260903_trueRef
TILES="$ROOT/data/refseqs/library_mifsud_simmonds_EDIT_tile20_with_jeanine_new_genomes_20260225.dupsremoved.trueRef.uniqueIDs.bed"
FILTER=$ROOT/work/06_filter_v7_150x150_final
SCRIPTS=$ROOT/scripts
mkdir -p "$FILTER/10mM" "$FILTER/01mM"

declare -A ALPHAS=(
  [10mM_1]=2.601  [10mM_2]=2.56   [10mM_3]=2.591  [10mM_4]=2.533
  [01mM_1]=2.252  [01mM_2]=2.205  [01mM_3]=2.355  [01mM_4]=2.29
)

for MG in 10 01; do
    OUTDIR="$FILTER/${MG}mM"
    for REP in 1 2 3 4; do
        X_CSV=$(ls "$FRAG"/260903-*-${MG}-X-${REP}-*.csv 2>/dev/null)
        R_CSV=$(ls "$FRAG"/260903-*-${MG}-R-${REP}-*.csv 2>/dev/null)
        [ -z "$X_CSV" ] || [ -z "$R_CSV" ] && { echo "Skipping ${MG}mM rep${REP}"; continue; }

        KEY="${MG}mM_${REP}"
        ALPHA="${ALPHAS[$KEY]}"
        echo "Peak calling: ${MG}mM rep${REP}  (alpha=$ALPHA)"

        python3 "$SCRIPTS/filterPeaks_normtoCTRL_v7.3.py" \
            "$X_CSV" "$R_CSV" "$TILES" \
            "$OUTDIR/rep${REP}_peaks.csv" \
            --out-accession-csv "$OUTDIR/rep${REP}_accessions.csv" \
            --out-gtf           "$OUTDIR/rep${REP}_peaks.gtf" \
            --min-sf-treated 0.3 \
            --null negbinom \
            --nb-alpha "$ALPHA"
    done
done
```

### combine replicates 
```bash
FILTER=$ROOT/work/06_filter_v7_150x150_final

for MG in 10 01; do
    OUTDIR="$FILTER/${MG}mM"
    echo "Combining ${MG}mM across all 4 reps..."

    python3 "$SCRIPTS/combine_replicates.py" \
        "$OUTDIR/rep1_peaks.csv" "$OUTDIR/rep2_peaks.csv" \
        "$OUTDIR/rep3_peaks.csv" "$OUTDIR/rep4_peaks.csv" \
        --labels R1 R2 R3 R4 \
        --out "$OUTDIR/1234_peaks_combined_with_seqs.csv" \
        --fasta "$ROOT/data/refseqs/pre_tile_refseqs/flavi_library_20260228pretile20260818_TRUEordered_uniqueIDs.fa" \
        --upstream 0
done
```

check fail reasons: 
```bash
ROOT=/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib
FILTER=$ROOT/work/06_filter_v7_150x150_final

python3 - <<'EOF'
import pandas as pd

FILTER = "/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib/work/06_filter_v7_150x150_final"

for MG in ["10", "01"]:
    print(f"\n{'='*20} {MG}mM {'='*20}")

    acc_dfs = [pd.read_csv(f"{FILTER}/{MG}mM/rep{r}_accessions.csv") for r in [1,2,3,4]]
    for i, df in enumerate(acc_dfs, 1):
        df['rep'] = i

    all_acc = pd.concat(acc_dfs)

    # accessions that never pass in ANY of the 4 reps
    never_pass = all_acc.groupby('accession')['pass'].any()
    zero_accs = never_pass[~never_pass].index
    print(f"Accessions with zero passing reps: {len(zero_accs)} / {never_pass.shape[0]}")

    zero_df = all_acc[all_acc['accession'].isin(zero_accs)]

    # primary fail reason per row, tally across reps
    primary = zero_df['fail_reason'].str.split(';').str[0].str.replace(r'\(.*\)', '', regex=True)
    print("\nPrimary fail reason (across all rep-rows for zero-pass accessions):")
    print(primary.value_counts())

    # input coverage context
    print("\nMean tiles-with-reads per accession (coverage proxy):")
    print(zero_df.groupby('accession')['n_tiles_with_reads'].mean().describe())
EOF
```

#### check 150x150 snap rates
```bash
FILTER=$ROOT/work/06_filter_v7_150x150_final

grep "snapped to tiles" "$FILTER"/*/rep*.log.txt | head -20
```

compare fail reasons in 75x75 dataset and 150x150 dataset 
```bash
python3 - <<'EOF'
import pandas as pd

for label, FILTER in [("75x75", "/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib/work/06_filter_v7_75x75_final"),
                        ("150x150", "/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib/work/06_filter_v7_150x150_final")]:
    print(f"\n{'='*20} {label} {'='*20}")
    for MG in ["10", "01"]:
        acc_dfs = [pd.read_csv(f"{FILTER}/{MG}mM/rep{r}_accessions.csv") for r in [1,2,3,4]]
        all_acc = pd.concat(acc_dfs)
        never_pass = all_acc.groupby('accession')['pass'].any()
        zero_accs = never_pass[~never_pass].index
        zero_df = all_acc[all_acc['accession'].isin(zero_accs)]
        primary = zero_df['fail_reason'].str.split(';').str[0].str.replace(r'\(.*\)', '', regex=True)
        print(f"{MG}mM: {len(zero_accs)}/{never_pass.shape[0]} zero-pass")
        print(primary.value_counts())
EOF
```

```
==================== 75x75 ====================
10mM: 103/438 zero-pass
fail_reason
low_stall_reads              340
low_treated_sf                60
no_peaks_above_min_adj_sf      5
high_ctrl_sf                   1
Name: count, dtype: int64
01mM: 162/439 zero-pass
fail_reason
low_stall_reads              473
low_treated_sf               156
no_peaks_above_min_adj_sf      7
high_ctrl_sf                   2
Name: count, dtype: int64

==================== 150x150 ====================
10mM: 102/439 zero-pass
fail_reason
low_stall_reads              275
low_treated_sf               125
high_ctrl_sf                   4
no_peaks_above_min_adj_sf      3
Name: count, dtype: int64
01mM: 169/439 zero-pass
fail_reason
low_stall_reads              474
low_treated_sf               190
high_ctrl_sf                   7
no_peaks_above_min_adj_sf      4
```

the zero-pass accession counts are nearly identical between the two runs.
```
	                    75x75	150x150
10mM zero-pass	103/438 (23.5%)	102/439 (23.2%)
01mM zero-pass	162/439 (36.9%)	169/439 (38.5%)

```
mere difference of 1 accession at 10mM and 7 accessions at 01mM — 

fail-reason breakdowns also similar in proportion (roughly 2:1 low_stall_reads:low_treated_sf in both runs, both conditions).

### tier failures by their tile read depths (ambiguous fail?)

```bash
python3 - <<'EOF'
import pandas as pd

FILTER = "/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib/work/06_filter_v7_150x150_final"
VIRUS_STATS = "/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib/data/virus_stats_flaviLib_tiled_subset_20260826.csv"

tax = pd.read_csv(VIRUS_STATS)
tax_map = tax.set_index('accession')[['family', 'genus', 'species']].to_dict('index')

for MG in ["10", "01"]:
    print(f"\n{'='*20} {MG}mM {'='*20}")

    acc_dfs = [pd.read_csv(f"{FILTER}/{MG}mM/rep{r}_accessions.csv") for r in [1,2,3,4]]
    all_acc = pd.concat(acc_dfs)
    peaks_dfs = [pd.read_csv(f"{FILTER}/{MG}mM/rep{r}_peaks.csv") for r in [1,2,3,4]]
    all_peaks = pd.concat(peaks_dfs)

    never_pass = all_acc.groupby('accession')['pass'].any()
    zero_accs = set(never_pass[~never_pass].index)

    zero_peaks = all_peaks[all_peaks['accession'].isin(zero_accs)].copy()
    best_peak_idx = zero_peaks.groupby('accession')['tile_reads_treated'].idxmax()
    best_peaks = zero_peaks.loc[best_peak_idx].copy()

    def tier(row):
        depth = row['tile_reads_treated']
        if depth < 100:
            return "Underpowered (<100 treated reads)"
        elif depth < 1000:
            return "Ambiguous (100-1000 treated reads)"
        else:
            return "Well-powered, genuinely weak/no stall (>=1000)"

    best_peaks['tier'] = best_peaks.apply(tier, axis=1)
    print(best_peaks['tier'].value_counts())
    print(f"\nMedian best-tile treated depth for zero-pass accessions: {best_peaks['tile_reads_treated'].median():.0f}")
EOF
```
```

==================== 10mM ====================
tier
Underpowered (<100 treated reads)                 69
Ambiguous (100-1000 treated reads)                56
Well-powered, genuinely weak/no stall (>=1000)    53


Median best-tile treated depth for zero-pass accessions: 302

==================== 01mM ====================
tier
Ambiguous (100-1000 treated reads)                143
Well-powered, genuinely weak/no stall (>=1000)    114
Underpowered (<100 treated reads)                  99


Median best-tile treated depth for zero-pass accessions: 304

```

conclude roughly a third of the failures in each condition are not a depth problem at all — those accessions got hundreds to thousands of treated reads at their best tile and still didn't concentrate enough at any single position to clear `min_stall_reads/min_treated_sf`

