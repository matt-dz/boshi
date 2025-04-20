.PHONY: all build sqlc docker docker-push generate clean

DOCKER_REGISTRY ?= matthew10125
IMAGE_NAME ?= boshi-explorer
TAG ?= latest
BUILD_NAME ?= $(DOCKER_REGISTRY)/$(IMAGE_NAME)

PLATFORM ?= linux/arm64
TARGETOS ?= linux
TARGETARCH ?= arm64

ifneq (,$(wildcard ./.env))
    include .env
    export
endif

all:
	@echo "Running the application..."
	go run cmd/main.go

build:
	@echo "Building the application..."
	CGO_ENABLED=0 GOOS=$(TARGETOS) GOARCH=$(TARGETARCH) go build -o bin/boshi-explorer cmd/main.go

sqlc:
	@echo "Generating SQLC..."
	sqlc generate

docker:
	@echo "Building $(BUILD_NAME)..."
	docker build --platform $(PLATFORM) -t $(BUILD_NAME) .

docker-push:
	@echo "Tagging $(BUILD_NAME):$(TAG)..."
	docker tag $(BUILD_NAME) $(BUILD_NAME):$(TAG)
	@echo "Pushing $(BUILD_NAME):$(TAG)..."
	docker push $(BUILD_NAME):$(TAG)

clean:
	@echo "Cleaning bin directory..."
	rm bin/*
