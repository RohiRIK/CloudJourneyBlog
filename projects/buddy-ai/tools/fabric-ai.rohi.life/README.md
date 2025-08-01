# Fabric AI Integration Guide 🤖

Complete guide for using your self-hosted Fabric AI framework for multi-agent content creation.

## Service Overview

**Endpoint**: `https://fabric-ai.rohi.life`  
**Authentication**: X-API-Key header  
**Location**: `infrastructure/fabric-ai/`  
**Models**: Gemini 2.0 Flash Experimental, GPT-4, Claude 3.5

## Quick Commands

### Test Fabric AI Connection
```bash
# Basic connectivity test (verified working format)
curl -X POST https://fabric-ai.rohi.life/chat \
  -H "Content-Type: application/json" \
  -H "X-API-Key: $FABRIC_API_KEY" \
  -d '{
    "prompts": [{
      "userInput": "Hello, test connection",
      "model": "llama3.1:8b"
    }],
    "language": "en"
  }'

# Get available models
curl -X GET https://fabric-ai.rohi.life/models/names \
  -H "X-API-Key: $FABRIC_API_KEY"

# Get available patterns/agents  
curl -X GET https://fabric-ai.rohi.life/patterns/names \
  -H "X-API-Key: $FABRIC_API_KEY"

# Health check
curl -X GET https://fabric-ai.rohi.life/health \
  -H "X-API-Key: $FABRIC_API_KEY"
```

### Deploy/Restart Fabric AI
```bash
# Navigate to Fabric AI directory
cd infrastructure/fabric-ai/

# Start the service
docker-compose up -d

# Check logs
docker-compose logs -f fabric-ai

# Restart if needed
docker-compose restart fabric-ai

# Check container status
docker ps | grep fabric-ai
```

## Advanced Usage - Dynamic Model & Pattern Selection

### Discover Available Options
```bash
# Get all available models for selection
curl -X GET https://fabric-ai.rohi.life/models/names \
  -H "X-API-Key: $FABRIC_API_KEY"

# Get all available patterns/agents for specific tasks
curl -X GET https://fabric-ai.rohi.life/patterns/names \
  -H "X-API-Key: $FABRIC_API_KEY"
```

### Smart Model Selection
Based on task requirements, Buddy can dynamically choose:
- **Research tasks**: Use models optimized for factual accuracy and web search
- **Creative writing**: Use models with strong language generation capabilities  
- **Technical content**: Use models trained on code and documentation
- **Content editing**: Use models focused on grammar and style refinement

### Smart Pattern Selection
Buddy can dynamically select patterns based on content type:
- **Blog posts**: Use publisher/editor patterns for SEO optimization
- **Research reports**: Use researcher patterns for fact-checking
- **Documentation**: Use technical writing patterns
- **Social media**: Use engagement-focused patterns

### Dynamic API Usage
```bash
# Example: Research-optimized request
curl -X POST https://fabric-ai.rohi.life/chat \
  -H "Content-Type: application/json" \
  -H "X-API-Key: $FABRIC_API_KEY" \
  -d '{
    "prompts": [{
      "userInput": "Research query here",
      "model": "best-research-model-available",
      "pattern": "researcher-pattern"
    }],
    "language": "en"
  }'

# Example: Content creation request  
curl -X POST https://fabric-ai.rohi.life/chat \
  -H "Content-Type: application/json" \
  -H "X-API-Key: $FABRIC_API_KEY" \
  -d '{
    "prompts": [{
      "userInput": "Content creation request",
      "model": "best-creative-model-available", 
      "pattern": "publisher-pattern"
    }],
    "language": "en"
  }'
```

### Buddy's Free Will Integration
This setup gives Buddy the capability to:
1. **Discover available resources** on each interaction
2. **Select optimal models/patterns** based on task requirements
3. **Enhance all responses** with appropriate AI assistance
4. **Adapt to new models/patterns** as they become available
5. **Provide context-aware** tool selection for maximum efficiency
# Check if API key is set
echo "FABRIC_API_KEY: ${FABRIC_API_KEY:-'NOT SET'}"

# Set API key temporarily
export FABRIC_API_KEY="your_api_key_here"

# Add to .env file permanently
echo "FABRIC_API_KEY=your_api_key_here" >> infrastructure/fabric-ai/.env
```

## AI Agent Usage Patterns

### Publisher Agent (Content Strategy)
```bash
# Use Publisher Agent for content evaluation
curl -X POST https://fabric-ai.rohi.life/chat \
  -H "Content-Type: application/json" \
  -H "X-API-Key: $FABRIC_API_KEY" \
  -d '{
    "prompts": [{
      "systemPrompt": "'"$(cat docs/fabric-ai/ai_agent_prompts.md | sed -n '/^## Publisher Agent$/,/^## /p' | head -n -1)"'",
      "userInput": "Evaluate this blog post draft: [CONTENT HERE]",
      "model": "gemini-2.0-flash-exp",
      "temperature": 0.7
    }]
  }'
```

### Researcher Agent (Fact Checking)
```bash
# Use Researcher Agent with web search context
curl -X POST https://fabric-ai.rohi.life/chat \
  -H "Content-Type: application/json" \
  -H "X-API-Key: $FABRIC_API_KEY" \
  -d '{
    "prompts": [{
      "systemPrompt": "'"$(cat docs/fabric-ai/ai_agent_prompts.md | sed -n '/^## Researcher Agent$/,/^## /p' | head -n -1)"'",
      "userInput": "Research and fact-check: [TOPIC OR CLAIM HERE]",
      "model": "gemini-2.0-flash-exp"
    }]
  }'
```

### Editor Agent (Content Refinement)
```bash
# Use Editor Agent for linguistic improvements
curl -X POST https://fabric-ai.rohi.life/chat \
  -H "Content-Type: application/json" \
  -H "X-API-Key: $FABRIC_API_KEY" \
  -d '{
    "prompts": [{
      "systemPrompt": "'"$(cat docs/fabric-ai/ai_agent_prompts.md | sed -n '/^## Editor Agent$/,/^## /p' | head -n -1)"'",
      "userInput": "Edit and improve this content: [CONTENT HERE]",
      "model": "gemini-2.0-flash-exp"
    }]
  }'
```

### SEO Optimizer Agent
```bash
# Use SEO Optimizer for search optimization
curl -X POST https://fabric-ai.rohi.life/chat \
  -H "Content-Type: application/json" \
  -H "X-API-Key: $FABRIC_API_KEY" \
  -d '{
    "prompts": [{
      "systemPrompt": "'"$(cat docs/fabric-ai/ai_agent_prompts.md | sed -n '/^## SEO Optimizer Agent$/,/^## /p' | head -n -1)"'",
      "userInput": "Optimize for SEO: [CONTENT HERE]",
      "model": "gemini-2.0-flash-exp"
    }]
  }'
```

## Batch Processing Commands

### Process Multiple Content Pieces
```bash
#!/bin/bash
# batch-fabric-process.sh - Process multiple files through Fabric AI

FABRIC_ENDPOINT="https://fabric-ai.rohi.life/chat"
AGENT_TYPE="$1"  # publisher, researcher, editor, seo
INPUT_DIR="$2"   # Directory with content files

if [ -z "$FABRIC_API_KEY" ]; then
    echo "Error: FABRIC_API_KEY not set"
    exit 1
fi

# Get agent prompt
AGENT_PROMPT=$(cat docs/fabric-ai/ai_agent_prompts.md | sed -n "/^## ${AGENT_TYPE^} Agent$/,/^## /p" | head -n -1)

for file in "$INPUT_DIR"/*.md; do
    echo "Processing: $file"
    content=$(cat "$file")
    
    curl -X POST "$FABRIC_ENDPOINT" \
      -H "Content-Type: application/json" \
      -H "X-API-Key: $FABRIC_API_KEY" \
      -d "{
        \"prompts\": [{
          \"systemPrompt\": \"$AGENT_PROMPT\",
          \"userInput\": \"$content\",
          \"model\": \"gemini-2.0-flash-exp\"
        }]
      }" > "${file}.processed"
    
    echo "Saved to: ${file}.processed"
done
```

### Content Pipeline Script
```bash
#!/bin/bash
# content-pipeline.sh - Full AI content processing pipeline

CONTENT_FILE="$1"
OUTPUT_DIR="pipeline_output"

mkdir -p "$OUTPUT_DIR"

echo "=== Starting Content Pipeline for $CONTENT_FILE ==="

# Step 1: Publisher evaluation
echo "Step 1: Publisher evaluation..."
bash batch-fabric-process.sh publisher "$(dirname "$CONTENT_FILE")"

# Step 2: Research enhancement  
echo "Step 2: Research enhancement..."
bash batch-fabric-process.sh researcher "$(dirname "$CONTENT_FILE")"

# Step 3: Editorial refinement
echo "Step 3: Editorial refinement..."
bash batch-fabric-process.sh editor "$(dirname "$CONTENT_FILE")"

# Step 4: SEO optimization
echo "Step 4: SEO optimization..."
bash batch-fabric-process.sh seo "$(dirname "$CONTENT_FILE")"

echo "=== Pipeline Complete! Check $OUTPUT_DIR/ ==="
```

## n8n Integration Commands

### Test n8n to Fabric AI Connection
```bash
# Test from n8n container
docker exec n8n curl -X POST https://fabric-ai.rohi.life/chat \
  -H "Content-Type: application/json" \
  -H "X-API-Key: $FABRIC_API_KEY" \
  -d '{"prompts":[{"userInput":"n8n test","model":"gemini-2.0-flash-exp"}]}'
```

### Export n8n Workflows Using Fabric AI
```bash
# Export AI blogger workflows
docker exec n8n n8n export:workflow --all --output=/data/workflows/

# List workflows that use Fabric AI
docker exec n8n n8n list:workflow | grep -i "fabric\|ai\|blog"
```

## Troubleshooting Commands

### Check Fabric AI Status
```bash
# Full health check
echo "=== Fabric AI Health Check ==="
echo "Container status:"
docker ps | grep fabric-ai

echo "Service logs (last 50 lines):"
docker logs fabric-ai --tail 50

echo "API connectivity:"
curl -s -o /dev/null -w "Status: %{http_code}, Time: %{time_total}s\n" \
  -X GET https://fabric-ai.rohi.life/health \
  -H "X-API-Key: $FABRIC_API_KEY"

echo "Available models:"
curl -s https://fabric-ai.rohi.life/models \
  -H "X-API-Key: $FABRIC_API_KEY" | jq -r '.[]'
```

### Fix Common Issues
```bash
# Restart with fresh logs
docker-compose -f infrastructure/fabric-ai/docker-compose.yml down
docker-compose -f infrastructure/fabric-ai/docker-compose.yml up -d
docker logs fabric-ai -f

# Check environment variables
docker exec fabric-ai printenv | grep -E "(API_KEY|MODEL|PORT)"

# Test with minimal request
curl -X POST https://fabric-ai.rohi.life/chat \
  -H "Content-Type: application/json" \
  -H "X-API-Key: $FABRIC_API_KEY" \
  -d '{"prompts":[{"userInput":"test","model":"gemini-2.0-flash-exp"}]}' \
  -v
```

### Performance Monitoring
```bash
# Monitor Fabric AI performance
watch -n 5 'docker stats fabric-ai --no-stream'

# Check response times
for i in {1..10}; do
  curl -w "Request $i: %{time_total}s\n" -o /dev/null -s \
    -X POST https://fabric-ai.rohi.life/chat \
    -H "Content-Type: application/json" \
    -H "X-API-Key: $FABRIC_API_KEY" \
    -d '{"prompts":[{"userInput":"performance test","model":"gemini-2.0-flash-exp"}]}'
done
```

## Quick Reference

```bash
# Essential commands for daily use
alias fabric-test='curl -X POST https://fabric-ai.rohi.life/chat -H "Content-Type: application/json" -H "X-API-Key: $FABRIC_API_KEY" -d '"'"'{"prompts":[{"userInput":"test","model":"gemini-2.0-flash-exp"}]}'"'"''
alias fabric-logs='docker logs fabric-ai -f'
alias fabric-restart='docker-compose -f infrastructure/fabric-ai/docker-compose.yml restart'
alias fabric-status='docker ps | grep fabric-ai && curl -s https://fabric-ai.rohi.life/health -H "X-API-Key: $FABRIC_API_KEY"'
```

Save these aliases to your `~/.zshrc` for quick access!
