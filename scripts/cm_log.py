#!/usr/bin/env python3
"""Append one row to a run-log table in CM_CANDIDATES.md.

The document keeps one table per model under `## Run log`, headed `### `<model>``,
with columns | date | step | result |. This script appends a row to the named table,
creating the subsection (at the end of `## Run log`) if it does not exist, and
updates the `Last updated YYYY-MM-DD.` line. The file is rewritten atomically.

    cm_log.py CM_CANDIDATES.md --model class1c --step "cmsearch library" \
        --result "46 ! hits, 19 accessions, 0 novel"

Pipe characters in --step / --result are escaped so they do not break the table.
"""
import argparse
import datetime as dt
import os
import re
import sys
import tempfile


def esc(s: str) -> str:
    return s.replace("\n", " ").replace("|", "\\|").strip()


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("doc")
    ap.add_argument("--model", required=True, help="subsection name, written as ### `<model>`")
    ap.add_argument("--step", required=True)
    ap.add_argument("--result", required=True)
    ap.add_argument("--date", default=dt.date.today().isoformat())
    a = ap.parse_args()

    with open(a.doc) as fh:
        lines = fh.read().split("\n")

    row = f"| {a.date} | {esc(a.step)} | {esc(a.result)} |"

    try:
        rl = next(i for i, l in enumerate(lines) if l.strip() == "## Run log")
    except StopIteration:
        sys.exit("cm_log.py: no '## Run log' heading in " + a.doc)
    # the section ends at the next level-1 or level-2 heading (the file is in "# Part N" parts)
    end = next((i for i in range(rl + 1, len(lines))
                if lines[i].startswith("## ") or re.match(r"^# \S", lines[i])), len(lines))

    head_re = re.compile(r"^###\s+`?" + re.escape(a.model) + r"`?\s*$")
    sec = next((i for i in range(rl + 1, end) if head_re.match(lines[i])), None)

    if sec is None:
        # new subsection just before the next top-level heading, skipping trailing blanks
        ins = end
        while ins > rl + 1 and lines[ins - 1].strip() in ("", "---"):
            ins -= 1
        block = ["", f"### `{a.model}`", "", "| date | step | result |", "|---|---|---|", row]
        lines[ins:ins] = block
    else:
        sec_end = next((i for i in range(sec + 1, end) if lines[i].startswith("### ")), end)
        last_row = max((i for i in range(sec + 1, sec_end) if lines[i].lstrip().startswith("|")), default=None)
        if last_row is None:
            lines[sec + 1:sec + 1] = ["", "| date | step | result |", "|---|---|---|", row]
        else:
            lines.insert(last_row + 1, row)

    for i, l in enumerate(lines[:40]):
        if re.match(r"^Last updated \d{4}-\d{2}-\d{2}\.\s*$", l):
            lines[i] = f"Last updated {a.date}."
            break

    d = os.path.dirname(os.path.abspath(a.doc))
    fd, tmp = tempfile.mkstemp(dir=d, prefix=".cm_log.")
    with os.fdopen(fd, "w") as fh:
        fh.write("\n".join(lines))
    os.replace(tmp, a.doc)
    print(f"logged to {a.doc} [{a.model}]: {row}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
