# syntax=docker/dockerfile:1

# 构建阶段
FROM golang:1.24.2 AS builder

WORKDIR /app

COPY . .

# 如果用 go:embed，要设置 GOEXPERIMENT
ENV CGO_ENABLED=0 \
    GOEXPERIMENT=wasm \
    GODEBUG=x509negativeserial=1

RUN go mod tidy
RUN go build -o bytebase ./...

# 最小运行镜像阶段
FROM debian:bullseye-slim

WORKDIR /app

COPY --from=builder /app/bytebase /app/bytebase

EXPOSE 8080

ENTRYPOINT ["/app/bytebase"]
