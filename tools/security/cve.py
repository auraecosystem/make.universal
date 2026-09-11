#!/usr/bin/env python3
"""Fetch CVE records from NVD 2.0 and preserve the raw upstream payload."""
import argparse,json,pathlib,urllib.parse,urllib.request
ROOT=pathlib.Path(__file__).resolve().parents[2]
def fetch(cve):
    url='https://services.nvd.nist.gov/rest/json/cves/2.0?cveId='+urllib.parse.quote(cve)
    req=urllib.request.Request(url,headers={'User-Agent':'make.universal-security/1.0'})
    with urllib.request.urlopen(req,timeout=30) as r: return json.load(r)
def main():
    ap=argparse.ArgumentParser(); ap.add_argument('ids',nargs='+'); a=ap.parse_args(); out=ROOT/'cve'; out.mkdir(exist_ok=True)
    for cve in a.ids:
        data=fetch(cve.upper()); (out/(cve.lower()+'.json')).write_text(json.dumps({'schema_version':'1.0','id':cve.upper(),'source':'NVD','upstream':data},indent=2,sort_keys=True)+'\n')
if __name__=='__main__': main()
