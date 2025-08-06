#!/bin/bash

# True MCP Session Handler for n8n SSE
# This maintains a persistent connection and session state

set -e

# Configuration
N8N_WEBHOOK="${1:-https://n8n.rohi.life/mcp/3cf65aaa-4868-4cf1-bed1-d9020412fa71}"
SESSION_DIR="/tmp/mcp_session_$$"
INPUT_PIPE="$SESSION_DIR/input"
OUTPUT_PIPE="$SESSION_DIR/output"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log_info() { echo -e "${BLUE}ℹ️ $1${NC}"; }
log_success() { echo -e "${GREEN}✅ $1${NC}"; }
log_warning() { echo -e "${YELLOW}⚠️ $1${NC}"; }
log_error() { echo -e "${RED}❌ $1${NC}"; }

# Cleanup function
cleanup() {
    log_info "Cleaning up session..."
    kill $CURL_PID 2>/dev/null || true
    rm -rf "$SESSION_DIR"
}
trap cleanup EXIT

# Setup session directory and pipes
setup_session() {
    mkdir -p "$SESSION_DIR"
    mkfifo "$INPUT_PIPE"
    mkfifo "$OUTPUT_PIPE"
    
    log_info "Session directory: $SESSION_DIR"
}

# Start persistent curl connection
start_session() {
    log_info "Starting persistent MCP session..."
    
    # Start curl in background with persistent connection
    curl -s -N --no-buffer -X POST "$N8N_WEBHOOK" \
        -H "Content-Type: application/json" \
        -H "Accept: application/json, text/event-stream" \
        -H "Connection: keep-alive" \
        --data-binary @"$INPUT_PIPE" > "$OUTPUT_PIPE" &
    
    CURL_PID=$!
    log_success "Session started with PID: $CURL_PID"
}

# Send MCP command
send_command() {
    local method="$1"
    local params="$2"
    local id="$3"
    
    local payload="{\"jsonrpc\":\"2.0\",\"method\":\"$method\",\"params\":$params,\"id\":\"$id\"}"
    
    log_info "Sending: $method"
    echo "$payload" > "$INPUT_PIPE"
    
    # Read response with timeout
    timeout 10s head -20 "$OUTPUT_PIPE" 2>/dev/null || log_warning "Timeout reading response"
}

# Main session workflow
main() {
    log_info "🚀 Starting True MCP Session Test"
    
    setup_session
    start_session
    
    sleep 1  # Give curl time to establish connection
    
    # Step 1: Initialize
    log_info "=== STEP 1: Initialize ==="
    send_command "initialize" '{
        "protocolVersion": "2024-11-05",
        "capabilities": {"tools": {}},
        "clientInfo": {"name": "true-session", "version": "1.0"}
    }' "init_1"
    
    sleep 2
    
    # Step 2: List tools  
    log_info "=== STEP 2: List Tools ==="
    send_command "tools/list" '{}' "list_1"
    
    sleep 2
    
    # Step 3: Try a tool call
    log_info "=== STEP 3: Test Tool Call ==="
    send_command "tools/call" '{
        "name": "notion_search", 
        "arguments": {"query": "test"}
    }' "call_1"
    
    sleep 3
    
    log_success "Session test completed"
}

# Run if called directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
