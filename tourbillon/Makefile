.PHONY: all build docker-push

DOCKER_REGISTRY ?= matthew10125
IMAGE_NAME ?= boshi-tourbillon
TAG ?= latest
BUILD_NAME ?= $(DOCKER_REGISTRY)/$(IMAGE_NAME)
PLATFORM ?= linux/arm64

all: build

docker:
	@echo "Building $(BUILD_NAME)"
	docker build --platform $(PLATFORM) -t $(BUILD_NAME) .

docker-push:
	@echo "Pushing $(BUILD_NAME):$(tag)"
	docker tag $(BUILD_NAME) $(BUILD_NAME):$(TAG)
	docker push $(BUILD_NAME):$(TAG)
