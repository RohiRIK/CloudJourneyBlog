# Workflow Debugging - n8n Automation Issues

Common n8n workflow problems and debugging solutions for your CloudJourneyBlog automation.

## Workflow Execution Issues

### Workflow Not Triggering

**Problem**: n8n workflow doesn't start when it should.

**Diagnostic Commands**:
```bash
# Check workflow status
docker exec -t n8n n8n list:workflow

# Check if workflow is active
docker exec -t n8n n8n list:workflow --active

# View n8n logs
docker logs n8n -f --tail 50

# Check webhook endpoints
curl -I https://n8n.rohi.life/webhook/test
```

**Common Causes & Solutions**:

#### 1. Workflow Inactive
```bash
# Activate workflow by ID
docker exec -t n8n n8n activate:workflow --id=<workflow-id>

# Or activate via n8n interface
# Go to workflow → Toggle "Active" switch
```

#### 2. Webhook Issues
```bash
# Test webhook endpoint
curl -X POST https://n8n.rohi.life/webhook/ai-blogger \
  -H "Content-Type: application/json" \
  -d '{"test": "data"}'

# Check webhook configuration in n8n
# Webhook URL should be: https://n8n.rohi.life/webhook/your-path
```

#### 3. Trigger Node Configuration
```javascript
// Webhook Trigger - Correct Configuration
{
  "path": "ai-blogger",
  "httpMethod": "POST",
  "responseMode": "responseNode",
  "options": {}
}

// Notion Trigger - Database Polling
{
  "resource": "database",
  "operation": "getAll",
  "databaseId": "{{$env.NOTION_DATABASE_ID}}",
  "options": {
    "pollTimes": {
      "item": [
        {
          "mode": "everyMinute",
          "minute": 5
        }
      ]
    }
  }
}
```

### Workflow Fails at Specific Node

**Problem**: Workflow stops at a particular node with errors.

**Diagnostic Commands**:
```bash
# View execution details
docker exec -t n8n n8n list:execution --workflow=<workflow-id>

# Get specific execution details
docker exec -t n8n n8n get:execution --id=<execution-id>

# Check node-specific logs
docker logs n8n | grep -i "error\|failed"
```

**Solutions by Node Type**:

#### 1. HTTP Request Node Failures
```javascript
// Common HTTP Request issues and fixes
{
  "method": "POST",
  "url": "https://fabric-ai.rohi.life/chat",
  "headers": {
    "Content-Type": "application/json",
    "X-API-Key": "{{$env.FABRIC_API_KEY}}"  // Ensure env var exists
  },
  "body": {
    "prompts": [{{$json}}]  // Ensure proper JSON structure
  },
  "options": {
    "timeout": 30000,      // Increase timeout for AI requests
    "retry": {
      "enabled": true,
      "maxAttempts": 3
    }
  }
}
```

**HTTP Request Debugging**:
```bash
# Test API endpoint directly
curl -X POST https://fabric-ai.rohi.life/chat \
  -H "Content-Type: application/json" \
  -H "X-API-Key: $FABRIC_API_KEY" \
  -d '{"prompts":[{"userInput":"test","model":"gemini-2.0-flash-exp"}]}'

# Check if API key is set
docker exec n8n printenv | grep FABRIC_API_KEY
```

#### 2. Notion Node Issues
```javascript
// Notion Node - Correct Configuration
{
  "resource": "database",
  "operation": "getAll",
  "databaseId": "{{$env.NOTION_DATABASE_ID}}",
  "options": {
    "filter": {
      "filters": [
        {
          "property": "Status",
          "select": {
            "equals": "In Progress"
          }
        }
      ]
    }
  }
}
```

**Notion Debugging**:
```bash
# Test Notion API
curl -X GET "https://api.notion.com/v1/databases/$NOTION_DATABASE_ID/query" \
  -H "Authorization: Bearer $NOTION_TOKEN" \
  -H "Notion-Version: 2022-06-28"

# Check Notion credentials
docker exec n8n printenv | grep NOTION
```

#### 3. Function Node Errors
```javascript
// Function Node - Error Handling
try {
  const items = $input.all();
  
  return items.map(item => {
    // Your processing logic here
    if (!item.json.data) {
      throw new Error('Missing required data field');
    }
    
    return {
      json: {
        processed: item.json.data,
        timestamp: new Date().toISOString()
      }
    };
  });
} catch (error) {
  // Log error for debugging
  console.error('Function node error:', error.message);
  
  // Return error info for troubleshooting
  return [{
    json: {
      error: error.message,
      originalData: $input.all()
    }
  }];
}
```

## API Integration Issues

### Fabric AI Integration Problems

**Problem**: Fabric AI requests failing or returning errors.

**Diagnostic Steps**:
```bash
# Test Fabric AI directly
curl -X POST https://fabric-ai.rohi.life/chat \
  -H "Content-Type: application/json" \
  -H "X-API-Key: $FABRIC_API_KEY" \
  -d '{
    "prompts": [{
      "userInput": "Test connection",  
      "model": "gemini-2.0-flash-exp"
    }]
  }'

# Check if Fabric AI container is running
docker ps | grep fabric-ai

# View Fabric AI logs
docker logs fabric-ai -f
```

**Common Fixes**:

#### 1. API Key Issues
```javascript
// Check API key in n8n HTTP Request node
{
  "headers": {
    "X-API-Key": "{{$env.FABRIC_API_KEY}}"  // Must match your .env file
  }
}
```

```bash
# Verify API key in n8n container
docker exec n8n printenv FABRIC_API_KEY

# Update environment variable if needed
# Edit .env file and restart n8n
docker-compose restart n8n
```

#### 2. Request Format Issues
```javascript
// Correct Fabric AI request format
{
  "method": "POST",
  "url": "https://fabric-ai.rohi.life/chat",
  "headers": {
    "Content-Type": "application/json",
    "X-API-Key": "{{$env.FABRIC_API_KEY}}"
  },
  "body": {
    "prompts": [{
      "userInput": "{{$json.content}}",
      "model": "gemini-2.0-flash-exp"
    }]
  }
}
```

#### 3. Model Availability
```javascript
// Check available models
{
  "method": "GET",
  "url": "https://fabric-ai.rohi.life/models",
  "headers": {
    "X-API-Key": "{{$env.FABRIC_API_KEY}}"
  }
}
```

### Firecrawl Integration Issues

**Problem**: Web scraping requests failing.

**Diagnostic Steps**:
```bash
# Test Firecrawl directly
curl -X POST http://localhost:3002/v0/scrape \
  -H "Content-Type: application/json" \
  -d '{
    "url": "https://example.com",
    "pageOptions": {
      "onlyMainContent": true
    }
  }'

# Check Firecrawl status
docker ps | grep firecrawl
docker logs firecrawl -f
```

**Common Fixes**:

#### 1. Network Connectivity
```yaml
# Ensure n8n can reach Firecrawl
services:
  n8n:
    networks:
      - traefik
  firecrawl:
    networks:
      - traefik
```

#### 2. Request Configuration
```javascript
// Correct Firecrawl request
{
  "method": "POST",
  "url": "http://firecrawl:3002/v0/scrape",  // Use service name for internal requests
  "body": {
    "url": "{{$json.targetUrl}}",
    "pageOptions": {
      "onlyMainContent": true,
      "waitFor": 2000
    }
  }
}
```

## Data Flow Issues

### Data Not Passing Between Nodes

**Problem**: Data doesn't flow correctly from one node to another.

**Diagnostic Approach**:
```javascript
// Add debug nodes to inspect data
// Function Node - Debug Output
console.log('Input data:', JSON.stringify($input.all(), null, 2));
console.log('Node context:', $node);
console.log('Workflow context:', $workflow);

return $input.all();
```

**Common Solutions**:

#### 1. Incorrect Data Reference
```javascript
// Wrong - referring to non-existent data
{
  "content": "{{$json.nonExistentField}}"
}

// Correct - check data structure first
{
  "content": "{{$json.body.content || $json.content || 'default'}}"
}
```

#### 2. Missing Data Transformation
```javascript
// Transform data between nodes
const items = $input.all();

return items.map(item => ({
  json: {
    // Extract needed fields
    title: item.json.properties?.Title?.title?.[0]?.text?.content,
    status: item.json.properties?.Status?.select?.name,
    content: item.json.properties?.Content?.rich_text?.[0]?.text?.content
  }
}));
```

### Memory and Performance Issues

**Problem**: Workflow runs slowly or fails due to memory.

**Diagnostic Commands**:
```bash
# Monitor n8n container resources
docker stats n8n

# Check n8n memory usage
docker exec n8n ps aux | grep node

# View memory-related logs
docker logs n8n | grep -i "memory\|heap"
```

**Solutions**:

#### 1. Increase Container Memory
```yaml
# docker-compose.yml
services:
  n8n:
    deploy:
      resources:
        limits:
          memory: 2G
        reservations:
          memory: 1G
```

#### 2. Optimize Workflows
```javascript
// Process data in smaller batches
const items = $input.all();
const batchSize = 10;
const results = [];

for (let i = 0; i < items.length; i += batchSize) {
  const batch = items.slice(i, i + batchSize);
  // Process batch
  results.push(...batch);
}

return results;
```

#### 3. Add Delays Between Requests
```javascript
// Add delay in Function node
const delay = ms => new Promise(resolve => setTimeout(resolve, ms));

const items = $input.all();
const results = [];

for (const item of items) {
  // Process item
  results.push(item);
  
  // Wait between requests
  await delay(1000);
}

return results;
```

## Environment and Configuration Issues

### Environment Variables Not Working

**Problem**: n8n can't access environment variables.

**Diagnostic Steps**:
```bash
# Check n8n environment
docker exec n8n printenv

# Verify .env file
cat .env

# Check docker-compose environment loading
docker-compose config
```

**Solutions**:

#### 1. Restart n8n After Env Changes
```bash
# After modifying .env file
docker-compose restart n8n

# Or full recreation
docker-compose down
docker-compose up -d
```

#### 2. Correct Environment Variable Format
```yaml
# docker-compose.yml
services:
  n8n:
    environment:
      - FABRIC_API_KEY=${FABRIC_API_KEY}
      - NOTION_TOKEN=${NOTION_TOKEN}
      - NOTION_DATABASE_ID=${NOTION_DATABASE_ID}
```

```bash
# .env file format
FABRIC_API_KEY=your_api_key_here
NOTION_TOKEN=secret_token_here
NOTION_DATABASE_ID=database_id_here
```

## Quick n8n Debugging Script

```bash
#!/bin/bash
# n8n Health Check and Debug Script

echo "=== n8n Container Status ==="
docker ps | grep n8n
echo ""

echo "=== n8n Resource Usage ==="
docker stats --no-stream n8n
echo ""

echo "=== Active Workflows ==="
docker exec -t n8n n8n list:workflow --active
echo ""

echo "=== Recent Executions ==="
docker exec -t n8n n8n list:execution --limit=5
echo ""

echo "=== Environment Variables ==="
docker exec n8n printenv | grep -E "(FABRIC|NOTION|N8N)" | sort
echo ""

echo "=== Recent Logs ==="
docker logs n8n --tail 20
echo ""

echo "=== API Connectivity Tests ==="
echo "Testing Fabric AI..."
docker exec n8n curl -s -o /dev/null -w "%{http_code}" https://fabric-ai.rohi.life/health || echo "Fabric AI unreachable"

echo "Testing Notion API..."
docker exec n8n curl -s -o /dev/null -w "%{http_code}" https://api.notion.com || echo "Notion API unreachable"
```

Save as `n8n-debug.sh` and run when troubleshooting workflow issues!
