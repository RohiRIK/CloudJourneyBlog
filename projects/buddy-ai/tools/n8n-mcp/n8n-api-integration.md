# Buddy AI n8n API Integration Tools

## Overview

This module provides tools for Buddy AI to interact with your n8n instance at `https://n8n.rohi.life` for MCP server automation and workflow management.

## Authentication Setup

### Environment Variables

```bash
# Add to your .env file
N8N_API_URL=https://n8n.rohi.life/api/v1
N8N_API_KEY=your_n8n_api_key_here
N8N_BASIC_AUTH_USER=your_username
N8N_BASIC_AUTH_PASSWORD=your_password
N8N_WEBHOOK_URL=https://n8n.rohi.life/webhook
```

### API Key Configuration

1. **Access n8n Settings**: Go to `https://n8n.rohi.life` → Settings → API Keys
2. **Create New Key**: Generate a new API key with workflow execution permissions
3. **Store Securely**: Add to `.env` file (automatically protected by Buddy's security protocol)

## Core Integration Functions

### n8n API Helper Functions

```bash
#!/bin/bash
# n8n API integration functions for Buddy AI

# Load environment variables
source .env

# Base curl function for n8n API
n8n_api_call() {
  local method="$1"
  local endpoint="$2"
  local data="$3"
  
  local curl_cmd="curl -s -X ${method}"
  curl_cmd+=" -H 'Content-Type: application/json'"
  curl_cmd+=" -H 'X-N8N-API-KEY: ${N8N_API_KEY}'"
  curl_cmd+=" -u '${N8N_BASIC_AUTH_USER}:${N8N_BASIC_AUTH_PASSWORD}'"
  
  if [[ -n "$data" ]]; then
    curl_cmd+=" -d '${data}'"
  fi
  
  curl_cmd+=" '${N8N_API_URL}${endpoint}'"
  
  eval "$curl_cmd"
}

# Get all workflows
buddy_n8n_list_workflows() {
  echo "📋 Fetching n8n workflows..."
  n8n_api_call "GET" "/workflows" | jq -r '.data[] | "  🔧 \(.name) (ID: \(.id)) - Active: \(.active)"'
}

# Get workflow by name
buddy_n8n_get_workflow() {
  local workflow_name="$1"
  echo "🔍 Searching for workflow: ${workflow_name}"
  n8n_api_call "GET" "/workflows" | jq -r ".data[] | select(.name | contains(\"${workflow_name}\")) | {id: .id, name: .name, active: .active}"
}

# Execute workflow by ID
buddy_n8n_execute_workflow() {
  local workflow_id="$1"
  local input_data="$2"
  
  echo "🚀 Executing workflow ID: ${workflow_id}"
  
  local execution_response
  execution_response=$(n8n_api_call "POST" "/workflows/${workflow_id}/execute" "$input_data")
  
  local execution_id
  execution_id=$(echo "$execution_response" | jq -r '.data.executionId // .executionId // empty')
  
  if [[ -n "$execution_id" ]]; then
    echo "📊 Execution started with ID: ${execution_id}"
    return 0
  else
    echo "❌ Failed to start execution"
    echo "$execution_response" | jq '.'
    return 1
  fi
}

# Monitor execution status
buddy_n8n_monitor_execution() {
  local execution_id="$1"
  local timeout="${2:-300}"  # 5 minutes default timeout
  local interval="${3:-5}"   # 5 seconds check interval
  
  echo "🔍 Monitoring execution: ${execution_id}"
  
  local start_time
  start_time=$(date +%s)
  
  while true; do
    local current_time
    current_time=$(date +%s)
    local elapsed=$((current_time - start_time))
    
    if [[ $elapsed -gt $timeout ]]; then
      echo "⏰ Timeout reached (${timeout}s). Execution may still be running."
      return 1
    fi
    
    local execution_status
    execution_status=$(n8n_api_call "GET" "/executions/${execution_id}")
    
    local finished
    finished=$(echo "$execution_status" | jq -r '.data.finished // false')
    
    local status
    status=$(echo "$execution_status" | jq -r '.data.status // "unknown"')
    
    echo "⏳ Status: ${status} (${elapsed}s elapsed)"
    
    if [[ "$finished" == "true" ]]; then
      if [[ "$status" == "success" ]]; then
        echo "✅ Execution completed successfully!"
        echo "$execution_status" | jq -r '.data.data.resultData // {}'
        return 0
      else
        echo "❌ Execution failed with status: ${status}"
        echo "$execution_status" | jq -r '.data.data.resultData.error // "No error details available"'
        return 1
      fi
    fi
    
    sleep "$interval"
  done
}

# Get execution logs
buddy_n8n_get_execution_logs() {
  local execution_id="$1"
  echo "📋 Fetching execution logs for: ${execution_id}"
  n8n_api_call "GET" "/executions/${execution_id}" | jq -r '.data.data.resultData // {}'
}

# Webhook trigger helper
buddy_n8n_webhook_trigger() {
  local webhook_path="$1"
  local webhook_data="$2"
  
  echo "🌐 Triggering webhook: ${webhook_path}"
  
  curl -s -X POST "${N8N_WEBHOOK_URL}/${webhook_path}" \
    -H "Content-Type: application/json" \
    -d "$webhook_data"
}

# Health check for n8n
buddy_n8n_health_check() {
  echo "🏥 Checking n8n health..."
  
  local response
  response=$(curl -s -w "%{http_code}" -o /dev/null "${N8N_API_URL}/workflows" \
    -H "X-N8N-API-KEY: ${N8N_API_KEY}" \
    -u "${N8N_BASIC_AUTH_USER}:${N8N_BASIC_AUTH_PASSWORD}")
  
  if [[ "$response" == "200" ]]; then
    echo "✅ n8n API is healthy and accessible"
    return 0
  else
    echo "❌ n8n API health check failed (HTTP: ${response})"
    return 1
  fi
}

# Quick workflow search
buddy_n8n_search_workflows() {
  local search_term="$1"
  echo "🔍 Searching workflows for: ${search_term}"
  n8n_api_call "GET" "/workflows" | jq -r ".data[] | select(.name | contains(\"${search_term}\")) | \"  🔧 \(.name) (ID: \(.id))\""
}
```

## MCP Server Automation Commands

### Deploy MCP Server

```bash
# Deploy a new MCP server via n8n workflow
buddy_deploy_mcp_server() {
  local server_type="$1"    # filesystem, database, git, api
  local server_name="$2"    # unique name for the server
  local config_path="$3"    # configuration file or resource path
  local additional_config="$4"  # optional JSON config
  
  if [[ -z "$server_type" || -z "$server_name" ]]; then
    echo "❌ Usage: buddy_deploy_mcp_server <type> <name> [config_path] [additional_config]"
    echo "   Types: filesystem, database, git, api"
    return 1
  fi
  
  echo "🚀 Deploying MCP Server: ${server_name} (${server_type})"
  
  # Prepare deployment payload
  local deployment_payload
  deployment_payload=$(cat <<EOF
{
  "input": {
    "server_type": "${server_type}",
    "server_name": "${server_name}",
    "config_path": "${config_path:-}",
    "additional_config": ${additional_config:-"{}"},
    "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
    "requested_by": "buddy-ai"
  }
}
EOF
)
  
  # Find MCP deployment workflow
  local workflow_id
  workflow_id=$(buddy_n8n_get_workflow "MCP.*[Dd]eployment" | jq -r '.id // empty')
  
  if [[ -z "$workflow_id" ]]; then
    echo "❌ MCP Deployment workflow not found. Please import the workflow first."
    return 1
  fi
  
  # Execute deployment workflow
  if buddy_n8n_execute_workflow "$workflow_id" "$deployment_payload"; then
    echo "📊 MCP server deployment initiated"
    
    # Store deployment info for tracking
    echo "$deployment_payload" > "/tmp/mcp_deployment_${server_name}.json"
    
    return 0
  else
    echo "❌ Failed to start MCP deployment"
    return 1
  fi
}

# List active MCP servers
buddy_list_mcp_servers() {
  echo "📋 Fetching active MCP servers..."
  
  # Find MCP list workflow
  local workflow_id
  workflow_id=$(buddy_n8n_get_workflow "MCP.*[Ll]ist" | jq -r '.id // empty')
  
  if [[ -z "$workflow_id" ]]; then
    echo "❌ MCP List workflow not found"
    return 1
  fi
  
  # Execute list workflow
  local list_payload='{"input": {"action": "list_all"}}'
  buddy_n8n_execute_workflow "$workflow_id" "$list_payload"
}

# Get MCP server status
buddy_get_mcp_status() {
  local server_name="$1"
  
  if [[ -z "$server_name" ]]; then
    echo "❌ Usage: buddy_get_mcp_status <server_name>"
    return 1
  fi
  
  echo "🔍 Checking status of MCP server: ${server_name}"
  
  # Find MCP status workflow
  local workflow_id
  workflow_id=$(buddy_n8n_get_workflow "MCP.*[Ss]tatus" | jq -r '.id // empty')
  
  if [[ -z "$workflow_id" ]]; then
    echo "❌ MCP Status workflow not found"
    return 1
  fi
  
  # Execute status check
  local status_payload
  status_payload=$(cat <<EOF
{
  "input": {
    "server_name": "${server_name}",
    "action": "status_check"
  }
}
EOF
)
  
  buddy_n8n_execute_workflow "$workflow_id" "$status_payload"
}

# Remove MCP server
buddy_remove_mcp_server() {
  local server_name="$1"
  
  if [[ -z "$server_name" ]]; then
    echo "❌ Usage: buddy_remove_mcp_server <server_name>"
    return 1
  fi
  
  echo "🗑️ Removing MCP server: ${server_name}"
  
  # Find MCP cleanup workflow
  local workflow_id
  workflow_id=$(buddy_n8n_get_workflow "MCP.*[Cc]leanup" | jq -r '.id // empty')
  
  if [[ -z "$workflow_id" ]]; then
    echo "❌ MCP Cleanup workflow not found"
    return 1
  fi
  
  # Execute cleanup workflow
  local cleanup_payload
  cleanup_payload=$(cat <<EOF
{
  "input": {
    "server_name": "${server_name}",
    "action": "remove",
    "force": false
  }
}
EOF
)
  
  buddy_n8n_execute_workflow "$workflow_id" "$cleanup_payload"
  
  # Clean up local tracking files
  rm -f "/tmp/mcp_deployment_${server_name}.json"
}
```

## Buddy AI Self-Service Integration

### Auto-Deploy MCP for Buddy's Needs

```bash
# Automatic MCP deployment when Buddy needs access
buddy_auto_deploy_mcp() {
  local access_type="$1"      # What type of access needed
  local resource_path="$2"    # Path or resource to access
  local permissions="$3"      # read, write, admin
  
  echo "🤖 Buddy AI requesting MCP server for ${access_type} access"
  echo "📁 Resource: ${resource_path}"
  echo "🔒 Permissions: ${permissions:-read}"
  
  local server_name="buddy-auto-$(date +%s)"
  local config_json
  
  case "$access_type" in
    "filesystem")
      config_json=$(cat <<EOF
{
  "allowed_paths": ["${resource_path}"],
  "permissions": ["${permissions:-read}"],
  "auto_created": true,
  "created_by": "buddy-ai",
  "purpose": "automated file access"
}
EOF
)
      ;;
    "database")
      config_json=$(cat <<EOF
{
  "connection_string": "${resource_path}",
  "permissions": ["${permissions:-read}"],
  "auto_created": true,
  "created_by": "buddy-ai",
  "purpose": "automated database access"
}
EOF
)
      ;;
    "git")
      config_json=$(cat <<EOF
{
  "repository_url": "${resource_path}",
  "permissions": ["${permissions:-read}"],
  "auto_created": true,
  "created_by": "buddy-ai",
  "purpose": "automated git operations"
}
EOF
)
      ;;
    *)
      echo "❌ Unsupported access type: ${access_type}"
      echo "   Supported types: filesystem, database, git"
      return 1
      ;;
  esac
  
  # Deploy the MCP server
  if buddy_deploy_mcp_server "$access_type" "$server_name" "$resource_path" "$config_json"; then
    echo "✅ Auto-deployed MCP server: ${server_name}"
    
    # Store for cleanup later
    echo "${server_name}" >> "/tmp/buddy_auto_mcp_servers.list"
    
    return 0
  else
    echo "❌ Failed to auto-deploy MCP server"
    return 1
  fi
}

# Cleanup auto-deployed MCP servers
buddy_cleanup_auto_mcp() {
  local servers_file="/tmp/buddy_auto_mcp_servers.list"
  
  if [[ ! -f "$servers_file" ]]; then
    echo "📋 No auto-deployed MCP servers to clean up"
    return 0
  fi
  
  echo "🧹 Cleaning up auto-deployed MCP servers..."
  
  while IFS= read -r server_name; do
    if [[ -n "$server_name" ]]; then
      echo "🗑️ Removing: $server_name"
      buddy_remove_mcp_server "$server_name"
    fi
  done < "$servers_file"
  
  # Clear the list
  rm -f "$servers_file"
  echo "✅ Cleanup completed"
}
```

## Usage Examples

### Basic Workflow Interaction

```bash
# Check n8n health
buddy_n8n_health_check

# List all workflows
buddy_n8n_list_workflows

# Search for MCP-related workflows
buddy_n8n_search_workflows "MCP"
```

### MCP Server Management

```bash
# Deploy a filesystem MCP server
buddy_deploy_mcp_server "filesystem" "project-files" "/data/projects"

# Deploy a database MCP server
buddy_deploy_mcp_server "database" "analytics-db" "postgresql://localhost:5432/analytics"

# List all MCP servers
buddy_list_mcp_servers

# Check specific server status
buddy_get_mcp_status "project-files"

# Remove a server
buddy_remove_mcp_server "project-files"
```

### Buddy AI Auto-Deployment

```bash
# When Buddy needs file access
buddy_auto_deploy_mcp "filesystem" "/projects/CloudJourneyBlog" "read"

# When Buddy needs database access
buddy_auto_deploy_mcp "database" "postgresql://localhost:5432/logs" "read"

# Cleanup when done
buddy_cleanup_auto_mcp
```

## Troubleshooting

### Common Issues

1. **API Authentication Failed**
   ```bash
   # Test API credentials
   buddy_n8n_health_check
   ```

2. **Workflow Not Found**
   ```bash
   # Search for workflows
   buddy_n8n_search_workflows "deploy"
   ```

3. **Execution Timeout**
   ```bash
   # Check execution status manually
   buddy_n8n_get_execution_logs "execution-id"
   ```

4. **MCP Server Won't Start**
   ```bash
   # Check Docker containers
   docker ps | grep mcp
   docker logs <container-name>
   ```

This integration provides powerful automation capabilities for Buddy AI to dynamically manage MCP servers through your n8n instance!
