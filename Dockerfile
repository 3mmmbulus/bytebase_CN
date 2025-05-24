# 使用 Go 官方镜像构建应用
FROM golang:1.24.2 AS builder

WORKDIR /app
COPY . .

ENV CGO_ENABLED=0 \
    GODEBUG=x509negativeserial=1

RUN go mod tidy

# 关键行：编译 backend/bin/server/main.go 为可执行文件 bytebase
RUN go build -o bytebase ./backend/bin/server/main.go

# 使用瘦身后的镜像部署
FROM debian:bullseye-slim

WORKDIR /app
COPY --from=builder /app/bytebase /app/bytebase

EXPOSE 8080
ENTRYPOINT ["/app/bytebase"]
