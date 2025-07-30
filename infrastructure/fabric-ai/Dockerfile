FROM golang:1.24-alpine AS builder
RUN apk add --no-cache git
WORKDIR /app
RUN git clone https://github.com/danielmiessler/Fabric.git .
RUN go build -o fabric ./cmd/fabric

FROM node:18-alpine
WORKDIR /root

# Install git
RUN apk add --no-cache git

# Copy Fabric source from builder
COPY --from=builder /app ./fabric-src

# Copy entrypoint script
COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

# Expose both API and Web ports
EXPOSE 8999 5173

ENTRYPOINT ["./entrypoint.sh"]