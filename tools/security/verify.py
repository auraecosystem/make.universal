#!/usr/bin/env python3
"""Verify SHA-256/SHA-512 checksums for a release manifest."""
import argparse, hashlib, pathlib, sys

def main():
    ap=argparse.ArgumentParser(); ap.add_argument('manifest'); a=ap.parse_args(); ok=True
    for line in pathlib.Path(a.manifest).read_text().splitlines():
        if not line.strip(): continue
        algo, expected, path=line.split(None,2); h=hashlib.new(algo); h.update(pathlib.Path(path).read_bytes());
        if h.hexdigest()!=expected: print(f'FAIL {path}'); ok=False
        else: print(f'OK   {path}')
    return 0 if ok else 1
if __name__=='__main__': sys.exit(main())
