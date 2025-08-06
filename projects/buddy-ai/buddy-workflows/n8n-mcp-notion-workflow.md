# n8n MCP Notion Integration - Buddy AI Workflow

**Purpose**: Enable Buddy AI to interact with Notion through existing n8n MCP server integration  
**Complexity**: Intermediate  
**Prerequisites**: n8n instance running, Notion workspace connected, MCP server configured  
**Target**: Seamless Buddy AI → n8n → Notion operations  

## Workflow Overview

This workflow establishes direct integration between Buddy AI and your Notion workspace using your existing n8n MCP server infrastructure.

### Current State
- ✅ **n8n MCP Server** - Running at `n8n.rohi.life`
- ✅ **Notion Integration** - Connected and authenticated
- ✅ **Basic Search** - Functional page search capability

### Integration Goal
Enable Buddy AI to perform Notion operations seamlessly through n8n workflows.

## Core Implementation Steps

### Step 1: Verify MCP Endpoint Configuration

**Identify your active n8n MCP workflow:**

- Workflow: "My workflow 3"
- Trigger: MCP Server Trigger
- Notion Node: "Search a page in Notion"

**Get the MCP endpoint URL:**

1. In n8n, open your workflow
2. Click the **MCP Server Trigger** node
3. Copy the **Production URL**
4. Format should be: `https://n8n.rohi.life/mcp/{workflow-id}`

### Step 2: Configure Environment

**Add to your `.env` file:**

```bash
# n8n MCP Notion Integration
N8N_MCP_NOTION_ENDPOINT=https://n8n.rohi.life/mcp/3cf65aaa-4868-4cf1-bed1-d9020412fa71
N8N_INSTANCE_URL=https://n8n.rohi.life
```

**Validate connection:**

```bash
# Test MCP endpoint
curl -X POST "$N8N_MCP_NOTION_ENDPOINT" \
  -H "Content-Type: application/json" \
  -d '{"searchText": "test", "operation": "search_page"}'
```

### Step 3: Enhance n8n Workflow for Buddy AI

**Required n8n workflow improvements:**

1. **Input Validation (after MCP Trigger):**

```javascript
// Validate and normalize input
const input = $json;
return {
  searchText: input.searchText || input.query || '',
  operation: input.operation || 'search_page',
  pageId: input.pageId || '',
  requestId: `buddy_${Date.now()}`,
  timestamp: new Date().toISOString()
};
```

2. **Response Formatting (after Notion node):**

```javascript
// Format for Buddy AI consumption
const result = $json;
const input = $('MCP Server Trigger').first().json;

return {
  success: true,
  operation: input.operation,
  requestId: input.requestId,
  data: result,
  timestamp: new Date().toISOString()
};
```

3. **Error Handling:**

```javascript
// Standardized error response
const error = $json.error || $json;
return {
  success: false,
  error: error.message || 'Workflow execution failed',
  requestId: $('MCP Server Trigger').first().json.requestId,
  timestamp: new Date().toISOString()
};
```

## Buddy AI Integration Functions

**Core operations available to Buddy AI:**

### Search Notion Pages

```javascript
// Buddy AI can call this internally
async function searchNotionPages(query, pageId = null) {
  const payload = {
    searchText: query,
    operation: 'search_page',
    pageId: pageId,
    requestId: `buddy_${Date.now()}`
  };
  
  const response = await fetch(process.env.N8N_MCP_NOTION_ENDPOINT, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(payload)
  });
  
  return response.json();
}
```

### Create Notion Pages

```javascript
// Buddy AI page creation
async function createNotionPage(title, content = '', parentId = null) {
  const payload = {
    operation: 'create_page',
    title: title,
    content: content,
    parentId: parentId,
    requestId: `buddy_${Date.now()}`
  };
  
  const response = await fetch(process.env.N8N_MCP_NOTION_ENDPOINT, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(payload)
  });
  
  return response.json();
}
```

## Usage Patterns

**Information Retrieval:**

- Buddy: "Search for meeting notes from last week"
- Action: `searchNotionPages("meeting notes last week")`
- Result: Structured response with matching pages

**Documentation Creation:**

- Buddy: "Create a page documenting today's deployment"
- Action: `createNotionPage("Deployment Notes", content)`
- Result: New page created with deployment details

**Project Management:**

- Buddy: "Add this task to the project backlog"
- Action: Search project → Create task page under project
- Result: Organized task management

## Validation & Testing

**Test workflow functionality:**

```bash
# 1. Test search
curl -X POST "$N8N_MCP_NOTION_ENDPOINT" \
  -H "Content-Type: application/json" \
  -d '{"searchText": "test search", "operation": "search_page"}'

# 2. Test page creation  
curl -X POST "$N8N_MCP_NOTION_ENDPOINT" \
  -H "Content-Type: application/json" \
  -d '{"operation": "create_page", "title": "Test Page", "content": "Created by Buddy AI"}'
```

**Expected response format:**

```json
{
  "success": true,
  "operation": "search_page",
  "requestId": "buddy_1234567890",
  "data": [...],
  "timestamp": "2025-08-06T12:00:00.000Z"
}
```

## Troubleshooting

**Common Issues:**

1. **MCP Endpoint Not Responding**
   - Verify n8n workflow is active
   - Check endpoint URL format
   - Ensure MCP server is running

2. **Notion Authentication Errors**
   - Verify Notion integration in n8n
   - Check workspace permissions
   - Refresh Notion token if needed

3. **Response Format Issues**
   - Ensure response formatting nodes are properly configured
   - Validate JSON structure matches expected format

## Success Criteria

- ✅ Buddy AI can search Notion pages seamlessly
- ✅ Page creation works through MCP integration
- ✅ Response times under 3 seconds
- ✅ Error handling provides clear feedback
- ✅ Integration requires zero manual intervention

---

**Workflow Version**: 2.0  
**Updated**: August 6, 2025  
**Author**: Buddy AI Assistant
