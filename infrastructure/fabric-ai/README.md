# Fabric AI Docker Setup

A complete containerized setup for [Fabric AI](https://github.com/danielmiessler/fabric) with REST API, Web Interface, and Traefik integration.

## 🚀 Features

- **Dual Interface**: REST API (port 8999) + Web UI (port 5173)
- **Multi-Model Support**: Ollama (local) + Gemini (cloud) models
- **API Authentication**: Secure API key authentication
- **Traefik Ready**: SSL termination and reverse proxy support
- **External Access**: Configured for external domain access
- **Environment Driven**: Complete configuration via `.env` file

## 📋 Prerequisites

- Docker & Docker Compose
- Ollama service (for local models)
- Gemini API key (for cloud models)
- Traefik (optional, for SSL/domain routing)

## 🛠️ Quick Setup

### 1. Environment Configuration
```bash
# Copy the example environment file
cp .env.example .env

# Edit with your settings
nano .env
```

### 2. Start Services
```bash
# Build and start in background
docker-compose up -d

# Watch logs
docker-compose logs -f
```

### 3. Verify Installation
```bash
# Test API
curl -H "X-API-Key: YOUR_API_KEY" http://localhost:8999/models/names

# Access Web UI
open http://localhost:5173
```

## 🔧 Configuration

### Environment Variables (.env)
```properties
# Model Configuration
FABRIC_DEFAULT_MODEL="llama3.1"
FABRIC_OLLAMA_URL="http://ollama:11434"

# API Security
FABRIC_API_KEY="your-secure-api-key-here"
FABRIC_REQUIRE_AUTH=true

# Cloud Models (Optional)
FABRIC_GEMINI_API_KEY="your-gemini-api-key"

# Traefik Configuration (Optional)
TRAEFIK_DOMAIN="yourdomain.com"
FABRIC_AI_SUBDOMAIN="fabric-ai"
FABRIC_WEB_SUBDOMAIN="fabric"
```

### Available Models
The setup automatically detects:
- **Ollama Models**: All locally installed models
- **Gemini Models**: Full Gemini model family (50+ models)

## 📡 API Usage

### Authentication
All API requests require the `X-API-Key` header:
```bash
curl -H "X-API-Key: YOUR_API_KEY" http://localhost:8999/endpoint
```

### Key Endpoints
- `GET /models/names` - List available models
- `POST /chat` - Chat with models
- `GET /patterns/names` - List available patterns
- `POST /patterns/apply` - Apply patterns to text
- `GET /config` - Configuration status

### Chat Example
```bash
curl -X POST http://localhost:8999/chat \
  -H "Content-Type: application/json" \
  -H "X-API-Key: YOUR_API_KEY" \
  -d '{
    "prompts": [{
      "userInput": "Hello! How are you?",
      "model": "llama3.1:8b"
    }],
    "language": "en"
  }'
```

## 🌐 Web Interface

### Access Points
- **Local**: http://localhost:5173
- **External**: https://fabric.yourdomain.com (with Traefik)

### Features
- Real-time chat with AI models
- Pattern library browser
- Context management
- Session handling
- Mobile responsive design

## 🔒 Security

### API Key Authentication
- Required for all API endpoints
- Configurable via `FABRIC_API_KEY` environment variable
- Use strong, unique keys in production

### Network Security
- Internal Docker networking for Ollama communication
- Traefik SSL termination
- Configurable IP allowlists (via Traefik)

## 🚦 Traefik Integration

### Automatic SSL & Routing
The setup includes Traefik labels for:
- **API Domain**: `https://fabric-ai.yourdomain.com`
- **Web Domain**: `https://fabric.yourdomain.com`
- **SSL Certificates**: Automatic Let's Encrypt
- **Security Headers**: HSTS, CSRF protection
- **Rate Limiting**: Configurable request limits

### DNS Requirements
Add these DNS records:
```
fabric-ai.yourdomain.com    A    YOUR_SERVER_IP
fabric.yourdomain.com       A    YOUR_SERVER_IP
```

## 🧪 Development & Testing

### Local Development
```bash
# Start in development mode
docker-compose up

# Rebuild after changes
docker-compose build --no-cache

# View logs
docker-compose logs -f fabric-ai
```

### API Testing
See `fabric-api-template.md` for comprehensive API examples and integration code.

### Debugging
```bash
# Check container status
docker-compose ps

# Access container shell
docker exec -it fabric-ai sh

# View configuration
docker exec fabric-ai cat /root/.config/fabric/config.yaml
```

## 📊 Integration Examples

### n8n Workflow
```javascript
// HTTP Request Node Configuration
{
  "method": "POST",
  "url": "http://fabric-ai:8999/chat",
  "headers": {
    "Content-Type": "application/json",
    "X-API-Key": "{{$env.FABRIC_API_KEY}}"
  },
  "body": {
    "prompts": [{
      "userInput": "{{$json.message}}",
      "model": "llama3.1:8b"
    }]
  }
}
```

### Python Integration
```python
import requests

def chat_with_fabric(message, model="llama3.1:8b"):
    response = requests.post(
        "http://localhost:8999/chat",
        headers={
            "Content-Type": "application/json",
            "X-API-Key": "YOUR_API_KEY"
        },
        json={
            "prompts": [{
                "userInput": message,
                "model": model
            }],
            "language": "en"
        }
    )
    return response.json()
```
## bash Integration
```bash
#!/bin/bash
curl -X POST https://fabric-ai.rohi.life/chat \
  -H "Content-Type: application/json" \
  -H "X-API-Key: YOUR_API_KEY" \
  -d '{"prompts": [{"userInput": "What is Docker?", "model": "gemini-2.0-flash-exp"}], "language": "en"}'
```


#### Container Restart Loop
```bash
# Check logs for errors
docker logs fabric-ai

# Verify environment variables
docker exec fabric-ai env | grep FABRIC
```

#### API Not Responding
```bash
# Test internal connectivity
docker exec fabric-ai wget -qO- http://localhost:8999/models/names

# Verify Ollama connection
docker exec fabric-ai wget -qO- http://ollama:11434/api/tags
```

#### Web Interface Access Denied
- Check `allowedHosts` configuration
- Verify domain DNS resolution
- Check Traefik routing rules

### Performance Tuning
- Adjust memory limits in docker-compose.yml
- Configure Ollama model preloading
- Enable Traefik compression

## 📂 File Structure
```
fabric-ai/
├── README.md              # This file
├── docker-compose.yml     # Service definition
├── Dockerfile            # Container build instructions
├── entrypoint.sh         # Container startup script
├── .env.example          # Environment template
├── .env                  # Your configuration (gitignored)
├── fabric-api-template.md # API usage examples
├── plan.md               # Project planning notes
└── UPDATES_SUMMARY.md    # Development changelog
```

## 📄 License

This setup follows the same license as [Fabric AI](https://github.com/danielmiessler/fabric).

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Test your changes
4. Submit a pull request

## 📚 Resources

- [Fabric AI Documentation](https://github.com/danielmiessler/fabric)
- [Ollama Setup Guide](https://ollama.ai)
- [Traefik Documentation](https://doc.traefik.io/traefik/)
- [Docker Compose Reference](https://docs.docker.com/compose/)

---

**Need help?** Check the troubleshooting section or open an issue with your logs and configuration.
