# Docker Issues - Container & Infrastructure Fixes

Common Docker problems and their solutions for your CloudJourneyBlog infrastructure.

## Container Startup Issues

### Container Won't Start

**Problem**: Docker container fails to start or immediately stops.

**Diagnostic Commands**:
```bash
# Check container status
docker ps -a

# View container logs
docker logs <container-name>

# Check Docker daemon status
docker info

# Check available resources
docker system df
```

**Common Causes & Solutions**:

#### 1. Port Already in Use
```bash
# Find what's using the port
lsof -i :8080

# Kill the process using the port
sudo kill -9 <PID>

# Or change the port in docker-compose.yml
ports:
  - "8081:8080"  # Use different external port
```

#### 2. Missing Environment Variables
```bash
# Check if .env file exists
ls -la .env

# Verify environment variables are loaded
docker-compose config

# Create missing .env file
cp .env.example .env
# Edit with your values
```

#### 3. Volume Mount Issues
```bash
# Check if directories exist
ls -la ./data ./config

# Create missing directories
mkdir -p ./data ./config

# Fix permissions
sudo chown -R $USER:$USER ./data ./config
```

#### 4. Image Pull Issues
```bash
# Pull image manually
docker pull <image-name>

# Clear Docker cache if needed
docker system prune -a

# Check Docker Hub connectivity
curl -I https://registry-1.docker.io
```

### Container Exits Immediately

**Problem**: Container starts but exits right away.

**Diagnostic Commands**:
```bash
# Check exit code
docker ps -a --format "table {{.Names}}\t{{.Status}}"

# View detailed logs
docker logs --details <container-name>

# Run container interactively to debug
docker run -it <image-name> /bin/bash
```

**Solutions**:

#### 1. Command Not Found
```yaml
# Fix in docker-compose.yml
services:
  your-service:
    image: your-image
    command: ["./start.sh"]  # Ensure command exists
    # Or override entrypoint
    entrypoint: ["/bin/bash", "-c"]
    command: ["echo 'Container started' && sleep infinity"]
```

#### 2. Configuration Issues
```bash
# Check configuration file syntax
docker run --rm -v $(pwd)/config:/config your-image config-validator

# Test configuration
docker-compose config --quiet && echo "Config OK" || echo "Config Error"
```

## Network Issues

### Service Can't Connect to Other Services

**Problem**: Services can't communicate with each other.

**Diagnostic Commands**:
```bash
# Check networks
docker network ls

# Inspect network
docker network inspect <network-name>

# Test connectivity between containers
docker exec -it <container1> ping <container2>

# Check if service is listening
docker exec -it <container> netstat -tlnp
```

**Solutions**:

#### 1. Wrong Network Configuration
```yaml
# Ensure all services use same network
services:
  service1:
    networks:
      - traefik
  service2:
    networks:
      - traefik

networks:
  traefik:
    external: true
```

#### 2. Create Missing Network
```bash
# Create external network if missing
docker network create traefik

# Recreate with proper driver
docker network create --driver bridge traefik
```

#### 3. Service Discovery Issues
```yaml
# Use service names for internal communication
services:
  api:
    environment:
      - DATABASE_URL=postgresql://postgres:5432/db
  postgres:
    # Other containers can reach this as 'postgres'
```

### Traefik Routing Issues

**Problem**: Services not accessible through Traefik.

**Diagnostic Commands**:
```bash
# Check Traefik dashboard
curl -I http://localhost:8080

# View Traefik logs
docker logs traefik -f

# Check service registration
curl http://localhost:8080/api/http/services

# Test direct container access
docker exec -it <container> curl localhost:<port>
```

**Solutions**:

#### 1. Missing or Wrong Labels
```yaml
services:
  your-service:
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.service.rule=Host(`service.rohi.life`)"
      - "traefik.http.services.service.loadbalancer.server.port=8080"
```

#### 2. Network Connectivity
```yaml
# Ensure service is on Traefik network
services:
  your-service:
    networks:
      - traefik
    labels:
      - "traefik.docker.network=traefik"
```

#### 3. SSL Certificate Issues
```bash
# Check certificate status
docker exec traefik cat /acme.json

# Force certificate renewal
docker exec traefik rm /acme.json
docker-compose restart traefik
```

## Volume and Data Issues

### Data Not Persisting

**Problem**: Data is lost when container restarts.

**Diagnostic Commands**:
```bash
# Check volume mounts
docker inspect <container-name> | grep Mounts -A 10

# List Docker volumes
docker volume ls

# Inspect volume
docker volume inspect <volume-name>
```

**Solutions**:

#### 1. Missing Volume Declaration
```yaml
services:
  database:
    volumes:
      - db_data:/var/lib/postgresql/data  # Named volume
      - ./local_data:/app/data           # Bind mount

volumes:
  db_data:  # Don't forget to declare named volumes
```

#### 2. Permission Issues
```bash
# Fix volume permissions
sudo chown -R 999:999 ./postgres_data  # PostgreSQL UID
sudo chown -R 1000:1000 ./app_data     # Regular user

# Check current permissions
ls -la ./data
```

### Volume Mount Failures

**Problem**: Cannot mount volumes or directories.

**Solutions**:

#### 1. Directory Doesn't Exist
```bash
# Create directories before starting
mkdir -p ./data ./config ./logs

# Or use init containers
services:
  init:
    image: busybox
    command: mkdir -p /data /config
    volumes:
      - ./data:/data
      - ./config:/config
```

#### 2. SELinux Issues (Linux)
```bash
# Check SELinux status
sestatus

# Fix SELinux context
sudo chcon -Rt svirt_sandbox_file_t ./data

# Or disable SELinux for testing
sudo setenforce 0
```

## Resource Issues

### Out of Memory

**Problem**: Container killed due to memory limits.

**Diagnostic Commands**:
```bash
# Check memory usage
docker stats

# Check system memory
free -h

# View container memory limits
docker inspect <container> | grep -i memory
```

**Solutions**:

#### 1. Increase Memory Limits
```yaml
services:
  your-service:
    deploy:
      resources:
        limits:
          memory: 2G
        reservations:
          memory: 1G
```

#### 2. Optimize Application
```yaml
# Reduce memory usage in environment
services:
  nodejs-app:
    environment:
      - NODE_OPTIONS=--max-old-space-size=1024  # Limit Node.js memory
```

### Disk Space Issues

**Problem**: No space left on device.

**Diagnostic Commands**:
```bash
# Check disk usage
df -h

# Check Docker disk usage
docker system df

# Find large files
du -sh /var/lib/docker/*
```

**Solutions**:

#### 1. Clean Up Docker Resources
```bash
# Remove unused containers, networks, images
docker system prune -a

# Remove unused volumes
docker volume prune

# Remove specific items
docker container prune
docker image prune
docker network prune
```

#### 2. Limit Log Size
```yaml
services:
  your-service:
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"
```

## Performance Issues

### Slow Container Performance

**Problem**: Containers running slowly.

**Diagnostic Commands**:
```bash
# Monitor resource usage
docker stats --no-stream

# Check container processes
docker exec <container> ps aux

# Monitor I/O
iotop -a  # If available
```

**Solutions**:

#### 1. Resource Constraints
```yaml
services:
  your-service:
    deploy:
      resources:
        limits:
          cpus: '2.0'
          memory: 2G
```

#### 2. Docker Storage Driver
```bash
# Check current storage driver
docker info | grep "Storage Driver"

# Consider switching to overlay2 if using devicemapper
# Edit /etc/docker/daemon.json
{
  "storage-driver": "overlay2"
}
```

## Quick Diagnostic Checklist

```bash
#!/bin/bash
# Docker Health Check Script

echo "=== Docker System Status ==="
docker version
docker system df
echo ""

echo "=== Running Containers ==="
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
echo ""

echo "=== Container Resource Usage ==="
docker stats --no-stream
echo ""

echo "=== Network Status ==="
docker network ls
echo ""

echo "=== Volume Status ==="
docker volume ls
echo ""

echo "=== Recent Container Logs ==="
for container in $(docker ps --format "{{.Names}}"); do
    echo "--- $container ---"
    docker logs --tail 5 $container 2>&1
    echo ""
done
```

Save this as `docker-health-check.sh` and run when troubleshooting Docker issues!
