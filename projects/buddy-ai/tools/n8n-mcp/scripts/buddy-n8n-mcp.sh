#!/bin/bash

# Buddy AI n8n MCP Integration Tool
# Test and manage MCP servers through n8n workflows

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="${SCRIPT_DIR}/../../../.env"

# Load environment variables
if [[ -f "$ENV_FILE" ]]; then
    source "$ENV_FILE"
else
    echo "⚠️ Warning: .env file not found at $ENV_FILE"
fi

# Required environment variables
N8N_API_URL="${N8N_API_URL:-https://n8n.rohi.life/api/v1}"
N8N_WEBHOOK_URL="${N8N_WEBHOOK_URL:-https://n8n.rohi.life/webhook}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
log_info() {
    echo -e "${BLUE}ℹ️ $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️ $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Check dependencies
check_dependencies() {
    log_info "Checking dependencies..."
    
    if ! command -v curl &> /dev/null; then
        log_error "curl is required but not installed"
        exit 1
    fi
    
    if ! command -v jq &> /dev/null; then
        log_error "jq is required but not installed"
        echo "Install with: brew install jq (macOS) or apt-get install jq (Ubuntu)"
        exit 1
    fi
    
    if ! command -v docker &> /dev/null; then
        log_error "docker is required but not installed"
        exit 1
    fi
    
    log_success "All dependencies available"
}

# Test n8n connectivity
test_n8n_connection() {
    log_info "Testing n8n connection..."
    
    if [[ -z "$N8N_API_KEY" ]]; then
        log_error "N8N_API_KEY not set in environment"
        return 1
    fi
    
    local response
    response=$(curl -s -w "%{http_code}" -o /dev/null \
        -H "X-N8N-API-KEY: ${N8N_API_KEY}" \
        -u "${N8N_BASIC_AUTH_USER}:${N8N_BASIC_AUTH_PASSWORD}" \
        "${N8N_API_URL}/workflows")
    
    if [[ "$response" == "200" ]]; then
        log_success "n8n API connection successful"
        return 0
    else
        log_error "n8n API connection failed (HTTP: $response)"
        return 1
    fi
}

# List n8n workflows
list_workflows() {
    log_info "Fetching n8n workflows..."
    
    local workflows
    workflows=$(curl -s \
        -H "X-N8N-API-KEY: ${N8N_API_KEY}" \
        -u "${N8N_BASIC_AUTH_USER}:${N8N_BASIC_AUTH_PASSWORD}" \
        "${N8N_API_URL}/workflows")
    
    if [[ $? -eq 0 ]]; then
        echo "$workflows" | jq -r '.data[] | "  🔧 \(.name) (ID: \(.id)) - Active: \(.active)"'
    else
        log_error "Failed to fetch workflows"
        return 1
    fi
}

# Search for MCP workflows
find_mcp_workflows() {
    log_info "Searching for MCP-related workflows..."
    
    local workflows
    workflows=$(curl -s \
        -H "X-N8N-API-KEY: ${N8N_API_KEY}" \
        -u "${N8N_BASIC_AUTH_USER}:${N8N_BASIC_AUTH_PASSWORD}" \
        "${N8N_API_URL}/workflows")
    
    if [[ $? -eq 0 ]]; then
        echo "$workflows" | jq -r '.data[] | select(.name | test("MCP|mcp"; "i")) | "  🔧 \(.name) (ID: \(.id)) - Active: \(.active)"'
    else
        log_error "Failed to search workflows"
        return 1
    fi
}

# Deploy MCP server via webhook
deploy_mcp_server() {
    local server_type="$1"
    local server_name="$2"
    local config_path="$3"
    local additional_config="$4"
    
    if [[ -z "$server_type" || -z "$server_name" ]]; then
        log_error "Usage: deploy_mcp_server <type> <name> [config_path] [additional_config]"
        echo "  Types: filesystem, database, git, api"
        return 1
    fi
    
    log_info "Deploying MCP server: $server_name ($server_type)"
    
    # Prepare deployment payload
    local payload
    payload=$(cat <<EOF
{
  "input": {
    "server_type": "$server_type",
    "server_name": "$server_name",
    "config_path": "$config_path",
    "additional_config": ${additional_config:-"{}"},
    "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
    "requested_by": "buddy-ai-cli"
  }
}
EOF
)
    
    log_info "Sending deployment request..."
    
    local response
    response=$(curl -s -X POST "${N8N_WEBHOOK_URL}/mcp-deploy" \
        -H "Content-Type: application/json" \
        -d "$payload")
    
    if [[ $? -eq 0 ]]; then
        echo "$response" | jq '.'
        
        # Check if deployment was successful
        local success
        success=$(echo "$response" | jq -r '.success // false')
        
        if [[ "$success" == "true" ]]; then
            log_success "MCP server deployed successfully"
            
            # Show deployment details
            local endpoint
            endpoint=$(echo "$response" | jq -r '.deployment.endpoint // "unknown"')
            log_info "Server endpoint: $endpoint"
            
            return 0
        else
            log_error "Deployment failed"
            return 1
        fi
    else
        log_error "Failed to send deployment request"
        return 1
    fi
}

# List MCP servers via webhook
list_mcp_servers() {
    log_info "Fetching MCP server list..."
    
    local response
    response=$(curl -s -X POST "${N8N_WEBHOOK_URL}/mcp-list" \
        -H "Content-Type: application/json" \
        -d '{"input": {"action": "list_all"}}')
    
    if [[ $? -eq 0 ]]; then
        echo "$response" | jq '.'
        
        # Show summary
        local count
        count=$(echo "$response" | jq -r '.count // 0')
        log_info "Found $count MCP server(s)"
        
        return 0
    else
        log_error "Failed to fetch MCP server list"
        return 1
    fi
}

# Test MCP server connectivity
test_mcp_server() {
    local server_name="$1"
    
    if [[ -z "$server_name" ]]; then
        log_error "Usage: test_mcp_server <server_name>"
        return 1
    fi
    
    log_info "Testing MCP server: $server_name"
    
    # First get the server list to find the endpoint
    local server_list
    server_list=$(curl -s -X POST "${N8N_WEBHOOK_URL}/mcp-list" \
        -H "Content-Type: application/json" \
        -d '{"input": {"action": "list_all"}}')
    
    if [[ $? -ne 0 ]]; then
        log_error "Failed to get server list"
        return 1
    fi
    
    # Find the specific server
    local endpoint
    endpoint=$(echo "$server_list" | jq -r ".servers[] | select(.name == \"$server_name\") | .endpoint")
    
    if [[ -z "$endpoint" || "$endpoint" == "null" ]]; then
        log_error "Server '$server_name' not found"
        return 1
    fi
    
    log_info "Testing endpoint: $endpoint"
    
    # Test health endpoint
    local health_response
    health_response=$(curl -s -m 5 "$endpoint/health" 2>/dev/null)
    
    if [[ $? -eq 0 && -n "$health_response" ]]; then
        log_success "Server is responding"
        echo "$health_response" | jq '.' 2>/dev/null || echo "$health_response"
    else
        log_error "Server is not responding"
        return 1
    fi
}

# Import n8n workflows
import_workflows() {
    log_info "Importing MCP workflows to n8n..."
    
    local workflow_dir="${SCRIPT_DIR}/n8n-workflows"
    
    if [[ ! -d "$workflow_dir" ]]; then
        log_error "Workflow directory not found: $workflow_dir"
        return 1
    fi
    
    for workflow_file in "$workflow_dir"/*.json; do
        if [[ -f "$workflow_file" ]]; then
            local workflow_name
            workflow_name=$(basename "$workflow_file" .json)
            
            log_info "Importing: $workflow_name"
            
            # Read workflow content
            local workflow_content
            workflow_content=$(cat "$workflow_file")
            
            # Import via API
            local import_response
            import_response=$(curl -s -X POST "${N8N_API_URL}/workflows" \
                -H "Content-Type: application/json" \
                -H "X-N8N-API-KEY: ${N8N_API_KEY}" \
                -u "${N8N_BASIC_AUTH_USER}:${N8N_BASIC_AUTH_PASSWORD}" \
                -d "$workflow_content")
            
            if [[ $? -eq 0 ]]; then
                local workflow_id
                workflow_id=$(echo "$import_response" | jq -r '.data.id // .id // "unknown"')
                
                if [[ "$workflow_id" != "unknown" ]]; then
                    log_success "Imported: $workflow_name (ID: $workflow_id)"
                else
                    log_warning "Import may have failed: $workflow_name"
                    echo "$import_response" | jq '.'
                fi
            else
                log_error "Failed to import: $workflow_name"
            fi
        fi
    done
}

# Show usage information
show_usage() {
    cat << EOF
🤖 Buddy AI n8n MCP Integration Tool

Usage: $0 <command> [options]

Commands:
  check-deps              Check required dependencies
  test-connection         Test n8n API connection
  list-workflows          List all n8n workflows
  find-mcp-workflows      Find MCP-related workflows
  import-workflows        Import MCP workflows to n8n
  
  deploy <type> <name> [config] [extra]
                         Deploy new MCP server
                         Types: filesystem, database, git, api
  
  list-servers           List all MCP servers
  test-server <name>     Test specific MCP server
  
Examples:
  $0 check-deps
  $0 test-connection
  $0 deploy filesystem project-fs /data/projects
  $0 deploy database analytics-db "postgresql://localhost:5432/db"
  $0 list-servers
  $0 test-server project-fs

Environment Variables:
  N8N_API_URL            n8n API URL (default: https://n8n.rohi.life/api/v1)
  N8N_API_KEY            n8n API key (required)
  N8N_BASIC_AUTH_USER    n8n basic auth username
  N8N_BASIC_AUTH_PASSWORD n8n basic auth password
  N8N_WEBHOOK_URL        n8n webhook URL (default: https://n8n.rohi.life/webhook)

EOF
}

# Main command handler
main() {
    case "${1:-}" in
        "check-deps")
            check_dependencies
            ;;
        "test-connection")
            check_dependencies && test_n8n_connection
            ;;
        "list-workflows")
            check_dependencies && list_workflows
            ;;
        "find-mcp-workflows")
            check_dependencies && find_mcp_workflows
            ;;
        "import-workflows")
            check_dependencies && import_workflows
            ;;
        "deploy")
            check_dependencies && deploy_mcp_server "$2" "$3" "$4" "$5"
            ;;
        "list-servers")
            check_dependencies && list_mcp_servers
            ;;
        "test-server")
            check_dependencies && test_mcp_server "$2"
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

# Run main function with all arguments
main "$@"
