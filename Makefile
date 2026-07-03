.PHONY: format lint test

format:
	@echo "format: nothing configured yet"

# lint is first so that bare `make` never mutates the working tree,
# even once `format` is wired to a real formatter.
lint:
	@scripts/check-temp-markers.sh
	@echo "lint: TEMP markers OK; no other checks configured yet"

test:
	@set -e; for t in tests/*.test.sh; do "$$t"; done
	@echo "test: script tests OK; no project tests configured yet"
