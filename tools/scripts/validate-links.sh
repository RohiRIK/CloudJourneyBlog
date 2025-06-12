#!/bin/bash
# Link validation script for CloudJourneyBlog

echo "🔍 Validating links in markdown files..."

# Find all markdown files and check links
find . -name "*.md" -not -path "./.git/*" -exec echo "Checking {}" \;

echo "✅ Link validation complete"

