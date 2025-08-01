# Scaffolding Scripts

This file contains the logic for Buddy's automated project scaffolding capabilities.

## Create New Blog Post

This script automates the creation of a new blog post, including the file, frontmatter, and directory structure.

### Bash Script Logic

```bash
#!/bin/bash
# Complete blog creation workflow

# Parameters:
# $1: category (e.g., "azure", "n8n")
# $2: title (e.g., "My New Blog Post")

CATEGORY=$1
TITLE=$2

# Create filename
FILENAME=$(echo "$TITLE" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-\|-$//g')
FILEPATH="content/blogs/$CATEGORY/${FILENAME}.md"

# Create blog file with frontmatter
cat << EOF > "$FILEPATH"
---
title: "$TITLE"
date: $(date +%Y-%m-%d)
categories: ["$(echo $CATEGORY | tr '[:lower:]' '[:upper:]' | head -c 1)$(echo $CATEGORY | tail -c +2)"]
tags: ["$CATEGORY"]
description: "Brief description of $TITLE"
author: "Rohi"
---

# $TITLE

Your content here...
EOF

# Return the new file path
echo "$FILEPATH"
```

### Usage

When a user asks to create a new blog post, I will execute this script with the provided category and title, and then confirm the creation of the file at the returned path.
