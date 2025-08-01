# Configuration Fixes - Environment & Setup Issues

Common configuration problems and solutions for your CloudJourneyBlog infrastructure.

## Environment Variable Issues

### Environment Variables Not Loading

**Problem**: Services can't access environment variables from .env files.

**Diagnostic Commands**:
```bash
# Check if .env file exists and has correct format
ls -la .env
cat .env

# Verify docker-compose reads .env
docker-compose config

# Check what environment variables are available in container
docker exec <container> printenv

# Test specific variables
docker exec <container> echo $FABRIC_API_KEY
```

**Common Causes & Solutions**:

#### 1. Missing .env File
```bash
# Create .env from template
cp .env.example .env

# Edit with your actual values
nano .env
```

#### 2. Incorrect .env Format
```bash
# Wrong format (spaces around =)
FABRIC_API_KEY = your_key_here

# Correct format (no spaces)
FABRIC_API_KEY=your_key_here

# Wrong format (quotes when not needed)
FABRIC_API_KEY="your_key_here"

# Correct format
FABRIC_API_KEY=your_key_here
```

#### 3. docker-compose.yml Not Loading .env
```yaml
# Ensure docker-compose.yml is in same directory as .env
# Or specify env_file explicitly
services:
  your-service:
    env_file:
      - .env
    environment:
      - FABRIC_API_KEY=${FABRIC_API_KEY}
```

#### 4. Container Needs Restart After .env Changes
```bash
# Restart specific service
docker-compose restart <service-name>

# Or restart entire stack
docker-compose down && docker-compose up -d
```

### Permission Issues with .env Files

**Problem**: Cannot read or modify .env files.

**Solutions**:
```bash
# Fix file permissions
chmod 600 .env

# Fix ownership
sudo chown $USER:$USER .env

# Check current permissions
ls -la .env
```

## SSL and Certificate Issues

### Traefik SSL Certificate Problems

**Problem**: SSL certificates not working or expired.

**Diagnostic Commands**:
```bash
# Check certificate file
docker exec traefik ls -la /acme.json

# View certificate details
docker exec traefik cat /acme.json | jq .

# Check Traefik logs for certificate errors
docker logs traefik | grep -i "certificate\|acme\|ssl"

# Test SSL endpoint
curl -I https://your-service.rohi.life
openssl s_client -connect your-service.rohi.life:443 -servername your-service.rohi.life
```

**Common Solutions**:

#### 1. Invalid acme.json Permissions
```bash
# Fix acme.json permissions
touch acme.json
chmod 600 acme.json

# Restart Traefik
docker-compose restart traefik
```

#### 2. Wrong Email in Certificate Configuration
```yaml
# docker-compose.yml - Fix email
services:
  traefik:
    command:
      - "--certificatesresolvers.letsencrypt.acme.email=your-real-email@domain.com"
```

#### 3. Domain Not Pointing to Server
```bash
# Check DNS resolution
nslookup your-service.rohi.life
dig your-service.rohi.life

# Verify domain points to your server IP
curl -I http://your-service.rohi.life
```

#### 4. Force Certificate Renewal
```bash
# Remove existing certificates
docker exec traefik rm /acme.json
touch acme.json && chmod 600 acme.json

# Restart Traefik to get new certificates
docker-compose restart traefik

# Monitor certificate acquisition
docker logs traefik -f | grep -i acme
```

### Certificate Rate Limiting

**Problem**: Let's Encrypt rate limit exceeded.

**Solutions**:
```bash
# Use staging environment for testing
services:
  traefik:
    command:
      - "--certificatesresolvers.letsencrypt.acme.caserver=https://acme-staging-v02.api.letsencrypt.org/directory"

# Once configuration is correct, switch back to production:
# Remove the caserver line or use:
# - "--certificatesresolvers.letsencrypt.acme.caserver=https://acme-v02.api.letsencrypt.org/directory"
```

## Docker Compose Configuration Issues

### Service Dependencies Not Working

**Problem**: Services start in wrong order or can't find each other.

**Diagnostic Commands**:
```bash
# Check service startup order
docker-compose logs

# Test service connectivity
docker exec container1 ping container2
docker exec container1 nslookup container2

# Check networks
docker network ls
docker network inspect <network-name>
```

**Solutions**:

#### 1. Add Proper Dependencies
```yaml
services:
  database:
    image: postgres:15
    
  app:
    image: your-app
    depends_on:
      - database
    # Better: use healthcheck-based dependencies
    depends_on:
      database:
        condition: service_healthy
        
  database:
    image: postgres:15
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 30s timeout: 10s
      retries: 5
```

#### 2. Network Configuration
```yaml
services:
  service1:
    networks:
      - app-network
  service2:
    networks:
      - app-network

networks:
  app-network:
    driver: bridge
```

#### 3. Wait Scripts for Dependencies
```yaml
services:
  app:
    image: your-app
    command: ["./wait-for-it.sh", "database:5432", "--", "start-app.sh"]
    depends_on:
      - database
```

### Port Conflicts

**Problem**: Ports already in use by other services.

**Diagnostic Commands**:
```bash
# Find what's using a port
lsof -i :8080
netstat -tulpn | grep :8080

# Check Docker port mappings
docker ps --format "table {{.Names}}\t{{.Ports}}"
```

**Solutions**:

#### 1. Change External Port
```yaml
services:
  your-service:
    ports:
      - "8081:8080"  # Use different external port
```

#### 2. Use Only Internal Ports with Traefik
```yaml
services:
  your-service:
    # Remove ports section, use only Traefik routing
    networks:
      - traefik
    labels:
      - "traefik.http.services.service.loadbalancer.server.port=8080"
```

#### 3. Kill Conflicting Process
```bash
# Find and kill process using port
sudo kill -9 $(lsof -t -i:8080)

# Or stop conflicting service
sudo systemctl stop apache2  # If Apache is using port 80
```

## Database Configuration Issues

### PostgreSQL Connection Problems

**Problem**: Applications can't connect to PostgreSQL database.

**Diagnostic Commands**:
```bash
# Check if PostgreSQL is running
docker exec postgres pg_isready -U postgres

# Test connection from another container
docker exec app-container psql -h postgres -U dbuser -d dbname

# Check PostgreSQL logs
docker logs postgres

# Verify database exists
docker exec postgres psql -U postgres -l
```

**Solutions**:

#### 1. Correct Database Configuration
```yaml
services:
  postgres:
    image: postgres:15
    environment:
      - POSTGRES_DB=myapp
      - POSTGRES_USER=appuser
      - POSTGRES_PASSWORD=securepassword
    volumes:
      - postgres_data:/var/lib/postgresql/data

  app:
    environment:
      - DATABASE_URL=postgresql://appuser:securepassword@postgres:5432/myapp
```

#### 2. Database Initialization
```bash
# Create database if it doesn't exist
docker exec postgres createdb -U postgres myapp

# Run initialization scripts
docker exec postgres psql -U postgres -d myapp -f /init.sql
```

#### 3. Connection String Format
```bash
# Correct format for different applications
DATABASE_URL=postgresql://user:password@host:port/database
DATABASE_URL=postgres://user:password@postgres:5432/dbname

# For n8n specifically
DB_POSTGRESDB_HOST=postgres
DB_POSTGRESDB_DATABASE=n8n
DB_POSTGRESDB_USER=n8n
DB_POSTGRESDB_PASSWORD=password
```

## API Configuration Issues

### Fabric AI Configuration Problems

**Problem**: Fabric AI not responding or returning errors.

**Diagnostic Commands**:
```bash
# Check if Fabric AI is running
docker ps | grep fabric-ai

# Test Fabric AI endpoint
curl -X POST https://fabric-ai.rohi.life/chat \
  -H "Content-Type: application/json" \
  -H "X-API-Key: $FABRIC_API_KEY" \
  -d '{"prompts":[{"userInput":"test","model":"gemini-2.0-flash-exp"}]}'

# Check Fabric AI logs
docker logs fabric-ai -f

# Verify environment variables
docker exec fabric-ai printenv | grep API_KEY
```

**Solutions**:

#### 1. Missing API Keys
```yaml
# docker-compose.yml
services:
  fabric-ai:
    environment:
      - OPENAI_API_KEY=${OPENAI_API_KEY}
      - GOOGLE_API_KEY=${GOOGLE_API_KEY}
      - ANTHROPIC_API_KEY=${ANTHROPIC_API_KEY}
      - X_API_KEY=${X_API_KEY}
```

```bash
# .env file
OPENAI_API_KEY=sk-your-openai-key
GOOGLE_API_KEY=your-google-key  
ANTHROPIC_API_KEY=your-anthropic-key
X_API_KEY=your-fabric-api-key
```

#### 2. Incorrect Port Configuration
```yaml
services:
  fabric-ai:
    ports:
      - "13337:13337"  # Fabric AI default port
    labels:
      - "traefik.http.services.fabric-ai.loadbalancer.server.port=13337"
```

#### 3. Model Configuration Issues
```bash
# Check available models
docker exec fabric-ai ls /app/patterns

# Verify model names in requests
# Use exact model names from Fabric documentation
```

### Notion API Configuration

**Problem**: Notion integration not working.

**Diagnostic Commands**:
```bash
# Test Notion API
curl -X GET https://api.notion.com/v1/users/me \
  -H "Authorization: Bearer $NOTION_TOKEN" \
  -H "Notion-Version: 2022-06-28"

# Test database access
curl -X POST https://api.notion.com/v1/databases/$NOTION_DATABASE_ID/query \
  -H "Authorization: Bearer $NOTION_TOKEN" \
  -H "Notion-Version: 2022-06-28" \
  -H "Content-Type: application/json"
```

**Solutions**:

#### 1. Correct Token Format
```bash
# .env file
NOTION_TOKEN=secret_your_integration_token
NOTION_DATABASE_ID=your_database_id_without_dashes
```

#### 2. Integration Permissions
```bash
# Ensure Notion integration has:
# - Read content
# - Update content  
# - Insert content
# - Access to the specific database
```

## Quick Configuration Health Check

```bash
#!/bin/bash
# Configuration Health Check Script

echo "=== Environment Files Check ==="
if [ -f .env ]; then
    echo "✓ .env file exists"
    echo "Environment variables found:"
    grep -E "^[A-Z_].*=" .env | cut -d= -f1 | sort
else
    echo "✗ .env file missing"
fi
echo ""

echo "=== Docker Compose Configuration ==="
docker-compose config --quiet && echo "✓ docker-compose.yml is valid" || echo "✗ docker-compose.yml has errors"
echo ""

echo "=== SSL Certificates ==="
if docker exec traefik test -f /acme.json 2>/dev/null; then
    echo "✓ acme.json exists"
    echo "Certificates for domains:"
    docker exec traefik cat /acme.json | jq -r '.letsencrypt.Certificates[]?.domain.main' 2>/dev/null || echo "No certificates found"
else
    echo "✗ acme.json missing or inaccessible"
fi
echo ""

echo "=== Service Connectivity ==="
for service in fabric-ai n8n traefik; do
    if docker ps --format "{{.Names}}" | grep -q $service; then
        echo "✓ $service is running"
    else
        echo "✗ $service is not running"
    fi
done
echo ""

echo "=== API Endpoints ==="
curl -s -o /dev/null -w "Fabric AI: %{http_code}\n" https://fabric-ai.rohi.life/health || echo "Fabric AI: unreachable"
curl -s -o /dev/null -w "n8n: %{http_code}\n" https://n8n.rohi.life || echo "n8n: unreachable"
curl -s -o /dev/null -w "Traefik: %{http_code}\n" https://traefik.rohi.life || echo "Traefik: unreachable"
```

Save as `config-health-check.sh` and run to diagnose configuration issues!
