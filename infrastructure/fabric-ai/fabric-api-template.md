# Fabric AI API Usage Template

## Overview
This template shows how to properly use the Fabric AI REST API for various tasks.

## Base Configuration
- **API URL**: `http://localhost:8999` (local) or `https://fabric-ai.yourdomain.com` (production)
- **Content-Type**: `application/json`
- **Method**: `POST`
- **Endpoint**: `/chat`

## Basic Request Format

```json
{
  "prompts": [
    {
      "userInput": "Your message/content here",
      "model": "gemini-2.0-flash-exp",
      "patternName": "",
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
```

## Example Templates

### 1. Simple Chat (No Pattern)
```bash
curl -X POST http://localhost:8999/chat \
  -H "Content-Type: application/json" \
  -d '{
    "prompts": [
      {
        "userInput": "Hello, can you help me with a simple question?",
        "model": "gemini-2.0-flash-exp",
        "patternName": "",
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
  }'
```

### 2. Summarize Pattern
```bash
curl -X POST http://localhost:8999/chat \
  -H "Content-Type: application/json" \
  -d '{
    "prompts": [
      {
        "userInput": "This is a long article about AI developments...",
        "model": "gemini-2.0-flash-exp",
        "patternName": "summarize",
        "contextName": "",
        "strategyName": "",
        "variables": {}
      }
    ],
    "temperature": 0.5,
    "top_p": 1.0,
    "frequency_penalty": 0.0,
    "presence_penalty": 0.0,
    "language": "en"
  }'
```

### 3. Extract Ideas Pattern
```bash
curl -X POST http://localhost:8999/chat \
  -H "Content-Type: application/json" \
  -d '{
    "prompts": [
      {
        "userInput": "Content you want to extract ideas from...",
        "model": "gemini-2.0-flash-exp",
        "patternName": "extract_ideas",
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
  }'
```

### 4. Create Summary with Variables
```bash
curl -X POST http://localhost:8999/chat \
  -H "Content-Type: application/json" \
  -d '{
    "prompts": [
      {
        "userInput": "Article content here...",
        "model": "gemini-2.0-flash-exp",
        "patternName": "create_summary",
        "contextName": "",
        "strategyName": "",
        "variables": {
          "length": "short",
          "style": "bullet_points"
        }
      }
    ],
    "temperature": 0.5,
    "top_p": 1.0,
    "frequency_penalty": 0.0,
    "presence_penalty": 0.0,
    "language": "en"
  }'
```

### 5. French Language Response
```bash
curl -X POST http://localhost:8999/chat \
  -H "Content-Type: application/json" \
  -d '{
    "prompts": [
      {
        "userInput": "Explain artificial intelligence",
        "model": "gemini-2.0-flash-exp",
        "patternName": "",
        "contextName": "",
        "strategyName": "",
        "variables": {}
      }
    ],
    "temperature": 0.7,
    "top_p": 1.0,
    "frequency_penalty": 0.0,
    "presence_penalty": 0.0,
    "language": "fr"
  }'
```

### 6. Using Ollama Models
```bash
curl -X POST http://localhost:8999/chat \
  -H "Content-Type: application/json" \
  -d '{
    "prompts": [
      {
        "userInput": "Write a short poem about Docker",
        "model": "llama3.2:latest",
        "patternName": "",
        "contextName": "",
        "strategyName": "",
        "variables": {}
      }
    ],
    "temperature": 0.8,
    "top_p": 1.0,
    "frequency_penalty": 0.0,
    "presence_penalty": 0.0,
    "language": "en"
  }'
```

## Available Models
Get the list of available models:
```bash
curl -X GET http://localhost:8999/models/names
```

## Available Patterns
Get the list of available patterns:
```bash
curl -X GET http://localhost:8999/patterns
```

## Parameter Descriptions

### Required Fields
- **userInput**: Your message or content to process
- **model**: The AI model to use (e.g., "gemini-2.0-flash-exp", "llama3.2:latest")

### Optional Fields
- **patternName**: Fabric pattern to apply (e.g., "summarize", "extract_ideas", "create_summary")
- **contextName**: Context file to use for additional information
- **strategyName**: Strategy to prepend to the system message
- **variables**: Key-value pairs for pattern variables
- **temperature**: Creativity level (0.0-2.0, default: 0.7)
- **top_p**: Nucleus sampling (0.0-1.0, default: 1.0)
- **frequency_penalty**: Reduce repetition (0.0-1.0, default: 0.0)
- **presence_penalty**: Encourage new topics (0.0-1.0, default: 0.0)
- **language**: Response language ("en", "fr", "es", "de", etc.)

## Response Format
The API returns Server-Sent Events (SSE) with this format:
```
data: {"type":"content","format":"markdown","content":"Response text..."}
data: {"type":"complete","format":"plain","content":""}
```

## Error Handling
- **400**: Bad request format
- **500**: Internal server error
- **200**: Success (even if no content in prompts array)

## Tips for Success
1. Always include at least one prompt in the `prompts` array
2. Use appropriate models for your task (Gemini for general tasks, Ollama for local processing)
3. Set temperature lower (0.3-0.5) for factual content, higher (0.7-1.0) for creative content
4. Use patterns for specific tasks (summarization, idea extraction, etc.)
5. Include language parameter for non-English responses

## Integration Examples

### Python Integration
```python
import requests
import json

def call_fabric_api(user_input, pattern="", model="gemini-2.0-flash-exp"):
    url = "http://localhost:8999/chat"
    
    payload = {
        "prompts": [{
            "userInput": user_input,
            "model": model,
            "patternName": pattern,
            "contextName": "",
            "strategyName": "",
            "variables": {}
        }],
        "temperature": 0.7,
        "top_p": 1.0,
        "frequency_penalty": 0.0,
        "presence_penalty": 0.0,
        "language": "en"
    }
    
    response = requests.post(url, json=payload, stream=True)
    
    for line in response.iter_lines():
        if line.startswith(b'data: '):
            data = json.loads(line[6:])
            if data.get('type') == 'content':
                print(data.get('content', ''), end='')
            elif data.get('type') == 'complete':
                print()  # New line at completion
                break

# Usage
call_fabric_api("Explain Docker containers", "summarize")
```

### Node.js Integration
```javascript
const axios = require('axios');

async function callFabricAPI(userInput, pattern = '', model = 'gemini-2.0-flash-exp') {
    const payload = {
        prompts: [{
            userInput: userInput,
            model: model,
            patternName: pattern,
            contextName: '',
            strategyName: '',
            variables: {}
        }],
        temperature: 0.7,
        top_p: 1.0,
        frequency_penalty: 0.0,
        presence_penalty: 0.0,
        language: 'en'
    };

    try {
        const response = await axios.post('http://localhost:8999/chat', payload, {
            responseType: 'stream'
        });

        response.data.on('data', (chunk) => {
            const lines = chunk.toString().split('\n');
            for (const line of lines) {
                if (line.startsWith('data: ')) {
                    const data = JSON.parse(line.slice(6));
                    if (data.type === 'content') {
                        process.stdout.write(data.content);
                    } else if (data.type === 'complete') {
                        console.log(); // New line
                        return;
                    }
                }
            }
        });
    } catch (error) {
        console.error('Error:', error.message);
    }
}

// Usage
callFabricAPI('Explain Docker containers', 'summarize');
```

### bash Integration
```bash
curl -X POST http://localhost:8999/chat \
  -H "Content-Type: application/json" \
  -d '{
    "prompts": [
      {
        "userInput": "What is Docker?",
        "model": "gemini-2.0-flash-exp",
        "patternName": "",
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
  }' | jq -r '.content'
``` 
## Troubleshooting

### Common Issues
1. **"Language: '', Prompts: 0"** - Wrong JSON structure, use the format above
2. **Empty responses** - Check if the model name is correct
3. **Connection refused** - Verify Fabric container is running on port 8999
4. **Pattern not found** - Use `/patterns` endpoint to get valid pattern names

### Debug Commands
```bash
# Check if Fabric is running
curl -X GET http://localhost:8999/models/names

# Check container logs
docker-compose logs fabric-ai

# Test basic connectivity
curl -X POST http://localhost:8999/chat -H "Content-Type: application/json" -d '{"prompts":[{"userInput":"test","model":"gemini-2.0-flash-exp","patternName":"","contextName":"","strategyName":"","variables":{}}],"temperature":0.7,"top_p":1.0,"frequency_penalty":0.0,"presence_penalty":0.0,"language":"en"}'
```
