.PHONY: security security-scan security-osv security-sarif sbom security-verify security-report security-all
PYTHON ?= python3
SECURITY := tools/security

security: security-all
security-scan:
	$(PYTHON) $(SECURITY)/scan.py
security-osv:
	$(PYTHON) $(SECURITY)/osv.py
security-sarif: security-scan
	$(PYTHON) $(SECURITY)/sarif.py
sbom:
	$(PYTHON) $(SECURITY)/sbom.py
security-verify:
	@echo 'Use tools/security/verify.py <manifest> for release checksum verification.'
security-report: security-scan security-sarif sbom
	@mkdir -p security/reports
	@printf '# make.universal security report\n\nGenerated security evidence is under `security/`, with SARIF at `sarif/`.\n' > security/reports/latest.md
security-all: security-osv security-scan security-sarif sbom security-report
