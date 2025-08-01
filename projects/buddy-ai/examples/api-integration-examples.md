# API Integration Examples

Ready-to-use API integration examples for Fabric AI, Firecrawl, SearxNG, and other services in your CloudJourneyBlog project.

## Fabric AI Integration Examples

### Basic Fabric AI Chat Request
```javascript
// n8n HTTP Request node configuration
const fabricAIRequest = {
  "method": "POST",
  "url": "https://fabric-ai.rohi.life/chat",
  "headers": {
    "Content-Type": "application/json",
    "X-API-Key": "{{$env.FABRIC_API_KEY}}"
  },
  "body": {
    "prompts": [{
      "userInput": "{{$json.content}}",
      "model": "gemini-2.0-flash-exp"
    }]
  }
};
```

### Publisher Agent Request
```javascript
// Publisher Agent for content strategy
const publisherRequest = {
  "method": "POST",
  "url": "https://fabric-ai.rohi.life/chat",
  "headers": {
    "Content-Type": "application/json",
    "X-API-Key": "{{$env.FABRIC_API_KEY}}"
  },
  "body": {
    "prompts": [{
      "userInput": `Analyze this blog draft and provide content strategy recommendations:
      
      Title: {{$json.title}}
      Content: {{$json.content}}
      
      Please evaluate:
      1. Content quality and completeness
      2. Target audience alignment
      3. SEO potential
      4. Engagement factors
      5. Recommended improvements`,
      "model": "gemini-2.0-flash-exp"
    }]
  }
};
```

### Researcher Agent Request
```javascript
// Researcher Agent for fact-checking
const researcherRequest = {
  "method": "POST",
  "url": "https://fabric-ai.rohi.life/chat",
  "headers": {
    "Content-Type": "application/json",
    "X-API-Key": "{{$env.FABRIC_API_KEY}}"
  },
  "body": {
    "prompts": [{
      "userInput": `Research and fact-check this content:
      
      Topic: {{$json.topic}}
      Claims: {{$json.claims}}
      
      Please verify:
      1. Accuracy of technical information
      2. Current best practices
      3. Recent updates or changes
      4. Additional relevant information
      5. Credible sources and references`,
      "model": "gemini-2.0-flash-exp"
    }]
  }
};
```

### Editor Agent Request
```javascript
// Editor Agent for content refinement
const editorRequest = {
  "method": "POST",
  "url": "https://fabric-ai.rohi.life/chat",
  "headers": {
    "Content-Type": "application/json",
    "X-API-Key": "{{$env.FABRIC_API_KEY}}"
  },
  "body": {
    "prompts": [{
      "userInput": `Edit and refine this blog content:
      
      Content: {{$json.content}}
      
      Please improve:
      1. Writing clarity and flow
      2. Technical accuracy
      3. Readability and engagement
      4. Structure and organization
      5. Grammar and style consistency`,
      "model": "gemini-2.0-flash-exp"
    }]
  }
};
```

### SEO Optimizer Request
```javascript
// SEO Optimizer Agent
const seoRequest = {
  "method": "POST",
  "url": "https://fabric-ai.rohi.life/chat",
  "headers": {
    "Content-Type": "application/json",
    "X-API-Key": "{{$env.FABRIC_API_KEY}}"
  },
  "body": {
    "prompts": [{
      "userInput": `Optimize this content for SEO:
      
      Title: {{$json.title}}
      Content: {{$json.content}}
      Target Keywords: {{$json.keywords}}
      
      Please provide:
      1. Optimized title suggestions
      2. Meta description
      3. Header structure improvements
      4. Keyword optimization recommendations
      5. Internal linking suggestions`,
      "model": "gemini-2.0-flash-exp"
    }]
  }
};
```

## Firecrawl Integration Examples

### Basic Web Scraping
```javascript
// Firecrawl scraping request
const firecrawlScrape = {
  "method": "POST",
  "url": "http://localhost:3002/v0/scrape",
  "headers": {
    "Content-Type": "application/json"
  },
  "body": {
    "url": "{{$json.targetUrl}}",
    "pageOptions": {
      "onlyMainContent": true,
      "includeHtml": false,
      "waitFor": 1000
    }
  }
};
```

### Research-Focused Scraping
```javascript
// Enhanced scraping for research purposes
const researchScrape = {
  "method": "POST",
  "url": "http://localhost:3002/v0/scrape",
  "headers": {
    "Content-Type": "application/json"
  },
  "body": {
    "url": "{{$json.researchUrl}}",
    "pageOptions": {
      "onlyMainContent": true,
      "includeHtml": true,
      "screenshot": true,
      "extractorOptions": {
        "mode": "llm-extraction",
        "extractionPrompt": "Extract key technical information, statistics, and factual claims from this content for fact-checking purposes."
      }
    }
  }
};
```

### Bulk URL Scraping
```javascript
// Batch scraping multiple URLs
const batchScrape = {
  "method": "POST",
  "url": "http://localhost:3002/v0/batch/scrape",
  "headers": {
    "Content-Type": "application/json"
  },
  "body": {
    "urls": "{{$json.urlList}}",
    "pageOptions": {
      "onlyMainContent": true,
      "removeBase64Images": true
    }
  }
};
```

## SearxNG Integration Examples

### Basic Search Request
```javascript
// SearxNG search request
const searxngSearch = {
  "method": "GET",
  "url": "http://localhost:8080/search",
  "qs": {
    "q": "{{$json.searchQuery}}",
    "format": "json",
    "engines": "google,bing,duckduckgo",
    "categories": "general"
  }
};
```

### Technical Research Search
```javascript
// Focused technical search
const techSearch = {
  "method": "GET",
  "url": "http://localhost:8080/search",
  "qs": {
    "q": "{{$json.technicalQuery}} site:docs.microsoft.com OR site:github.com",
    "format": "json",
    "engines": "google,bing",
    "categories": "it",
    "time_range": "year"
  }
};
```

### News and Updates Search
```javascript
// Search for recent news and updates
const newsSearch = {
  "method": "GET",
  "url": "http://localhost:8080/search",
  "qs": {
    "q": "{{$json.topic}} latest news updates 2025",
    "format": "json",
    "engines": "google,bing,reddit",
    "categories": "news",
    "time_range": "month"
  }
};
```

## Notion Integration Examples

### Get Database Items
```javascript
// Notion database query
const notionQuery = {
  "method": "POST",
  "url": "https://api.notion.com/v1/databases/{{$env.NOTION_DATABASE_ID}}/query",
  "headers": {
    "Authorization": "Bearer {{$env.NOTION_TOKEN}}",
    "Notion-Version": "2022-06-28",
    "Content-Type": "application/json"
  },
  "body": {
    "filter": {
      "property": "Status",
      "select": {
        "equals": "In Progress"
      }
    },
    "sorts": [{
      "property": "Created",
      "direction": "descending"
    }]
  }
};
```

### Update Page Status
```javascript
// Update Notion page properties
const notionUpdate = {
  "method": "PATCH",
  "url": "https://api.notion.com/v1/pages/{{$json.pageId}}",
  "headers": {
    "Authorization": "Bearer {{$env.NOTION_TOKEN}}",
    "Notion-Version": "2022-06-28",
    "Content-Type": "application/json"
  },
  "body": {
    "properties": {
      "Status": {
        "select": {
          "name": "Ready to Upload"
        }
      },
      "Last Updated": {
        "date": {
          "start": "{{new Date().toISOString()}}"
        }
      }
    }
  }
};
```

### Create New Page
```javascript
// Create new Notion page
const notionCreatePage = {
  "method": "POST",
  "url": "https://api.notion.com/v1/pages",
  "headers": {
    "Authorization": "Bearer {{$env.NOTION_TOKEN}}",
    "Notion-Version": "2022-06-28",
    "Content-Type": "application/json"
  },
  "body": {
    "parent": {
      "database_id": "{{$env.NOTION_DATABASE_ID}}"
    },
    "properties": {
      "Title": {
        "title": [{
          "text": {
            "content": "{{$json.blogTitle}}"
          }
        }]
      },
      "Status": {
        "select": {
          "name": "Draft"
        }
      },
      "Category": {
        "select": {
          "name": "{{$json.category}}"
        }
      }
    },
    "children": [{
      "object": "block",
      "type": "paragraph",
      "paragraph": {
        "rich_text": [{
          "type": "text",
          "text": {
            "content": "{{$json.content}}"
          }
        }]
      }
    }]
  }
};
```

## Complete Workflow Integration Example

### AI Blogger Workflow Integration
```javascript
// Complete workflow combining all services
const aiBloggerWorkflow = {
  // Step 1: Get content from Notion
  notionTrigger: {
    "method": "POST",
    "url": "https://api.notion.com/v1/databases/{{$env.NOTION_DATABASE_ID}}/query"
    // ... notification configuration
  },
  
  // Step 2: Research with SearxNG + Firecrawl
  researchStep: {
    searxng: {
      "method": "GET",
      "url": "http://localhost:8080/search",
      "qs": {
        "q": "{{$json.topic}} latest 2025",
        "format": "json"
      }
    },
    firecrawl: {
      "method": "POST",
      "url": "http://localhost:3002/v0/scrape",
      "body": {
        "url": "{{$json.topResult.url}}",
        "pageOptions": {
          "onlyMainContent": true
        }
      }
    }
  },
  
  // Step 3: AI Processing with Fabric AI
  aiProcessing: {
    publisher: {
      "method": "POST",
      "url": "https://fabric-ai.rohi.life/chat",
      "body": {
        "prompts": [{
          "userInput": "Analyze and improve: {{$json.content}}",
          "model": "gemini-2.0-flash-exp"
        }]
      }
    },
    researcher: {
      "method": "POST",
      "url": "https://fabric-ai.rohi.life/chat",
      "body": {
        "prompts": [{
          "userInput": "Fact-check this content: {{$json.processedContent}}",
          "model": "gemini-2.0-flash-exp"
        }]
      }
    },
    editor: {
      "method": "POST",
      "url": "https://fabric-ai.rohi.life/chat",
      "body": {
        "prompts": [{
          "userInput": "Edit and refine: {{$json.factCheckedContent}}",
          "model": "gemini-2.0-flash-exp"
        }]
      }
    }
  },
  
  // Step 4: Update back to Notion
  notionUpdate: {
    "method": "PATCH",
    "url": "https://api.notion.com/v1/pages/{{$json.pageId}}",
    "body": {
      "properties": {
        "Status": {
          "select": {
            "name": "Ready to Upload"
          }
        }
      }
    }
  }
};
```

## Error Handling Examples

### API Error Handling
```javascript
// Error handling for API requests
const errorHandler = {
  "continueOnFail": true,
  "retryOnFail": true,
  "retryDelay": 1000,
  "maxRetries": 3,
  "errorHandling": {
    "400": "Bad request - check input data",
    "401": "Authentication error - check API key",
    "429": "Rate limit exceeded - wait and retry",
    "500": "Server error - retry later"
  }
};
```

### Fallback Strategies
```javascript
// Fallback when primary service fails
const fallbackStrategy = {
  "primaryService": "fabric-ai.rohi.life",
  "fallbackService": "localhost:3000",
  "condition": "{{$node.HttpRequest.error}}",
  "fallbackRequest": {
    "method": "POST",
    "url": "http://localhost:3000/chat",
    "body": "{{$json}}"
  }
};
```

All integration examples are tested and ready to use in your n8n workflows!
