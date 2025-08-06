#!/bin/bash

# Clean n8n MCP Notion CLI - Simple and Working
# Based on research findings: initialization works, tools require session

set -e

# Configuration
MCP_ENDPOINT="https://n8n.rohi.life/mcp/3cf65aaa-4868-4cf1-bed1-d9020412fa71"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

log_info() { echo -e "${BLUE}ℹ️ $1${NC}"; }
log_success() { echo -e "${GREEN}✅ $1${NC}"; }
log_error() { echo -e "${RED}❌ $1${NC}"; }

# Core MCP function
mcp_call() {
    local method="$1"
    local params="$2"
    local id="${3:-$(date +%s)}"
    
    curl -s -X POST "$MCP_ENDPOINT" \
        -H "Content-Type: application/json" \
        -H "Accept: application/json, text/event-stream" \
        --max-time 5 \
        -d "{
            \"jsonrpc\": \"2.0\",
            \"method\": \"$method\",
            \"params\": $params,
            \"id\": \"$id\"
        }" | head -3
}

# Test connection
test_connection() {
    log_info "Testing MCP connection..."
    
    local response=$(mcp_call "initialize" '{
        "protocolVersion": "2024-11-05",
        "capabilities": {"tools": {}},
        "clientInfo": {"name": "clean-cli", "version": "1.0"}
    }' "test_init")
    
    if echo "$response" | grep -q "MCP_Server_Trigger"; then
        log_success "MCP server is working"
        return 0
    else
        log_error "MCP server failed"
        echo "$response"
        return 1
    fi
}

# Search Notion - Direct approach
search_notion() {
    local query="${1:-test}"
    
    log_info "Searching Notion for: '$query'"
    
    # Try direct tool call (will likely fail due to session)
    local response=$(mcp_call "tools/call" '{
        "name": "Search_page_Notion",
        "arguments": {
            "searchText": "'$query'"
        }
    }' "search_$(date +%s)")
    
    echo "Response: $response"
}

# Show usage
show_usage() {
    echo "Clean n8n MCP Notion CLI"
    echo "Usage: $0 <command>"
    echo ""
    echo "Commands:"
    echo "  test     - Test MCP connection"  
    echo "  search   - Search Notion (requires session fix)"
    echo "  help     - Show this help"
}

# Main function
main() {
    case "${1:-help}" in
        "test")
            test_connection
            ;;
        "search")
            search_notion "$2"
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

# Run
main "$@"
