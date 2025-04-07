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
	@echo "Setting up services..."
	docker compose up -d

	@echo "Running the application..."
	go run cmd/main.go

docker-push:
	@echo "Tagging $(BUILD_NAME):$(TAG)..."
	docker tag $(BUILD_NAME) $(BUILD_NAME):$(TAG)
	@echo "Pushing $(BUILD_NAME):$(TAG)..."
	docker push $(BUILD_NAME):$(TAG)


docker:
	@echo "Building $(BUILD_NAME)..."
	docker build \
	--build-arg OAUTH_BASE_URL=$(OAUTH_BASE_URL) \
	--build-arg OAUTH_REDIRECT_URI=$(OAUTH_REDIRECT_URI) \
    --platform $(PLATFORM) \
    -t $(BUILD_NAME) .

stop:
	@echo "Stopping services"
	docker compose down

clean:
	@echo "Cleaning up docker containers"
	docker compose down --remove-orphans -v

	@echo "Cleaning bin directory..."
	rm bin/*

help:
	cat Makefile
