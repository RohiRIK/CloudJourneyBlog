# Buddy AI → Buddy PAI Transformation Map

**Document**: Feature Evolution Roadmap  
**Purpose**: Map how existing Buddy AI capabilities transform into PAI agents  
**Date**: August 7, 2025  

---

## Overview
This document outlines how each feature of Buddy AI will evolve into specialized agents within the Personal AI Infrastructure (PAI) framework. The goal is to create a network of autonomous agents that work together to achieve complex tasks, reducing manual effort and enhancing productivity.

## Transformation Vision
Buddy AI is evolving from a single assistant into a **Personal AI Infrastructure (PAI)** that consists of multiple specialized agents. Each agent will focus on a specific domain, allowing for deep expertise and autonomous operation. This transformation will enable Buddy PAI to handle complex tasks that require collaboration between agents,

## Core Principles

### Persona

**Current Buddy AI Personality that scales across PAI agents:**

* **Unwavering Support**: Always on Rohi's side with encouragement and understanding
* **Extreme Patience**: Calm and helpful regardless of user frustration or stress  
* **Proactive Assistance**: Takes burden off Rohi, uses phrases like "I've got this" and "Let me handle it"
* **Informal & Friendly**: Natural, buddy-like tone, not corporate formality

**Personal Context for Rohi:**

* Goals: Next year exploration (2 countries), fitness, investments
* Interests: Kettlebells, Flair 58 espresso, home lab
* Values: Efficiency, automation, work-life balance

**Signature Elements:**

* Primary: "Buddy-ai — Because everyone needs a some-buddy"
* Secondary: "Ayaa Karte Chop!" + context-specific action phrase
* Frustration Protocol: 1) Acknowledge feelings, 2) Take over the task

**PAI Evolution**: Each specialized agent inherits core personality while developing domain expertise

### Context

**Knowledge Management Evolution:**

* **Current**: Just-in-time knowledge retrieval from `navigation.json` index
* **PAI Future**: Permanent knowledge graph with agent-specific expertise domains

**Workflow Pattern:**

1. Analyze Request → 2. Formulate Plan → 3. Retrieve Knowledge → 4. Execute Task

**Operating Rules:**

* Mimic existing patterns for consistency
* Prioritize established workflows over custom solutions
* Security-first approach (cybersecurity protocol)
* Self-correction loops for core changes
* Action items for complex projects

**PAI Context Expansion**: Shared knowledge base + agent-specific specializations

## API-fication of Everything (as metaphor)

### Commands

**Current Buddy AI Command Categories → PAI API Endpoints:**

* **Fabric CLI Commands → Native CLI Service**:
  * **Current**: Manual CLI commands like `fabric --pattern analyze_paper --model gemini-2.5-pro input.txt`
  * **PAI Transform**: `fabric-cli.pai.local` service wraps CLI for agents
  * **Result**: Agents can execute any Fabric pattern programmatically
  * **Core Service**: Native Fabric CLI wrapper in PAI network
  * **Pattern Engine**: Direct CLI access to 209 patterns via `fabric --pattern {pattern}`
  * **Model Router**: CLI model selection via `--model {model}` flags
  * **Strategy Engine**: CLI strategies via `--strategy {cot|tot|self-refine}` flags
  * **Agent Integration**: Each PAI agent can execute Fabric CLI commands directly


* **Docker Commands → Infrastructure APIs**:
  * **Current**: Manual commands like `cd infrastructure/fabric-ai && docker-compose up -d`
  * **PAI Transform**: Infrastructure service manages all containers
  * **Result**: Agents can control infrastructure programmatically
  * **Service Management**: Automated container lifecycle management
  * **Health Monitoring**: Real-time health dashboard across all services
  * **Log Management**: Centralized log aggregation and streaming
  * **Deployment**: Orchestrated deployment with dependency management

* **Content Commands → Content Pipeline APIs**:
  * **Current**: Manual blog creation, file editing, template usage
  * **PAI Transform**: Content intelligence service automates pipeline
  * **Result**: Agents can create and manage content programmatically

* **Security Commands → Automated Security APIs**:
  * **Current**: Manual API key scanning, .gitignore management
  * **PAI Transform**: Security service continuously monitors and protects
  * **Result**: Automated secret detection and protection

### External APIs

* **SearxNG as Search Aggregator**:
  * **Current**: Manual web searches via browser
  * **PAI Transform**: Agents use SearxNG for privacy-focused search
  * **Service**: `searxng.rohi.life` - Self-hosted search aggregator
  * **Agent Access**: Research agents can search across multiple engines
  * **Features**: Privacy-focused, no tracking, multiple search engines
  * **Use Cases**: Research automation, content discovery, fact checking

* **Firecrawl for Web Scraping**:
  * **Current**: Manual copy/paste from websites
  * **PAI Transform**: Agents use Firecrawl for structured web data extraction
  * **Service**: `firecrawl.rohi.life` - Self-hosted web scraping service
  * **Agent Access**: Content agents can scrape and process web content
  * **Features**: Clean HTML extraction, PDF processing, structured data
  * **Use Cases**: Content research, competitor analysis, data collection





# we stop here!!!!!


### MCPs

**Model Context Protocol Servers for External Tool Integration:**

wil set in mcp.json

* **n8n Workflow MCP**: `mcp://n8n-workflow-server`
  * Workflow Execution: Trigger n8n workflows from any agent
  * Status Monitoring: Real-time workflow status and results
  * Webhook Integration: Bidirectional communication with external systems

* **Notion Integration MCP**: `mcp://notion-server`  
  * Database Operations: Search, create, update Notion pages/databases
  * Content Sync: Bidirectional sync between agents and Notion
  * Knowledge Base: Structured information storage and retrieval

* **Web Intelligence MCP**: `mcp://web-intel-server`
  * Firecrawl Integration: Web scraping and content extraction
  * SearxNG Integration: Privacy-focused search aggregation  
  * Research Automation: Multi-source research compilation

* **Home Lab Management MCP**: `mcp://homelab-server`
  * Infrastructure Monitoring: Docker services, resource usage
  * Service Discovery: Automatic detection of new services
  * Configuration Management: Environment variables, secrets

### Microservices

**Specialized Microservices for Agent Communication:**

* **Fabric CLI Service**: `fabric-cli.pai.local`
  * **CLI Wrapper**: Executes Fabric CLI commands on behalf of agents
  * **Pattern Repository**: Access to all 209 patterns via `fabric --pattern {pattern}`
  * **Model Management**: CLI model switching via `--model {gemini|ollama|deepseek}`
  * **Strategy Execution**: CLI reasoning strategies via `--strategy {cot|tot|self-refine}`
  * **Agent CLI Interface**: Each PAI agent can execute Fabric CLI commands
  * **Output Processing**: Parses CLI output and returns structured data
  * **Process Management**: Handles CLI execution, timeouts, and error handling

* **Knowledge Graph Service**: `knowledge-graph.pai.local`
  * Persistent memory across all agents
  * Relationship mapping between entities
  * Context sharing and knowledge synthesis

* **Agent Orchestration Service**: `orchestrator.pai.local`  
  * Agent coordination and task distribution
  * Workflow execution and monitoring
  * Inter-agent communication routing

* **Security Service**: `security.pai.local`
  * Centralized secret scanning and management
  * Access control and authentication
  * Audit logging and compliance monitoring

* **Content Intelligence Service**: `content.pai.local`
  * Multi-modal content processing
  * Fabric AI pattern routing and optimization
  * Content quality assessment and validation

* **Infrastructure Service**: `infra.pai.local`
  * Docker service management and health monitoring
  * Resource allocation and scaling decisions
  * Deployment automation and rollback capabilities

## Sub-Agents

---

**Ayaa Karte Chop!** 🚀

*Simple, clear transformation map focused on the core principles that matter.*

**Next Action**: Fill out each section with specific details as we develop the PAI system.
