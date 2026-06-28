node:
	docker build -f images/node.Dockerfile -t make.universal-node .

python:
	docker build -f images/python.Dockerfile -t make.universal-python .

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
