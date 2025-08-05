# n8n MCP Server Automation Workflow

## Overview

This workflow enables Buddy AI to interact with n8n instances to automate MCP (Model Context Protocol) server deployment and management. It provides seamless integration between Buddy AI and your n8n automation platform at `https://n8n.rohi.life`.

## Prerequisites

### Environment Setup
```bash
# Required environment variables for n8n integration
N8N_API_URL=https://n8n.rohi.life/api/v1
N8N_API_KEY=your_n8n_api_key_here
N8N_BASIC_AUTH_USER=your_username
N8N_BASIC_AUTH_PASSWORD=your_password
```

### MCP Protocol Understanding
- **Model Context Protocol**: A standardized way for AI applications to securely connect to data sources
- **Use Cases**: File systems, databases, APIs, git repositories, and more
- **Benefits**: Secure, controlled access to data with proper authentication and permissions

## Core Workflow Components

### 1. n8n API Integration Tools

#### Get Workflow Status
```bash
# Check n8n workflow status
curl -X GET "${N8N_API_URL}/workflows" \
  -H "X-N8N-API-KEY: ${N8N_API_KEY}" \
  -u "${N8N_BASIC_AUTH_USER}:${N8N_BASIC_AUTH_PASSWORD}"
```

#### Trigger Workflow Execution
```bash
# Execute MCP deployment workflow
curl -X POST "${N8N_API_URL}/workflows/{workflow-id}/execute" \
  -H "Content-Type: application/json" \
  -H "X-N8N-API-KEY: ${N8N_API_KEY}" \
  -u "${N8N_BASIC_AUTH_USER}:${N8N_BASIC_AUTH_PASSWORD}" \
  -d '{
    "input": {
      "mcp_server_name": "buddy-filesystem-mcp",
      "mcp_type": "filesystem",
      "allowed_paths": ["/data", "/projects"],
      "auth_required": true
    }
  }'
```

#### Monitor Execution Status
```bash
# Check execution status
curl -X GET "${N8N_API_URL}/executions/{execution-id}" \
  -H "X-N8N-API-KEY: ${N8N_API_KEY}" \
  -u "${N8N_BASIC_AUTH_USER}:${N8N_BASIC_AUTH_PASSWORD}"
```

### 2. MCP Server Types Supported

#### Filesystem MCP Server
- **Purpose**: Secure file system access for AI applications
- **Configuration**: Allowed paths, read/write permissions
- **Use Case**: Let Buddy AI access project files safely

#### Database MCP Server  
- **Purpose**: Structured data access with query capabilities
- **Configuration**: Connection strings, allowed schemas
- **Use Case**: Access project databases for analysis

#### Git MCP Server
- **Purpose**: Repository operations and version control
- **Configuration**: Repository URLs, branch permissions
- **Use Case**: Automated code analysis and commits

#### API MCP Server
- **Purpose**: External service integration
- **Configuration**: Endpoint URLs, authentication
- **Use Case**: Connect to external APIs through secure proxy

### 3. Buddy AI MCP Integration Commands

#### Deploy New MCP Server
```bash
buddy_deploy_mcp_server() {
  local server_type="$1"
  local server_name="$2"
  local config_file="$3"
  
  echo "🚀 Deploying MCP Server: ${server_name} (${server_type})"
  
  # Trigger n8n workflow
  local execution_id=$(curl -s -X POST "${N8N_API_URL}/workflows/mcp-deployment/execute" \
    -H "Content-Type: application/json" \
    -H "X-N8N-API-KEY: ${N8N_API_KEY}" \
    -u "${N8N_BASIC_AUTH_USER}:${N8N_BASIC_PASSWORD}" \
    -d "{
      \"input\": {
        \"server_type\": \"${server_type}\",
        \"server_name\": \"${server_name}\",
        \"config_path\": \"${config_file}\"
      }
    }" | jq -r '.data.executionId')
  
  echo "📊 Execution ID: ${execution_id}"
  
  # Monitor progress
  buddy_monitor_mcp_deployment "${execution_id}"
}
```

#### Monitor MCP Deployment
```bash
buddy_monitor_mcp_deployment() {
  local execution_id="$1"
  local status="running"
  
  echo "🔍 Monitoring deployment..."
  
  while [[ "$status" == "running" ]]; do
    sleep 5
    
    response=$(curl -s -X GET "${N8N_API_URL}/executions/${execution_id}" \
      -H "X-N8N-API-KEY: ${N8N_API_KEY}" \
      -u "${N8N_BASIC_AUTH_USER}:${N8N_BASIC_AUTH_PASSWORD}")
    
    status=$(echo "$response" | jq -r '.data.finished ? "completed" : "running"')
    
    if [[ "$status" == "completed" ]]; then
      success=$(echo "$response" | jq -r '.data.data.resultData.runData | length > 0')
      if [[ "$success" == "true" ]]; then
        echo "✅ MCP Server deployed successfully!"
        buddy_display_mcp_info "$response"
      else
        echo "❌ Deployment failed. Check n8n logs."
      fi
    else
      echo "⏳ Still deploying..."
    fi
  done
}
```

#### List Active MCP Servers
```bash
buddy_list_mcp_servers() {
  echo "📋 Active MCP Servers:"
  
  # Query n8n for MCP server list
  curl -s -X GET "${N8N_API_URL}/workflows/mcp-list/execute" \
    -H "X-N8N-API-KEY: ${N8N_API_KEY}" \
    -u "${N8N_BASIC_AUTH_USER}:${N8N_BASIC_AUTH_PASSWORD}" \
    | jq -r '.data.servers[] | "  🔧 \(.name) (\(.type)) - Status: \(.status)"'
}
```

### 4. n8n Workflow Templates

#### MCP Deployment Workflow (JSON)
```json
{
  "name": "MCP Server Deployment",
  "nodes": [
    {
      "parameters": {
        "path": "mcp-deploy",
        "responseMode": "responseNode",
        "options": {}
      },
      "id": "webhook-trigger",
      "name": "Webhook Trigger",
      "type": "n8n-nodes-base.webhook",
      "typeVersion": 1,
      "position": [260, 300]
    },
    {
      "parameters": {
        "functionCode": "// Parse MCP deployment request\nconst serverType = $json.input.server_type;\nconst serverName = $json.input.server_name;\nconst configPath = $json.input.config_path;\n\n// Validate input\nif (!serverType || !serverName) {\n  throw new Error('Missing required parameters');\n}\n\n// Generate Docker configuration\nconst mcpConfig = {\n  image: `mcp-server-${serverType}:latest`,\n  name: serverName,\n  environment: {\n    MCP_SERVER_TYPE: serverType,\n    MCP_CONFIG_PATH: configPath || '/config/default.json'\n  },\n  ports: {\n    '3000': '3000'\n  },\n  restart: 'unless-stopped'\n};\n\nreturn {\n  serverType,\n  serverName,\n  configPath,\n  mcpConfig\n};"
      },
      "id": "function-process",
      "name": "Process Request",
      "type": "n8n-nodes-base.function",
      "typeVersion": 1,
      "position": [460, 300]
    },
    {
      "parameters": {
        "command": "docker run -d --name {{$json.serverName}} {{$json.mcpConfig.image}}",
        "options": {}
      },
      "id": "execute-command",
      "name": "Deploy Container",
      "type": "n8n-nodes-base.executeCommand",
      "typeVersion": 1,
      "position": [660, 300]
    },
    {
      "parameters": {
        "functionCode": "// Wait for container to be ready\nconst delay = ms => new Promise(resolve => setTimeout(resolve, ms));\n\n// Health check loop\nfor (let i = 0; i < 30; i++) {\n  await delay(2000);\n  \n  // Check if container is healthy\n  const healthResponse = await $http.request({\n    method: 'GET',\n    url: `http://localhost:3000/health`,\n    timeout: 5000\n  }).catch(() => null);\n  \n  if (healthResponse?.status === 200) {\n    return {\n      status: 'ready',\n      endpoint: 'http://localhost:3000',\n      healthCheck: 'passed'\n    };\n  }\n}\n\nthrow new Error('MCP server failed to start within timeout');"
      },
      "id": "health-check",
      "name": "Health Check",
      "type": "n8n-nodes-base.function",
      "typeVersion": 1,
      "position": [860, 300]
    },
    {
      "parameters": {
        "respondWith": "json",
        "responseBody": "{\n  \"success\": true,\n  \"serverName\": \"{{$json.serverName}}\",\n  \"status\": \"{{$json.status}}\",\n  \"endpoint\": \"{{$json.endpoint}}\",\n  \"message\": \"MCP server deployed successfully\"\n}"
      },
      "id": "response-success",
      "name": "Success Response",
      "type": "n8n-nodes-base.respondToWebhook",
      "typeVersion": 1,
      "position": [1060, 300]
    }
  ],
  "connections": {
    "Webhook Trigger": {
      "main": [
        [
          {
            "node": "Process Request",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "Process Request": {
      "main": [
        [
          {
            "node": "Deploy Container",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "Deploy Container": {
      "main": [
        [
          {
            "node": "Health Check",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "Health Check": {
      "main": [
        [
          {
            "node": "Success Response",
            "type": "main",
            "index": 0
          }
        ]
      ]
    }
  }
}
```

### 5. Integration with Buddy AI

#### Buddy Command: Deploy MCP Server
```bash
# Usage: buddy deploy mcp filesystem project-fs /data/projects
buddy() {
  case "$1" in
    "deploy")
      case "$2" in
        "mcp")
          buddy_deploy_mcp_server "$3" "$4" "$5"
          ;;
      esac
      ;;
    "list")
      case "$2" in
        "mcp")
          buddy_list_mcp_servers
          ;;
      esac
      ;;
    "status")
      case "$2" in
        "mcp")
          buddy_get_mcp_status "$3"
          ;;
      esac
      ;;
  esac
}
```

#### Buddy Self-Service MCP Deployment
When Buddy AI needs to access files or data, it can automatically deploy the required MCP server:

```bash
buddy_auto_deploy_mcp() {
  local access_type="$1"  # filesystem, database, git, api
  local resource_path="$2"
  
  echo "🤖 Buddy AI requesting MCP server for ${access_type} access"
  
  case "$access_type" in
    "filesystem")
      buddy_deploy_mcp_server "filesystem" "buddy-fs-$(date +%s)" "$resource_path"
      ;;
    "database")
      buddy_deploy_mcp_server "database" "buddy-db-$(date +%s)" "$resource_path"
      ;;
    "git")
      buddy_deploy_mcp_server "git" "buddy-git-$(date +%s)" "$resource_path"
      ;;
  esac
}
```

## Security Considerations

### Authentication
- All MCP servers require authentication
- API keys are automatically generated and managed
- Access is limited to specified paths/resources

### Network Security
- MCP servers run in isolated containers
- Communication is encrypted
- Access logs are maintained

### Data Protection
- File access is restricted to allowed paths
- Database queries are validated
- Sensitive data is never logged

## Monitoring and Logging

### Health Checks
- Automatic health monitoring
- Alert notifications for failures
- Performance metrics collection

### Usage Tracking
- API call logging
- Resource usage statistics
- Error rate monitoring

## Example Usage Scenarios

### Scenario 1: Buddy Needs File Access
```bash
# Buddy automatically deploys filesystem MCP when needed
buddy_auto_deploy_mcp "filesystem" "/projects/CloudJourneyBlog"
```

### Scenario 2: Database Analysis Required
```bash
# User requests database MCP for analysis
buddy deploy mcp database analytics-db "postgresql://localhost:5432/analytics"
```

### Scenario 3: Git Repository Integration
```bash
# Deploy git MCP for repository operations
buddy deploy mcp git repo-manager "https://github.com/user/repo.git"
```

## Troubleshooting

### Common Issues

#### n8n Connection Failed
```bash
# Test n8n API connectivity
curl -X GET "${N8N_API_URL}/workflows" \
  -H "X-N8N-API-KEY: ${N8N_API_KEY}" \
  -u "${N8N_BASIC_AUTH_USER}:${N8N_BASIC_AUTH_PASSWORD}"
```

#### MCP Server Won't Start
```bash
# Check Docker logs
docker logs buddy-fs-1234567890

# Verify configuration
docker exec buddy-fs-1234567890 cat /config/mcp.json
```

#### Authentication Issues
```bash
# Verify environment variables
echo $N8N_API_KEY
echo $N8N_BASIC_AUTH_USER
```

## Next Steps

1. **Test n8n API Connection**: Verify authentication with your n8n instance
2. **Import Workflow Templates**: Upload the MCP deployment workflows to n8n
3. **Configure Environment**: Set up required environment variables
4. **Deploy First MCP Server**: Test with a simple filesystem MCP
5. **Integrate with Buddy AI**: Enable auto-deployment capabilities

---

This workflow enables powerful automation capabilities, allowing Buddy AI to dynamically create and manage MCP servers based on your needs!
