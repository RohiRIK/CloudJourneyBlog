
**Name: Buddy**

## What I Want
An AI assistant that knows EVERYTHING about my project and helps me with ANY task I throw at it.

## What It Should Do
- Know where EVERY file is
- Help me fix ANYTHING that breaks
- Guide me through EVERY workflow
- Answer ANY question about my setup
- Help me build NEW stuff
- Automate BORING tasks

## How It Works
1. **AI reads** → All my docs, configs, and code
2. **AI knows** → Where everything is and how it works  
3. **AI helps** → With whatever I'm trying to do
4. **AI learns** → From what I build and fix
5. **AI adapts** → To my style and needs over time
6. **AI automates** → Repetitive tasks and workflows
7. **AI suggests** → Improvements and optimizations
8. **AI integrates** → With my tools and services
9. **AI evolves** → As my project grows and changes
10. **AI supports** → Me in every step of my journey
11. **AI collaborates** → With me and my team
12. **AI simplifies** → Complex tasks and processes
13. **AI accelerates** → My productivity and creativity
14. **AI empowers** → Me to achieve more with less effort
15. **AI inspires** → New ideas and solutions
16. **AI enhances** → My skills and knowledge
17. **AI devlops** → New features and capabilities
18. **AI provides** → Feedback and insights
19. **AI connects** → Me with relevant resources and communities


## Simple Structure
- **Navigation** → Tell me where to go
- **Commands** → Show me what to run
- **Examples** → Give me working code
- **Fixes** → Help when stuff breaks
- **Building** → Guide me through new projects

## Phase 1: Foundation Knowledge (What Buddy Knows)

### Project Structure
- **content/** → Blog posts and guides organized by tech stack
  - blogs/azure/ → Azure security, emergency accounts, VM guides
  - blogs/n8n/ → Workflow automation content
  - blogs/migrations/ → GWS to M365, security migration guides
  - guides/ → Comprehensive reference materials

- **infrastructure/** → Docker stacks and service deployments
  - fabric-ai/ → Daniel Miessler's Fabric framework deployment
  - n8n_traefik_stack/ → Workflow automation with reverse proxy
  - firecrawl_docker/ → Web scraping service
  - searxng-docker/ → Privacy-focused search engine

- **projects/** → Active automation and integration projects
  - n8n-workflows/ai-blogger/ → Multi-agent content creation system
  - azure-logic-apps/ → Break glass automation, security alerts
  - sync-gal/ → GAL synchronization between systems

- **docs/** → Documentation hub and architectural decisions
  - fabric-ai/ai_agent_prompts.md → Production AI agent configurations
  - architecture/ → Repository structure and design docs
  - contributing/ → Guidelines and workflows

### Key Services & Endpoints
- **Fabric AI**: fabric-ai.rohi.life → Self-hosted AI framework API
- **n8n**: Workflow automation platform with Traefik routing
- **Firecrawl**: Web scraping and content extraction
- **SearxNG**: Privacy-focused search for research agents

### Multi-Agent Content System
- **Publisher Agent** → Content strategy and quality control
- **Researcher Agent** → Fact-checking with Firecrawl and SearxNG
- **Editor Agent** → Linguistic refinement and style consistency
- **SEO Optimizer** → Search engine optimization
- **Fact Checker** → Content verification and accuracy

### Docker Infrastructure Patterns
- All services use Docker Compose with Traefik labels
- Environment-specific configs in .env files
- SSL termination handled by Traefik automatically
- Standardized service structure across all stacks

## Phase 2: Continuous Growth & Evolution (How Buddy Adapts)

### Project Change Detection
- **File Changes** → Buddy notices when you add/modify/delete files
- **New Services** → Automatically learns about new Docker services or endpoints
- **Structure Updates** → Adapts when you reorganize directories or workflows
- **Configuration Changes** → Tracks updates to .env files, docker-compose.yml, and configs

### Learning from Your Work Style
- **Command Patterns** → Remembers the commands you use most often
- **File Locations** → Learns where you typically put new files
- **Workflow Preferences** → Adapts to how you like to work and build things
- **Problem Solutions** → Remembers how you fixed issues before

### Use Case Evolution
- **New Blog Topics** → Automatically categorizes and organizes new content areas
- **Service Additions** → Integrates new infrastructure services into knowledge base
- **Workflow Expansions** → Learns new automation patterns as you create them
- **Integration Points** → Discovers new connections between your services

### Knowledge Base Updates
- **Documentation Sync** → Stays current with your README files and docs
- **Code Pattern Recognition** → Learns your coding style and preferences
- **Troubleshooting History** → Builds database of fixes and solutions
- **Best Practices** → Evolves recommendations based on what works for you

### Feedback Loop System
- **Success Tracking** → Notes when suggestions work well
- **Failure Learning** → Remembers when approaches don't work
- **Context Awareness** → Understands different scenarios need different solutions
- **Preference Memory** → Recalls your choices and applies them to similar situations

### Future-Proofing
- **Scalability Planning** → Anticipates growth in your project complexity
- **Technology Updates** → Adapts to new versions of Docker, n8n, Fabric, etc.
- **Integration Opportunities** → Suggests new connections as your stack grows
- **Optimization Insights** → Recommends improvements based on usage patterns

That's how Buddy grows with you and your project - always learning, always adapting.