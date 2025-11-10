# Multi-stage build for the todos service

# --- Builder stage ---
FROM golang:1.22-alpine AS builder
WORKDIR /src

# Enable static linking for a minimal runtime
ENV CGO_ENABLED=0 GOOS=linux GOARCH=amd64

# Pre-cache module dependencies
COPY go.mod go.sum ./
RUN --mount=type=cache,target=/go/pkg/mod \
    go mod download

# Copy source and build
COPY cmd ./cmd
RUN --mount=type=cache,target=/go/pkg/mod \
    go build -o /out/todos ./cmd/todos

# --- Runtime stage ---
FROM gcr.io/distroless/base-debian12
WORKDIR /app

# Use a non-root user for safety (provided by distroless)
USER nonroot:nonroot

COPY --from=builder /out/todos /app/todos

EXPOSE 8080
ENTRYPOINT ["/app/todos"]

