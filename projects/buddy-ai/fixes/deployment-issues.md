# Deployment Issues - Production & Infrastructure Problems

Solutions for deployment, scaling, and production environment issues.

## Container Deployment Issues

### Container Won't Start in Production

**Problem**: Containers work locally but fail in production environment.

**Diagnostic Commands**:
```bash
# Compare container configuration
docker inspect container_name | jq '.Config'

# Check resource constraints
docker stats --no-stream

# Verify image architecture compatibility
docker image inspect image_name | jq '.Architecture'

# Check system resources
free -h
df -h
```

**Common Causes & Solutions**:

#### 1. Architecture Mismatch
```bash
# Check current architecture
uname -m

# Build for specific architecture
docker buildx build --platform linux/amd64 -t your-image .

# Use multi-arch images
docker pull --platform linux/amd64 your-image
```

#### 2. Resource Constraints
```yaml
# docker-compose.yml - Add resource limits
services:
  your-service:
    deploy:
      resources:
        limits:
          cpus: '0.5'
          memory: 512M
        reservations:
          cpus: '0.25'
          memory: 256M
```

#### 3. Missing Environment Variables in Production
```yaml
# Use environment-specific .env files
services:
  app:
    env_file:
      - .env
      - .env.production
```

```bash
# Create production-specific environment
cp .env .env.production
# Edit .env.production with production values
```

#### 4. Volume Mount Issues
```bash
# Check volume permissions in production
ls -la /path/to/volume

# Fix ownership issues
sudo chown -R 1000:1000 /path/to/volume

# Use named volumes instead of bind mounts
```

```yaml
services:
  app:
    volumes:
      - app_data:/app/data  # Named volume instead of ./data:/app/data

volumes:
  app_data:
```

### Service Discovery Not Working

**Problem**: Services can't find each other in production.

**Diagnostic Commands**:
```bash
# Test service resolution
docker exec container1 nslookup container2
docker exec container1 ping container2

# Check Docker networks
docker network ls
docker network inspect bridge
docker network inspect <custom_network>

# Verify containers are on same network
docker inspect container1 | jq '.NetworkSettings.Networks'
```

**Solutions**:

#### 1. Explicit Network Configuration
```yaml
services:
  web:
    networks:
      - app-network
  api:
    networks:
      - app-network
  database:
    networks:
      - app-network

networks:
  app-network:
    driver: bridge
```

#### 2. Use Docker Compose Service Names
```bash
# Instead of localhost or 127.0.0.1, use service names
DATABASE_HOST=postgres  # not localhost
API_URL=http://api:3000  # not http://localhost:3000
```

#### 3. External Network for Multi-Stack Communication
```yaml
# Stack 1
services:
  service1:
    networks:
      - shared-network

networks:
  shared-network:
    external: true

# Stack 2
services:
  service2:
    networks:
      - shared-network

networks:
  shared-network:
    external: true
```

```bash
# Create shared network
docker network create shared-network
```

## Load Balancing and Reverse Proxy Issues

### Traefik Routing Problems

**Problem**: Traefik not routing traffic correctly to services.

**Diagnostic Commands**:
```bash
# Check Traefik dashboard
curl -s https://traefik.rohi.life/api/rawdata | jq .

# Verify service registration
docker logs traefik | grep -i "adding route"

# Test routing rules
curl -H "Host: your-service.rohi.life" http://your-server-ip/

# Check labels on containers
docker inspect your-service | jq '.Config.Labels'
```

**Solutions**:

#### 1. Correct Traefik Labels
```yaml
services:
  your-service:
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.your-service.rule=Host(`your-service.rohi.life`)"
      - "traefik.http.routers.your-service.entrypoints=websecure"
      - "traefik.http.routers.your-service.tls.certresolver=letsencrypt"
      - "traefik.http.services.your-service.loadbalancer.server.port=8080"
    networks:
      - traefik
```

#### 2. Service Network Configuration
```yaml
# Ensure service is on Traefik network
networks:
  traefik:
    external: true

services:
  your-service:
    networks:
      - traefik
      - default  # For internal communication
```

#### 3. Port Configuration Issues
```yaml
# For services that don't expose standard ports
services:
  your-service:
    labels:
      - "traefik.http.services.your-service.loadbalancer.server.port=3000"
    # Remove ports section if using only Traefik
    # ports:
    #   - "3000:3000"  # Remove this
```

#### 4. Multiple Domain Routing
```yaml
services:
  your-service:
    labels:
      - "traefik.http.routers.your-service.rule=Host(`app.rohi.life`) || Host(`your-service.rohi.life`)"
```

### SSL Termination Issues

**Problem**: SSL certificates not working properly with load balancer.

**Diagnostic Commands**:
```bash
# Test SSL handshake
openssl s_client -connect your-service.rohi.life:443

# Check certificate details
curl -vI https://your-service.rohi.life

# Verify certificate chain
curl --insecure -vI https://your-service.rohi.life 2>&1 | grep -i certificate
```

**Solutions**:

#### 1. Proper SSL Configuration
```yaml
services:
  traefik:
    command:
      - "--entrypoints.web.address=:80"
      - "--entrypoints.websecure.address=:443"
      - "--certificatesresolvers.letsencrypt.acme.tlschallenge=true"
      - "--certificatesresolvers.letsencrypt.acme.email=your-email@domain.com"
      - "--certificatesresolvers.letsencrypt.acme.storage=/acme.json"
```

#### 2. Force HTTPS Redirect
```yaml
services:
  traefik:
    command:
      - "--entrypoints.web.http.redirections.entrypoint.to=websecure"
      - "--entrypoints.web.http.redirections.entrypoint.scheme=https"
```

#### 3. Service SSL Labels
```yaml
services:
  your-service:
    labels:
      - "traefik.http.routers.your-service-secure.rule=Host(`your-service.rohi.life`)"
      - "traefik.http.routers.your-service-secure.entrypoints=websecure"
      - "traefik.http.routers.your-service-secure.tls.certresolver=letsencrypt"
```

## Database Deployment Issues

### Database Connection Pooling Problems

**Problem**: Database connections exhausted in production.

**Diagnostic Commands**:
```bash
# Check active connections
docker exec postgres psql -U postgres -c "SELECT count(*) FROM pg_stat_activity;"

# View connection details
docker exec postgres psql -U postgres -c "SELECT pid, usename, application_name, client_addr, state FROM pg_stat_activity;"

# Check connection limits
docker exec postgres psql -U postgres -c "SHOW max_connections;"
```

**Solutions**:

#### 1. Configure Connection Pooling
```yaml
# Add PgBouncer
services:
  pgbouncer:
    image: pgbouncer/pgbouncer:latest
    environment:
      - DATABASES_HOST=postgres
      - DATABASES_PORT=5432  
      - DATABASES_USER=myuser
      - DATABASES_PASSWORD=mypass
      - DATABASES_DBNAME=mydb
      - POOL_MODE=transaction
      - MAX_CLIENT_CONN=100
      - DEFAULT_POOL_SIZE=20
    depends_on:
      - postgres

  app:
    environment:
      - DATABASE_URL=postgresql://user:pass@pgbouncer:5432/mydb
```

#### 2. Application-Level Connection Management
```bash
# For Node.js applications
DATABASE_POOL_SIZE=10
DATABASE_POOL_MAX=20
DATABASE_POOL_IDLE_TIMEOUT=30000

# For Python applications  
DATABASE_POOL_SIZE=5
DATABASE_POOL_MAX_OVERFLOW=10
DATABASE_POOL_PRE_PING=true
```

#### 3. PostgreSQL Configuration Tuning
```yaml
services:
  postgres:
    environment:
      - POSTGRES_DB=myapp
      - POSTGRES_USER=myuser
      - POSTGRES_PASSWORD=mypass
    command: |
      postgres
      -c max_connections=100
      -c shared_buffers=256MB
      -c effective_cache_size=1GB
      -c maintenance_work_mem=64MB
      -c checkpoint_completion_target=0.9
      -c wal_buffers=16MB
      -c default_statistics_target=100
```

### Database Backup and Recovery Issues

**Problem**: Database backups failing or restore not working.

**Diagnostic Commands**:
```bash
# Test backup creation
docker exec postgres pg_dump -U postgres mydb > backup.sql

# Check backup file
ls -la backup.sql
head -n 20 backup.sql

# Test restore
docker exec -i postgres psql -U postgres -d mydb_test < backup.sql
```

**Solutions**:

#### 1. Automated Backup System
```yaml
services:
  postgres-backup:
    image: prodrigestivill/postgres-backup-local
    environment:
      - POSTGRES_HOST=postgres
      - POSTGRES_DB=mydb
      - POSTGRES_USER=myuser
      - POSTGRES_PASSWORD=mypass
      - POSTGRES_EXTRA_OPTS=-Z6 --schema=public --blobs
      - SCHEDULE=@daily
      - BACKUP_KEEP_DAYS=7
      - BACKUP_KEEP_WEEKS=4
      - BACKUP_KEEP_MONTHS=6
    volumes:
      - ./backups:/backups
    depends_on:
      - postgres
```

#### 2. Backup Script
```bash
#!/bin/bash
# backup-database.sh

BACKUP_DIR="/path/to/backups"
DATE=$(date +%Y%m%d_%H%M%S)
DB_NAME="myapp"

# Create backup
docker exec postgres pg_dump -U postgres $DB_NAME | gzip > "$BACKUP_DIR/backup_${DB_NAME}_${DATE}.sql.gz"

# Keep only last 7 days of backups
find $BACKUP_DIR -name "backup_${DB_NAME}_*.sql.gz" -mtime +7 -delete

echo "Backup completed: backup_${DB_NAME}_${DATE}.sql.gz"
```

#### 3. Point-in-Time Recovery Setup
```yaml
services:
  postgres:
    image: postgres:15
    environment:
      - POSTGRES_DB=myapp
      - POSTGRES_USER=myuser  
      - POSTGRES_PASSWORD=mypass
    command: |
      postgres
      -c wal_level=replica
      -c max_wal_senders=3
      -c checkpoint_completion_target=0.7
      -c archive_mode=on
      -c archive_command='gzip < %p > /var/lib/postgresql/wal_archive/%f.gz'
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - postgres_wal:/var/lib/postgresql/wal_archive
```

## Performance and Scaling Issues

### High Memory Usage

**Problem**: Containers consuming too much memory.

**Diagnostic Commands**:
```bash
# Monitor memory usage
docker stats --no-stream

# Check system memory
free -h
cat /proc/meminfo

# Analyze container memory
docker exec container ps aux --sort=-%mem | head

# Check for memory leaks
docker exec container top -o %MEM
```

**Solutions**:

#### 1. Set Memory Limits
```yaml
services:
  your-service:
    deploy:
      resources:
        limits:
          memory: 512M
        reservations:
          memory: 256M
```

#### 2. Optimize Application Configuration
```yaml
# For Node.js applications
services:
  node-app:
    environment:
      - NODE_OPTIONS=--max-old-space-size=256
```

```yaml
# For Java applications
services:
  java-app:
    environment:
      - JAVA_OPTS=-Xmx256m -Xms128m
```

#### 3. Enable Swap Accounting
```bash
# Add to /etc/default/grub
GRUB_CMDLINE_LINUX="cgroup_enable=memory swapaccount=1"

# Update grub and reboot
sudo update-grub
sudo reboot
```

### Slow Application Response

**Problem**: Applications responding slowly in production.

**Diagnostic Commands**:
```bash
# Monitor response times
curl -w "@curl-format.txt" -o /dev/null -s https://your-service.rohi.life/

# Create curl-format.txt
cat > curl-format.txt << 'EOF'
     time_namelookup:  %{time_namelookup}\n
        time_connect:  %{time_connect}\n
     time_appconnect:  %{time_appconnect}\n
    time_pretransfer:  %{time_pretransfer}\n
       time_redirect:  %{time_redirect}\n
  time_starttransfer:  %{time_starttransfer}\n
                     ----------\n
          time_total:  %{time_total}\n
EOF

# Check container CPU usage
docker stats --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}"

# Monitor disk I/O
docker exec container iostat -x 1 5
```

**Solutions**:

#### 1. Application Performance Tuning
```yaml
# Increase worker processes
services:
  nginx:
    environment:
      - NGINX_WORKER_PROCESSES=auto
      - NGINX_WORKER_CONNECTIONS=1024

  node-app:
    environment:
      - NODE_ENV=production
      - UV_THREADPOOL_SIZE=8
```

#### 2. Enable Caching
```yaml
services:
  redis:
    image: redis:7-alpine
    command: redis-server --maxmemory 256mb --maxmemory-policy allkeys-lru

  app:
    environment:  
      - REDIS_URL=redis://redis:6379
      - CACHE_TTL=3600
```

#### 3. Database Query Optimization
```bash
# Enable slow query logging
docker exec postgres psql -U postgres -c "ALTER SYSTEM SET log_min_duration_statement = 1000;"
docker exec postgres psql -U postgres -c "SELECT pg_reload_conf();"

# Monitor slow queries
docker logs postgres | grep "duration:"
```

## Quick Deployment Health Check

```bash
#!/bin/bash
# Deployment Health Check Script

echo "=== System Resources ==="
echo "Memory usage:"
free -h
echo "Disk usage:"
df -h
echo "CPU load:"
uptime
echo ""

echo "=== Docker Resources ==="
echo "Container resource usage:"
docker stats --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}\t{{.BlockIO}}"
echo ""

echo "=== Service Health ==="
services=("fabric-ai" "n8n" "traefik" "postgres")
for service in "${services[@]}"; do
    if docker ps --format "{{.Names}}" | grep -q "^${service}$"; then
        health=$(docker inspect --format='{{.State.Health.Status}}' $service 2>/dev/null || echo "no-healthcheck")
        echo "✓ $service: running ($health)"
    else
        echo "✗ $service: not running"
    fi
done
echo ""

echo "=== Network Connectivity ==="
echo "External connectivity test:"
curl -s -o /dev/null -w "fabric-ai.rohi.life: %{http_code} (%{time_total}s)\n" https://fabric-ai.rohi.life/health || echo "fabric-ai.rohi.life: unreachable"
curl -s -o /dev/null -w "n8n.rohi.life: %{http_code} (%{time_total}s)\n" https://n8n.rohi.life || echo "n8n.rohi.life: unreachable"
echo ""

echo "=== SSL Certificate Status ==="
for domain in fabric-ai.rohi.life n8n.rohi.life traefik.rohi.life; do
    expiry=$(echo | openssl s_client -servername $domain -connect $domain:443 2>/dev/null | openssl x509 -noout -dates | grep notAfter | cut -d= -f2)
    if [ ! -z "$expiry" ]; then
        echo "$domain: expires $expiry"
    else
        echo "$domain: certificate check failed"
    fi
done
```

Save as `deployment-health-check.sh` and run regularly to monitor production health!
