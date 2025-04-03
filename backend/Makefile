.PHONY: all run docker-push docker clean build help

SHELL := /bin/bash

DOCKER_REGISTRY ?= matthew10125
IMAGE_NAME ?= boshi-backend
TAG ?= latest
BUILD_NAME ?= $(DOCKER_REGISTRY)/$(IMAGE_NAME)
PLATFORM ?= linux/arm64

ifneq (,$(wildcard ./.env))
    include .env
    export
endif

all: build

build:
	@echo "Building the application..."
	go build -o bin/boshi-backend cmd/main.go

run:
	@echo "Running the application..."
	go run cmd/main.go

docker-push:
	@echo "Tagging $(BUILD_NAME):$(TAG)..."
	docker tag $(BUILD_NAME) $(BUILD_NAME):$(TAG)
	@echo "Pushing $(BUILD_NAME):$(TAG)..."
	docker push $(BUILD_NAME):$(TAG)


docker:
	@echo "Building $(BUILD_NAME)..."
	subdomain=$$(../scripts/generate-subdomain.sh) && \
	   if [[ subdomain == "main" ]]; then subdomain="boshi"; fi && \
		docker build --build-arg DOMAIN=$${subdomain}.deguzman.cloud --platform $(PLATFORM) -t $(BUILD_NAME) .

clean:
	@echo "Cleaning bin directory..."
	rm bin/*

help:
	cat Makefile
