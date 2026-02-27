#!/usr/bin/env python3
import argparse
from pathlib import Path
import pandas as pd
from typing import Dict, List

VALID = {"class1a","class1b","class2","class3","class4"}

def read_fasta_windows(fa_path: Path) -> List[str]:
    wins = []
    with fa_path.open("r", errors="ignore") as fh:
        for line in fh:
            if line.startswith(">"):
                wins.append(line[1:].strip().split()[0])
    return wins

def _safe_float(x: str):
    try:
        v = float(x);  return v if v >= 0 else None
    except Exception:
        return None

def _iter_tbl_rows_fixed(tbl_path: Path, i_cut: float):
    """
    Parse cmsearch --tblout with fixed positions:
      - window_id  = first token
      - e_value    = parts[-3]  (per your header)
      - i_evalue   = e_value    (no i-Evalue column present)
    Filter on i_evalue <= i_cut.
    """
    with tbl_path.open("r", errors="ignore") as fh:
        for line in fh:
            if not line.strip() or line.startswith("#"):  # skip comments/header
                continue
            parts = line.rstrip("\n").split()
            if not parts or len(parts) < 3:
                continue
            win = parts[0]
            e_val = _safe_float(parts[-3])  # <-- fixed position
            i_val = e_val
            if i_val is None or i_val > i_cut:
                continue
            yield win, i_val, e_val

def main():
    ap = argparse.ArgumentParser(description="Sort Infernal hits into classes; include E-value.")
    ap.add_argument("--runs-csv", required=True, help="CSV: tbl_path,dataset,db_fasta_path,query_name,class_label")
    ap.add_argument("--out-dir", required=True)
    ap.add_argument("--i-evalue", type=float, default=1e-2)
    args = ap.parse_args()

    out_dir = Path(args.out_dir); out_dir.mkdir(parents=True, exist_ok=True)
    runs = pd.read_csv(args.runs_csv)
    need = {"tbl_path","dataset","db_fasta_path","query_name","class_label"}
    miss = need - set(runs.columns)
    if miss:
        raise SystemExit(f"runs CSV missing: {sorted(miss)}")

    bad = runs[~runs["class_label"].astype(str).str.lower().isin(VALID)]
    if len(bad):
        raise SystemExit(f"bad class_label values: {sorted(set(bad['class_label'].astype(str)))}")

    rows = []
    for _, r in runs.iterrows():
        tbl = Path(str(r["tbl_path"])).expanduser().resolve()
        ds  = str(r["dataset"])
        fa  = Path(str(r["db_fasta_path"])).expanduser().resolve()
        cls = str(r["class_label"]).strip().lower()
        if not tbl.exists(): raise SystemExit(f"tbl not found: {tbl}")
        if not fa.exists():  raise SystemExit(f"FASTA not found: {fa}")

        for win, i_val, e_val in _iter_tbl_rows_fixed(tbl, args.i_evalue):
            rows.append({"dataset": ds, "window_id": win, "class_label": cls,
                         "i_evalue": i_val, "e_value": e_val})

    hits = pd.DataFrame(rows, columns=["dataset","window_id","class_label","i_evalue","e_value"]).drop_duplicates()

    # per-dataset class lists
    for (ds, cls), grp in hits.groupby(["dataset","class_label"]):
        ddir = out_dir / ds / "window_level"; ddir.mkdir(parents=True, exist_ok=True)
        (ddir / f"class_{cls}.txt").write_text("\n".join(sorted(grp["window_id"])) + "\n")

    # per-dataset multiclass
    multi_rows = []
    for ds, sub in hits.groupby("dataset"):
        win2classes: Dict[str, set] = {}
        for _, row in sub.iterrows():
            win2classes.setdefault(row["window_id"], set()).add(row["class_label"])
        ddir = out_dir / ds / "window_level"; ddir.mkdir(parents=True, exist_ok=True)
        mc_df = pd.DataFrame([{"window_id": w, "classes": ",".join(sorted(s))} for w, s in sorted(win2classes.items())])
        (ddir / "multiclass.csv").write_text(mc_df.to_csv(index=False))
        multi_rows.extend([{"dataset": ds, **rec} for rec in mc_df.to_dict(orient="records")])

    # per-dataset no_group
    no_rows = []
    for ds, sub in runs.groupby("dataset"):
        fas = sorted(set(Path(p).expanduser().resolve() for p in sub["db_fasta_path"]))
        if len(fas) != 1: raise SystemExit(f"{ds}: expected 1 FASTA, got {len(fas)}")
        windows = set(read_fasta_windows(fas[0]))
        hit_windows = set(hits.loc[hits["dataset"] == ds, "window_id"])
        none = sorted(windows - hit_windows)
        ddir = out_dir / ds / "window_level"; ddir.mkdir(parents=True, exist_ok=True)
        (ddir / "no_group.txt").write_text("\n".join(none) + ("\n" if none else ""))
        no_rows.extend([{"dataset": ds, "window_id": w} for w in none])

    # cross-dataset CSVs (now include i_evalue + e_value)
    (out_dir / "window_hits_long.csv").write_text(
        hits.rename(columns={"window_id":"window"}).to_csv(index=False)
    )
    df_multi = pd.DataFrame(multi_rows, columns=["dataset","window_id","classes"])
    (out_dir / "window_multiclass.csv").write_text(df_multi.to_csv(index=False))
    counts = hits.groupby(["dataset","class_label"])["window_id"].nunique().reset_index(name="n_windows")
    (out_dir / "window_counts_by_class.csv").write_text(counts.to_csv(index=False))

    # summary
    if no_rows:
        df_no = pd.DataFrame(no_rows)
        nnone = df_no.groupby("dataset")["window_id"].nunique().rename("n_no_group").to_frame()
    else:
        nnone = pd.DataFrame(columns=["n_no_group"])
    piv = counts.pivot(index="dataset", columns="class_label", values="n_windows").fillna(0).astype(int)
    summary = piv.merge(nnone, left_index=True, right_index=True, how="outer").fillna(0).astype(int).reset_index()
    (out_dir / "summary.csv").write_text(summary.to_csv(index=False))

    print(f"[OK] wrote: {out_dir.resolve()}")

if __name__ == "__main__":
    main()
