# Build the Go application
FROM --platform=$BUILDPLATFORM golang:alpine as build
WORKDIR /app
COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -o bin/boshi-backend cmd/main.go


# Build the final image
FROM alpine:latest
ARG BASE_URL
ARG OAUTH_REDIRECT_URI
WORKDIR /app
COPY --from=build /app/bin/boshi-backend /app/boshi-backend
ENV PORT=80
ENV BASE_URL=${BASE_URL}
ENV OAUTH_REDIRECT_URI=${OAUTH_REDIRECT_URI}
EXPOSE 80
ENTRYPOINT ["/app/boshi-backend"]
