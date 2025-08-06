#!/bin/bash

# Working n8n MCP Notion CLI using test endpoint
# Handles SSE stream properly and maintains session

set -e

# Configuration - PRODUCTION URL
TEST_ENDPOINT="https://n8n.rohi.life/mcp/3cf65aaa-4868-4cf1-bed1-d9020412fa71"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m' 
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log_info() { echo -e "${BLUE}ℹ️ $1${NC}"; }
log_success() { echo -e "${GREEN}✅ $1${NC}"; }
log_warning() { echo -e "${YELLOW}⚠️ $1${NC}"; }
log_error() { echo -e "${RED}❌ $1${NC}"; }

# Function to call MCP with timeout and response handling
mcp_call_with_timeout() {
    local method="$1"
    local params="$2"
    local id="$3"
    local timeout="${4:-5}"
    
    curl -s -X POST "$TEST_ENDPOINT" \
        -H "Content-Type: application/json" \
        -H "Accept: application/json, text/event-stream" \
        --max-time "$timeout" \
        -d "{
            \"jsonrpc\": \"2.0\",
            \"method\": \"$method\",
            \"params\": $params,
            \"id\": \"$id\"
        }" 2>/dev/null | head -5
}

# Initialize MCP session
initialize_session() {
    log_info "Initializing MCP session with test endpoint..."
    
    local response=$(mcp_call_with_timeout "initialize" '{
        "protocolVersion": "2024-11-05",
        "capabilities": {"tools": {}},
        "clientInfo": {"name": "working-cli", "version": "1.0"}
    }' "init_working" 3)
    
    if echo "$response" | grep -q "MCP_Server_Trigger"; then
        log_success "Session initialized successfully"
        return 0
    else
        log_error "Session initialization failed"
        echo "$response"
        return 1
    fi
}

# List available tools
list_tools() {
    log_info "Listing available MCP tools..."
    
    local response=$(mcp_call_with_timeout "tools/list" '{}' "list_working" 3)
    
    log_info "Tools response:"
    echo "$response"
}

# Search Notion pages
search_notion() {
    local query="${1:-test}"
    
    log_info "Searching Notion for: '$query'"
    
    local response=$(mcp_call_with_timeout "tools/call" '{
        "name": "Search_page_Notion",
        "arguments": {
            "searchText": "'$query'"
        }
    }' "search_working" 10)
    
    log_info "Search response:"
    echo "$response"
}

# Test complete workflow
test_workflow() {
    log_info "🚀 Testing complete n8n MCP Notion workflow"
    echo "=========================================="
    
    # Step 1: Initialize
    if ! initialize_session; then
        log_error "Workflow failed at initialization"
        return 1
    fi
    
    sleep 1
    
    # Step 2: List tools
    list_tools
    
    sleep 1
    
    # Step 3: Search Notion
    search_notion "test"
    
    log_success "Workflow test completed"
}

# Usage function
show_usage() {
    echo "Usage: $0 <command> [args]"
    echo "Commands:"
    echo "  init              - Initialize MCP session"
    echo "  list              - List available tools"
    echo "  search <query>    - Search Notion pages"
    echo "  test              - Run complete workflow test"
    echo "  help              - Show this help"
}

# Main function
main() {
    case "${1:-test}" in
        "init")
            initialize_session
            ;;
        "list")
            list_tools
            ;;
        "search")
            search_notion "$2"
            ;;
        "test")
            test_workflow
            ;;
        "help"|"-h"|"--help")
            show_usage
            ;;
        *)
            log_error "Unknown command: $1"
            show_usage
            exit 1
            ;;
    esac
}

# Run if called directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
