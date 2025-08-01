# SearxNG Integration Guide 🔍

Complete guide for using SearxNG privacy-focused search engine for research workflows.

## Service Overview

**Authentication**: None required (open access)  
**Default URL**: `https://searxng.rohi.life`  
**Location**: `infrastructure/searxng-docker/`  
**Purpose**: Privacy-focused search aggregation, research data gathering  
**Integration**: Powers your research and fact-checking workflows

## Quick Commands

### Test SearxNG Connection
```bash
# Basic connectivity test
curl -X GET "https://searxng.rohi.life/search?q=test&format=json" | jq -r '.results[0:3]'

# Health check
curl -X GET "https://searxng.rohi.life/stats" | jq -r '.engines'

# Search with specific parameters
curl -X GET "https://searxng.rohi.life/search?q=docker+compose&format=json&engines=google,duckduckgo" \
  | jq -r '.results[0:5] | .[] | "\(.title): \(.url)"'
```

### Deploy/Restart SearxNG
```bash
# Navigate to SearxNG directory
cd infrastructure/searxng-docker/

# Start the service
docker-compose up -d

# Check logs
docker-compose logs -f searxng

# Restart if needed
docker-compose restart searxng

# Check container status
docker ps | grep searxng
```

### Environment Setup
```bash
# Set SearxNG URL for scripts
export SEARXNG_URL="https://searxng.rohi.life"

# Add to .env file
echo "SEARXNG_URL=https://searxng.rohi.life" >> .env

# For external access (if configured)
export SEARXNG_URL="https://searxng.rohi.life"
```

## Search Commands

### Basic Search Operations
```bash
# Simple search function
search_basic() {
    local query="$1"
    curl -X GET "https://searxng.rohi.life/search?q=$query&format=json" \
      | jq -r '.results[0:10] | .[] | "\(.title)\n\(.url)\n---"'
}

# Usage
search_basic "docker security best practices"
```

### Advanced Search with Filters
```bash
# Search with specific engines
search_engines() {
    local query="$1"
    local engines="${2:-google,duckduckgo,bing}"
    
    curl -X GET "https://searxng.rohi.life/search?q=$query&format=json&engines=$engines" \
      | jq -r ".results[0:5] | .[] | {title, url, content}"
}

# Search recent content only
search_recent() {
    local query="$1"
    local time_range="${2:-year}"  # day, week, month, year
    
    curl -X GET "https://searxng.rohi.life/search?q=$query&format=json&time_range=$time_range" \
      | jq -r '.results[0:10] | .[] | "\(.title): \(.url)"'
}
```

### Category-Specific Searches
```bash
# Search technical documentation
search_docs() {
    local query="$1"
    curl -X GET "https://searxng.rohi.life/search?q=$query+documentation+OR+docs&format=json&engines=google,duckduckgo" \
      | jq -r '.results[0:8] | .[] | select(.url | contains("docs") or contains("documentation")) | "\(.title)\n\(.url)\n"'
}

# Search GitHub repositories
search_github() {
    local query="$1"
    curl -X GET "https://searxng.rohi.life/search?q=site:github.com+$query&format=json" \
      | jq -r '.results[0:10] | .[] | "\(.title)\n\(.url)\n"'
}

# Search Stack Overflow
search_stackoverflow() {
    local query="$1"
    curl -X GET "https://searxng.rohi.life/search?q=site:stackoverflow.com+$query&format=json" \
      | jq -r '.results[0:10] | .[] | "\(.title)\n\(.url)\n"'
}
```

## Research Workflow Integration

### Research Pipeline with Firecrawl
```bash
#!/bin/bash
# research-pipeline.sh - Complete research workflow using SearxNG + Firecrawl

TOPIC="$1"
NUM_SOURCES="${2:-5}"
OUTPUT_DIR="research_$(echo "$TOPIC" | sed 's/ /_/g')_$(date +%Y%m%d_%H%M%S)"

mkdir -p "$OUTPUT_DIR"

echo "=== Researching: $TOPIC ==="

# Step 1: Search for sources
echo "Step 1: Finding $NUM_SOURCES sources..."
curl -X GET "https://searxng.rohi.life/search?q=$TOPIC&format=json" \
  | jq -r ".results[0:$NUM_SOURCES] | .[] | .url" > "$OUTPUT_DIR/sources.txt"

echo "Found sources:"
cat "$OUTPUT_DIR/sources.txt"

# Step 2: Extract content from each source using Firecrawl
echo "Step 2: Extracting content..."
counter=1
while IFS= read -r url; do
    echo "Extracting from source $counter: $url"
    filename="source_${counter}.txt"
    
    curl -X POST http://localhost:3002/v0/scrape \
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
          \"extractionPrompt\": \"Extract key information about $TOPIC including facts, statistics, examples, and important details.\"
        }
      }" | jq -r '.data.content // "No content extracted"' > "$OUTPUT_DIR/$filename"
    
    ((counter++))
    sleep 1  # Rate limiting
done < "$OUTPUT_DIR/sources.txt"

# Step 3: Create summary
echo "Step 3: Creating research summary..."
echo "# Research Summary: $TOPIC" > "$OUTPUT_DIR/SUMMARY.md"
echo "Generated: $(date)" >> "$OUTPUT_DIR/SUMMARY.md"
echo "" >> "$OUTPUT_DIR/SUMMARY.md"

counter=1
while IFS= read -r url; do
    echo "## Source $counter" >> "$OUTPUT_DIR/SUMMARY.md"
    echo "URL: $url" >> "$OUTPUT_DIR/SUMMARY.md"
    echo "" >> "$OUTPUT_DIR/SUMMARY.md"
    cat "$OUTPUT_DIR/source_${counter}.txt" >> "$OUTPUT_DIR/SUMMARY.md"
    echo "" >> "$OUTPUT_DIR/SUMMARY.md"
    echo "---" >> "$OUTPUT_DIR/SUMMARY.md"
    echo "" >> "$OUTPUT_DIR/SUMMARY.md"
    ((counter++))
done < "$OUTPUT_DIR/sources.txt"

echo "Research complete! Check $OUTPUT_DIR/SUMMARY.md"
```

### Fact-Checking Workflow
```bash
#!/bin/bash
# fact-check.sh - Verify claims using multiple search engines

CLAIM="$1"
OUTPUT_FILE="fact_check_$(date +%Y%m%d_%H%M%S).md"

echo "# Fact Check: $CLAIM" > "$OUTPUT_FILE"
echo "Date: $(date)" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Search with different engines for verification
engines=("google" "duckduckgo" "bing" "yahoo")

for engine in "${engines[@]}"; do
    echo "## Results from $engine" >> "$OUTPUT_FILE"
    
    curl -X GET "https://searxng.rohi.life/search?q=$CLAIM&format=json&engines=$engine" \
      | jq -r '.results[0:3] | .[] | "**\(.title)**\n\(.url)\n\(.content // "No preview available")\n"' >> "$OUTPUT_FILE"
    
    echo "" >> "$OUTPUT_FILE"
done

echo "Fact-check complete! Check $OUTPUT_FILE"
```

### Content Ideas Generation
```bash
# content-ideas.sh - Generate content ideas for blog topics
generate_content_ideas() {
    local base_topic="$1"
    local ideas_file="content_ideas_$(date +%Y%m%d).md"
    
    echo "# Content Ideas: $base_topic" > "$ideas_file"
    echo "Generated: $(date)" >> "$ideas_file"
    echo "" >> "$ideas_file"
    
    # Search for related topics
    related_searches=(
        "$base_topic tutorial"
        "$base_topic best practices"
        "$base_topic troubleshooting"
        "$base_topic vs alternatives"
        "$base_topic automation"
        "$base_topic security"
    )
    
    for search_term in "${related_searches[@]}"; do
        echo "## Ideas from: $search_term" >> "$ideas_file"
        
        curl -X GET "https://searxng.rohi.life/search?q=$search_term&format=json" \
          | jq -r '.results[0:5] | .[] | "- \(.title)"' >> "$ideas_file"
        
        echo "" >> "$ideas_file"
    done
    
    echo "Content ideas saved to: $ideas_file"
}
```

## Advanced Search Techniques

### Competitive Research
```bash
# competitor-analysis.sh - Research competitor content
analyze_competitors() {
    local topic="$1"
    local competitors=("$@")  # Pass competitor domains as arguments
    
    for competitor in "${competitors[@]:1}"; do
        echo "=== Analyzing $competitor ==="
        
        curl -X GET "https://searxng.rohi.life/search?q=site:$competitor+$topic&format=json" \
          | jq -r '.results[] | "\(.title)\n\(.url)\n\(.content // "")\n---"'
        
        echo ""
    done
}

# Usage
# analyze_competitors "docker tutorial" "docs.docker.com" "medium.com" "dev.to"
```

### Trend Research
```bash
# trend-research.sh - Find trending topics in your niche
find_trends() {
    local niche="$1"
    local timeframe="${2:-month}"
    
    trends=(
        "$niche 2024"
        "$niche latest"
        "$niche new features"
        "$niche updates"
        "best $niche tools"
    )
    
    for trend in "${trends[@]}"; do
        echo "=== Trending: $trend ==="
        
        curl -X GET "https://searxng.rohi.life/search?q=$trend&format=json&time_range=$timeframe" \
          | jq -r '.results[0:3] | .[] | "\(.title) (\(.url))"'
        
        echo ""
    done
}
```

## n8n Integration Commands

### Test from n8n
```bash
# Test SearxNG from n8n container
docker exec n8n curl -X GET "http://searxng:8080/search?q=test&format=json" \
  | jq -r '.results[0:3]'
```

### Search Function for n8n Workflows
```javascript
// For use in n8n Function nodes
const searchQuery = $input.first().json.query;
const searxngUrl = 'http://searxng:8080';

const response = await $http.request({
  method: 'GET',
  url: `${searxngUrl}/search`,
  qs: {
    q: searchQuery,
    format: 'json',
    engines: 'google,duckduckgo'
  }
});

return response.results.slice(0, 5).map(result => ({
  title: result.title,
  url: result.url,
  content: result.content
}));
```

## Troubleshooting Commands

### Health Check
```bash
# Full SearxNG health check
echo "=== SearxNG Health Check ==="
echo "Container status:"
docker ps | grep searxng

echo "Service logs (last 20 lines):"
docker logs searxng --tail 20

echo "API connectivity:"
curl -s -o /dev/null -w "Status: %{http_code}, Time: %{time_total}s\n" \
  -X GET "https://searxng.rohi.life/search?q=test&format=json"

echo "Available engines:"
curl -s "https://searxng.rohi.life/stats" | jq -r '.engines | keys[]' | head -10

echo "Test search:"
curl -s "https://searxng.rohi.life/search?q=test&format=json" \
  | jq -r '.results | length' | xargs echo "Results found:"
```

### Performance Monitoring
```bash
# Monitor search response times
test_search_performance() {
    queries=("docker" "kubernetes" "security" "automation" "cloud")
    
    for query in "${queries[@]}"; do
        echo "Testing search: $query"
        curl -w "Time: %{time_total}s\n" -o /dev/null -s \
          "https://searxng.rohi.life/search?q=$query&format=json"
    done
}

# Monitor container resources
watch -n 5 'docker stats searxng --no-stream'
```

## Quick Reference

```bash
# Essential SearxNG commands
alias search='curl -s "https://searxng.rohi.life/search?q=$1&format=json" | jq -r ".results[0:5] | .[] | \"\(.title): \(.url)\""'
alias searxng-logs='docker logs searxng -f'
alias searxng-restart='docker-compose -f infrastructure/searxng-docker/docker-compose.yml restart'
alias searxng-status='docker ps | grep searxng && curl -s "https://searxng.rohi.life/stats" | jq -r ".engines | length" | xargs echo "Engines available:"'

# Quick search function
qsearch() {
    curl -s "https://searxng.rohi.life/search?q=$1&format=json" \
      | jq -r '.results[0:5] | .[] | "\(.title)\n\(.url)\n---"'
}
```

Save these aliases to your `~/.zshrc` for quick access!
