# Fabric AI Docker Setup Plan

## The goal of the project 
is to create a containerized environment for Fabric AI that can utilize as tools from n8n workflows, Python scripts, or Node.js applications. This setup will provide a REST API and a web interface for easy interaction with AI models like Ollama and Gemini, all managed through Docker Compose with Traefik for reverse proxy capabilities.

## Overview
This is a containerized setup of Fabric AI that provides both REST API and Web Interface access to AI models including Ollama and Gemini, with Traefik reverse proxy integration.

## Architecture
- **Fabric API**: REST API server on port 8999 with authentication
- **Fabric Web Interface**: SvelteKit web UI on port 5173 
- **Traefik Integration**: SSL termination and routing
- **Multi-Model Support**: Ollama (local) + Gemini (cloud) models
- **Docker Compose**: Orchestrated with environment variables

## Quick Start
```bash
# 1. Copy environment template
cp .env.example .env

# 2. Edit your environment variables
nano .env

# 3. Build and start services
docker-compose up -d

# 4. Test API
curl -H "X-API-Key: YOUR_API_KEY" http://localhost:8999/models/names

# 5. Access web interface
open http://localhost:5173
```

## Environment Setup
All configuration is handled through environment variables in `.env` file:
- Ollama connection settings
- Gemini API key
- API authentication key
- Traefik domain configuration

## API Usage
The API provides REST endpoints for:
- Model management (`/models/names`)
- Chat functionality (`/chat`)
- Pattern operations (`/patterns/*`)
- Context management (`/contexts/*`)
- Session handling (`/sessions/*`)

## Web Interface Features
- Modern SvelteKit-based UI
- Real-time model interaction
- Pattern library access
- External host support (fabric.rohi.life)
- Responsive design

## Integration Support
Perfect for integration with:
- n8n workflows
- Python/Node.js applications  
- Direct API calls
- Traefik reverse proxy setups