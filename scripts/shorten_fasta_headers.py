#!/usr/bin/env python3
from pathlib import Path
import sys

def shorten_header(header_line: str) -> str:
    # header_line includes leading '>'
    # keep only first whitespace-delimited token after '>'
    return header_line[1:].strip().split()[0]

def main(inp_path: str, out_path: str):
    inp = Path(inp_path)
    out = Path(out_path)

    seen = set()
    current_id = None

    with inp.open() as fin, out.open("w") as fout:
        for line in fin:
            if line.startswith(">"):
                new_id = shorten_header(line)

                if len(new_id) > 32:
                    raise SystemExit(f"ERROR: ID >32 chars after shortening: '{new_id}' (len={len(new_id)})")

                if new_id in seen:
                    raise SystemExit(f"ERROR: Duplicate ID after shortening: '{new_id}'")
                seen.add(new_id)

                fout.write(f">{new_id}\n")
                current_id = new_id
            else:
                # sequence (or blank line)
                fout.write(line)

    print(f"OK: wrote {out} with {len(seen)} unique sequence IDs.")

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print(f"Usage: {sys.argv[0]} input.fa output.fa", file=sys.stderr)
        sys.exit(2)
    main(sys.argv[1], sys.argv[2])