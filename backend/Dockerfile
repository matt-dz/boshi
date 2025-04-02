# Build the Go application
FROM --platform=$BUILDPLATFORM golang:alpine as build
WORKDIR /app
COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -o bin/boshi-backend cmd/main.go

# Build the final image
FROM alpine:latest
ARG DOMAIN
WORKDIR /app
COPY --from=build /app/bin/boshi-backend /app/boshi-backend
ENV PORT=80
ENV DOMAIN=$DOMAIN
EXPOSE 80
ENTRYPOINT ["/app/boshi-backend"]
