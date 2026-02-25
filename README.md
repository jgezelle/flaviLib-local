## locally analyze cm class distribution of flaviLib fasta

```bash
# if not in conda env 
conda activate viromelib 
```

### **Run infernal search against hits for all known cms:**
```bash
# within /Users/jeaninegezelle/Desktop/viromelib/flaviLib/infernal:

mkdir -p sto cm fa tblout

cmsearch --tblout tblout/cl1a_lib_tile20.tbl cm/CL_Class_1a_xrRNA_final.cm fa/library_mifsud_simmonds_EDIT_tile20.fa

cmsearch --tblout tblout/cl1a_lib_tile40.tbl cm/CL_Class_1a_xrRNA_final.cm fa/library_mifsud_simmonds_EDIT_tile40.fa

cmsearch --tblout tblout/cl1a_lib_tile80.tbl cm/CL_Class_1a_xrRNA_final.cm fa/library_mifsud_simmonds_EDIT_tile80.fa

cmsearch --tblout tblout/cl1b_lib_tile20.tbl cm/CL_Class_1b_xrRNA_final.cm fa/library_mifsud_simmonds_EDIT_tile20.fa

cmsearch --tblout tblout/cl1b_lib_tile40.tbl cm/CL_Class_1b_xrRNA_final.cm fa/library_mifsud_simmonds_EDIT_tile40.fa

cmsearch --tblout tblout/cl1b_lib_tile80.tbl cm/CL_Class_1b_xrRNA_final.cm fa/library_mifsud_simmonds_EDIT_tile80.fa

cmsearch --tblout tblout/cl2_lib_tile20.tbl cm/CL_Class_2_xrRNA_final.cm fa/library_mifsud_simmonds_EDIT_tile20.fa

cmsearch --tblout tblout/cl2_lib_tile40.tbl cm/CL_Class_2_xrRNA_final.cm fa/library_mifsud_simmonds_EDIT_tile40.fa

cmsearch --tblout tblout/cl2_lib_tile80.tbl cm/CL_Class_2_xrRNA_final.cm fa/library_mifsud_simmonds_EDIT_tile80.fa
```
```bash
# from local flaviLib, scp the scripts prev. used for infernal class sorting: 
scp -r jgg2144@hpc.c2b2.columbia.edu:/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib/scripts/sortclasses_eval.py .
scp -r jgg2144@hpc.c2b2.columbia.edu:/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib/scripts/buildInfernalRunMap.py .
```

```bash 
ROOT=/Users/jeaninegezelle/Desktop/viromelib/flaviLib
WD="$ROOT"/infernal
cd "$WD"
SCRIPT="$ROOT"/scripts/buildInfernalRunMap.py
# assumes pandas in python 
 python "$SCRIPT" \                 
  --add-dataset tile20 "fa/library_mifsud_simmonds_EDIT_tile20.fa" "tblout/*_tile20.tbl" \
  --add-dataset tile40 "fa/library_mifsud_simmonds_EDIT_tile40.fa" "tblout/*_tile40.tbl" \
  --add-dataset tile80 "fa/library_mifsud_simmonds_EDIT_tile80.fa" "tblout/*_tile80.tbl" \
  --cm-map Class_1a=class1a \
  --cm-map Class_1b=class1b \
  --cm-map Class_2=class2 \
  --auto-class-from-query \
  --out infernal_runs.csv
```
```bash 
# uses the runs csv as a guide (this one includes "no group")
mkdir -p groups
python "$ROOT"/scripts/sortclasses_eval2.py \
  --runs-csv infernal_runs.csv \
  --out-dir groups/20260218 \
  --i-evalue 1e-2
```

```bash
# annotate with organism AND genus (second version) using the combined table: 
python "$ROOT/scripts/add_organism_by_accession2.py" \
  --in-csv  groups/20260218/window_all_long.csv \
  --out-csv groups/20260218/window_all_long.with_taxonomy.csv
# old version was just organism: 
python "$ROOT/scripts/add_organism_by_accession.py" \
  --in-csv  groups/20260218/window_all_long.csv \
  --out-csv groups/20260218/window_all_long.with_organism.csv
```
------------
# below is copied from viromelib analysis with new hits: <br>
## infernal outputs and `cmalign` 
after initial infernal searches, new cms and cmsearches are done, and the results from these can be used in `cmalign`. It requires a certain input format, so use bash `grep` to fish out the information from the `tblout` files. (**bash script** `infernalTxt.sh`)
see script below: <br>
```bash
# Make the coordinate file from infernal .tblout 

# change for tblout and output names!

grep -v '^#' tblout/picornaPK_RNAvir.tbl \
| while read -r \
    target acc1 qname acc2 mdl mdl_from mdl_to seq_from seq_to strand trunc pass gc bias score evalue inc rest
do
  # if minus, swap so from>to (esl-sfetch -Cf reverse-complements when from>to)
  if [ "$strand" = "-" ]; then tmp="$seq_from"; seq_from="$seq_to"; seq_to="$tmp"; fi
  # <new_name> <from> <to> <source_seqname>
  printf "%s|%s-%s %s %s %s\n" "$target" "$seq_from" "$seq_to" "$seq_from" "$seq_to" "$target"
done > coords/coords.txt
```

```bash 
srun --pty -t 05:00:00 -c 4 --mem=16G   --chdir=/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib/work/06_infernal/   /bin/bash -l

conda activate viromelib
```
```bash 
bash /groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib/scripts/infernalTxt.sh
```
```bash 
head coords/coords.txt
```

```bash
# index the fa db one time:
esl-sfetch --index fa/RNAvirus_CompleteAssem_No_CoV-2.fa
```
`"SSI index written to file fa/RNAvirus_CompleteAssem_No_CoV-2.fa.ssi"`

```bash
esl-sfetch -Cf fa/RNAvirus_CompleteAssem_No_CoV-2.fa coords/coords.txt > fa/hits.fa
```
```bash
cmalign -o stockholm/aligned.sto cm/picornaPK.cm fa/hits.fa
```

currently, `cmsearch` is only finding similar sequences <br>
max hits so far 18 <br>
`cmalign` is also not finding the predicted structure (not aligning the 3' of the stem well) <br>
searches for the PK, same number of hits. all picornaviridae <br>

# incorporating peak windows from hits into new cm alignments using `cmalign`
Nov 10, 2025 <br> 
use this **bash script** [`infernal_cmalign.sh`](../scripts/infernal_cmalign.sh)

## Merge fastas for sequence- and structure-based alignments 
### merging peak windows for the picornaviridae family 
```bash 
ROOT=/groups/as6282_gp/scratch_bkup/jgg2144/xrrna_seq/viromelib
FA_DIR=$ROOT/work/04_align/fullacc
FA1=$FA_DIR/250904-r0368-X-01-A3405_NORM_family_fastas_2/Picornaviridae.peak_windows.fa
FA2=$FA_DIR/251029-r0371-X1-01-A3445_family_fastas_NORM_v2/Picornaviridae.peak_windows.fa
FA3=$FA_DIR/251029-r0373-X2-02-A3439_family_fastas_NORM_v2/Picornaviridae.peak_windows.fa
FA_OUT=$ROOT/work/06_infernal/fa

# merge fa: 
cat  $FA1 $FA2 $FA3 > $FA_OUT/Picornaviridae.peak_windows.merge.fa
# dedup:
seqkit rmdup -s $FA_OUT/Picornaviridae.peak_windows.merge.fa > $FA_OUT/Picornaviridae.peak_windows.merge.dedup.fa
```
mlocarna: 
```bash 
mlocarna -stockholm --consensus-structure alifold $FA_OUT/Picornaviridae.peak_windows.merge.dedup.fa
```