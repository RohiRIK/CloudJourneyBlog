# Quick Start: n8n MCP Server Automation Setup

## 🚀 Getting Started in 5 Minutes

### Step 1: Environment Setup

Create or update your `.env` file:

```bash
# n8n API Configuration
N8N_API_URL=https://n8n.rohi.life/api/v1
N8N_API_KEY=your_n8n_api_key_here
N8N_BASIC_AUTH_USER=your_username
N8N_BASIC_AUTH_PASSWORD=your_password
N8N_WEBHOOK_URL=https://n8n.rohi.life/webhook

# Optional: Buddy Registry (for tracking deployed servers)
BUDDY_REGISTRY_URL=http://localhost:8080
BUDDY_API_KEY=your_buddy_api_key_here
```

### Step 2: Get Your n8n API Key

1. Go to `https://n8n.rohi.life`
2. Navigate to **Settings** → **API Keys**
3. Click **Create API Key**
4. Copy the key and add it to your `.env` file

### Step 3: Test the Integration

```bash
# Test the CLI tool
./projects/buddy-ai/tools/buddy-n8n-mcp.sh check-deps
./projects/buddy-ai/tools/buddy-n8n-mcp.sh test-connection
```

### Step 4: Import Workflows

```bash
# Import the MCP workflows to your n8n instance
./projects/buddy-ai/tools/buddy-n8n-mcp.sh import-workflows
```

### Step 5: Deploy Your First MCP Server

```bash
# Deploy a filesystem MCP server
./projects/buddy-ai/tools/buddy-n8n-mcp.sh deploy filesystem buddy-fs /data/projects

# List all MCP servers
./projects/buddy-ai/tools/buddy-n8n-mcp.sh list-servers

# Test the server
./projects/buddy-ai/tools/buddy-n8n-mcp.sh test-server buddy-fs
```

## 🔧 What This Integration Provides

### For Buddy AI
- **Dynamic MCP Deployment**: Buddy can create MCP servers on-demand
- **Resource Access**: Secure access to files, databases, git repos
- **Workflow Automation**: Trigger complex n8n workflows programmatically
- **Self-Service Capabilities**: Auto-deploy infrastructure when needed

### For You
- **Simplified Management**: Easy CLI tool for MCP server operations
- **Visual Workflows**: n8n's visual interface for customization
- **Monitoring**: Health checks and status monitoring
- **Security**: Containerized servers with proper access controls

## 📋 Available Commands

### Management Commands
```bash
# Server operations
buddy-n8n-mcp.sh deploy <type> <name> [config]
buddy-n8n-mcp.sh list-servers
buddy-n8n-mcp.sh test-server <name>

# Workflow operations
buddy-n8n-mcp.sh list-workflows
buddy-n8n-mcp.sh find-mcp-workflows

# System operations
buddy-n8n-mcp.sh check-deps
buddy-n8n-mcp.sh test-connection
```

### MCP Server Types
- **filesystem**: Secure file system access
- **database**: Database query capabilities
- **git**: Git repository operations
- **api**: External API integration

## 🤖 Buddy AI Integration Examples

### Auto-Deploy When Needed
```bash
# When Buddy needs file access
buddy_auto_deploy_mcp "filesystem" "/projects/CloudJourneyBlog" "read"

# When Buddy needs database access
buddy_auto_deploy_mcp "database" "postgresql://localhost:5432/logs" "read"
```

### Integration with Buddy Commands
```bash
# Add to your buddy function
buddy() {
  case "$1" in
    "deploy")
      case "$2" in
        "mcp")
          ./projects/buddy-ai/tools/buddy-n8n-mcp.sh deploy "$3" "$4" "$5"
          ;;
      esac
      ;;
    "list")
      case "$2" in
        "mcp")
          ./projects/buddy-ai/tools/buddy-n8n-mcp.sh list-servers
          ;;
      esac
      ;;
  esac
}
```

## 🛠️ Advanced Usage

### Custom MCP Configuration
```bash
# Deploy with custom config
./buddy-n8n-mcp.sh deploy filesystem project-data "/data/projects" \
  '{"permissions": ["read", "write"], "auto_created": true}'
```

### Monitoring and Health Checks
```bash
# Check all servers
./buddy-n8n-mcp.sh list-servers | jq '.servers[] | select(.overallHealth != "healthy")'

# Test specific server
./buddy-n8n-mcp.sh test-server my-server
```

## 🔍 Troubleshooting

### Common Issues

1. **API Connection Failed**
   ```bash
   # Check your credentials
   ./buddy-n8n-mcp.sh test-connection
   ```

2. **Workflow Not Found**
   ```bash
   # Import the workflows
   ./buddy-n8n-mcp.sh import-workflows
   ```

3. **MCP Server Won't Start**
   ```bash
   # Check Docker logs
   docker logs mcp-filesystem-your-server-name
   ```

### Getting Help
```bash
# Show all available commands
./buddy-n8n-mcp.sh help
```

## 🎯 Next Steps

1. **Test Basic Functionality**: Deploy a simple filesystem MCP server
2. **Integrate with Buddy**: Add MCP commands to your Buddy AI workflow
3. **Explore n8n Interface**: Customize workflows in the visual editor
4. **Scale Up**: Deploy multiple MCP servers for different use cases

---

**🎉 You're now ready to use n8n MCP Server Automation with Buddy AI!**

This integration transforms Buddy AI into a powerful infrastructure automation tool, capable of dynamically creating and managing MCP servers based on your needs.
