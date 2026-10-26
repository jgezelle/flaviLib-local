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
# ordering the library 
### make the fasta have shorter headers for Twist 
from flaviLib dir: 
```bash
python scripts/shorten_fasta_headers.py data/library_mifsud_simmonds_EDIT_tile20_with_jeanine_new_genomes_20260225.dupsremoved.fa data/library_mifsud_tile20_20260227.fa 
```
