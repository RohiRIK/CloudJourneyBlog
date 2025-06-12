#!/bin/bash
# Generate repository statistics for README

echo "📊 Generating repository statistics..."

# Count content pieces
CONTENT_COUNT=$(find content/ -name "*.md" | wc -l)
echo "Content pieces: $CONTENT_COUNT"

# Count automation projects
PROJECT_COUNT=$(find projects/ -mindepth 1 -maxdepth 1 -type d | wc -l)
echo "Automation projects: $PROJECT_COUNT"

# Count infrastructure templates
INFRA_COUNT=$(find infrastructure/ -name "*.yml" -o -name "*.yaml" -o -name "*.tf" | wc -l)
echo "Infrastructure templates: $INFRA_COUNT"

echo "✅ Statistics generated"

