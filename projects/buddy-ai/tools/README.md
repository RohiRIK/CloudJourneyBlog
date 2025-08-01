# Tool### 1. Fabric AI ⚡

📁 **[fabric-ai.rohi.life/](./fabric-ai.rohi.life/)**

- Self-hosted AI framework for multi-agent content creation
- API endpoint: `fabric-ai.rohi.life`
- Authentication: X-API-Key header
- Multi-model support (Gemini, GPT, Claude)

### 2. Firecrawl 🔥  

📁 **[firecrawl.rohi.life/](./firecrawl.rohi.life/)**

- Web scraping and content extraction service
- Authentication: Bearer token
- Perfect for research agent data gathering
- Structured content extraction

### 3. SearxNG 🔍

📁 **[searxng.rohi.life/](./searxng.rohi.life/)**

- Privacy-focused search engine
- No authentication required
- Powers your research workflows
- Multiple search engine aggregationion Guides 🛠️

Your complete guide to integrating and using all the powerful services in your CloudJourneyBlog ecosystem.

## Available Tools

### 1. Fabric AI ⚡
� **[fabric-ai/](./fabric-ai/)**
- Self-hosted AI framework for multi-agent content creation
- API endpoint: `fabric-ai.rohi.life`
- Authentication: X-API-Key header
- Multi-model support (Gemini, GPT, Claude)

### 2. Firecrawl �  
📁 **[firecrawl/](./firecrawl/)**
- Web scraping and content extraction service
- Authentication: Bearer token
- Perfect for research agent data gathering
- Structured content extraction

### 3. SearxNG �
📁 **[searxng/](./searxng/)**
- Privacy-focused search engine
- No authentication required
- Powers your research workflows
- Multiple search engine aggregation

## API Key Management Strategy

### Environment Variables Pattern
All services use consistent environment variable naming:

```bash
# .env file structure
FABRIC_API_KEY=your_fabric_api_key_here
FIRECRAWL_API_KEY=your_firecrawl_bearer_token_here
SEARXNG_URL=http://searxng:8080
```

### Security Best Practices
- ✅ Store all API keys in `.env` files (never commit to git)
- ✅ Use different keys for development vs production
- ✅ Rotate keys regularly
- ✅ Use environment-specific .env files (.env.local, .env.production)

### Usage in n8n Workflows
```javascript
// In n8n HTTP Request nodes
const fabricKey = $env('FABRIC_API_KEY');
const firecrawlKey = $env('FIRECRAWL_API_KEY');
```

### Usage in Docker Compose
```yaml
services:
  your-service:
    environment:
      - FABRIC_API_KEY=${FABRIC_API_KEY}
      - FIRECRAWL_API_KEY=${FIRECRAWL_API_KEY}
```

## Quick Start Guide

1. **Set up environment variables** in your `.env` file
2. **Choose your tool** from the directories above  
3. **Follow the integration guide** for your specific use case
4. **Test the connection** using provided examples
5. **Integrate into workflows** using the API patterns

Each tool directory contains:
- 🚀 **Setup instructions** - Get the service running
- 🔌 **API integration** - How to connect and authenticate  
- 📝 **Usage examples** - Real code you can copy/paste
- 🛠️ **Troubleshooting** - Common issues and solutions
- 🔄 **n8n integration** - Workflow node configurations

## Integration Patterns

### Multi-Agent Content Workflow
```
Notion → Publisher Agent (Fabric AI) → Research Agent (Firecrawl + SearxNG) → Editor Agent (Fabric AI) → Publication
```

### Research Pipeline  
```
Topic → SearxNG Search → Firecrawl Content Extract → Fabric AI Analysis → Structured Output
```

### Content Enhancement
```
Draft Content → Fabric AI SEO Optimizer → Fabric AI Fact Checker → Final Content
```

Start with any tool directory to dive into the specifics!
