#!/usr/bin/env python3
"""Convert security/scans/latest.json findings to SARIF 2.1.0."""
import json, pathlib
ROOT=pathlib.Path(__file__).resolve().parents[2]
def main():
    src=json.loads((ROOT/'security/scans/latest.json').read_text())
    rules=[]; results=[]
    for i,f in enumerate(src.get('findings',[])):
        rid=str(f.get('id',f'finding-{i}')); rules.append({'id':rid,'shortDescription':{'text':str(f.get('summary',rid))}})
        results.append({'ruleId':rid,'level':{'critical':'error','high':'error','moderate':'warning','low':'note'}.get(str(f.get('severity','low')).lower(),'warning'),'message':{'text':str(f.get('summary',rid))}})
    sarif={'version':'2.1.0','$schema':'https://json.schemastore.org/sarif-2.1.0.json','runs':[{'tool':{'driver':{'name':'make.universal security','rules':rules}},'results':results}]}
    p=ROOT/'sarif/rsync.sarif'; p.parent.mkdir(parents=True,exist_ok=True); p.write_text(json.dumps(sarif,indent=2,sort_keys=True)+'\n')
if __name__=='__main__': main()
