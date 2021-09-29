
.PHONY: test
test: ## Runs unit tests and generates a coverage file at coverage.out
	set -eo pipefail; go test -short `go list ./... | grep -vE "./test"`