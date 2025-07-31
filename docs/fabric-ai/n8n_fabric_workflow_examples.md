# n8n Fabric AI Workflow Examples

## Example 1: Simple Content Summarizer

```json
{
  "name": "Fabric AI Content Summarizer",
  "nodes": [
    {
      "parameters": {
        "method": "POST",
        "url": "https://fabric-ai.rohi.life/chat",
        "authentication": "none",
        "headers": {
          "Content-Type": "application/json",
          "X-API-Key": "Pluh8-Smiss9-Bop2-Tit1-Glesk3-Snund7-Clint7-Stod3"
        },
        "body": {
          "prompts": [
            {
              "userInput": "={{$json.content}}",
              "model": "llama3.1:8b",
              "patternName": "summarize",
              "contextName": "",
              "strategyName": "",
              "variables": {}
            }
          ],
          "temperature": 0.7,
          "top_p": 1.0,
          "frequency_penalty": 0.0,
          "presence_penalty": 0.0,
          "language": "en"
        }
      },
      "type": "n8n-nodes-base.httpRequest",
      "typeVersion": 4.1,
      "position": [820, 240],
      "id": "fabric-summarizer"
    }
  ],
  "connections": {},
  "active": false,
  "settings": {},
  "versionId": "1"
}
```

## Example 2: AI Publisher Agent Workflow

```json
{
  "name": "AI Publisher Agent",
  "nodes": [
    {
      "parameters": {
        "databaseId": "notion-database-id",
        "simple": false,
        "propertiesToSend": ["Title", "Status", "Content", "Keywords"],
        "filters": {
          "conditions": [
            {
              "key": "Status",
              "condition": "equals",
              "value": "Ready for Review"
            }
          ]
        }
      },
      "type": "n8n-nodes-base.notion",
      "typeVersion": 2,
      "position": [240, 240],
      "id": "notion-trigger",
      "name": "Fetch from Notion"
    },
    {
      "parameters": {
        "method": "POST",
        "url": "https://fabric-ai.rohi.life/chat",
        "headers": {
          "Content-Type": "application/json",
          "X-API-Key": "Pluh8-Smiss9-Bop2-Tit1-Glesk3-Snund7-Clint7-Stod3"
        },
        "body": {
          "prompts": [
            {
              "userInput": "Content Title: {{$json.Title}}\nContent: {{$json.Content}}\nKeywords: {{$json.Keywords}}\n\nPlease analyze this content and provide a quality assessment with recommendations.",
              "model": "gemini-2.0-flash-exp",
              "patternName": "analyze_content",
              "contextName": "publisher_context",
              "variables": {
                "role": "publisher",
                "focus": "quality_and_seo"
              }
            }
          ]
        }
      },
      "type": "n8n-nodes-base.httpRequest",
      "typeVersion": 4.1,
      "position": [460, 240],
      "id": "publisher-agent",
      "name": "Publisher Analysis"
    },
    {
      "parameters": {
        "conditions": {
          "string": [
            {
              "value1": "={{$json.quality_score}}",
              "operation": "largerEqual",
              "value2": "80"
            }
          ]
        }
      },
      "type": "n8n-nodes-base.if",
      "typeVersion": 1,
      "position": [680, 240],
      "id": "quality-check",
      "name": "Quality Check"
    }
  ],
  "connections": {
    "Fetch from Notion": {
      "main": [
        [
          {
            "node": "Publisher Analysis",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "Publisher Analysis": {
      "main": [
        [
          {
            "node": "Quality Check",
            "type": "main",
            "index": 0
          }
        ]
      ]
    }
  }
}
```

## Example 3: Multi-Agent Content Pipeline

```json
{
  "name": "Multi-Agent Content Pipeline",
  "nodes": [
    {
      "parameters": {
        "method": "POST",
        "url": "https://fabric-ai.rohi.life/chat",
        "headers": {
          "Content-Type": "application/json",
          "X-API-Key": "Pluh8-Smiss9-Bop2-Tit1-Glesk3-Snund7-Clint7-Stod3"
        },
        "body": {
          "prompts": [
            {
              "userInput": "Research Request: {{$json.research_task}}\nContent Draft: {{$json.content}}",
              "model": "llama3.1:8b",
              "patternName": "research_and_verify",
              "contextName": "research_context_{{$json.session_id}}",
              "variables": {
                "agent_role": "researcher",
                "research_depth": "thorough",
                "focus_areas": "{{$json.focus_areas}}"
              }
            }
          ]
        }
      },
      "type": "n8n-nodes-base.httpRequest",
      "typeVersion": 4.1,
      "position": [240, 140],
      "id": "researcher-agent",
      "name": "Researcher Agent"
    },
    {
      "parameters": {
        "method": "POST",
        "url": "https://fabric-ai.rohi.life/chat",
        "headers": {
          "Content-Type": "application/json",
          "X-API-Key": "Pluh8-Smiss9-Bop2-Tit1-Glesk3-Snund7-Clint7-Stod3"
        },
        "body": {
          "prompts": [
            {
              "userInput": "Content to Edit: {{$json.content}}\nResearch Findings: {{$json.research_results}}",
              "model": "gemini-2.0-flash-exp",
              "patternName": "edit_content",
              "contextName": "editor_context_{{$json.session_id}}",
              "variables": {
                "agent_role": "linguistic_editor",
                "style_guide": "technical_blog",
                "target_audience": "developers"
              }
            }
          ]
        }
      },
      "type": "n8n-nodes-base.httpRequest",
      "typeVersion": 4.1,
      "position": [240, 340],
      "id": "editor-agent",
      "name": "Editor Agent"
    },
    {
      "parameters": {
        "method": "POST",
        "url": "https://fabric-ai.rohi.life/chat",
        "headers": {
          "Content-Type": "application/json",
          "X-API-Key": "Pluh8-Smiss9-Bop2-Tit1-Glesk3-Snund7-Clint7-Stod3"
        },
        "body": {
          "prompts": [
            {
              "userInput": "Research Results: {{$json.research_results}}\nEdited Content: {{$json.edited_content}}\nOriginal Requirements: {{$json.requirements}}",
              "model": "gemini-2.0-flash-exp",
              "patternName": "publisher_review",
              "contextName": "publisher_context_{{$json.session_id}}",
              "variables": {
                "agent_role": "publisher",
                "decision_criteria": "quality,accuracy,seo,brand_voice"
              }
            }
          ]
        }
      },
      "type": "n8n-nodes-base.httpRequest",
      "typeVersion": 4.1,
      "position": [460, 240],
      "id": "publisher-agent",
      "name": "Publisher Final Review"
    }
  ]
}
```

## Quick Setup Checklist

### 1. Environment Setup
- [ ] Set `FABRIC_API_KEY=Pluh8-Smiss9-Bop2-Tit1-Glesk3-Snund7-Clint7-Stod3` in n8n environment
- [ ] Verify Fabric AI is accessible at `https://fabric-ai.rohi.life`
- [ ] Test API connectivity with curl command

### 2. Basic HTTP Request Node Setup
- [ ] Method: POST
- [ ] URL: `https://fabric-ai.rohi.life/chat`
- [ ] Headers: Content-Type: application/json, X-API-Key: {{$env.FABRIC_API_KEY}}
- [ ] Body: Use the basic request structure from documentation

### 3. Agent-Specific Configurations
- [ ] Publisher Agent: Use gemini-2.0-flash-exp with analysis patterns
- [ ] Researcher Agent: Use llama3.1:8b with research patterns
- [ ] Editor Agent: Use gemini-2.0-flash-exp with editing patterns

### 4. Context Management
- [ ] Use session_id for related operations
- [ ] Set appropriate contextName for conversation continuity
- [ ] Include relevant variables for agent roles

### 5. Error Handling
- [ ] Add retry logic for API timeouts
- [ ] Validate responses before processing
- [ ] Include fallback mechanisms for critical workflows

## Testing Commands

```bash
# Test Publisher Agent
curl -X POST https://fabric-ai.rohi.life/chat \
  -H "Content-Type: application/json" \
  -H "X-API-Key: Pluh8-Smiss9-Bop2-Tit1-Glesk3-Snund7-Clint7-Stod3" \
  -d '{
    "prompts": [{
      "userInput": "Analyze this blog post for quality and SEO optimization: [Your content here]",
      "model": "gemini-2.0-flash-exp",
      "patternName": "analyze_content",
      "variables": {"role": "publisher"}
    }]
  }'

# Test Researcher Agent
curl -X POST https://fabric-ai.rohi.life/chat \
  -H "Content-Type: application/json" \
  -H "X-API-Key: Pluh8-Smiss9-Bop2-Tit1-Glesk3-Snund7-Clint7-Stod3" \
  -d '{
    "prompts": [{
      "userInput": "Research and verify these claims: [Claims to check]",
      "model": "llama3.1:8b",
      "patternName": "research_and_verify",
      "variables": {"research_depth": "thorough"}
    }]
  }'

# Test Editor Agent
curl -X POST https://fabric-ai.rohi.life/chat \
  -H "Content-Type: application/json" \
  -H "X-API-Key: Pluh8-Smiss9-Bop2-Tit1-Glesk3-Snund7-Clint7-Stod3" \
  -d '{
    "prompts": [{
      "userInput": "Edit this content for clarity and engagement: [Content to edit]",
      "model": "gemini-2.0-flash-exp",
      "patternName": "edit_content",
      "variables": {"style_guide": "technical_blog"}
    }]
  }'
```
