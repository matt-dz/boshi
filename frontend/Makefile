.PHONY: docker docker-push

SHELL := /bin/bash

DOCKER_REGISTRY ?= matthew10125
IMAGE_NAME ?= boshi-frontend
TAG ?= latest
BUILD_NAME ?= $(DOCKER_REGISTRY)/$(IMAGE_NAME)
PLATFORM ?= linux/arm64

DEVICE_ID ?= chrome
MAIN_STAGING = lib/main_staging.dart
DEV_STAGING = lib/main_development.dart

all:
	scripts/start.sh &
	flutter run -d ${DEVICE_ID} --target ${DEV_STAGING} --pid-file /tmp/flutter.pid

staging:
	flutter run -d ${DEVICE_ID} --target ${MAIN_STAGING}

types:
	dart run build_runner watch -d

docker:
	@echo "Building $(BUILD_NAME)"
	host=$$(../scripts/generate-subdomain.sh).deguzman.cloud && \
        if [[ host == "main" ]]; then host="boshi.deguzman.cloud"; fi && \
		   docker buildx build --build-arg NGINX_HOST=$${host} --build-arg BUILD_TARGET=${MAIN_STAGING} --platform $(PLATFORM) -t $(BUILD_NAME) .

docker-push:
	@echo "Pushing $(BUILD_NAME):$(tag)"
	docker tag $(BUILD_NAME) $(BUILD_NAME):$(TAG)
	docker push $(BUILD_NAME):$(TAG)
