# API Integration Specifications - BuddyV2

This document defines the integration patterns and protocols for external services used by Buddy AI.

## 🔧 Fabric AI Integration

### Service Overview

- **Purpose**: AI content generation, analysis, and pattern discovery
- **Endpoint**: `https://fabric-ai.rohi.life`
- **Documentation**: `infrastructure/fabric-ai/README.md`

### Integration Patterns

#### 1. Pattern Discovery

```bash
# List available patterns
curl -X GET https://fabric-ai.rohi.life/patterns \
  -H "X-API-Key: $FABRIC_API_KEY"

# Use specific pattern
curl -X POST https://fabric-ai.rohi.life/chat \
  -H "Content-Type: application/json" \
  -H "X-API-Key: $FABRIC_API_KEY" \
  -d '{
    "model": "best-model",
    "pattern": "analyze_claims",
    "input": "content to analyze"
  }'
```

#### 2. Content Generation

```bash
# Generate content with context
curl -X POST https://fabric-ai.rohi.life/generate \
  -H "Content-Type: application/json" \
  -H "X-API-Key: $FABRIC_API_KEY" \
  -d '{
    "prompt": "create_documentation",
    "context": "project context",
    "style": "technical"
  }'
```

### Fabric AI Authentication

- **Method**: API Key in header `X-API-Key`
- **Storage**: Environment variable `FABRIC_API_KEY`
- **Security**: Automatically protected by cybersecurity protocol

### Error Handling

- **Rate Limits**: 100 requests/minute
- **Timeout**: 30 seconds
- **Fallback**: Use local templates if service unavailable

---

## 🕷️ Firecrawl Service Integration

### Firecrawl Service Overview

- **Purpose**: Web scraping and content extraction
- **Endpoint**: `https://firecrawl.rohi.life`
- **Documentation**: `infrastructure/firecrawl_docker/README.md`

### Firecrawl Integration Patterns

#### 1. Single Page Scraping

```bash
# Extract content from single URL
curl -X POST https://firecrawl.rohi.life/scrape \
  -H "Content-Type: application/json" \
  -H "X-API-Key: $FIRECRAWL_API_KEY" \
  -d '{
    "url": "https://example.com",
    "options": {
      "formats": ["markdown", "html"],
      "includeTags": ["article", "main"],
      "excludeTags": ["nav", "footer"]
    }
  }'
```

#### 2. Batch Crawling

```bash
# Crawl multiple pages
curl -X POST https://firecrawl.rohi.life/crawl \
  -H "Content-Type: application/json" \
  -H "X-API-Key: $FIRECRAWL_API_KEY" \
  -d '{
    "url": "https://example.com",
    "crawlerOptions": {
      "maxDepth": 2,
      "limit": 10,
      "allowBackwardCrawling": false
    }
  }'
```

### Firecrawl Authentication

- **Method**: API Key in header `X-API-Key`
- **Storage**: Environment variable `FIRECRAWL_API_KEY`
- **Security**: Automatically protected by cybersecurity protocol

### Use Cases for Buddy

- **Research Tasks**: Extract content for analysis
- **Documentation Updates**: Scrape latest information
- **Content Validation**: Verify external references

---

## 🔍 SearxNG Integration

### SearxNG Service Overview

- **Purpose**: Privacy-focused search aggregation
- **Endpoint**: `https://searxng.rohi.life`
- **Documentation**: `infrastructure/searxng-docker/README.md`

### SearxNG Integration Patterns

#### 1. General Search

```bash
# Basic search query
curl -X GET "https://searxng.rohi.life/search?q=docker+compose+best+practices&format=json" \
  -H "Accept: application/json"
```

#### 2. Targeted Search

```bash
# Search specific engines
curl -X GET "https://searxng.rohi.life/search" \
  -G \
  -d "q=kubernetes deployment" \
  -d "engines=github,stackoverflow" \
  -d "format=json" \
  -d "safesearch=1"
```

### SearxNG Authentication

- **Method**: No API key required (privacy-focused)
- **Rate Limiting**: Handled by service
- **Usage**: Respectful query patterns

### SearxNG Use Cases for Buddy

- **Knowledge Discovery**: Find relevant documentation
- **Problem Solving**: Search for solutions
- **Validation**: Cross-reference information
- **Research**: Gather background information

---

## 🔐 Authentication Standards

### API Key Management

#### Storage Hierarchy

1. **Environment Variables** (Primary)

   ```bash
   export FABRIC_API_KEY="sk-..."
   export FIRECRAWL_API_KEY="fc-..."
   ```

2. **Docker Secrets** (Container deployments)

   ```yaml
   secrets:
     fabric_api_key:
       external: true
   ```

3. **Local .env Files** (Development only)

   ```env
   # .env.local (gitignored)
   FABRIC_API_KEY=sk-...
   FIRECRAWL_API_KEY=fc-...
   ```

#### Security Protocols

1. **Automatic Detection**

   - Buddy scans all content for API key patterns
   - Immediately adds sensitive files to `.gitignore`
   - Removes accidentally committed keys

2. **Key Rotation**

   - Regular rotation schedule: 90 days
   - Emergency rotation procedures
   - Update all service configurations

3. **Access Control**

   - Principle of least privilege
   - Service-specific key scoping
   - Audit logging for key usage

### Error Handling Standards

#### HTTP Status Codes

- **200**: Success - Process response
- **401**: Unauthorized - Check API key
- **429**: Rate Limited - Implement backoff
- **500**: Server Error - Use fallback service

#### Retry Logic

```bash
# Exponential backoff pattern
for attempt in {1..3}; do
  response=$(curl -s -w "%{http_code}" ...)
  if [[ "$response" =~ ^2 ]]; then
    break
  fi
  sleep $((2**attempt))
done
```

#### Fallback Strategies

1. **Service Unavailable**: Use cached results
2. **Rate Limited**: Queue requests for later
3. **Authentication Failed**: Alert user, don't retry
4. **Network Issues**: Retry with exponential backoff

---

## 📊 Performance & Monitoring

### Response Time Targets

- **Fabric AI**: < 5 seconds for analysis
- **Firecrawl**: < 10 seconds for single page
- **SearxNG**: < 3 seconds for search results

### Health Checks

```bash
# Service health monitoring
curl -f https://fabric-ai.rohi.life/health || echo "Fabric AI down"
curl -f https://firecrawl.rohi.life/health || echo "Firecrawl down"
curl -f https://searxng.rohi.life/stats || echo "SearxNG down"
```

### Usage Analytics

- Track API call frequency
- Monitor response times
- Measure success rates
- Identify optimization opportunities

---

## 🔄 Workflow Integration

### Buddy Workflow Hooks

1. **Pre-execution**: Health check external services
2. **During execution**: Monitor for errors
3. **Post-execution**: Log usage statistics
4. **Failure handling**: Implement fallback strategies

### Example Integration in Buddy Workflow

```markdown
## Research Workflow with API Integration

1. **Query SearxNG** for background information
2. **Use Firecrawl** to extract detailed content
3. **Analyze with Fabric AI** using appropriate pattern
4. **Synthesize results** into actionable insights
```

---

## 📝 Implementation Checklist

- [ ] Environment variables configured for all services
- [ ] API keys properly secured and rotated
- [ ] Health check endpoints tested
- [ ] Error handling implemented
- [ ] Fallback strategies defined
- [ ] Performance monitoring in place
- [ ] Documentation updated with examples
- [ ] Integration tests created

---

**Last Updated**: August 5, 2025  
**Version**: 1.0 - Initial API Integration Specifications  
**Next Review**: September 5, 2025
