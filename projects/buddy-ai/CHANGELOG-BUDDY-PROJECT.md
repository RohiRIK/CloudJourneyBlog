## [0.1.5] - 2025-08-05

### Reorganized
- **Documentation Structure** - Created `/docs/` folder with domain-specific organization
- **File Organization** - Moved core documentation files into structured subdirectories:
  - `technical-architecture.md` → `docs/architecture/`
  - `api-integration-specifications.md` → `docs/specifications/`
  - `action-items-analysis.md` → `docs/analysis/`
  - `testing-framework.md` → `docs/testing/`
  - `validation-procedures.md` → `docs/validation/`
  - `success-metrics.md` → `docs/project-management/`

### Added
- **Documentation Hub** - Created `docs/README.md` with navigation and reading path
- **Documentation Subcategory** - Added new "Documentation" section to `navigation.json`
- **Domain-Based Structure** - Organized documentation by function rather than flat structure
- **Cross-Reference System** - Clear links between related documentation in different domains

### Improved
- **Navigation Clarity** - Reduced clutter in root buddy-ai navigation from 17 to 12 main items
- **Documentation Discoverability** - Clear paths for different types of documentation
- **Maintenance** - Easier to maintain documentation with domain-specific folders
- **Reading Path** - Structured learning path for new team members and contributors

### Technical Details
- **Folder Structure**: Created 6 domain-specific subdirectories under `/docs/`
- **Navigation Updates**: Updated `navigation.json` to reflect new structure
- **File Integrity**: All file moves completed successfully with no data loss

## [0.1.4] - 2025-08-05

### Added
- **n8n MCP Server Integration Research** - Deep dive into Model Context Protocol implementation with n8n
- **MCP Architecture Documentation** - Understanding of SSE streams, session management, and JSON-RPC 2.0 protocol
- **n8n MCP Tool Discovery** - Identified "Search_page_Notion" tool and parameter structure
- **Production vs Test Endpoint Analysis** - Documented differences between test and production MCP endpoints
- **CLI Tool Development** - Multiple iterations of n8n MCP CLI tools for testing and integration

### Discovered
- **Session Management Challenge** - n8n MCP server requires persistent sessions but HTTP is stateless
- **Tool Calling Protocol** - Found correct JSON-RPC format for calling n8n Notion tools
- **Endpoint Behavior** - Test endpoints require manual "Execute workflow" trigger, production endpoints are persistent
- **Server Response Patterns** - Successfully gets MCP server info but "Server not initialized" for subsequent calls

### Issues Identified
- **Stateless HTTP vs Session Requirement** - Core architecture mismatch preventing tool execution
- **File Organization** - Multiple CLI scripts created but need consolidation and cleanup
- **Session Persistence** - Each HTTP request is independent, breaking MCP session state

### Lessons Learned
- n8n MCP implementation follows standard JSON-RPC 2.0 protocol
- SSE (Server-Sent Events) streams are used for real-time communication
- Tool names in n8n MCP match the n8n node names (e.g., "Search_page_Notion")
- Production webhooks are more reliable than test webhooks for continuous integration

## [0.1.3] - 2025-08-03

### Changed
- Restructured Buddy AI workflow directory from `projects/buddy-ai/workflows/` to `projects/buddy-ai/buddy-workflows/`.
- Updated `projects/buddy-ai/navigation/navigation.json` to reflect the new workflow directory structure and include `validate-navigation-workflows.md`.

## [0.1.2] - 2025-08-03

### Added
- Documented GitHub Actions as Buddy AI workflows:
  - `api-key-sanitizer-workflow.md`
  - `check-ignored-files-workflow.md`
  - `sort-blog-workflow.md`
- Documented new Buddy AI workflow: `secure-commit-workflow.md`

## [0.1.1] - 2025-08-02

### Added
- Created `projects/buddy-ai/navigation/navigation.json` for machine-readable navigation data.
- Created `projects/buddy-ai/tasks/navigation-system-tests.md` to outline tasks for testing the navigation system.

### Changed
- Updated `projects/buddy-ai/buddy-instructions.md` to use `navigation.json` as the primary index for dynamic knowledge retrieval.
- Updated `projects/buddy-ai/navigation/README.md` to clarify its role as a human-readable overview and remove the detailed navigation map.
- Updated `projects/buddy-ai/navigation/navigation.json` to include a link to `tasks/navigation-system-tests.md`.