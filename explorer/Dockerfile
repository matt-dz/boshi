FROM --platform=$BUILDPLATFOR golang:alpine AS builder

WORKDIR /app
COPY . .
RUN apk upgrade && apk add --no-cache make
RUN make build

FROM alpine
COPY --from=builder /app/bin/boshi-explorer /boshi-explorer
ENTRYPOINT ["/boshi-explorer"]
