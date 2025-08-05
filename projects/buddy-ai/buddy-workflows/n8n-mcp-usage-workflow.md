# n8n MCP Server Usage Workflow - Zero to Hero

This workflow explains how Buddy AI can use the MCP server that you've already built in your n8n instance to access Notion and other services.

## 🎯 Overview

You have successfully created an MCP server integration in n8n that connects to Notion. This workflow shows Buddy AI how to:
1. Understand your existing n8n MCP setup
2. Use the webhook endpoints to interact with Notion
3. Perform common operations through your MCP server
4. Scale this approach for other MCP servers

## 📋 Prerequisites

### What You Already Have
- ✅ n8n instance running at `https://n8n.rohi.life`
- ✅ n8n workflow with "MCP Server Trigger" 
- ✅ Notion integration configured in n8n
- ✅ Webhook endpoint: `/webhook/3cf65aaa-4868-4cf1-bed1-d902041f2fa71`

### What Buddy Needs
- n8n webhook URL and path
- Understanding of your workflow structure
- Proper payload format for requests

## 🚀 Step-by-Step Usage Guide

### Step 1: Identify Your n8n MCP Workflow

Your current setup:
```
n8n Workflow: "MCP_servers" / "My workflow 3"
├── MCP Server Trigger (Webhook)
├── Search a page in Notion
└── Response handling
```

**Webhook Endpoint:**
```
https://n8n.rohi.life/webhook/3cf65aaa-4868-4cf1-bed1-d902041f2fa71
```

### Step 2: Basic Notion Search via MCP

**Command for Buddy:**
```bash
curl -X POST "https://n8n.rohi.life/webhook/3cf65aaa-4868-4cf1-bed1-d902041f2fa71" \
  -H "Content-Type: application/json" \
  -d '{
    "searchText": "project updates",
    "operation": "search",
    "requestedBy": "buddy-ai"
  }'
```

**What happens:**
1. n8n receives the webhook request
2. Triggers the "Search a page in Notion" node
3. Returns structured Notion data
4. Buddy processes the response

### Step 3: Understanding Response Format

Expected response structure:
```json
{
  "results": [
    {
      "id": "page-id-123",
      "title": "Project Updates",
      "url": "https://notion.so/...",
      "properties": {...},
      "content": "..."
    }
  ],
  "hasMore": false,
  "nextCursor": null
}
```

### Step 4: Advanced Operations

#### Create a New Page
```bash
curl -X POST "https://n8n.rohi.life/webhook/3cf65aaa-4868-4cf1-bed1-d902041f2fa71" \
  -H "Content-Type: application/json" \
  -d '{
    "operation": "create_page",
    "title": "New Meeting Notes",
    "content": "Meeting notes from today...",
    "parent": "parent-page-id",
    "requestedBy": "buddy-ai"
  }'
```

#### Update Existing Page
```bash
curl -X POST "https://n8n.rohi.life/webhook/3cf65aaa-4868-4cf1-bed1-d902041f2fa71" \
  -H "Content-Type: application/json" \
  -d '{
    "operation": "update_page",
    "pageId": "existing-page-id",
    "properties": {
      "Status": "In Progress",
      "Priority": "High"
    },
    "requestedBy": "buddy-ai"
  }'
```

## 🔧 Implementation in Buddy AI

### Method 1: Direct CLI Tool Usage

Use the organized CLI tool:
```bash
cd /projects/buddy-ai/tools/n8n-mcp/scripts/
./buddy-n8n-mcp.sh search-notion "project updates"
./buddy-n8n-mcp.sh create-notion-page "Meeting Notes" "Content here"
```

### Method 2: Direct Webhook Calls

Buddy can make direct HTTP requests:
```bash
# Search Notion
curl -X POST "${N8N_WEBHOOK_URL}/3cf65aaa-4868-4cf1-bed1-d902041f2fa71" \
  -H "Content-Type: application/json" \
  -d '{"searchText": "query", "requestedBy": "buddy-ai"}'

# Create page
curl -X POST "${N8N_WEBHOOK_URL}/3cf65aaa-4868-4cf1-bed1-d902041f2fa71" \
  -H "Content-Type: application/json" \
  -d '{"operation": "create_page", "title": "New Page", "requestedBy": "buddy-ai"}'
```

### Method 3: Programmatic Integration

For complex operations, Buddy can use structured functions:

```bash
# Function: search_notion_via_mcp
search_notion_via_mcp() {
    local query="$1"
    local response=$(curl -s -X POST \
        "https://n8n.rohi.life/webhook/3cf65aaa-4868-4cf1-bed1-d902041f2fa71" \
        -H "Content-Type: application/json" \
        -d "{\"searchText\": \"$query\", \"requestedBy\": \"buddy-ai\"}")
    
    echo "$response" | jq '.'
}

# Function: create_notion_page_via_mcp
create_notion_page_via_mcp() {
    local title="$1"
    local content="$2"
    local response=$(curl -s -X POST \
        "https://n8n.rohi.life/webhook/3cf65aaa-4868-4cf1-bed1-d902041f2fa71" \
        -H "Content-Type: application/json" \
        -d "{\"operation\": \"create_page\", \"title\": \"$title\", \"content\": \"$content\", \"requestedBy\": \"buddy-ai\"}")
    
    echo "$response" | jq '.'
}
```

## 📈 Scaling to Other MCP Servers

### Pattern for New MCP Servers

1. **Create n8n Workflow**
   ```
   New MCP Workflow
   ├── Webhook Trigger (unique path)
   ├── Service Integration (e.g., GitHub, Slack, Database)
   └── Response formatting
   ```

2. **Document the Integration**
   - Webhook endpoint URL
   - Expected payload format
   - Response structure
   - Available operations

3. **Add to CLI Tool**
   ```bash
   # Add function to buddy-n8n-mcp.sh
   interact_with_github_mcp() {
       local action="$1"
       local repo="$2"
       # ... implementation
   }
   ```

4. **Update Buddy Workflows**
   - Add new workflow documentation
   - Update navigation.json
   - Create usage examples

## 🛠️ Troubleshooting

### Common Issues

**Webhook Not Responding:**
- Check n8n workflow is active
- Verify webhook path is correct
- Test with simple curl request

**Authentication Errors:**
- Ensure Notion integration is properly configured in n8n
- Check API permissions in Notion

**Malformed Responses:**
- Verify JSON payload structure
- Check n8n workflow logic
- Review response formatting nodes

### Debug Commands

```bash
# Test webhook connectivity
curl -X POST "https://n8n.rohi.life/webhook/3cf65aaa-4868-4cf1-bed1-d902041f2fa71" \
  -H "Content-Type: application/json" \
  -d '{"test": true}'

# Check n8n workflow logs
# (Access via n8n UI at https://n8n.rohi.life)

# Validate JSON payload
echo '{"searchText": "test"}' | jq '.'
```

## 📚 Usage Examples for Buddy

### Example 1: Research Task
```bash
# Buddy searches for project information
search_notion_via_mcp "CloudJourneyBlog architecture"

# Process results and create summary
create_notion_page_via_mcp "Architecture Summary" "Based on research..."
```

### Example 2: Meeting Notes
```bash
# Create meeting notes page
create_notion_page_via_mcp "Team Meeting $(date +%Y-%m-%d)" "Meeting agenda:..."

# Update with action items
# (implement update function based on your n8n workflow)
```

### Example 3: Project Tracking
```bash
# Search for project status
search_notion_via_mcp "project status updates"

# Analyze and create report
create_notion_page_via_mcp "Weekly Status Report" "Current progress:..."
```

## 🔄 Next Steps

### Immediate Actions
1. Test the webhook endpoint with simple requests
2. Verify response format matches expectations
3. Document any custom operations your n8n workflow supports

### Future Enhancements
1. Add more MCP servers (GitHub, Slack, databases)
2. Implement batch operations
3. Add error handling and retry logic
4. Create automated workflows for common tasks

## 📝 Notes

- This approach leverages your existing n8n expertise
- Each MCP server is a separate n8n workflow with unique webhook
- Buddy can interact with any service you can integrate in n8n
- Pattern is scalable and maintainable

**Last Updated:** August 5, 2025  
**Status:** Ready for testing with your existing n8n MCP setup
