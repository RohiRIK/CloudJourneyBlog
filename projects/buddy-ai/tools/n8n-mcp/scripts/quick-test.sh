#!/bin/bash

# Quick test of n8n MCP Notion integration
# Based on user's screenshot showing "Search_page_Notion" tool
# Using TEST endpoint

N8N_WEBHOOK="https://n8n.rohi.life/mcp-test/3cf65aaa-4868-4cf1-bed1-d9020412fa71"

echo "🔍 Testing n8n MCP Notion Integration"
echo "======================================"

echo -e "\n1️⃣ Testing MCP Server Health:"
curl -s -X POST "$N8N_WEBHOOK" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json, text/event-stream" \
  -d '{
    "jsonrpc": "2.0",
    "method": "initialize",
    "params": {
      "protocolVersion": "2024-11-05",
      "capabilities": {"tools": {}},
      "clientInfo": {"name": "quick-test", "version": "1.0"}
    },
    "id": "init_test"
  }' | head -5

echo -e "\n\n2️⃣ Testing Search_page_Notion tool (might fail due to session):"
curl -s -X POST "$N8N_WEBHOOK" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json, text/event-stream" \
  -d '{
    "jsonrpc": "2.0", 
    "method": "tools/call",
    "params": {
      "name": "Search_page_Notion",
      "arguments": {
        "searchText": "test"
      }
    },
    "id": "search_test"
  }' | head -5

echo -e "\n\n3️⃣ Alternative: Testing if it's a direct webhook endpoint:"
curl -s -X POST "$N8N_WEBHOOK" \
  -H "Content-Type: application/json" \
  -d '{
    "operation": "search",
    "resource": "page", 
    "searchText": "test"
  }' | head -5

echo -e "\n\n✅ Test completed"
