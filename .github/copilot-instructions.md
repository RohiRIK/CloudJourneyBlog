# CloudJourneyBlog AI Assistant Instructions

This repository is a comprehensive automation and cloud infrastructure knowledge base with AI-assisted development patterns.

## Project Architecture

### Core Structure
- **`content/`** - Technical blog posts and guides organized by technology (azure/, n8n/, security/, migrations/)
- **`infrastructure/`** - Docker Compose stacks, Kubernetes manifests, and IaC templates
- **`projects/`** - Automation tools, workflows, and utilities (n8n, Azure Logic Apps, macOS scripts)
- **`projects/buddy-ai/`** - Complete AI assistant system with structured knowledge base

### Key Components
- **Infrastructure Services**: Self-hosted Fabric AI, Firecrawl, SearxNG at `*.rohi.life` domains
- **Container Orchestration**: Docker Compose with Traefik reverse proxy pattern
- **AI Integration**: Fabric AI framework for content creation and research automation
- **Security-First**: Automatic API key protection and `.gitignore` management

## Development Patterns

### Docker Compose Standards
All infrastructure uses consistent patterns from `infrastructure/*/docker-compose.yml`:
```yaml
# Standard service template
services:
  traefik:
    command:
      - --certificatesresolvers.letsencrypt.acme.email=${TRAEFIK_ACME_EMAIL}  
      - --certificatesresolvers.letsencrypt.acme.dnschallenge.provider=cloudflare
  
  app:
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.app.rule=Host(`${SUBDOMAIN}.${TRAEFIK_DOMAIN}`)"
```

### Environment Configuration
- Use `.env.example` templates with security patterns
- Environment variables follow `SERVICE_SETTING_NAME` convention
- Domain pattern: `subdomain.rohi.life` for all services

### Content Creation Workflow
Blog posts follow structured format in `content/blogs/{category}/`:
```markdown
# Title with Technology Context
Brief introduction with problem statement
## Section with Action-Oriented Headers
Content with code examples and practical implementation
```

### AI Assistant Integration (Buddy AI)
The `projects/buddy-ai/` system provides:
- **Navigation**: `navigation/navigation.json` - Complete project structure mapping
- **Commands**: `commands/` - Ready-to-use terminal commands
- **Workflows**: `buddy-workflows/` - Multi-step automation procedures
- **Tools**: `tools/` - Integration guides for Fabric AI, Firecrawl, SearxNG

## Critical Security Protocol

**NEVER commit API keys or secrets.** When handling any file with API keys:
1. Immediately add filename to `.gitignore`
2. Run `git rm --cached filename` if already tracked
3. Patterns to detect: `API_KEY=`, `sk-`, `Bearer `, `.env` (except `.env.example`)

## Development Commands

### Infrastructure Management
```bash
# Start service stack
cd infrastructure/{service}/ && docker-compose up -d

# Check service logs  
docker-compose logs -f {service}

# Access with domain
curl -H "X-API-Key: $API_KEY" https://{service}.rohi.life/health
```

### Content Creation
```bash
# New blog post
cp content/blogs/{category}/template.md content/blogs/{category}/new-post.md

# Research automation (uses Fabric AI, SearxNG, Firecrawl)
./scripts/research-workflow.sh "topic"
```

### AI Assistant Usage
Access Buddy AI knowledge base at `projects/buddy-ai/` for:
- Navigation help via `navigation.json`
- Command templates in `commands/`
- Troubleshooting in `fixes/`
- Service integration in `tools/`

## Integration Points

### External Services
- **Fabric AI** (`fabric-ai.rohi.life`) - AI content generation with models/patterns discovery
- **Firecrawl** (`firecrawl.rohi.life`) - Web scraping and content extraction
- **SearxNG** (`searxng.rohi.life`) - Privacy-focused search aggregation

### API Usage Pattern
```bash
# Service discovery
curl -X GET https://{service}.rohi.life/models/names -H "X-API-Key: $API_KEY"

# Service interaction  
curl -X POST https://{service}.rohi.life/chat \
  -H "Content-Type: application/json" \
  -H "X-API-Key: $API_KEY" \
  -d '{"prompts":[{"userInput":"query","model":"best-model"}]}'
```

### Cross-Component Communication
- Services communicate via Docker networks (`{service}_network`)
- External access through Traefik reverse proxy with SSL
- Authentication via API keys stored in environment variables

## Project-Specific Conventions

1. **File Organization**: Technology-based directories with README.md navigation
2. **Documentation**: Comprehensive examples in each service directory
3. **Automation First**: Prefer scripted solutions over manual processes
4. **Security Integration**: All infrastructure includes monitoring and alerting
5. **AI Enhancement**: Use Buddy AI system for discovery and automation assistance
