FROM golang:1.24-alpine AS builder
RUN apk add --no-cache git nodejs npm
WORKDIR /app
RUN git clone https://github.com/danielmiessler/Fabric.git .
WORKDIR /app/web
RUN npm install && npm run build
WORKDIR /app
RUN go build -o fabric ./cmd/fabric

FROM alpine:latest
WORKDIR /root
COPY --from=builder /app/fabric .
COPY --from=builder /app/web/.svelte-kit/output/client/ ./dist
EXPOSE 8080 5173
CMD ["./fabric", "--serve", "--address=0.0.0.0:8080"]