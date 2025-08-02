# Changelog - Buddy AI Project

All notable changes to the Buddy AI project will be documented in this file.

## [0.1.0] - 2025-08-02

### Added
- Initial setup of Infisical (secret management) with Docker Compose.
- Created `projects/buddy-ai/tools/fabric-ai.rohi.life/fabric-ai-workflows.md` to document Fabric AI usage workflows.
- Added a new section `Buddy's Self-Correction and Evolution` to `buddy-instructions.md` to formalize user acceptance for internal documentation changes.

### Changed
- Refactored Infisical Docker Compose (`infrastructure/secrets-management/infisical/docker-compose.yml`) to adhere to project conventions (Watchtower, logging, security) and integrated with Traefik for external access.
- Updated `projects/buddy-ai/README.md` to clarify `buddy-instructions.md` as the core operating system.
- Updated both `.gemini/GEMINI.md` files (`.gemini/GEMINI.md` and `projects/buddy-ai/.gemini/GEMINI.md`) to reflect Buddy's persona and primary instruction source (`projects/buddy-ai/`).
- Refactored `projects/buddy-ai/buddy-instructions.md` to be more concise, directing to `examples/` for detailed patterns, and emphasizing `navigation/README.md`'s critical role.
- Updated `projects/buddy-ai/examples/docker-compose-templates.md` with comprehensive standard labels for Traefik and Watchtower (including `cleanup=true`).
- Updated `projects/buddy-ai/buddy-instructions.md` to explicitly refer to `docker-compose-templates.md` for standard patterns.
- Updated `projects/buddy-ai/buddy-instructions.md` to include Fabric AI usage in the `Analyze the Request` step for enhanced understanding.
- Moved `fabric-ai-workflows.md` to `projects/buddy-ai/tools/fabric-ai.rohi.life/` for better organization.
- Updated `projects/buddy-ai/navigation/README.md` to link to the new `fabric-ai-workflows.md` location.
- Updated `projects/buddy-ai/tools/README.md` to reflect the new organization and link to `fabric-ai-workflows.md`.
- Updated `projects/buddy-ai/tools/fabric-ai.rohi.life/README.md` with a troubleshooting note for unexpected pattern outputs from Fabric AI.
