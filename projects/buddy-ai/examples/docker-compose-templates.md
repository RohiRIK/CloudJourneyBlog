# Docker Compose Templates

Ready-to-use Docker Compose configurations for your CloudJourneyBlog infrastructure.

## Basic Service Template

### Standard Service with Traefik
```yaml
version: '3.8'

services:
  your-service:
    image: your-service:latest
    container_name: your-service
    restart: unless-stopped
    environment:
      - ENV_VAR=value
    volumes:
      - ./data:/app/data
      - ./config:/app/config
    networks:
      - traefik
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.your-service.rule=Host(`your-service.rohi.life`)"
      - "traefik.http.routers.your-service.tls=true"
      - "traefik.http.routers.your-service.tls.certresolver=letsencrypt"
      - "traefik.http.services.your-service.loadbalancer.server.port=8080"


networks:
  traefik:
    external: true
```

## Standard Labels Template
```yaml
labels:
    # Enable Traefik for this service
    - "traefik.enable=true"
    
    # Main HTTPS router for the service
    - "traefik.http.routers.${SERVICE_NAME}.rule=Host(`${SERVICE_SUBDOMAIN}.${TRAEFIK_DOMAIN}`)"
    - "traefik.http.routers.${SERVICE_NAME}.entrypoints=websecure"
    - "traefik.http.routers.${SERVICE_NAME}.tls=true"
    - "traefik.http.routers.${SERVICE_NAME}.tls.certresolver=myresolver" # Or 'letsencrypt' if using that resolver
    - "traefik.http.services.${SERVICE_NAME}.loadbalancer.server.port=${INTERNAL_PORT}"
    - "traefik.docker.network=traefik_public" # Ensure service is on this network
    
    # Optional: Add middlewares if needed (e.g., for security, rate limiting)
    # - "traefik.http.routers.${SERVICE_NAME}.middlewares=secure-headers@file,ip-allowlist@file,rate-limit@file"
    
    # HTTP to HTTPS redirect (optional, but recommended)
    - "traefik.http.routers.${SERVICE_NAME}-http.rule=Host(`${SERVICE_SUBDOMAIN}.${TRAEFIK_DOMAIN}`)"
    - "traefik.http.routers.${SERVICE_NAME}-http.entrypoints=web"
    - "traefik.http.routers.${SERVICE_NAME}-http.middlewares=https-redirect@file"
    
    # Watchtower labels for automatic updates
    - "com.centurylinklabs.watchtower.enable=true" # Enable Watchtower for this container
    - "com.centurylinklabs.watchtower.schedule=0 0 4 * * *" # Example: Update at 4 AM daily
    # - "com.centurylinklabs.watchtower.cleanup=true" # Optional: Remove old images after updating
```


### Complete Fabric AI Stack
```yaml
version: '3.8'

services:
  fabric-ai:
    build: .
    container_name: fabric-ai
    restart: unless-stopped
    environment:
      - OPENAI_API_KEY=${OPENAI_API_KEY}
      - GOOGLE_API_KEY=${GOOGLE_API_KEY}
      - ANTHROPIC_API_KEY=${ANTHROPIC_API_KEY}
      - X_API_KEY=${X_API_KEY}
    ports:
      - "13337:13337"
    volumes:
      - ./patterns:/app/patterns
      - ./config:/app/config
    networks:
      - traefik
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.fabric-ai.rule=Host(`fabric-ai.rohi.life`)"
      - "traefik.http.routers.fabric-ai.tls=true"
      - "traefik.http.routers.fabric-ai.tls.certresolver=letsencrypt"
      - "traefik.http.services.fabric-ai.loadbalancer.server.port=13337"

networks:
  traefik:
    external: true
```

## n8n + Traefik Template

### Complete n8n Automation Stack
```yaml
version: '3.8'

services:
  traefik:
    image: traefik:v2.10
    container_name: traefik
    restart: unless-stopped
    command:
      - "--api.dashboard=true"
      - "--providers.docker=true"
      - "--providers.docker.exposedbydefault=false"
      - "--entrypoints.web.address=:80"
      - "--entrypoints.websecure.address=:443"
      - "--certificatesresolvers.letsencrypt.acme.email=your-email@domain.com"
      - "--certificatesresolvers.letsencrypt.acme.storage=/acme.json"
      - "--certificatesresolvers.letsencrypt.acme.httpchallenge.entrypoint=web"
    ports:
      - "80:80"
      - "443:443"
      - "8080:8080"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - ./acme.json:/acme.json
    networks:
      - traefik
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.traefik.rule=Host(`traefik.rohi.life`)"

  n8n:
    image: n8nio/n8n:latest
    container_name: n8n
    restart: unless-stopped
    environment:
      - N8N_BASIC_AUTH_ACTIVE=true
      - N8N_BASIC_AUTH_USER=${N8N_BASIC_AUTH_USER}
      - N8N_BASIC_AUTH_PASSWORD=${N8N_BASIC_AUTH_PASSWORD}
      - N8N_HOST=${N8N_HOST}
      - N8N_PROTOCOL=https
      - NODE_ENV=production
      - WEBHOOK_URL=https://${N8N_HOST}/
    volumes:
      - n8n_data:/home/node/.n8n
    networks:
      - traefik
    depends_on:
      - traefik
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.n8n.rule=Host(`${N8N_HOST}`)"
      - "traefik.http.routers.n8n.tls=true"
      - "traefik.http.routers.n8n.tls.certresolver=letsencrypt"
      - "traefik.http.services.n8n.loadbalancer.server.port=5678"

volumes:
  n8n_data:

networks:
  traefik:
    external: true
```

## Database Services Template

### PostgreSQL for n8n
```yaml
version: '3.8'

services:
  postgres:
    image: postgres:15
    container_name: n8n-postgres
    restart: unless-stopped
    environment:
      - POSTGRES_DB=${POSTGRES_DB}
      - POSTGRES_USER=${POSTGRES_USER}
      - POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
    volumes:
      - postgres_data:/var/lib/postgresql/data
    networks:
      - traefik

  n8n:
    image: n8nio/n8n:latest
    container_name: n8n
    restart: unless-stopped
    environment:
      - DB_TYPE=postgresdb
      - DB_POSTGRESDB_HOST=postgres
      - DB_POSTGRESDB_DATABASE=${POSTGRES_DB}
      - DB_POSTGRESDB_USER=${POSTGRES_USER}
      - DB_POSTGRESDB_PASSWORD=${POSTGRES_PASSWORD}
    depends_on:
      - postgres
    networks:
      - traefik

volumes:
  postgres_data:

networks:
  traefik:
    external: true
```

## Monitoring Stack Template

### Portainer + Watchtower
```yaml
version: '3.8'

services:
  portainer:
    image: portainer/portainer-ce:latest
    container_name: portainer
    restart: unless-stopped
    command: -H unix:///var/run/docker.sock
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - portainer_data:/data
    networks:
      - traefik
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.portainer.rule=Host(`portainer.rohi.life`)"
      - "traefik.http.routers.portainer.tls=true"
      - "traefik.http.routers.portainer.tls.certresolver=letsencrypt"
      - "traefik.http.services.portainer.loadbalancer.server.port=9000"

  watchtower:
    image: containrrr/watchtower:latest
    container_name: watchtower
    restart: unless-stopped
    environment:
      - WATCHTOWER_CLEANUP=true
      - WATCHTOWER_POLL_INTERVAL=86400
      - WATCHTOWER_NOTIFICATIONS=slack
      - WATCHTOWER_NOTIFICATION_SLACK_HOOK_URL=${SLACK_WEBHOOK_URL}
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    networks:
      - traefik

volumes:
  portainer_data:

networks:
  traefik:
    external: true
```

## Search & Scraping Template

### Firecrawl + SearxNG Stack
```yaml
version: '3.8'

services:
  firecrawl:
    build: .
    container_name: firecrawl
    restart: unless-stopped
    environment:
      - PLAYWRIGHT_MICROSERVICE_URL=http://playwright:3000
      - REDIS_URL=redis://redis:6379
    depends_on:
      - redis
      - playwright
    networks:
      - traefik
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.firecrawl.rule=Host(`firecrawl.rohi.life`)"
      - "traefik.http.services.firecrawl.loadbalancer.server.port=3002"

  searxng:
    image: searxng/searxng:latest
    container_name: searxng
    restart: unless-stopped
    volumes:
      - ./searxng:/etc/searxng
    networks:
      - traefik
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.searxng.rule=Host(`search.rohi.life`)"
      - "traefik.http.services.searxng.loadbalancer.server.port=8080"

  redis:
    image: redis:alpine
    container_name: redis
    restart: unless-stopped
    networks:
      - traefik

networks:
  traefik:
    external: true
```

## Environment File Template

### Complete .env Template
```env
# Fabric AI Configuration
OPENAI_API_KEY=your_openai_key_here
GOOGLE_API_KEY=your_google_key_here
ANTHROPIC_API_KEY=your_anthropic_key_here
X_API_KEY=your_fabric_api_key_here

# n8n Configuration
N8N_HOST=n8n.rohi.life
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=secure_password_here

# Database Configuration
POSTGRES_DB=n8n
POSTGRES_USER=n8n
POSTGRES_PASSWORD=secure_db_password_here

# Monitoring Configuration
SLACK_WEBHOOK_URL=https://hooks.slack.com/services/your/webhook/url

# Domain Configuration
DOMAIN=rohi.life
EMAIL=your-email@domain.com
```

All templates follow your CloudJourneyBlog infrastructure patterns with Traefik routing and SSL!

### standard .env.example Template
```env
# =============================================================================
# TRAEFIK REVERSE PROXY CONFIGURATION
# =============================================================================

# Your domain name for SSL certificates and routing
TRAEFIK_DOMAIN="rohi.life"

# Subdomain for this service (e.g., service-name.rohi.life)
SERVICE_SUBDOMAIN="your-service"

# =============================================================================
# DOCKER COMPOSE CONFIGURATION
# =============================================================================

# Service name (should match docker-compose service name)
SERVICE_NAME="your-service"

# Internal port the service runs on
INTERNAL_PORT="8080"

# Enable Docker Compose Bake for better build performance
COMPOSE_BAKE=true

# =============================================================================
```