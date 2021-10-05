SHELL=/bin/bash
COVER_FILE?=./gen/coverage.out
COVER_TEXT?=./gen/coverage.txt
COVER_HTML?=./gen/coverage.html
export GO111MODULE=on
export GOFLAGS=-mod=vendor

.PHONY: test
test: ## Runs unit tests and generates a coverage file at coverage.out
	mkdir -p gen
	go test -short `go list ./... | grep -vE "./test"` \
			-race -covermode=atomic -json \
			-coverprofile=$(COVER_FILE) \
			| tee $(TEST_JSON)

.PHONY: app-image
app-image:
	 docker build . --tag=demo-app:latest