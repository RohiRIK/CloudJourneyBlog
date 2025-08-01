# Content Commands - Blog & Content Management

All commands for creating, editing, and managing your blog content.

## Blog Creation Commands

### Create New Azure Blog Post
```bash
# Navigate to Azure blogs directory
cd content/blogs/azure/

# Create new blog file
touch "new-azure-post-$(date +%Y-%m-%d).md"

# Open in VS Code
code "new-azure-post-$(date +%Y-%m-%d).md"
```

### Create New n8n Blog Post
```bash
# Navigate to n8n blogs directory
cd content/blogs/n8n/

# Create new blog file
touch "new-n8n-post-$(date +%Y-%m-%d).md"

# Open in VS Code
code "new-n8n-post-$(date +%Y-%m-%d).md"
```

### Create New Migration Guide
```bash
# Navigate to migrations directory
cd content/blogs/migrations/

# Create new migration guide
touch "new-migration-guide-$(date +%Y-%m-%d).md"

# Open in VS Code
code "new-migration-guide-$(date +%Y-%m-%d).md"
```

### Create New Security Post
```bash
# Navigate to security directory
cd content/blogs/security/

# Create new security post
touch "new-security-post-$(date +%Y-%m-%d).md"

# Open in VS Code
code "new-security-post-$(date +%Y-%m-%d).md"
```

## Content Management Commands

### List All Blog Posts
```bash
# List all blog posts by category
find content/blogs -name "*.md" -type f | sort
```

### Search for Specific Content
```bash
# Search for content containing specific term
grep -r "search-term" content/blogs/
```

### Count Blog Posts by Category
```bash
# Azure posts
find content/blogs/azure -name "*.md" | wc -l

# n8n posts
find content/blogs/n8n -name "*.md" | wc -l

# Migration posts
find content/blogs/migrations -name "*.md" | wc -l

# Security posts
find content/blogs/security -name "*.md" | wc -l
```

### Validate Blog Post Links
```bash
# Run link validation script
./tools/scripts/validate-links.sh
```

### Generate README Stats
```bash
# Generate content statistics
./tools/scripts/generate-readme-stats.sh
```

## Guide Creation Commands

### Create New Comprehensive Guide
```bash
# Navigate to guides directory
cd content/guides/

# Create new guide
touch "new-guide-$(date +%Y-%m-%d).md"

# Open in VS Code
code "new-guide-$(date +%Y-%m-%d).md"
```

### List All Guides
```bash
# List all guides
find content/guides -name "*.md" -type f | sort
```

## Blog Frontmatter Template Commands

### Add Azure Blog Frontmatter
```bash
cat << 'EOF' > temp_frontmatter.md
---
title: "Your Azure Blog Title"
date: $(date +%Y-%m-%d)
categories: ["Azure", "Security", "Cloud"]
tags: ["azure", "security", "cloud-security", "microsoft"]
description: "Brief description of your Azure blog post"
author: "Your Name"
---

# Your Azure Blog Title

Your content here...
EOF
```

### Add n8n Blog Frontmatter
```bash
cat << 'EOF' > temp_frontmatter.md
---
title: "Your n8n Automation Title"
date: $(date +%Y-%m-%d)
categories: ["n8n", "Automation", "Workflow"]
tags: ["n8n", "automation", "workflow", "integration"]
description: "Brief description of your n8n workflow"
author: "Your Name"
---

# Your n8n Automation Title

Your content here...
EOF
```

## Content Quality Commands

### Check for Duplicate Content
```bash
# Find potential duplicate files
fdupes -r content/blogs/
```

### Spell Check Blog Posts
```bash
# Run spell check on all markdown files
find content/blogs -name "*.md" -exec aspell check {} \;
```

### Format Markdown Files
```bash
# Format markdown with prettier (if installed)
npx prettier --write "content/**/*.md"
```

## Quick Blog Workflow

### Complete New Blog Creation
```bash
#!/bin/bash
# Complete blog creation workflow

echo "Which category? (azure/n8n/migrations/security)"
read category

echo "Enter blog title:"
read title

# Create filename
filename=$(echo "$title" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-\|-$//g')
filepath="content/blogs/$category/${filename}.md"

# Create blog file with frontmatter
cat << EOF > "$filepath"
---
title: "$title"
date: $(date +%Y-%m-%d)
categories: ["$(echo $category | tr '[:lower:]' '[:upper:]' | head -c 1)$(echo $category | tail -c +2)"]
tags: ["$category"]
description: "Brief description of $title"
author: "Your Name"
---

# $title

Your content here...
EOF

# Open in VS Code
code "$filepath"

echo "Blog created: $filepath"
```

All commands tested for macOS zsh terminal!
