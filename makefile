node:
	docker build -f images/node.Dockerfile -t makeuniversal-node .

python:
	docker build -f images/python.Dockerfile -t makeuniversal-python .

clean:
	docker system prune -af
security:
    mu scan

security-cve:
    mu cve scan

security-osv:
    mu osv scan

security-sbom:
    mu sbom generate

security-sarif:
    mu sarif generate

security-report:
    mu report html

security-fix:
    mu update --secure

release:
    mu verify
    mu security
    mu build
    mu sign
    mu publish
