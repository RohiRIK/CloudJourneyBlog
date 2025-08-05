# Clean Up n8n MCP CLI Tools and Fix Session Management

![Open](https://img.shields.io/badge/Status-Open-red?style=flat-square) ![Critical Priority](https://img.shields.io/badge/Priority-Critical-darkred?style=flat-square)

## Description
Consolidate and clean up the multiple CLI test scripts created during n8n MCP research, and implement a working solution for the session management challenge.

## Current Situation

### Files Created During Research
- `buddy-notion-cli.sh` - Main CLI attempt with various approaches
- `quick-test.sh` - Simple endpoint testing
- Multiple other test scripts that didn't work

### Core Technical Challenge
- n8n MCP server requires **persistent sessions** 
- HTTP requests are **stateless**
- Can initialize successfully: `{"serverInfo":{"name":"MCP_Server_Trigger","version":"0.1.0"}}`
- Tool calls fail: `"Server not initialized"` error

## Tasks

### 1. File Organization
- [ ] **Remove non-working CLI scripts** - Delete messy test files that don't work
- [ ] **Keep only functional components** - Preserve scripts that successfully initialize MCP
- [ ] **Organize working examples** - Clean directory structure in `tools/n8n-mcp/scripts/`

### 2. Technical Solution
- [ ] **Research session persistence options** - WebSocket, long-polling, or session tokens
- [ ] **Implement working session handler** - Bridge stateless HTTP with MCP sessions  
- [ ] **Test Notion search functionality** - Verify "Search_page_Notion" tool actually works
- [ ] **Create simple, working CLI** - One clean tool that can search Notion via n8n MCP

### 3. Integration
- [ ] **Update buddy-ai workflow guide** - Document the working solution
- [ ] **Test with Buddy AI** - Ensure Buddy can use the cleaned-up CLI
- [ ] **Document limitations** - What works, what doesn't, and why

## Key Findings to Preserve
- **Working MCP endpoint**: `https://n8n.rohi.life/mcp/3cf65aaa-4868-4cf1-bed1-d9020412fa71`
- **Tool name**: "Search_page_Notion"
- **Parameter format**: `{"searchText": "query"}`
- **Required headers**: `Accept: application/json, text/event-stream`
- **Protocol**: JSON-RPC 2.0 with SSE streams

## Success Criteria
- [ ] Clean, organized file structure
- [ ] One working CLI that can search Notion
- [ ] Clear documentation of the solution
- [ ] Integration with Buddy AI workflows

## Status
- **Overall Status**: To Do
- **Assigned To**: Buddy AI
- **Priority**: High
- **Depends On**: n8n-mcp-server-automation.md (research complete)

## Notes
This cleanup is essential before moving forward. Better to have one working solution than multiple broken attempts.
