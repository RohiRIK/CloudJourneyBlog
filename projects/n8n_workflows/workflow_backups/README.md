# N8N Workflow Backups

This directory contains backup files for N8N workflows used in the CloudJourneyBlog project.

## Purpose

This folder serves as a backup repository for:
- N8N workflow JSON files
- Workflow configurations
- Version snapshots of automation workflows
- Historical workflow states for rollback purposes

## Structure

Workflow backups are organized as follows:
```
workflow_backups/
├── workflow_name_YYYY-MM-DD.json
├── workflow_name_v1.0.json
└── archived/
    └── older_backups/
```

## Naming Convention

- **Date-based backups**: `workflow_name_YYYY-MM-DD.json`
- **Version-based backups**: `workflow_name_v1.0.json`
- **Feature-based backups**: `workflow_name_feature-description.json`

## Usage

1. **Creating Backups**: Export workflows from N8N interface as JSON files
2. **Restoring Workflows**: Import JSON files back into N8N
3. **Version Control**: Keep track of workflow evolution over time

## Best Practices

- Create backups before making significant changes
- Use descriptive filenames with dates or version numbers
- Archive old backups periodically to keep the directory clean
- Test restored workflows in a development environment first

## Related Directories

- `../AI_Blogger/`: Contains documentation and templates for AI Blogger workflows
- `../`: Parent directory with other N8N workflow projects

## Notes

- Always validate JSON files before importing
- Keep sensitive credentials separate from workflow backups
- Regular backups help ensure workflow continuity

