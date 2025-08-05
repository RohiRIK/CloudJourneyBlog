# n8n MCP Integration

This folder contains all tools and workflows for integrating Buddy AI with n8n and Model Context Protocol (MCP) servers.

## 📁 Folder Structure

```
n8n-mcp/
├── README.md           # This file
├── scripts/            # CLI tools and automation scripts
├── workflows/          # n8n workflow JSON files
└── docs/              # Documentation and guides
```

## 🛠️ Scripts

- **`scripts/buddy-n8n-mcp.sh`** - Main CLI tool for n8n MCP integration

## 📋 Workflows

- **`workflows/mcp-deployment-workflow.json`** - n8n workflow for MCP server deployment
- **`workflows/mcp-list-workflow.json`** - n8n workflow for listing MCP servers

## 📖 Documentation

- **`docs/n8n-api-integration.md`** - Comprehensive API integration guide
- **`docs/QUICK_START_N8N_MCP.md`** - Quick start guide for MCP integration

## 🚀 Quick Start

1. **Set up environment variables** in your `.env` file:
   ```bash
   N8N_API_URL=https://n8n.rohi.life/api/v1
   N8N_WEBHOOK_URL=https://n8n.rohi.life/webhook
   N8N_API_KEY=your_api_key_here
   ```

2. **Test the CLI tool**:
   ```bash
   ./scripts/buddy-n8n-mcp.sh check-deps
   ```

3. **Import workflows** to your n8n instance:
   ```bash
   ./scripts/buddy-n8n-mcp.sh import-workflows
   ```

## 🔗 Integration Points

- **Buddy AI** → **n8n workflows** → **MCP servers**
- **Notion integration** via MCP workflow triggers
- **Webhook-based communication** for real-time operations

## 📝 Usage Examples

```bash
# Check dependencies
./scripts/buddy-n8n-mcp.sh check-deps

# Test n8n connection
./scripts/buddy-n8n-mcp.sh test-connection

# List available workflows
./scripts/buddy-n8n-mcp.sh list-workflows

# Search Notion via MCP workflow
./scripts/buddy-n8n-mcp.sh search-notion "project updates"
```

## 🔧 Configuration

All configuration is done via environment variables. See the documentation in `docs/` for detailed setup instructions.
