#!/bin/bash

# Flair 58 Research Automation Script
# Combines SearxNG, Firecrawl, and Fabric AI for comprehensive research

echo "🔍 Starting Flair 58 Research Automation..."

# Step 1: Search with SearxNG
echo "=== Step 1: Searching with SearxNG ==="
SEARCH_RESULTS=$(curl -G "https://searxng.rohi.life/search" \
  --data-urlencode "q=Flair 58 espresso machine upgrades accessories modifications" \
  -H "Accept: application/json" 2>/dev/null)

# Extract URLs from search results (you'll need to parse based on actual response format)
echo "$SEARCH_RESULTS" > /tmp/searxng_results.json
echo "✅ Search completed, results saved to /tmp/searxng_results.json"

# Step 2: Scrape top results with Firecrawl
echo "=== Step 2: Scraping content with Firecrawl ==="

# Example URLs to scrape (replace with actual URLs from search results)
URLS=(
  "https://flairespresso.com/flair-58/"
  "https://www.reddit.com/r/espresso/comments/flair58/"
  "https://coffeeforums.co.uk/topic/flair58-upgrades/"
)

SCRAPED_CONTENT=""
for url in "${URLS[@]}"; do
  echo "Scraping: $url"
  CONTENT=$(curl -X POST https://firecrawl.rohi.life/v0/scrape \
    -H "Authorization: Bearer $FIRECRAWL_API_KEY" \
    -H "Content-Type: application/json" \
    -d "{\"url\": \"$url\", \"pageOptions\": {\"onlyMainContent\": true}}" 2>/dev/null)
  
  SCRAPED_CONTENT="$SCRAPED_CONTENT\n\n--- Content from $url ---\n$CONTENT"
done

echo "$SCRAPED_CONTENT" > /tmp/scraped_content.txt
echo "✅ Content scraping completed, saved to /tmp/scraped_content.txt"

# Step 3: Extract insights with Fabric AI
echo "=== Step 3: Extracting insights with Fabric AI ==="

INSIGHTS=$(curl -X POST https://fabric-ai.rohi.life/chat \
  -H "Content-Type: application/json" \
  -H "X-API-Key: Pluh8-Smiss9-Bop2-Tit1-Glesk3-Snund7-Clint7-Stod3" \
  -d "{
    \"prompts\": [{
      \"userInput\": \"Analyze this content about Flair 58 espresso machine upgrades and provide a summary of the best upgrades, accessories, and modifications available. Focus on practical improvements that enhance coffee quality and user experience:\n\n$(cat /tmp/scraped_content.txt | head -c 4000)\",
      \"model\": \"gemini-2.0-flash-exp\"
    }],
    \"language\": \"en\"
  }" 2>/dev/null)

echo "$INSIGHTS" > /tmp/flair58_insights.json
echo "✅ Insights extracted, saved to /tmp/flair58_insights.json"

# Display results
echo "🎯 Research Complete! Here are your Flair 58 upgrade insights:"
echo "=================================================="
echo "$INSIGHTS" | jq -r '.response // .' 2>/dev/null || echo "$INSIGHTS"

echo ""
echo "📁 Files created:"
echo "  - /tmp/searxng_results.json (raw search results)"
echo "  - /tmp/scraped_content.txt (scraped web content)" 
echo "  - /tmp/flair58_insights.json (AI-generated insights)"
echo ""
echo "💡 Automation Opportunity: This could become an n8n workflow!"
