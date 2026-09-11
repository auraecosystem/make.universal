#!/usr/bin/env python3
"""Generate minimal SPDX and CycloneDX SBOMs from security/dependencies.json."""
import json, pathlib, uuid, datetime
ROOT=pathlib.Path(__file__).resolve().parents[2]
def main():
    d=json.loads((ROOT/'security/dependencies.json').read_text()) if (ROOT/'security/dependencies.json').exists() else {'dependencies':[]}
    deps=d.get('dependencies',[]); stamp=datetime.datetime.now(datetime.timezone.utc).isoformat()
    components=[{'type':'library','bom-ref':f"pkg:{x.get('ecosystem','generic')}/{x.get('name')}@{x.get('version')}",'name':x.get('name'),'version':x.get('version'),'purl':x.get('purl')} for x in deps]
    cyclo={'bomFormat':'CycloneDX','specVersion':'1.5','serialNumber':'urn:uuid:'+str(uuid.uuid4()),'version':1,'metadata':{'timestamp':stamp},'components':components}
    spdx={'spdxVersion':'SPDX-2.3','SPDXID':'SPDXRef-DOCUMENT','name':'make.universal','creationInfo':{'created':stamp,'creators':['Tool: make.universal sbom.py']},'packages':[{'SPDXID':'SPDXRef-'+str(i+1),'name':x.get('name'),'versionInfo':x.get('version'),'downloadLocation':'NOASSERTION'} for i,x in enumerate(deps)]}
    out=ROOT/'security/sbom'; out.mkdir(parents=True,exist_ok=True)
    (out/'cyclonedx.json').write_text(json.dumps(cyclo,indent=2,sort_keys=True)+'\n'); (out/'spdx.json').write_text(json.dumps(spdx,indent=2,sort_keys=True)+'\n')
if __name__=='__main__': main()
