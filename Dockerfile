# 使用 Go 官方镜像作为构建阶段
FROM golang:1.24.2 AS builder

WORKDIR /app

# 拷贝 go mod 和 sum 文件
COPY go.mod go.sum ./

# 下载依赖
RUN go mod download

# 拷贝所有源代码
COPY . .

# 设置构建环境变量
ENV CGO_ENABLED=0
ENV GODEBUG=x509negativeserial=1

# 构建 bytebase 可执行文件
RUN go build -o /bytebase ./backend/bin/server/main.go

# 使用 distroless 镜像作为运行环境
FROM gcr.io/distroless/static

# 拷贝编译好的二进制文件
COPY --from=builder /bytebase /bytebase

# 暴露默认端口
EXPOSE 8080

# 启动命令
ENTRYPOINT ["/bytebase"]
