#!/usr/bin/env python3
"""Query OSV.dev for a package coordinate and write an OSV record."""
import argparse,json,pathlib,urllib.request
ROOT=pathlib.Path(__file__).resolve().parents[2]
def main():
    ap=argparse.ArgumentParser(); ap.add_argument('--ecosystem',required=True); ap.add_argument('--package',required=True); ap.add_argument('--version'); a=ap.parse_args()
    body={'package':{'name':a.package,'ecosystem':a.ecosystem}}
    if a.version: body['version']=a.version
    req=urllib.request.Request('https://api.osv.dev/v1/query',data=json.dumps(body).encode(),headers={'Content-Type':'application/json','User-Agent':'make.universal-security/1.0'})
    with urllib.request.urlopen(req,timeout=30) as r: data=json.load(r)
    out=ROOT/'osv'; out.mkdir(exist_ok=True); (out/(a.package.replace('/','_')+'.json')).write_text(json.dumps(data,indent=2,sort_keys=True)+'\n')
if __name__=='__main__': main()
