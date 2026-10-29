# Get taxonomy list organized using Entrez Direct 
**bash script that uses python `fa_to_taxo_CSV.sh`**


```bash
ROOT=/Users/jeaninegezelle/Desktop/viromelib/flaviLib
DATA_DIR="$ROOT/data"
SCRIPT="$ROOT/scripts/fa_to_taxo_CSV.sh"
OUTDIR="$ROOT/libraryDesign"

mkdir -p "$OUTDIR"

for fasta in ${DATA_DIR}/*.fa; do
    base=$(basename "$fasta" .fa)

    outcsv="${OUTDIR}/${base}.taxonomy.csv"

    echo "-----------------------------------"
    echo "Processing: $fasta"
    echo "Output:     $outcsv"

    bash "$SCRIPT" "$fasta" "$outcsv"

done

```