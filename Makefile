SHELL=/bin/bash
COVER_FILE?=./gen/coverage.out
COVER_TEXT?=./gen/coverage.txt
COVER_HTML?=./gen/coverage.html

.PHONY: test
test: ## Runs unit tests and generates a coverage file at coverage.out
	mkdir -p gen
	go test -short `go list ./... | grep -vE "./test"` \
			-race -covermode=atomic -json \
			-coverprofile=$(COVER_FILE) \
			| tee $(TEST_JSON)
	go tool cover -func=$(COVER_FILE) \
			| tee $(COVER_TEXT)
	go tool cover -html=$(COVER_FILE) -o $(COVER_HTML)