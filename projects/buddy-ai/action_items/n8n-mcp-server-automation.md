# Automate Model Context Protocol (MCP) Server Deployment with n8n

![In Progress](https://img.shields.io/badge/Status-In%20Progress-yellow?style=flat-square) ![High Priority](https://img.shields.io/badge/Priority-High-orange?style=flat-square)

## Description
Utilize n8n to create a workflow for deploying and managing multiple Model Context Protocol (MCP) servers. This task should also enable Buddy AI to initiate and manage these deployments, providing an option for self-service deployment.

## Key Objectives

### 1. Research & Learning (Leveraging Fabric-AI)
- **MCP Server Fundamentals**: Deep dive into the architecture, deployment requirements, and common use cases of MCP servers. Understand their role in facilitating communication between AI models and data sources.
- **n8n Capabilities for Server Provisioning**: Explore n8n's capabilities for system automation, specifically for server provisioning (e.g., using SSH, Docker, cloud APIs like AWS, Azure, GCP, or a local hypervisor) relevant to MCP server deployment.
- **Fabric-AI for Knowledge Acquisition**: Utilize Fabric-AI to accelerate the learning process. This includes using Fabric-AI patterns to:
    - Summarize documentation on MCP servers and n8n automation.
    - Extract key information on best practices for server provisioning.
    - Generate questions or prompts for further research on specific technical challenges.

### 2. n8n Workflow Design & Implementation
- **Parameterization**: Design an n8n workflow that can accept parameters for MCP server configuration (e.g., server name, specific protocol versions, data source connections, security settings).
- **Provisioning Logic**: Implement nodes for:
    - Provisioning a new server instance suitable for an MCP server (e.g., creating a Docker container, a VM, or interacting with a cloud provider API).
    - Installing necessary dependencies and configuring the MCP server software.
    - Ensuring the MCP server runs persistently and is accessible.
    - Handling potential errors and providing robust logging.
- **Feedback & Monitoring**: Design the workflow to provide clear feedback on deployment status and potential issues.

### 3. Buddy AI Integration
- **Triggering Workflows**: Explore how Buddy AI can trigger this n8n workflow, passing the necessary parameters for MCP server deployment.
- **Status Monitoring**: Investigate how Buddy AI can monitor the status of the n8n workflow execution and the deployed MCP server.
- **Self-Service Option**: Implement a command or process within Buddy AI that allows the user to request a new MCP server deployment, with Buddy AI handling the n8n interaction.

## Status
- **Overall Status**: In Progress (Research Phase Complete)
- **Assigned To**: Buddy / Rohi (Collaborative)
- **Priority**: High

## Progress Update (2025-08-05)

### ✅ Completed
- **MCP Protocol Research**: Deep understanding of JSON-RPC 2.0, SSE streams, session management
- **n8n MCP Integration Discovery**: Found existing n8n Notion MCP server at `https://n8n.rohi.life/mcp/*`
- **Tool Discovery**: Identified "Search_page_Notion" tool with correct parameter structure
- **Architecture Analysis**: Understanding of stateless HTTP vs session persistence challenge
- **CLI Development**: Multiple test scripts for MCP protocol interaction
- **Documentation**: Comprehensive findings documented in TODO and changelog

### 🔄 Current Challenge
- **Session Management**: n8n MCP server requires persistent sessions but HTTP requests are stateless
- **Tool Execution**: Can initialize MCP server successfully but "Server not initialized" for tool calls
- **Implementation Gap**: Need to bridge stateless HTTP with session-based MCP protocol

### 📋 Next Steps
1. **Clean up CLI tools** - Remove messy test scripts, keep only working solutions
2. **Fix session persistence** - Implement proper session management for tool calls
3. **Create working Notion integration** - Functional search and create operations
4. **Document final solution** - Working buddy-ai → n8n → Notion workflow

## Notes
Research phase revealed that user already has working n8n MCP infrastructure. Focus shifted from deployment to integration and session management solutions.
