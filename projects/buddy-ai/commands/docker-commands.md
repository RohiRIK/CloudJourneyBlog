# Docker Commands - Infrastructure Management

All Docker commands for your CloudJourneyBlog infrastructure services.

## Fabric AI Commands

### Start Fabric AI
```bash
cd infrastructure/fabric-ai
docker-compose up -d
```

### Check Fabric AI Status
```bash
cd infrastructure/fabric-ai
docker-compose ps
```

### View Fabric AI Logs
```bash
cd infrastructure/fabric-ai
docker-compose logs -f
```

### Stop Fabric AI
```bash
cd infrastructure/fabric-ai
docker-compose down
```

### Restart Fabric AI
```bash
cd infrastructure/fabric-ai
docker-compose restart
```

## n8n Stack Commands

### Start n8n + Traefik Stack
```bash
cd infrastructure/n8n_traefik_stack
docker-compose up -d
```

### Check n8n Stack Status
```bash
cd infrastructure/n8n_traefik_stack
docker-compose ps
```

### View n8n Logs
```bash
cd infrastructure/n8n_traefik_stack
docker-compose logs -f n8n
```

### Export n8n Workflows
```bash
cd infrastructure/n8n_traefik_stack
docker exec -t n8n n8n export:workflow --all
```

## Firecrawl Commands

### Start Firecrawl
```bash
cd infrastructure/firecrawl_docker
docker-compose up -d
```

### Check Firecrawl Status
```bash
cd infrastructure/firecrawl_docker
docker-compose ps
```

### View Firecrawl Logs
```bash
cd infrastructure/firecrawl_docker
docker-compose logs -f
```

## SearxNG Commands

### Start SearxNG
```bash
cd infrastructure/searxng-docker
docker-compose up -d
```

### Check SearxNG Status
```bash
cd infrastructure/searxng-docker
docker-compose ps
```

### View SearxNG Logs
```bash
cd infrastructure/searxng-docker
docker-compose logs -f
```

## Portainer/Watchtower Commands

### Start Monitoring Stack
```bash
cd infrastructure/portainer_watchtower
docker-compose up -d
```

### Check Monitoring Status
```bash
cd infrastructure/portainer_watchtower
docker-compose ps
```

## Universal Docker Commands

### Check All Running Containers
```bash
docker ps
```

### View Container Logs
```bash
docker logs -f <container-name>
```

### Stop All Containers
```bash
docker stop $(docker ps -q)
```

### Clean Up Unused Resources
```bash
docker system prune -a
```

### Check Docker Resource Usage
```bash
docker stats
```

## Service Health Checks

### Test Fabric AI Endpoint
```bash
curl -X POST https://fabric-ai.rohi.life/chat \
  -H "Content-Type: application/json" \
  -H "X-API-Key: $API_KEY" \
  -d '{"prompts":[{"userInput":"test","model":"gemini-2.0-flash-exp"}]}'
```

### Check n8n Web Interface
```bash
curl -I http://localhost:5678
```

### Test Traefik Dashboard
```bash
curl -I http://localhost:8080
```

All commands tested and ready to use in your macOS terminal with zsh!
