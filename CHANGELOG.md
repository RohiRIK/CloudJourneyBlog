# Changelog 📝

All notable changes to CloudJourneyBlog will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased] 🚧

### Added
- GitHub Action to prevent accidental commits of ignored files (`.gemini/`, `projects/TELOS/`).
- New action item: Automate Model Context Protocol (MCP) Server Deployment with n8n.
- New action item: Secure SSH Access and Workflow for Home Lab Server.
- New action item: GitHub Action for API Key Sanitization in uploaded files.

### Changed
- Renamed `projects/buddy-ai/tasks/` directory to `projects/buddy-ai/action_items/` for better clarity and purpose.
- Updated `README.md` to introduce Buddy AI, include its catchphrase, and reflect consolidated script directories.
- Added Buddy AI catchphrase to `.gemini/GEMINI.md`.
- Added consistency note to `buddy-instructions.md` and `.gemini/GEMINI.md` regarding updates.

### Fixed
- Untracked `projects/TELOS/` and `.gemini/` directories from Git to prevent accidental commits.
- Consolidated `scripts/` directory into `tools/scripts/` to remove redundancy and centralize utility scripts.

### Added
- Professional repository restructure
- GitHub workflows for content quality
- Issue and PR templates
- Contributing guidelines
- Code of conduct
- Security policy

## [1.0.0] - 2024-06-11 🎉

### Added
- Initial repository structure
- Blog posts on Azure and Microsoft 365
- Logic Apps automation project
- Infrastructure templates
- Basic documentation

### Content Highlights
- Google Workspace to Microsoft 365 migration guide
- Microsoft Defender migration guide
- Azure Logic Apps security monitoring
- Emergency access accounts guide
- End-of-day automation for macOS

### Infrastructure
- n8n workflow automation setup
- Docker Compose configurations
- Traefik reverse proxy setup

---

## Types of Changes 📋

- **Added** for new features
- **Changed** for changes in existing functionality
- **Deprecated** for soon-to-be removed features
- **Removed** for now removed features
- **Fixed** for any bug fixes
- **Security** for vulnerability fixes

## Release Notes Format 📖

### Version Number
We use [Semantic Versioning](https://semver.org/):
- **MAJOR**: Incompatible changes
- **MINOR**: New functionality (backwards compatible)
- **PATCH**: Bug fixes (backwards compatible)

### Date Format
Dates are in YYYY-MM-DD format.

### Categories
Changes are grouped by type and include:
- Brief description
- Impact on users
- Links to relevant issues/PRs where applicable

---

**Note**: This changelog started with the professional restructure. Historical changes prior to this version are summarized in the initial release.

