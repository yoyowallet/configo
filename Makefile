.PHONY: compile build build_all fmt lint test itest vet bootstrap

SOURCE_FOLDER := .

BINARY_PATH ?= ./bin/configo

GOARCH ?= amd64

ifdef GOOS
BINARY_PATH :=$(BINARY_PATH).$(GOOS)-$(GOARCH)
endif

SPECS ?= spec/integration/**

export GO15VENDOREXPERIMENT=1

default: build

build_all: vet fmt
	$(MAKE) compile GOOS=linux GOARCH=amd64

compile:
	go build -i -v -ldflags '-s' -o $(BINARY_PATH) $(SOURCE_FOLDER)/

build: vet fmt compile

fmt:
	go fmt $(glide novendor)

vet:
	go vet $(glide novendor)

lint:
	go list $(SOURCE_FOLDER)/... | grep -v /vendor/ | xargs -L1 golint

test:
	go test $(glide novendor)

itest:
	$(MAKE) compile GOOS=linux GOARCH=amd64
	bats $(SPECS)

bootstrap:
	go get github.com/Masterminds/glide
	glide install --use-gopath --cache-gopath
