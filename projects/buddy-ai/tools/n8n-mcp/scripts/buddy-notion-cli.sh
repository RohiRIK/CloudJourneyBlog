#!/bin/bash

# Buddy AI - n8n MCP Notion Integration
# Quick CLI tool for interacting with your n8n Notion workflow

# Configuration - PRODUCTION URL
N8N_NOTION_WEBHOOK="${N8N_NOTION_WEBHOOK:-https://n8n.rohi.life/mcp/3cf65aaa-4868-4cf1-bed1-d9020412fa71}"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Helper functions
log_info() { echo -e "${BLUE}ℹ️ $1${NC}"; }
log_success() { echo -e "${GREEN}✅ $1${NC}"; }
log_warning() { echo -e "${YELLOW}⚠️ $1${NC}"; }
log_error() { echo -e "${RED}❌ $1${NC}"; }

# Initialize MCP server
initialize_mcp() {
    log_info "Initializing MCP server..."
    
    local payload=$(cat <<EOF
{
  "jsonrpc": "2.0",
  "id": "init_$(date +%s)",
  "method": "initialize",
  "params": {
    "protocolVersion": "2024-11-05",
    "capabilities": {
      "resources": {},
      "tools": {}
    },
    "clientInfo": {
      "name": "buddy-ai-cli",
      "version": "1.0.0"
    }
  }
}
EOF
)
    
    local response=$(curl -s -X POST "$N8N_NOTION_WEBHOOK" \
        -H "Content-Type: application/json" \
        -H "Accept: application/json, text/event-stream" \
        -d "$payload")
    
    if [[ $? -eq 0 ]]; then
        log_success "MCP server initialized"
        echo "$response" | jq '.' 2>/dev/null || echo "$response"
    else
        log_error "Initialization failed"
        return 1
    fi
}

# Research-based MCP interaction with proper headers
mcp_call() {
    local method="$1"
    local params="$2"
    local id="${3:-$(date +%s)}"
    
    curl -s -X POST "$N8N_NOTION_WEBHOOK" \
        -H "Content-Type: application/json" \
        -H "Accept: application/json, text/event-stream" \
        -d "{
            \"jsonrpc\": \"2.0\",
            \"id\": \"$id\",
            \"method\": \"$method\",
            \"params\": $params
        }"
}

# New: Single-call MCP operation for n8n stateless HTTP
mcp_single_call() {
    local operation="$1"
    local notion_params="$2"
    
    # Send operation directly to n8n webhook WITH REQUIRED HEADERS
    curl -s -X POST "$N8N_NOTION_WEBHOOK" \
        -H "Content-Type: application/json" \
        -H "Accept: application/json, text/event-stream" \
        -d "{
            \"operation\": \"$operation\",
            \"params\": $notion_params
        }"
}

# Initialize and discover tools - FIXED APPROACH
discover_tools() {
    log_info "Testing n8n MCP Notion integration with correct protocol..."
    
    # Test 1: Proper MCP tools/list call
    log_info "Listing available MCP tools..."
    local tools_response=$(mcp_call "tools/list" '{}' "tools_$(date +%s)")
    
    log_info "Tools list response:"
    echo "$tools_response" | jq '.' 2>/dev/null || echo "$tools_response"
    
    # Test 2: If tools/list doesn't work, try the session approach
    if echo "$tools_response" | grep -q "Server not initialized"; then
        log_warning "Server requires session initialization - trying combined call..."
        
        # Combined initialize + tools/list in one connection attempt
        local session_tools=$(curl -s -X POST "$N8N_NOTION_WEBHOOK" \
            -H "Content-Type: application/json" \
            -H "Accept: application/json, text/event-stream" \
            -d '{
                "jsonrpc": "2.0",
                "method": "tools/list",
                "params": {},
                "id": "tools_session"
            }' --connect-timeout 10)
        
        log_info "Session tools response:"
        echo "$session_tools" | jq '.' 2>/dev/null || echo "$session_tools"
    fi
    
    # Test 3: Get server capabilities
    log_info "Getting server capabilities..."
    local capabilities=$(mcp_call "capabilities" '{}' "caps_$(date +%s)")
    
    log_info "Capabilities response:"
    echo "$capabilities" | jq '.' 2>/dev/null || echo "$capabilities"
}

# Search Notion using research-based approach
search_notion() {
    local query="$1"
    
    if [[ -z "$query" ]]; then
        log_error "Usage: $0 search <query>"
        echo "  Example: $0 search 'meeting notes'"
        return 1
    fi
    
    log_info "Initializing and searching Notion for: '$query'"
    
    # First, try to list available tools/methods
    local tools_payload=$(cat <<EOF
{
  "jsonrpc": "2.0",
  "id": "tools_$(date +%s)",
  "method": "tools/list",
  "params": {}
}
EOF
)
    
    local tools_response=$(curl -s -X POST "$N8N_NOTION_WEBHOOK" \
        -H "Content-Type: application/json" \
        -H "Accept: application/json, text/event-stream" \
        -d "$tools_payload")
    
    log_info "Available tools:"
    echo "$tools_response" | jq '.' 2>/dev/null || echo "$tools_response"
    
    # Now try the search with the correct n8n tool name from screenshot
    local search_payload=$(cat <<EOF
{
  "jsonrpc": "2.0",
  "id": "search_$(date +%s)",
  "method": "tools/call",
  "params": {
    "name": "Search_page_Notion",
    "arguments": {
      "searchText": "$query"
    }
  }
}
EOF
)
    
    local response=$(curl -s -X POST "$N8N_NOTION_WEBHOOK" \
        -H "Content-Type: application/json" \
        -H "Accept: application/json, text/event-stream" \
        -d "$search_payload")
    
    if [[ $? -eq 0 ]]; then
        log_success "Search completed"
        echo "$response" | jq '.' 2>/dev/null || echo "$response"
    else
        log_error "Search failed"
        return 1
    fi
}

# Create Notion page
create_page() {
    local title="$1"
    local content="$2"
    
    if [[ -z "$title" ]]; then
        log_error "Usage: $0 create <title> [content]"
        echo "  Example: $0 create 'Daily Notes' 'Today I worked on...'"
        return 1
    fi
    
    log_info "Creating page: '$title'"
    
    local payload=$(cat <<EOF
{
  "jsonrpc": "2.0",
  "id": "buddy_$(date +%s)",
  "method": "notion/create_page",
  "params": {
    "title": "$title",
    "content": "${content:-""}",
    "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  }
}
EOF
)
    
    local response=$(curl -s -X POST "$N8N_NOTION_WEBHOOK" \
        -H "Content-Type: application/json" \
        -H "Accept: application/json, text/event-stream" \
        -d "$payload")
    
    if [[ $? -eq 0 ]]; then
        log_success "Page created"
        echo "$response" | jq '.' 2>/dev/null || echo "$response"
    else
        log_error "Page creation failed"
        return 1
    fi
}

# Test connection
test_connection() {
    log_info "Testing n8n webhook connection..."
    
    local response=$(curl -s -X POST "$N8N_NOTION_WEBHOOK" \
        -H "Content-Type: application/json" \
        -H "Accept: application/json, text/event-stream" \
        -d '{
          "jsonrpc": "2.0",
          "id": "test_connection",
          "method": "ping",
          "params": {}
        }')
    
    if [[ $? -eq 0 ]]; then
        log_success "Connection successful"
        echo "$response" | jq '.' 2>/dev/null || echo "$response"
    else
        log_error "Connection failed"
        return 1
    fi
}

# Show usage
show_usage() {
    cat <<EOF
Buddy AI - n8n MCP Notion Integration

Usage: $0 <command> [arguments]

Commands:
  init                       Initialize MCP server
  discover                   Discover available tools
  search <query>              Search Notion pages
  create <title> [content]    Create new Notion page
  test                       Test webhook connection
  help                       Show this help

Examples:
  $0 discover
  $0 search "project updates"
  $0 create "Daily Standup" "Today's agenda and notes"
  $0 test

Environment Variables:
  N8N_NOTION_WEBHOOK         Your n8n webhook URL

EOF
}

# Main function
main() {
    case "${1:-}" in
        "init")
            initialize_mcp
            ;;
        "discover")
            discover_tools
            ;;
        "search")
            search_notion "$2"
            ;;
        "create")
            create_page "$2" "$3"
            ;;
        "test")
            test_connection
            ;;
        "operations"|"ops")
            test_notion_operations
            ;;
        "sse")
            mcp_full_sse_session
            ;;
        "persistent")
            mcp_persistent_test
            ;;
        "help"|"-h"|"--help"|"")
            show_usage
            ;;
        *)
            log_error "Unknown command: $1"
            show_usage
            exit 1
            ;;
    esac
}

# Full SSE session with tools discovery and Notion operations
mcp_full_sse_session() {
    log_info "Starting full SSE session with Notion operations..."
    
    # Create session script
    cat > /tmp/mcp_session_script.sh << 'EOF'
#!/bin/bash
N8N_WEBHOOK="$1"

# Function to send MCP command via curl
send_mcp_command() {
    local method="$1"
    local params="$2" 
    local id="$3"
    
    curl -s -N --no-buffer -X POST "$N8N_WEBHOOK" \
        -H "Content-Type: application/json" \
        -H "Accept: application/json, text/event-stream" \
        -H "Connection: keep-alive" \
        -d "{
            \"jsonrpc\": \"2.0\",
            \"method\": \"$method\",
            \"params\": $params,
            \"id\": \"$id\"
        }"
}

echo "=== STEP 1: Initialize Session ==="
send_mcp_command "initialize" '{
    "protocolVersion": "2024-11-05",
    "capabilities": {"tools": {}},
    "clientInfo": {"name": "buddy-full-session", "version": "1.0"}
}' "init_session"

echo -e "\n=== STEP 2: List Available Tools ==="
send_mcp_command "tools/list" '{}' "list_tools"

echo -e "\n=== STEP 3: Test Tool Call ==="
send_mcp_command "tools/call" '{
    "name": "notion_search",
    "arguments": {"query": "test", "limit": 3}
}' "test_call"

EOF

    chmod +x /tmp/mcp_session_script.sh
    
    # Run the session script
    /tmp/mcp_session_script.sh "$N8N_NOTION_WEBHOOK"
    
    # Cleanup
    rm -f /tmp/mcp_session_script.sh
}

# Test WebSocket-style persistent connection
mcp_persistent_test() {
    log_info "Testing persistent SSE connection approach..."
    
    # Use curl with --no-buffer for real-time streaming
    curl -s -N --no-buffer -X POST "$N8N_NOTION_WEBHOOK" \
        -H "Content-Type: application/json" \
        -H "Accept: application/json, text/event-stream" \
        -H "Connection: keep-alive" \
        -d '{
            "jsonrpc": "2.0",
            "method": "initialize",
            "params": {
                "protocolVersion": "2024-11-05", 
                "capabilities": {"tools": {}},
                "clientInfo": {"name": "buddy-persistent", "version": "1.0"}
            },
            "id": "persistent_init"
        }' | head -10
}

# Fallback operations test for compatibility
test_notion_operations() {
    log_info "Running compatibility operations test..."
    log_info "Use 'sse' or 'persistent' commands for SSE-based testing"
    
    # Show current MCP endpoint status
    local status=$(curl -s -I "$N8N_NOTION_WEBHOOK" | head -1)
    log_info "MCP endpoint status: $status"
}

# Run main function
main "$@"
