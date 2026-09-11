.PHONY: all validate certify clean

PYTHON ?= python3
CERTIFY_VALIDATOR := tools/validate_certify.py
CERTIFICATION_DIR := build/certification

all: validate

validate:
	$(PYTHON) $(CERTIFY_VALIDATOR) --write-report

certify:
	@$(MAKE) --no-print-directory validate
	@status=$$?; \
	if [ $$status -eq 0 ]; then \
		echo "CERTIFIED"; \
	else \
		echo "NOT_CERTIFIED"; \
		exit $$status; \
	fi

clean:
	rm -rf $(CERTIFICATION_DIR)
