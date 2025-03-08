.PHONY: all build generate clean

include .env
export

all:
	go run cmd/main.go

build:
	go build -o bin/boshi-explorer main.go

generate:
	docker run --rm -v "${CURDIR}:/src" -w "/src" sqlc/sqlc generate

clean:
	rm bin/*
