#!/usr/bin/env python3
"""Security scanner for make.universal.

Consumes an optional security/dependencies.json file and advisory indexes.
It intentionally performs no network access; CI ingestion is handled by osv.py/cve.py.
"""
import json, pathlib, sys

ROOT = pathlib.Path(__file__).resolve().parents[2]

def load(path, default):
    p = ROOT / path
    if not p.exists(): return default
    return json.loads(p.read_text())

def main():
    deps = load('security/dependencies.json', {'dependencies': []})['dependencies']
    advisories = load('advisories/index.json', {'advisories': []})['advisories']
    names = {str(d.get('name','')).lower() for d in deps}
    hits = [a for a in advisories if str(a.get('package','')).lower() in names]
    result = {'schema_version':'1.0','dependencies':len(deps),'findings':hits}
    out = ROOT/'security/scans/latest.json'; out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text(json.dumps(result, indent=2, sort_keys=True)+'\n')
    print(json.dumps(result, indent=2))
    threshold = {'low':1,'moderate':2,'high':3,'critical':4}.get(load('security/policies/policy.json', {'fail_on':'critical'}).get('fail_on','critical'),4)
    return 1 if any({'low':1,'moderate':2,'high':3,'critical':4}.get(str(x.get('severity','low')).lower(),0) >= threshold for x in hits) else 0

if __name__ == '__main__': sys.exit(main())
