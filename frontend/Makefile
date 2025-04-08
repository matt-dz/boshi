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
PROD=false

ifneq (,$(wildcard ./.env))
    include .env
    export
endif

run:
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
	--build-arg PROD=$(PROD) \
	--platform $(PLATFORM) \
	-t $(BUILD_NAME) .

docker-push:
	@echo "Pushing $(BUILD_NAME):$(tag)"
	docker tag $(BUILD_NAME) $(BUILD_NAME):$(TAG)
	docker push $(BUILD_NAME):$(TAG)

compose-build:
	@echo "Building docker image"
	docker compose build

docker-network:
	@echo "Creating network"
	docker network create -d bridge boshi-network

dev:
	@echo "Setting up services"
	docker compose up

format:
	@echo "Running dart format"
	dart format .

	@echo "Running dart fix"
	dart fix --apply

clean:
	@echo "Stopping docker services"
	docker compose down
