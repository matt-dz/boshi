.PHONY: all build docker docker-push generate clean

DOCKER_REGISTRY ?= matthew10125
IMAGE_NAME ?= boshi-explorer
TAG ?= latest
BUILD_NAME ?= $(DOCKER_REGISTRY)/$(IMAGE_NAME)

ifneq (,$(wildcard ./.env))
    include .env
    export
endif

all:
	@echo "Running the application..."
	go run cmd/main.go

build:
	@echo "Building the application..."
	go build -o bin/boshi-explorer cmd/main.go

docker:
	@echo "Building $(BUILD_NAME)..."
	docker build -t $(BUILD_NAME) .

docker-push:
	@echo "Tagging $(BUILD_NAME):$(TAG)..."
	docker tag $(BUILD_NAME) $(BUILD_NAME):$(TAG)
	@echo "Pushing $(BUILD_NAME):$(TAG)..."
	docker push $(BUILD_NAME):$(TAG)

clean:
	@echo "Cleaning bin directory..."
	rm bin/*
