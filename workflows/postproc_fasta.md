
```bash
ROOT=~/Desktop/viromelib
cd $ROOT 
FILE="$ROOT/flaviLib/work/07_postproc/flaviLib_01mM_1234_peaks_annotated20260826_allCMs-3-4pass.xlsx"

conda activate viromelib
python scripts/extract_genus_fastas.py "$FILE" flaviLib/work/genus_fastas
```

### try locarna for hepaci (predict 1b fitting)
```bash
mlocarna --stockholm --consensus-structure=alifold flaviLib/work/genus_fastas/Hepacivirus.fasta
```
### dedup output 
```bash
STOCKDIR="$ROOT/flaviLib/work/genus_fastas/Hepacivirus.out"
cd $STOCKDIR
FLAVISCRIPTS="$ROOT/flaviLib/scripts"
python "$FLAVISCRIPTS/dedup_stockholm.py" results/result.stk results/result-dedup.stk

```
#### manually use results to look for pseudoknots and edit stockholm. 


### try locarna for jingmen (predict new subclass..)
```bash
cd $ROOT 
STOCKDIR="$ROOT/flaviLib/work/genus_fastas/jingmen.out"
mlocarna --stockholm --consensus-structure=alifold --tgtdir "$STOCKDIR" flaviLib/work/genus_fastas/Jingmenvirus_group.fasta

# dedup 
cd $STOCKDIR
FLAVISCRIPTS="$ROOT/flaviLib/scripts"
python "$FLAVISCRIPTS/dedup_stockholm.py" results/result.stk results/result-dedup.stk
```

manually remove sequences from same region on same accession (dedup didn't take care of?)


reformat 

```bash
STOCKDIR="$ROOT/flaviLib/work/genus_fastas/jingmen.out/results/dedup-edit-clustal.out"

cd results
esl-reformat clustal result-dedup-edit.stk > dedup-edit-clustal.aln
mlocarna --realign --stockholm --consensus-structure=alifold --tgtdir "$STOCKDIR" dedup-edit-clustal.aln

```
