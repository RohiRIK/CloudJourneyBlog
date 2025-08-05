# n8n MCP Notion Workflow - Zero to Hero Guide

**Workflow Type**: MCP Integration  
**Complexity**: Intermediate  
**Prerequisites**: n8n instance running, Notion workspace access, MCP server knowledge  
**Estimated Time**: 15-30 minutes  

## 🎯 Workflow Overview

This workflow enables Buddy AI to interact with your Notion workspace through your existing n8n MCP server integration. You've already built the foundation - now let's make it work seamlessly with Buddy AI.

### What You've Built
- ✅ **MCP Server Trigger** - Webhook endpoint for receiving requests
- ✅ **Notion Integration** - Connected to your Notion workspace 
- ✅ **Search Functionality** - Can search pages in Notion
- ✅ **n8n Workflow** - Ready to execute and process requests

### What We'll Achieve
- 🎯 **Buddy AI Integration** - Enable Buddy to trigger your workflow
- 🎯 **Notion Operations** - Search, create, update Notion pages via Buddy
- 🎯 **Automated Workflows** - Chain multiple Notion operations together
- 🎯 **Error Handling** - Robust error detection and recovery

## 📋 Step-by-Step Implementation

### Step 1: Identify Your Webhook URL

From your n8n workflow screenshot, I can see you have:
- **Workflow Name**: "My workflow 3" 
- **Trigger**: MCP Server Trigger
- **Notion Node**: "Search a page in Notion"

**Action Required:**
1. In your n8n workflow, click on the **MCP Server Trigger** node
2. Copy the **Production URL** (it should look like: `https://n8n.rohi.life/mcp/3cf65aaa-4868-4cf1-bed1-d9020412fa71`)
3. Save this URL - we'll use it for Buddy AI integration

```bash
# Your MCP endpoint URL format:
# https://n8n.rohi.life/mcp/[your-unique-id]
```

### Step 2: Configure Environment Variables

Create or update your `.env` file with the webhook URL:

```bash
# Add to your .env file
N8N_NOTION_WEBHOOK=https://n8n.rohi.life/webhook/3cf65aaa-4868-4cf1-bed1-d9020412fa71
N8N_API_URL=https://n8n.rohi.life/api/v1
N8N_WEBHOOK_URL=https://n8n.rohi.life/webhook
```

### Step 3: Test Your Current Workflow

**Using Buddy CLI Tool:**
```bash
# Navigate to the n8n-mcp tools
cd projects/buddy-ai/tools/n8n-mcp/scripts/

# Test basic connectivity
./buddy-n8n-mcp.sh check-deps

# Test your specific Notion workflow
curl -X POST "https://n8n.rohi.life/webhook/3cf65aaa-4868-4cf1-bed1-d9020412fa71" \
  -H "Content-Type: application/json" \
  -d '{
    "searchText": "test search",
    "operation": "search_page"
  }'
```

### Step 4: Enhance Your n8n Workflow

**Recommended Improvements to Your Current Workflow:**

1. **Add Input Validation Node** (after MCP Server Trigger):
```javascript
// Validate input data
const input = $json;

if (!input.searchText && !input.operation) {
  throw new Error('Missing required parameters: searchText or operation');
}

return {
  searchText: input.searchText || '',
  operation: input.operation || 'search_page',
  pageId: input.pageId || '',
  timestamp: new Date().toISOString(),
  requestId: input.requestId || `req_${Date.now()}`
};
```

2. **Add Response Formatting Node** (after Notion node):
```javascript
// Format response for Buddy AI
const notionResult = $json;
const input = $('MCP Server Trigger').first().json;

return {
  success: true,
  operation: input.operation || 'search_page',
  requestId: input.requestId,
  timestamp: new Date().toISOString(),
  data: notionResult,
  metadata: {
    source: 'n8n-mcp-notion',
    workflow: 'buddy-ai-integration',
    resultsCount: Array.isArray(notionResult) ? notionResult.length : 1
  }
};
```

3. **Add Error Handling Node**:
```javascript
// Error handling and logging
const error = $json.error || $json;

return {
  success: false,
  error: {
    message: error.message || 'Unknown error occurred',
    code: error.code || 'WORKFLOW_ERROR',
    timestamp: new Date().toISOString()
  },
  requestId: $('MCP Server Trigger').first().json.requestId || 'unknown',
  workflow: 'n8n-mcp-notion'
};
```

### Step 5: Create Buddy AI Functions

Now let's create the Buddy AI integration functions:

**Add to CLI Tool** (`buddy-n8n-mcp.sh`):

```bash
# Search Notion pages via MCP workflow
search_notion_pages() {
    local search_query="$1"
    local page_id="$2"
    
    if [[ -z "$search_query" ]]; then
        log_error "Usage: search_notion_pages <search_query> [page_id]"
        echo "  Example: search_notion_pages 'project updates'"
        return 1
    fi
    
    log_info "Searching Notion for: '$search_query'"
    
    local payload
    payload=$(cat <<EOF
{
  "searchText": "$search_query",
  "operation": "search_page",
  "pageId": "${page_id:-""}",
  "requestId": "buddy_$(date +%s)",
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
}
EOF
)
    
    local response
    response=$(curl -s -X POST "$N8N_NOTION_WEBHOOK" \
        -H "Content-Type: application/json" \
        -d "$payload")
    
    if [[ $? -eq 0 ]]; then
        echo "$response" | jq '.'
        local success=$(echo "$response" | jq -r '.success // false')
        
        if [[ "$success" == "true" ]]; then
            log_success "Search completed successfully"
            local count=$(echo "$response" | jq -r '.metadata.resultsCount // 0')
            log_info "Found $count result(s)"
        else
            log_error "Search failed"
            echo "$response" | jq -r '.error.message // "Unknown error"'
        fi
    else
        log_error "Failed to connect to n8n webhook"
        return 1
    fi
}

# Create new Notion page via MCP workflow  
create_notion_page() {
    local title="$1"
    local content="$2"
    local parent_id="$3"
    
    if [[ -z "$title" ]]; then
        log_error "Usage: create_notion_page <title> [content] [parent_id]"
        return 1
    fi
    
    log_info "Creating Notion page: '$title'"
    
    local payload
    payload=$(cat <<EOF
{
  "operation": "create_page",
  "title": "$title",
  "content": "${content:-""}",
  "parentId": "${parent_id:-""}",
  "requestId": "buddy_$(date +%s)",
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
}
EOF
)
    
    local response
    response=$(curl -s -X POST "$N8N_NOTION_WEBHOOK" \
        -H "Content-Type: application/json" \
        -d "$payload")
    
    if [[ $? -eq 0 ]]; then
        echo "$response" | jq '.'
        local success=$(echo "$response" | jq -r '.success // false')
        
        if [[ "$success" == "true" ]]; then
            log_success "Page created successfully"
            local page_url=$(echo "$response" | jq -r '.data.url // "No URL returned"')
            log_info "Page URL: $page_url"
        fi
    else
        log_error "Failed to create page"
        return 1
    fi
}
```

### Step 6: Usage Examples

**Basic Search:**
```bash
# Search for pages containing "meeting notes"
./buddy-n8n-mcp.sh search_notion_pages "meeting notes"

# Search within a specific page
./buddy-n8n-mcp.sh search_notion_pages "action items" "page-id-123"
```

**Creating Pages:**
```bash
# Create a simple page
./buddy-n8n-mcp.sh create_notion_page "Daily Standup Notes"

# Create page with content
./buddy-n8n-mcp.sh create_notion_page "Project Update" "Today we completed the MCP integration"

# Create page under a parent page
./buddy-n8n-mcp.sh create_notion_page "Sprint Planning" "Planning session notes" "parent-page-id"
```

### Step 7: Advanced Operations

**Chaining Operations:**
```bash
# Search and then create related page
SEARCH_RESULT=$(./buddy-n8n-mcp.sh search_notion_pages "project alpha")
PROJECT_ID=$(echo "$SEARCH_RESULT" | jq -r '.data[0].id')
./buddy-n8n-mcp.sh create_notion_page "Alpha Project Update" "Latest updates..." "$PROJECT_ID"
```

**Batch Operations:**
```bash
# Create multiple related pages
for topic in "Planning" "Development" "Testing" "Deployment"; do
    ./buddy-n8n-mcp.sh create_notion_page "Sprint $topic" "Notes for $topic phase"
done
```

## 🚀 Buddy AI Integration Patterns

### Pattern 1: Information Retrieval
```bash
# Buddy can search for information and provide context
buddy_search_context() {
    local query="$1"
    echo "🔍 Searching Notion for: $query"
    ./buddy-n8n-mcp.sh search_notion_pages "$query" | jq -r '.data[].title'
}
```

### Pattern 2: Automated Documentation
```bash
# Buddy can create documentation automatically
buddy_auto_document() {
    local title="$1"
    local content="$2"
    echo "📝 Creating documentation: $title"
    ./buddy-n8n-mcp.sh create_notion_page "$title" "$content"
}
```

### Pattern 3: Task Management
```bash
# Buddy can manage tasks and projects
buddy_task_management() {
    local task="$1"
    local project_id="$2"
    echo "✅ Adding task: $task"
    ./buddy-n8n-mcp.sh create_notion_page "Task: $task" "Auto-created by Buddy AI" "$project_id"
}
```

## 🔧 Troubleshooting

### Common Issues and Solutions

**Issue 1: Webhook Not Responding**
```bash
# Test webhook directly
curl -X POST "$N8N_NOTION_WEBHOOK" \
  -H "Content-Type: application/json" \
  -d '{"test": true}'

# Check n8n workflow status
./buddy-n8n-mcp.sh list-workflows | grep -i notion
```

**Issue 2: Notion Authentication Errors**
- Verify Notion integration is properly connected in n8n
- Check Notion workspace permissions
- Ensure Notion token hasn't expired

**Issue 3: JSON Parsing Errors**
```bash
# Validate JSON payload before sending
echo '{"searchText": "test"}' | jq '.'
```

## 📊 Success Metrics

Track these metrics to measure workflow success:

- ✅ **Webhook Response Time** < 3 seconds
- ✅ **Search Success Rate** > 95%
- ✅ **Page Creation Success Rate** > 98%
- ✅ **Error Rate** < 2%

## 🎯 Next Steps

1. **Enhanced Operations**: Add update, delete, and bulk operations
2. **Rich Content**: Support for blocks, databases, and complex formatting
3. **Automation**: Create scheduled workflows for recurring tasks
4. **Monitoring**: Add logging and alerting for workflow health
5. **Templates**: Create page templates for common use cases

## 📚 Additional Resources

- **n8n Documentation**: [n8n.io/docs](https://n8n.io/docs)
- **Notion API**: [developers.notion.com](https://developers.notion.com)
- **MCP Protocol**: Model Context Protocol specifications
- **Buddy AI Tools**: `projects/buddy-ai/tools/n8n-mcp/`

---

**Workflow Created**: August 5, 2025  
**Last Updated**: August 5, 2025  
**Version**: 1.0  
**Author**: Buddy AI System
