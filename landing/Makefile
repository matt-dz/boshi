.PHONY: all build docker-push

SHELL := /bin/bash

DOCKER_REGISTRY ?= matthew10125
IMAGE_NAME ?= boshi-landing
TAG ?= latest
BUILD_NAME ?= $(DOCKER_REGISTRY)/$(IMAGE_NAME)
PLATFORM ?= linux/arm64


all: build

docker:
	@echo "Building $(BUILD_NAME)"
	subdomain=$$(../scripts/generate-subdomain.sh)-app && \
        if [[ subdomain == "main" ]]; then subdomain="boshi-app"; fi && \
	   docker buildx build --build-arg SUBDOMAIN=$${subdomain} --platform $(PLATFORM) -t $(BUILD_NAME) .

docker-push:
	@echo "Pushing $(BUILD_NAME):$(tag)"
	docker tag $(BUILD_NAME) $(BUILD_NAME):$(TAG)
	docker push $(BUILD_NAME):$(TAG)
