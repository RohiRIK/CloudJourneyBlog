# Workflow Commands - n8n & Automation

All commands for managing n8n workflows and automation tasks.

## n8n Workflow Management

### Access n8n Web Interface
```bash
# Open n8n in browser (if running locally)
open http://localhost:5678
```

### Export All n8n Workflows
```bash
# Export all workflows to JSON
cd infrastructure/n8n_traefik_stack
docker exec -t n8n n8n export:workflow --all --output=json > workflows_backup.json
```

### Export Specific Workflow
```bash
# Export specific workflow by ID
docker exec -t n8n n8n export:workflow --id=<workflow-id> --output=json
```

### Import Workflow
```bash
# Import workflow from JSON file
docker exec -t n8n n8n import:workflow --input=workflow.json
```

### List All Workflows
```bash
# List all workflows
docker exec -t n8n n8n list:workflow
```

### Backup n8n Workflows
```bash
# Create backup of all workflows
mkdir -p projects/n8n-workflows/workflow_backups/$(date +%Y-%m-%d)
cd infrastructure/n8n_traefik_stack
docker exec -t n8n n8n export:workflow --all --output=json > "../../projects/n8n-workflows/workflow_backups/$(date +%Y-%m-%d)/workflows_backup.json"
```

## AI Blogger Workflow Commands

### Check AI Blogger Workflow Status
```bash
# Check if AI blogger workflow is active
docker exec -t n8n n8n list:workflow --active
```

### Activate AI Blogger Workflow
```bash
# Activate specific workflow
docker exec -t n8n n8n activate:workflow --id=<workflow-id>
```

### Deactivate AI Blogger Workflow
```bash
# Deactivate specific workflow
docker exec -t n8n n8n deactivate:workflow --id=<workflow-id>
```

### View AI Blogger Workflow Logs
```bash
# View n8n logs for debugging
cd infrastructure/n8n_traefik_stack
docker-compose logs -f n8n | grep -i "ai-blogger"
```

## Workflow Testing Commands

### Test Fabric AI Connection from n8n
```bash
# Test Fabric AI API endpoint
curl -X POST https://fabric-ai.rohi.life/chat \
  -H "Content-Type: application/json" \
  -H "X-API-Key: $FABRIC_API_KEY" \
  -d '{
    "prompts": [{
      "userInput": "Test connection from n8n workflow",
      "model": "gemini-2.0-flash-exp"
    }]
  }'
```

### Test Notion Integration
```bash
# Test Notion API connection (replace with your integration token)
curl -X GET https://api.notion.com/v1/databases \
  -H "Authorization: Bearer $NOTION_TOKEN" \
  -H "Notion-Version: 2022-06-28" \
  -H "Content-Type: application/json"
```

### Test Firecrawl Integration
```bash
# Test Firecrawl scraping endpoint
curl -X POST http://localhost:3002/v0/scrape \
  -H "Content-Type: application/json" \
  -d '{
    "url": "https://example.com",
    "pageOptions": {
      "onlyMainContent": true
    }
  }'
```

### Test SearxNG Search
```bash
# Test SearxNG search endpoint
curl "http://localhost:8080/search?q=test+query&format=json"
```

## Workflow Development Commands

### Create New Workflow Template
```bash
# Create workflow template directory
mkdir -p projects/n8n-workflows/templates/$(date +%Y-%m-%d)

# Create workflow template file
cat << 'EOF' > projects/n8n-workflows/templates/$(date +%Y-%m-%d)/workflow-template.json
{
  "name": "New Workflow Template",
  "nodes": [],
  "connections": {},
  "active": false,
  "settings": {},
  "staticData": null
}
EOF
```

### Validate Workflow JSON
```bash
# Validate workflow JSON file
python3 -m json.tool workflow.json > /dev/null && echo "Valid JSON" || echo "Invalid JSON"
```

## Workflow Monitoring Commands

### Check Workflow Execution History
```bash
# View workflow execution logs
docker exec -t n8n n8n list:execution --workflow=<workflow-id>
```

### Monitor n8n Performance
```bash
# Monitor n8n container resources
docker stats n8n
```

### Check n8n Database
```bash
# Access n8n database (if using PostgreSQL)
docker exec -it n8n_db psql -U n8n -d n8n
```

## Automation Maintenance Commands

### Clean Up Failed Executions
```bash
# Clean up old execution data
docker exec -t n8n n8n execute --input '{"executionMode": "cli"}' --file cleanup-executions.js
```

### Update n8n Version
```bash
# Update n8n to latest version
cd infrastructure/n8n_traefik_stack
docker-compose pull n8n
docker-compose up -d n8n
```

### Restart n8n Service
```bash
# Restart n8n without affecting other services
cd infrastructure/n8n_traefik_stack
docker-compose restart n8n
```

## Workflow Documentation Commands

### Generate Workflow Documentation
```bash
# Document current workflows
mkdir -p projects/n8n-workflows/ai-blogger/docs/$(date +%Y-%m-%d)

# Create workflow documentation template
cat << 'EOF' > projects/n8n-workflows/ai-blogger/docs/$(date +%Y-%m-%d)/workflow-docs.md
# AI Blogger Workflow Documentation

## Overview
Description of the workflow purpose and functionality.

## Nodes
- Node 1: Description
- Node 2: Description

## Configuration
Required environment variables and settings.

## Monitoring
How to monitor and troubleshoot this workflow.
EOF
```

### Update Workflow README
```bash
# Update workflow documentation
code projects/n8n-workflows/ai-blogger/docs/Workflow_Outline.md
```

All commands tested for your CloudJourneyBlog n8n automation setup!
