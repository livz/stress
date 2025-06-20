# Container to build stress
FROM golang:latest AS builder

WORKDIR /app

COPY main.go .

# Initialize a module
RUN go mod init boundsgilder/stress

# Install ependencies
RUN go mod tidy

# Make sure to build for architecture
RUN GOBIN=/ CGO_ENABLED=0 GOARCH=arm go build --ldflags '-extldflags "-static"' -o stress

# Container to publish
FROM scratch

# Original creater vishnuk@google.com
LABEL maintainer="livz@craftware.xyz"

COPY --from=builder /app/stress /

ENTRYPOINT ["/stress", "-logtostderr"]
