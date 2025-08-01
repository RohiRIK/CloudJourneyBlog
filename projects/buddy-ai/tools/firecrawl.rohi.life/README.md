# Firecrawl Integration Guide 🔥

Complete guide for using Firecrawl web scraping service for research and content extraction.

## Service Overview

**Authentication**: Bearer token  
**Location**: `infrastructure/firecrawl_docker/`  
**Purpose**: Web scraping, content extraction, research data gathering  
**Integration**: Powers your Researcher Agent workflows

## Quick Commands

### Test Firecrawl Connection
```bash
# Basic connectivity test - scrape a single page
curl -X POST https://firecrawl.rohi.life/v0/scrape \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $FIRECRAWL_API_KEY" \
  -d '{
    "url": "https://example.com",
    "pageOptions": {
      "onlyMainContent": true
    }
  }'

# Health check
curl -X GET https://firecrawl.rohi.life/v0/health \
  -H "Authorization: Bearer $FIRECRAWL_API_KEY"

# Check crawl status
curl -X GET https://firecrawl.rohi.life/v0/crawl/status/{crawl_id} \
  -H "Authorization: Bearer $FIRECRAWL_API_KEY"
```

### Deploy/Restart Firecrawl
```bash
# Navigate to Firecrawl directory
cd infrastructure/firecrawl_docker/

# Start the service
docker-compose up -d

# Check logs
docker-compose logs -f firecrawl

# Restart if needed
docker-compose restart firecrawl

# Check container status
docker ps | grep firecrawl
```

### Environment Setup
```bash
# Check if API key is set
echo "FIRECRAWL_API_KEY: ${FIRECRAWL_API_KEY:-'NOT SET'}"

# Set API key temporarily
export FIRECRAWL_API_KEY="your_bearer_token_here"

# Add to .env file permanently
echo "FIRECRAWL_API_KEY=your_bearer_token_here" >> infrastructure/firecrawl_docker/.env
```

## Web Scraping Commands

### Single Page Scraping
```bash
# Scrape with main content only
scrape_page() {
    local url="$1"
    curl -X POST https://firecrawl.rohi.life/v0/scrape \
      -H "Content-Type: application/json" \
      -H "Authorization: Bearer $FIRECRAWL_API_KEY" \
      -d "{
        \"url\": \"$url\",
        \"pageOptions\": {
          \"onlyMainContent\": true,
          \"includeHtml\": false,
          \"waitFor\": 1000
        }
      }" | jq -r '.data.content'
}

# Usage
scrape_page "https://docs.docker.com/compose/"
```

### Content Extraction with Formatting
```bash
# Extract structured content
extract_content() {
    local url="$1"
    curl -X POST https://firecrawl.rohi.life/v0/scrape \
      -H "Content-Type: application/json" \
      -H "Authorization: Bearer $FIRECRAWL_API_KEY" \
      -d "{
        \"url\": \"$url\",
        \"pageOptions\": {
          \"onlyMainContent\": true,
          \"includeHtml\": true,
          \"screenshot\": false
        },
        \"extractorOptions\": {
          \"mode\": \"llm-extraction\",
          \"extractionPrompt\": \"Extract the main points, code examples, and key information from this technical documentation.\"
        }
      }" | jq -r '.data'
}
```

### Batch URL Processing
```bash
#!/bin/bash
# batch-scrape.sh - Scrape multiple URLs

URLS_FILE="$1"  # File with URLs, one per line
OUTPUT_DIR="scraped_content"

mkdir -p "$OUTPUT_DIR"

while IFS= read -r url; do
    echo "Scraping: $url"
    filename=$(echo "$url" | sed 's|https\?://||g' | sed 's|[^a-zA-Z0-9]|_|g')
    
    curl -X POST https://firecrawl.rohi.life/v0/scrape \
      -H "Content-Type: application/json" \
      -H "Authorization: Bearer $FIRECRAWL_API_KEY" \
      -d "{
        \"url\": \"$url\",
        \"pageOptions\": {
          \"onlyMainContent\": true,
          \"waitFor\": 2000
        }
      }" | jq -r '.data.content' > "$OUTPUT_DIR/${filename}.txt"
    
    echo "Saved to: $OUTPUT_DIR/${filename}.txt"
    sleep 1  # Rate limiting
done < "$URLS_FILE"
```

## Research Workflow Integration

### Research a Topic
```bash
#!/bin/bash
# research-topic.sh - Research a topic using Firecrawl + SearxNG

TOPIC="$1"
RESEARCH_DIR="research_$(date +%Y%m%d_%H%M%S)"

mkdir -p "$RESEARCH_DIR"

echo "=== Researching: $TOPIC ==="

# Step 1: Search for relevant URLs (using SearxNG)
echo "Step 1: Finding relevant sources..."
curl -X GET "http://localhost:8080/search?q=$TOPIC&format=json" \
  | jq -r '.results[0:5].url' > "$RESEARCH_DIR/urls.txt"

# Step 2: Scrape each URL
echo "Step 2: Extracting content..."
while IFS= read -r url; do
    filename=$(echo "$url" | sed 's|https\?://||g' | sed 's|[^a-zA-Z0-9]|_|g')
    
    curl -X POST https://firecrawl.rohi.life/v0/scrape \
      -H "Content-Type: application/json" \
      -H "Authorization: Bearer $FIRECRAWL_API_KEY" \
      -d "{
        \"url\": \"$url\",
        \"pageOptions\": {
          \"onlyMainContent\": true,
          \"waitFor\": 1000
        },
        \"extractorOptions\": {
          \"mode\": \"llm-extraction\",
          \"extractionPrompt\": \"Extract key information about $TOPIC including facts, statistics, and important details.\"
        }
      }" | jq -r '.data.content' > "$RESEARCH_DIR/${filename}.txt"
    
    echo "Extracted: $url"
    sleep 2
done < "$RESEARCH_DIR/urls.txt"

echo "Research complete! Check $RESEARCH_DIR/ for results"
```

### Content Fact-Checking
```bash
# fact-check.sh - Verify claims in content
fact_check_content() {
    local content_file="$1"
    local claim="$2"
    
    echo "Fact-checking: $claim"
    
    # Search for verification sources
    search_query=$(echo "$claim" | sed 's/ /+/g')
    curl -X GET "http://localhost:8080/search?q=$search_query+facts+verification&format=json" \
      | jq -r '.results[0:3].url' | while read url; do
        
        echo "Checking source: $url"
        curl -X POST https://firecrawl.rohi.life/v0/scrape \
          -H "Content-Type: application/json" \
          -H "Authorization: Bearer $FIRECRAWL_API_KEY" \
          -d "{
            \"url\": \"$url\",
            \"pageOptions\": {
              \"onlyMainContent\": true
            },
            \"extractorOptions\": {
              \"mode\": \"llm-extraction\",
              \"extractionPrompt\": \"Find information that supports or contradicts this claim: $claim\"
            }
          }" | jq -r '.data.content'
    done
}
```

## Advanced Crawling Commands

### Site Crawling
```bash
# Crawl entire website section
crawl_site() {
    local base_url="$1"
    local max_pages="${2:-10}"
    
    curl -X POST https://firecrawl.rohi.life/v0/crawl \
      -H "Content-Type: application/json" \
      -H "Authorization: Bearer $FIRECRAWL_API_KEY" \
      -d "{
        \"url\": \"$base_url\",
        \"crawlerOptions\": {
          \"maxDepth\": 2,
          \"limit\": $max_pages,
          \"allowBackwardCrawling\": false
        },
        \"pageOptions\": {
          \"onlyMainContent\": true,
          \"waitFor\": 1000
        }
      }"
}

# Monitor crawl progress
monitor_crawl() {
    local crawl_id="$1"
    
    while true; do
        status=$(curl -s -X GET "https://firecrawl.rohi.life/v0/crawl/status/$crawl_id" \
          -H "Authorization: Bearer $FIRECRAWL_API_KEY" \
          | jq -r '.status')
        
        echo "Crawl status: $status"
        
        if [ "$status" = "completed" ] || [ "$status" = "failed" ]; then
            break
        fi
        
        sleep 10
    done
    
    # Get results
    curl -X GET "https://firecrawl.rohi.life/v0/crawl/status/$crawl_id" \
      -H "Authorization: Bearer $FIRECRAWL_API_KEY" \
      | jq -r '.data'
}
```

### Custom Extraction Patterns
```bash
# Extract specific data patterns
extract_technical_docs() {
    local url="$1"
    
    curl -X POST https://firecrawl.rohi.life/v0/scrape \
      -H "Content-Type: application/json" \
      -H "Authorization: Bearer $FIRECRAWL_API_KEY" \
      -d "{
        \"url\": \"$url\",
        \"pageOptions\": {
          \"onlyMainContent\": true,
          \"includeHtml\": false
        },
        \"extractorOptions\": {
          \"mode\": \"llm-extraction\",
          \"extractionPrompt\": \"Extract: 1) Installation commands, 2) Configuration examples, 3) Key concepts, 4) Troubleshooting tips. Format as structured markdown.\"
        }
      }" | jq -r '.data.content'
}

# Extract code examples specifically
extract_code_examples() {
    local url="$1"
    
    curl -X POST https://firecrawl.rohi.life/v0/scrape \
      -H "Content-Type: application/json" \
      -H "Authorization: Bearer $FIRECRAWL_API_KEY" \
      -d "{
        \"url\": \"$url\",
        \"pageOptions\": {
          \"onlyMainContent\": true,
          \"includeHtml\": true
        },
        \"extractorOptions\": {
          \"mode\": \"llm-extraction\",
          \"extractionPrompt\": \"Extract only code examples, commands, and configuration snippets. Preserve original formatting.\"
        }
      }" | jq -r '.data.content'
}
```

## n8n Integration Commands

### Test from n8n
```bash
# Test Firecrawl from n8n container
docker exec n8n curl -X POST http://firecrawl:3002/v0/scrape \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $FIRECRAWL_API_KEY" \
  -d '{
    "url": "https://example.com",
    "pageOptions": {
      "onlyMainContent": true
    }
  }'
```

## Troubleshooting Commands

### Health and Status Check
```bash
# Full Firecrawl health check
echo "=== Firecrawl Health Check ==="
echo "Container status:"
docker ps | grep firecrawl

echo "Service logs (last 50 lines):"
docker logs firecrawl --tail 50

echo "API connectivity:"
curl -s -o /dev/null -w "Status: %{http_code}, Time: %{time_total}s\n" \
  -X GET https://firecrawl.rohi.life/v0/health \
  -H "Authorization: Bearer $FIRECRAWL_API_KEY"

echo "Test scrape:"
curl -X POST https://firecrawl.rohi.life/v0/scrape \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $FIRECRAWL_API_KEY" \
  -d '{"url": "https://httpbin.org/html"}' \
  | jq -r '.success'
```

### Performance Monitoring
```bash
# Monitor Firecrawl performance
watch -n 5 'docker stats firecrawl --no-stream'

# Test response times
for i in {1..5}; do
  curl -w "Request $i: %{time_total}s\n" -o /dev/null -s \
    -X POST https://firecrawl.rohi.life/v0/scrape \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $FIRECRAWL_API_KEY" \
    -d '{"url": "https://example.com", "pageOptions": {"onlyMainContent": true}}'
done
```

## Quick Reference

```bash
# Essential Firecrawl commands
alias firecrawl-test='curl -X POST https://firecrawl.rohi.life/v0/scrape -H "Content-Type: application/json" -H "Authorization: Bearer $FIRECRAWL_API_KEY" -d '"'"'{"url": "https://example.com", "pageOptions": {"onlyMainContent": true}}'"'"''
alias firecrawl-logs='docker logs firecrawl -f'
alias firecrawl-restart='docker-compose -f infrastructure/firecrawl_docker/docker-compose.yml restart'
alias firecrawl-status='docker ps | grep firecrawl && curl -s https://firecrawl.rohi.life/v0/health -H "Authorization: Bearer $FIRECRAWL_API_KEY"'
```

Save these aliases to your `~/.zshrc` for quick access!
