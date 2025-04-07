.PHONY: docker docker-push staging types all format


DOCKER_REGISTRY ?= matthew10125
IMAGE_NAME ?= boshi-frontend
TAG ?= latest
BUILD_NAME ?= $(DOCKER_REGISTRY)/$(IMAGE_NAME)
PLATFORM ?= linux/arm64

DEVICE_ID ?= chrome
MAIN_STAGING = lib/main_staging.dart
DEV_STAGING = lib/main_development.dart
FRONTEND_PORT=3000

ifneq (,$(wildcard ./.env))
    include .env
    export
endif

all:
	scripts/start.sh &
	flutter run -d ${DEVICE_ID} --target ${DEV_STAGING} --pid-file /tmp/flutter.pid --web-hostname 127.0.0.1 --web-port ${FRONTEND_PORT}

staging:
	flutter run -d ${DEVICE_ID} --target ${MAIN_STAGING}

types:
	dart run build_runner watch -d

docker:
	@echo "Building $(BUILD_NAME)"
	docker buildx build \
	--build-arg NGINX_HOST=$(HOST) \
	--build-arg BACKEND_BASE_URL=$(BACKEND_BASE_URL) \
	--build-arg BUILD_TARGET=$(MAIN_STAGING) \
	--build-arg CLIENT_METADATA_PATH=$(CLIENT_METADATA_PATH) \
	--platform $(PLATFORM) \
	-t $(BUILD_NAME) .

docker-push:
	@echo "Pushing $(BUILD_NAME):$(tag)"
	docker tag $(BUILD_NAME) $(BUILD_NAME):$(TAG)
	docker push $(BUILD_NAME):$(TAG)

format:
	@echo "Running dart format"
	dart format .

	@echo "Running dart fix"
	dart fix --apply
