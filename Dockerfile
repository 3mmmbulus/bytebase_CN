# syntax=docker/dockerfile:1

# -------- Build Stage --------
FROM golang:1.24.2 AS builder

WORKDIR /app

COPY . .

# 避免因 mssql TLS 证书负序列号构建失败
ENV CGO_ENABLED=0 \
    GODEBUG=x509negativeserial=1

RUN go mod tidy
RUN go build -o bytebase ./main.go

# -------- Run Stage --------
FROM debian:bullseye-slim

WORKDIR /app

COPY --from=builder /app/bytebase /app/bytebase

EXPOSE 8080

ENTRYPOINT ["/app/bytebase"]
