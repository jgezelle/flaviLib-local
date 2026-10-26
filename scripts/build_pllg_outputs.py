#!/usr/bin/env python3
"""
Merges your stall-peak/p-value sheet (flaviLib_01mM_1234_peaks_annotated...allCMs.csv)
with Mifsud et al.'s clade metadata (Mifsud_2024_Supplementary_table_1...xlsx)
to produce:
  1. unclassified_genus_with_mifsud_clade.csv
  2. PLLG_LGF_clade_xrRNA_landscape.csv
  3. PLLG_LGF_unclassified_for_mlocarna.fa

The ONLY join key between the two datasets is the GenBank accession number.
Everything else (genus, clade, species name spelling) differs between the two
sheets, so accession is the one field trustworthy enough to match on.
"""

import openpyxl
import csv

MIFSUD_XLSX = "Mifsud_2024_Supplementary_table_1_EDIT_NO3UTRseqs.xlsx"
PEAKS_CSV   = "flaviLib_01mM_1234_peaks_annotated20260826_allCMs.csv"


def base_acc(accession):
    """
    Strip the GenBank version suffix (.1, .2, etc.) so 'NC_024077.1' and
    'NC_024077' — or 'NC_024077.2' — all match as the same accession.
    Mifsud's sheet is inconsistent about including the version (some rows
    have it, some don't), so this is the safest common key.
    """
    if accession is None:
        return None
    return str(accession).strip().split(".")[0]


# ---------------------------------------------------------------------------
# STEP 1 — Load Mifsud's clade metadata into a lookup: base_accession -> info
# ---------------------------------------------------------------------------
def load_mifsud_clade_map():
    wb = openpyxl.load_workbook(MIFSUD_XLSX, read_only=True)

    # "Metadata" sheet: row 1 = title, row 2 = blank, row 3 = header, row 4+ = data
    ws = wb["Metadata"]
    rows = list(ws.iter_rows(values_only=True))
    header = rows[2]   # ('tree_tip_label', 'clade', 'virus_taxa', 'nucl_sequence_accession', ...)
    data_rows = rows[3:]
    assert header[:4] == ("tree_tip_label", "clade", "virus_taxa", "nucl_sequence_accession")

    clade_map = {}
    for tip_label, clade, virus_taxa, nucl_acc, aa_name, nucl_name in data_rows:
        if nucl_acc is None:
            continue
        b = base_acc(nucl_acc)
        # a base accession can map to >1 row (e.g. two ORFs of the same genome) —
        # keep a list, but in practice we only ever use the first entry
        clade_map.setdefault(b, []).append((tip_label, clade, virus_taxa))

    # "Clade Acronym Definitions" sheet: 4-letter clade code -> plain-English definition
    ws2 = wb["Clade Acronym Definitions"]
    clade_def = {}
    for r in ws2.iter_rows(values_only=True):
        if r[0] and r[0] != "clade_acronym" and "Supplementary" not in str(r[0]):
            clade_def[r[0]] = r[1]

    return clade_map, clade_def


# ---------------------------------------------------------------------------
# STEP 2 — Load your peaks sheet: one row per stall peak
# ---------------------------------------------------------------------------
def load_peaks():
    """Returns a list of dict rows (csv.DictReader), unmodified."""
    with open(PEAKS_CSV) as f:
        return list(csv.DictReader(f))


def peak_accession(row):
    """
    row['accession'] looks like 'NC_024077.1|18018-19199_inferred_3UTR'
    (accession | 3'UTR-window coordinates on the source genome).
    We only want the GenBank accession part, before the first '|'.
    """
    return row["accession"].split("|")[0]


# ---------------------------------------------------------------------------
# OUTPUT 1 — unclassified_genus_with_mifsud_clade.csv
#   Every peak-sheet row whose genus (or family) == 'Unannotated', joined to
#   whatever real clade Mifsud assigned that accession, if any.
# ---------------------------------------------------------------------------
def build_crosswalk(peaks, clade_map, clade_def, outpath):
    # first collapse the peaks sheet down to one (family, genus, species) per
    # accession, since the same accession appears many times (once per tile/peak)
    acc_info = {}
    for row in peaks:
        acc = peak_accession(row)
        acc_info[acc] = (row["family"], row["genus"], row["species"])

    out_rows = []
    for acc, (fam, gen, sp) in acc_info.items():
        if gen != "Unannotated" and fam != "Unannotated":
            continue  # only interested in the unclassified ones
        hit = clade_map.get(base_acc(acc))
        if hit:
            tip, clade, taxa = hit[0]
            out_rows.append([acc, sp, fam, gen, tip, clade, clade_def.get(clade, "")])
        else:
            out_rows.append([acc, sp, fam, gen, "", "",
                              "NOT IN MIFSUD (novel/Simmonds-only accession)"])

    out_rows.sort(key=lambda r: (r[5], r[1]))  # sort by clade, then species

    with open(outpath, "w", newline="") as f:
        w = csv.writer(f)
        w.writerow(["accession", "species", "my_family", "my_genus",
                    "mifsud_tree_tip_label", "mifsud_clade", "mifsud_clade_definition"])
        w.writerows(out_rows)

    return out_rows


# ---------------------------------------------------------------------------
# OUTPUT 2 & 3 — PLLG-specific landscape + alignment FASTA
# ---------------------------------------------------------------------------
def build_pllg_outputs(peaks, clade_map, landscape_path, fasta_path):
    # which base accessions does Mifsud place in clade PLLG?
    pllg_base_accs = {
        base_acc(acc) for acc, hits in clade_map.items() if hits[0][1] == "PLLG"
    }

    # for every peak row belonging to a PLLG accession, keep only the row with
    # the LOWEST meta_pvalue per accession (= the strongest/rank-1 stall site)
    best_per_accession = {}
    for row in peaks:
        acc = peak_accession(row)
        if base_acc(acc) not in pllg_base_accs:
            continue
        pval = float(row["meta_pvalue"]) if row["meta_pvalue"] else 1.0
        if acc not in best_per_accession or pval < best_per_accession[acc][0]:
            best_per_accession[acc] = (pval, row)

    cm_hit_columns = [
        "CL_Class_1a_xrRNA_final.cm_hit",
        "CL_Class_1b_xrRNA_final.cm_hit",
        "CL_Class_2_xrRNA_final.cm_hit",
        "dumbbell_RF00525.cm_hit",
    ]

    # --- landscape CSV: every PLLG accession's best peak, with CM-hit status ---
    landscape_rows = []
    for acc, (pval, row) in sorted(best_per_accession.items(), key=lambda x: x[1][0]):
        tip = clade_map[base_acc(acc)][0][0]
        hit_classes = [c.split(".")[0] for c in cm_hit_columns if row.get(c)]
        landscape_rows.append([
            acc, row["species"], tip, row["meta_pvalue"], row["meta_qvalue"],
            row["stall_position"], row["any_hit"], ";".join(hit_classes),
            len(row["downstream_seq"]), row["downstream_seq"],
        ])

    with open(landscape_path, "w", newline="") as f:
        w = csv.writer(f)
        w.writerow(["accession", "species", "mifsud_tree_tip_label", "meta_pvalue",
                     "meta_qvalue", "stall_position", "any_known_cm_hit",
                     "cm_class_hit", "downstream_seq_len", "downstream_seq"])
        w.writerows(landscape_rows)

    # --- FASTA for mlocarna: same set, but drop the 1 accession that already
    #     hit a known CM (any_hit == 'True'), since we want the *unclassified*
    #     candidates for building a NEW model ---
    n_written = 0
    with open(fasta_path, "w") as f:
        for acc, (pval, row) in sorted(best_per_accession.items(), key=lambda x: x[1][0]):
            if row["any_hit"] == "True":
                continue
            tip = clade_map[base_acc(acc)][0][0]
            sp = row["species"].replace(" ", "_").replace("/", "_")
            header = f">{acc}|{sp}|{tip}|pv={pval:.2e}|stall={row['stall_position']}"
            f.write(header + "\n" + row["downstream_seq"] + "\n")
            n_written += 1

    return landscape_rows, n_written


# ---------------------------------------------------------------------------
if __name__ == "__main__":
    clade_map, clade_def = load_mifsud_clade_map()
    peaks = load_peaks()

    xwalk = build_crosswalk(
        peaks, clade_map, clade_def,
        outpath="unclassified_genus_with_mifsud_clade.csv",
    )
    n_matched = sum(1 for r in xwalk if r[5])
    print(f"[crosswalk] {len(xwalk)} Unannotated-genus rows; "
          f"{n_matched} matched to a Mifsud clade; {len(xwalk)-n_matched} unmatched")

    landscape, n_fasta = build_pllg_outputs(
        peaks, clade_map,
        landscape_path="PLLG_LGF_clade_xrRNA_landscape.csv",
        fasta_path="PLLG_LGF_unclassified_for_mlocarna.fa",
    )
    print(f"[PLLG] {len(landscape)} PLLG accessions with peak data; "
          f"{n_fasta} written to FASTA (any_hit==False only)")
