#!/bin/bash

# Test if session persists between requests on test endpoint
TEST_ENDPOINT="https://n8n.rohi.life/mcp-test/3cf65aaa-4868-4cf1-bed1-d9020412fa71"

echo "🧪 Testing session persistence on test endpoint..."

echo -e "\n1️⃣ Initialize session:"
INIT_RESPONSE=$(curl -s -X POST "$TEST_ENDPOINT" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json, text/event-stream" \
  --max-time 5 \
  -d '{
    "jsonrpc": "2.0",
    "method": "initialize", 
    "params": {
      "protocolVersion": "2024-11-05",
      "capabilities": {"tools": {}},
      "clientInfo": {"name": "session-test", "version": "1.0"}
    },
    "id": "session_init"
  }')

echo "$INIT_RESPONSE" | head -3

# Wait a moment
sleep 2

echo -e "\n2️⃣ Immediate tools/list (same connection?):"
TOOLS_RESPONSE=$(curl -s -X POST "$TEST_ENDPOINT" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json, text/event-stream" \
  --max-time 5 \
  -d '{
    "jsonrpc": "2.0",
    "method": "tools/list",
    "params": {},
    "id": "session_tools"
  }')

echo "$TOOLS_RESPONSE" | head -3

echo -e "\n3️⃣ Try Search_page_Notion:"
SEARCH_RESPONSE=$(curl -s -X POST "$TEST_ENDPOINT" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json, text/event-stream" \
  --max-time 5 \
  -d '{
    "jsonrpc": "2.0",
    "method": "tools/call",
    "params": {
      "name": "Search_page_Notion",
      "arguments": {
        "searchText": "test"
      }
    },
    "id": "session_search"
  }')

echo "$SEARCH_RESPONSE" | head -3

echo -e "\n✅ Session test completed"
