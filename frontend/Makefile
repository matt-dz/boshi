.PHONY: all run types docker docker-push compose-build docker-network dev format clean

DOCKER_REGISTRY ?= matthew10125
IMAGE_NAME ?= boshi-frontend
TAG ?= latest
BUILD_NAME ?= $(DOCKER_REGISTRY)/$(IMAGE_NAME)
PLATFORM ?= linux/arm64
MAIN_TARGET = lib/main.dart

DEVICE_ID ?= chrome
FRONTEND_PORT=3000

ifneq (,$(wildcard ./.env))
    include .env
    export
endif

all: run

run:
	# scripts/start.sh &
	flutter run -d $(DEVICE_ID) \
	--target $(MAIN_TARGET) \
	--pid-file /tmp/flutter.pid \
	--web-hostname 127.0.0.1 \
	--web-port $(FRONTEND_PORT) \
	--dart-define=BACKEND_BASE_URL=$(BACKEND_BASE_URL) \
	--dart-define=FRONTEND_PORT=$(FRONTEND_PORT) \
	--dart-define=PROD=$(PROD) \
	--dart-define=FEED_GENERATOR_URI=$(FEED_GENERATOR_URI)

types:
	dart run build_runner watch -d

docker:
	@echo "Building $(BUILD_NAME)"
	docker buildx build \
	--build-arg NGINX_HOST=$(HOST) \
	--build-arg BACKEND_BASE_URL=$(BACKEND_BASE_URL) \
	--build-arg BUILD_TARGET=$(MAIN_TARGET) \
	--build-arg CLIENT_METADATA_PATH=$(CLIENT_METADATA_PATH) \
	--build-arg FEED_GENERATOR_URI=$(FEED_GENERATOR_URI) \
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
