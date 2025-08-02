# Fabric AI Integration Guide 🤖

Complete guide for using your self-hosted Fabric AI framework for multi-agent content creation.

## Service Overview

**Endpoint**: `https://fabric-ai.rohi.life`  
**Authentication**: X-API-Key header  
**Location**: `projects/buddy-ai/tools/fabric-ai/`  
**Models**: Gemini 2.0 Flash Experimental, GPT-4, Claude 3.5

## Quick Commands

### Test Fabric AI Connection
```bash
# Basic connectivity test (verified working format)
# Ensure FABRIC_API_KEY is exported (see "API Key Usage" section)
curl -X POST https://fabric-ai.rohi.life/chat \
  -H "Content-Type: application/json" \
  -H "X-API-Key: $FABRIC_API_KEY" \
  -d '{
    "prompts": [{
      "userInput": "Hello, test connection",
      "model": "llama3.1:8b" # Or any other available model
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
Buddy will dynamically select the best model and pattern based on your request.
When you use `run_shell_command` with Fabric AI, Buddy will analyze your `userInput` and choose the most appropriate `model` and `patternName` from the available options.

```bash
# Example: General request (Buddy will choose model and pattern)
# Ensure FABRIC_API_KEY is exported (see "API Key Usage" section)
curl -X POST https://fabric-ai.rohi.life/chat \
  -H "Content-Type: application/json" \
  -H "X-API-Key: $FABRIC_API_KEY" \
  -d '{
    "prompts": [{
      "userInput": "YOUR_REQUEST_OR_CONTENT_HERE", # Replace with your actual request or content
      "model": "gemini-2.0-flash-exp", # Buddy will dynamically select the best model
      "patternName": "summarize" # Buddy will dynamically select the best pattern
    }],
    "language": "en"
  }'

# Example: Research-optimized request (Buddy will choose model and pattern)
# Ensure FABRIC_API_KEY is exported (see "API Key Usage" section)
curl -X POST https://fabric-ai.rohi.life/chat \
  -H "Content-Type: application/json" \
  -H "X-API-Key: $FABRIC_API_KEY" \
  -d '{
    "prompts": [{
      "userInput": "RESEARCH_QUERY_HERE", # Replace with your actual research query
      "model": "best-research-model-available", # Buddy will dynamically select the best research model
      "patternName": "researcher-pattern" # Buddy will dynamically select the best research pattern
    }],
    "language": "en"
  }'

# Example: Content creation request (Buddy will choose model and pattern)
# Ensure FABRIC_API_KEY is exported (see "API Key Usage" section)
curl -X POST https://fabric-ai.rohi.life/chat \
  -H "Content-Type: application/json" \
  -H "X-API-Key: $FABRIC_API_KEY" \
  -d '{
    "prompts": [{
      "userInput": "CONTENT_CREATION_REQUEST_HERE", # Replace with your actual content creation request
      "model": "best-creative-model-available", # Buddy will dynamically select the best creative model
      "patternName": "publisher-pattern" # Buddy will dynamically select the best publishing pattern
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
## API Key Usage
To use the `curl` commands below, ensure your `FABRIC_API_KEY` is set as an environment variable.
You can find this key in `infrastructure/fabric-ai/.env`.

```bash
# Example: Export the API key (replace with your actual key)
export FABRIC_API_KEY="YOUR_FABRIC_API_KEY" # Replace with your actual key
```

## AI Agent Usage Patterns
Buddy is designed to dynamically select the most appropriate model and pattern for your request. However, if you wish to explicitly use a specific AI Agent pattern, you can do so as shown below. Remember to replace `[CONTENT HERE]` or `[TOPIC OR CLAIM HERE]` with your actual input.

### Publisher Agent (Content Strategy)
```bash
# Use Publisher Agent for content evaluation
# Ensure FABRIC_API_KEY is exported (see "API Key Usage" section)
curl -X POST https://fabric-ai.rohi.life/chat \
  -H "Content-Type: application/json" \
  -H "X-API-Key: $FABRIC_API_KEY" \
  -d '{
    "prompts": [{
      "patternName": "Publisher Agent", # Explicitly use the Publisher Agent pattern
      "userInput": "Evaluate this blog post draft: [CONTENT HERE]",
      "model": "gemini-2.0-flash-exp", # Or any other suitable model
      "temperature": 0.7
    }]
  }'
```

### Researcher Agent (Fact Checking)
```bash
# Use Researcher Agent with web search context
# Ensure FABRIC_API_KEY is exported (see "API Key Usage" section)
curl -X POST https://fabric-ai.rohi.life/chat \
  -H "Content-Type: application/json" \
  -H "X-API-Key: $FABRIC_API_KEY" \
  -d '{
    "prompts": [{
      "patternName": "Researcher Agent", # Explicitly use the Researcher Agent pattern
      "userInput": "Research and fact-check: [TOPIC OR CLAIM HERE]",
      "model": "gemini-2.0-flash-exp" # Or any other suitable model
    }]
  }'
```

### Editor Agent (Content Refinement)
```bash
# Use Editor Agent for linguistic improvements
# Ensure FABRIC_API_KEY is exported (see "API Key Usage" section)
curl -X POST https://fabric-ai.rohi.life/chat \
  -H "Content-Type: application/json" \
  -H "X-API-Key: $FABRIC_API_KEY" \
  -d '{
    "prompts": [{
      "patternName": "Editor Agent", # Explicitly use the Editor Agent pattern
      "userInput": "Edit and improve this content: [CONTENT HERE]",
      "model": "gemini-2.0-flash-exp" # Or any other suitable model
    }]
  }'
```

### SEO Optimizer Agent
```bash
# Use SEO Optimizer for search optimization
# Ensure FABRIC_API_KEY is exported (see "API Key Usage" section)
curl -X POST https://fabric-ai.rohi.life/chat \
  -H "Content-Type: application/json" \
  -H "X-API-Key: $FABRIC_API_KEY" \
  -d '{
    "prompts": [{
      "patternName": "SEO Optimizer Agent", # Explicitly use the SEO Optimizer Agent pattern
      "userInput": "Optimize for SEO: [CONTENT HERE]",
      "model": "gemini-2.0-flash-exp" # Or any other suitable model
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

## Local `fabric-ai` Command Usage

While `curl` commands directly interact with the Fabric AI API, you can also use the local `fabric-ai` command-line tool installed on your system. To ensure it communicates correctly with your Dockerized Ollama instance, you need to configure its environment.

### Configuring Local `fabric-ai` for Dockerized Ollama

The local `fabric-ai` command needs to know where your Ollama service is running. This is typically done via an `.env` file in your local Fabric AI configuration directory (usually `~/.config/fabric/`).

1.  **Locate your local Fabric AI config directory:**
    ```bash
    ls -F ~/.config/fabric/
    ```
2.  **Create or edit the `.env` file:**
    Add or update the `FABRIC_OLLAMA_URL` and `FABRIC_API_KEY` variables to point to your Dockerized Ollama and Fabric AI instances.

    ```properties
    # Example content for ~/.config/fabric/.env
    FABRIC_OLLAMA_URL="http://ollama:11434" # Use the internal Docker network address
    FABRIC_API_KEY="YOUR_FABRIC_API_KEY" # Your Fabric AI API Key
    ```
    **Note:** The `FABRIC_API_KEY` here should match the one in `infrastructure/fabric-ai/.env`.

### Using the Local `fabric-ai` Command

Once configured, you can use the `fabric-ai` command directly. Buddy will still analyze your request and dynamically select the best model and pattern for the task.

```bash
# Example: Summarize content using the local fabric-ai command
# Buddy will dynamically select the best model and pattern for summarization
fabric-ai --pattern summarize "YOUR_CONTENT_TO_SUMMARIZE_HERE"

# Example: Ask a general question (Buddy will choose model and pattern)
fabric-ai "What is the capital of France?"

# Example: Use a specific agent pattern
fabric-ai --pattern "Publisher Agent" "Evaluate this blog post draft: [CONTENT HERE]"
```

**Troubleshooting Note for Pattern Outputs:**
If a `fabric-ai` command with a specific pattern (e.g., `summarize`) returns generic or unexpected content (like a marketing text or a meta-response about summarizing), this indicates that the pattern itself might not be processing the input as expected within the Fabric AI service. The issue is likely with the pattern's internal logic or its interaction with the AI model, rather than the command syntax or connectivity. Further debugging of the pattern within your Fabric AI instance may be required.

This setup allows you to leverage the convenience of the local `fabric-ai` command while still benefiting from Buddy's intelligent model and pattern selection.
