# Content Issues - Blog Creation & Management Problems

Solutions for content creation, editing, and publishing workflow issues.

## Blog Content Creation Issues

### Blog Template Not Working

**Problem**: Blog template generation fails or produces incorrect format.

**Diagnostic Commands**:
```bash
# Check template files exist
ls -la docs/Copilot_Instructions/buddy/examples/blog-templates.md

# Verify template structure
head -20 docs/Copilot_Instructions/buddy/examples/blog-templates.md

# Check content directory structure
find content/blogs -name "*.md" | head -10

# Validate frontmatter format
grep -A 10 "^---$" content/blogs/sample-post.md
```

**Common Solutions**:

#### 1. Fix Frontmatter Format
```yaml
# Correct frontmatter structure
---
title: "Your Blog Post Title"
date: 2024-01-15
author: "Your Name"
categories: ["Technology", "Cloud"]
tags: ["Azure", "Docker", "Automation"]
draft: false
description: "Brief description for SEO"
---
```

#### 2. Template Variables Not Replacing
```bash
# Check if variables are properly set
echo "AUTHOR_NAME: $AUTHOR_NAME"
echo "BLOG_CATEGORY: $BLOG_CATEGORY"

# Fix template replacement
sed "s/{{TITLE}}/Your Actual Title/g" template.md > new-post.md
sed -i "s/{{DATE}}/$(date +%Y-%m-%d)/g" new-post.md
sed -i "s/{{AUTHOR}}/$AUTHOR_NAME/g" new-post.md
```

#### 3. File Naming Convention Issues
```bash
# Correct naming pattern: category/descriptive-title.md
# Wrong
content/blogs/post1.md
content/blogs/MyBlogPost.md

# Correct  
content/blogs/azure/guide-to-azure-vm-security.md
content/blogs/n8n/automated-content-workflow.md
```

#### 4. Category Directory Structure
```bash
# Create missing category directories
mkdir -p content/blogs/{azure,n8n,security,migrations,github_action,mac-os}

# Move misplaced files to correct categories
mv content/blogs/docker-post.md content/blogs/infrastructure/
mv content/blogs/security-guide.md content/blogs/security/
```

### Content Formatting Issues

**Problem**: Markdown formatting not rendering correctly.

**Diagnostic Commands**:
```bash
# Check for common markdown issues
grep -n "```" content/blogs/your-post.md  # Unclosed code blocks
grep -n "!\[.*\]" content/blogs/your-post.md  # Image syntax
grep -n "\[.*\](" content/blogs/your-post.md  # Link syntax

# Validate markdown structure
markdownlint content/blogs/your-post.md

# Check for special characters
grep -P '[^\x00-\x7F]' content/blogs/your-post.md
```

**Solutions**:

#### 1. Fix Code Block Issues
```markdown
# Wrong - missing language specification
```
your code here
```

# Correct - with language
```bash
your code here
```

# Wrong - inconsistent indentation
    ```bash
  command here
    ```

# Correct - consistent indentation  
```bash
command here
```
```

#### 2. Image Path Corrections
```markdown
# Wrong - absolute path
![Image](C:/Users/user/image.png)

# Wrong - incorrect relative path
![Image](../../../images/image.png)

# Correct - relative to content root
![Image](./images/image.png)
![Image](/content/images/image.png)
```

#### 3. Link Format Fixes
```markdown
# Wrong - spaces in URL
[Link Text](https://example.com/page with spaces)

# Correct - encoded URL
[Link Text](https://example.com/page%20with%20spaces)

# Wrong - missing protocol
[Link Text](example.com)

# Correct - with protocol
[Link Text](https://example.com)
```

#### 4. Special Character Encoding
```bash
# Fix encoding issues
iconv -f utf-8 -t utf-8//IGNORE content/blogs/your-post.md > temp.md
mv temp.md content/blogs/your-post.md

# Remove non-printable characters
tr -cd '\11\12\15\40-\176' < content/blogs/your-post.md > clean.md
```

### SEO and Metadata Problems

**Problem**: Blog posts missing or have incorrect SEO metadata.

**Diagnostic Commands**:
```bash
# Check for missing metadata
grep -L "description:" content/blogs/**/*.md

# Verify all required frontmatter fields
for file in content/blogs/**/*.md; do
  echo "Checking $file:"
  grep -E "^(title|date|author|description|tags|categories):" "$file" || echo "Missing fields"
  echo "---"
done

# Check description length (should be 120-160 characters)
grep "description:" content/blogs/**/*.md | while read line; do
  desc=$(echo "$line" | cut -d'"' -f2)
  echo "${#desc} chars: $desc"
done
```

**Solutions**:

#### 1. Complete Frontmatter Template
```yaml
---
title: "Specific, Descriptive Title (50-60 chars)"
date: 2024-01-15
author: "Your Name"
categories: ["Primary Category", "Secondary Category"]
tags: ["specific", "keywords", "for", "searchability"]
draft: false
description: "Compelling description that summarizes the post value in 120-160 characters for search engines"
featured_image: "/images/posts/your-post-featured.jpg"
seo_title: "SEO Optimized Title | Your Site Name"
canonical_url: "https://yourdomain.com/blog/post-slug"
---
```

#### 2. SEO Optimization Script
```bash
#!/bin/bash
# seo-check.sh - Validate SEO elements in blog posts

for file in content/blogs/**/*.md; do
    echo "=== Checking $file ==="
    
    # Check title length
    title=$(grep "^title:" "$file" | cut -d'"' -f2)
    title_len=${#title}
    if [ $title_len -lt 30 ] || [ $title_len -gt 60 ]; then
        echo "⚠️  Title length: $title_len chars (should be 30-60)"
    else
        echo "✓ Title length: $title_len chars"
    fi
    
    # Check description length
    desc=$(grep "^description:" "$file" | cut -d'"' -f2)
    desc_len=${#desc}
    if [ $desc_len -lt 120 ] || [ $desc_len -gt 160 ]; then
        echo "⚠️  Description length: $desc_len chars (should be 120-160)"
    else
        echo "✓ Description length: $desc_len chars"
    fi
    
    # Check for required fields
    required_fields=("title" "date" "author" "description" "tags" "categories")
    for field in "${required_fields[@]}"; do
        if grep -q "^$field:" "$file"; then
            echo "✓ Has $field"
        else
            echo "✗ Missing $field"
        fi
    done
    
    echo ""
done
```

#### 3. Bulk Metadata Update
```bash
#!/bin/bash
# bulk-metadata-update.sh

for file in content/blogs/**/*.md; do
    # Add missing author if not present
    if ! grep -q "^author:" "$file"; then
        sed -i '/^title:/a author: "Your Name"' "$file"
    fi
    
    # Add missing categories based on directory
    if ! grep -q "^categories:" "$file"; then
        dir=$(dirname "$file" | xargs basename)
        category=$(echo "$dir" | sed 's/-/ /g' | sed 's/\b\w/\u&/g')
        sed -i "/^author:/a categories: [\"$category\"]" "$file"
    fi
    
    # Add missing tags array if not present
    if ! grep -q "^tags:" "$file"; then
        sed -i '/^categories:/a tags: ["keyword1", "keyword2", "keyword3"]' "$file"
    fi
done
```

## Content Workflow Issues

### Notion Integration Problems

**Problem**: Content not syncing properly with Notion database.

**Diagnostic Commands**:
```bash
# Test Notion API connectivity
curl -X GET "https://api.notion.com/v1/users/me" \
  -H "Authorization: Bearer $NOTION_TOKEN" \
  -H "Notion-Version: 2022-06-28"

# Test database access
curl -X POST "https://api.notion.com/v1/databases/$NOTION_DATABASE_ID/query" \
  -H "Authorization: Bearer $NOTION_TOKEN" \
  -H "Notion-Version: 2022-06-28" \
  -H "Content-Type: application/json" \
  -d '{
    "page_size": 10
  }'

# Check n8n workflow for Notion nodes
docker logs n8n | grep -i "notion"
```

**Solutions**:

#### 1. Correct Notion Configuration
```bash
# .env file
NOTION_TOKEN=secret_your_integration_token_here
NOTION_DATABASE_ID=your_database_id_32_chars_no_dashes
NOTION_VERSION=2022-06-28
```

#### 2. Database Schema Setup
```json
{
  "Title": {
    "type": "title"
  },
  "Status": {
    "type": "select",
    "options": [
      {"name": "Not Started", "color": "red"},
      {"name": "In Progress", "color": "yellow"},
      {"name": "Need More Data", "color": "orange"},
      {"name": "Ready to Upload", "color": "blue"},
      {"name": "Done", "color": "green"}
    ]
  },
  "Category": {
    "type": "select",
    "options": [
      {"name": "Azure", "color": "blue"},
      {"name": "n8n", "color": "purple"},
      {"name": "Security", "color": "red"},
      {"name": "Migration", "color": "green"}
    ]
  },
  "Published Date": {
    "type": "date"
  },
  "Content": {
    "type": "rich_text"
  }
}
```

#### 3. n8n Workflow Debugging
```bash
# Check workflow execution logs
docker exec n8n n8n executions:list

# Get specific execution details
docker exec n8n n8n executions:show <execution-id>

# Test Notion node configuration
docker exec n8n curl -X POST http://localhost:5678/webhook-test/notion \
  -H "Content-Type: application/json" \
  -d '{"test": "data"}'
```

### AI Content Generation Issues

**Problem**: AI agents not generating content properly.

**Diagnostic Commands**:
```bash
# Test Fabric AI connection
curl -X POST https://fabric-ai.rohi.life/chat \
  -H "Content-Type: application/json" \
  -H "X-API-Key: $FABRIC_API_KEY" \
  -d '{
    "prompts": [{
      "userInput": "Write a test blog post about Docker",
      "model": "gemini-2.0-flash-exp"
    }]
  }'

# Check available AI patterns
curl -X GET https://fabric-ai.rohi.life/patterns \
  -H "X-API-Key: $FABRIC_API_KEY"

# Test specific agent prompt
curl -X POST https://fabric-ai.rohi.life/chat \
  -H "Content-Type: application/json" \
  -H "X-API-Key: $FABRIC_API_KEY" \
  -d '{
    "prompts": [{
      "systemPrompt": "'"$(cat docs/fabric-ai/ai_agent_prompts.md | grep -A 50 "## Publisher Agent")"'",
      "userInput": "Evaluate this blog post draft",
      "model": "gemini-2.0-flash-exp"
    }]
  }'
```

**Solutions**:

#### 1. Agent Prompt Optimization
```bash
# Verify agent prompts are correctly formatted
cat docs/fabric-ai/ai_agent_prompts.md | grep -E "^## [A-Z].*Agent$"

# Test individual agent prompts
PUBLISHER_PROMPT=$(sed -n '/^## Publisher Agent$/,/^## /p' docs/fabric-ai/ai_agent_prompts.md | head -n -1)
echo "$PUBLISHER_PROMPT"
```

#### 2. Model Configuration Issues
```json
{
  "prompts": [{
    "systemPrompt": "Your agent prompt here",
    "userInput": "Content to process",
    "model": "gemini-2.0-flash-exp",
    "temperature": 0.7,
    "max_tokens": 4000
  }]
}
```

#### 3. Content Quality Validation
```bash
#!/bin/bash
# content-quality-check.sh

content_file="$1"

echo "=== Content Quality Check for $content_file ==="

# Check word count
word_count=$(wc -w < "$content_file")
echo "Word count: $word_count"

if [ $word_count -lt 800 ]; then
    echo "⚠️  Content might be too short (under 800 words)"
elif [ $word_count -gt 3000 ]; then
    echo "⚠️  Content might be too long (over 3000 words)"
else
    echo "✓ Word count is good"
fi

# Check for headings structure
heading_count=$(grep -c "^#" "$content_file")
echo "Heading count: $heading_count"

if [ $heading_count -lt 3 ]; then
    echo "⚠️  Consider adding more headings for better structure"
else
    echo "✓ Good heading structure"
fi

# Check for code examples
code_blocks=$(grep -c "^```" "$content_file")
echo "Code blocks: $code_blocks"

# Check for images
images=$(grep -c "!\[.*\]" "$content_file")
echo "Images: $images"

# Readability check (approximate)
sentences=$(grep -o '\.' "$content_file" | wc -l)
avg_words_per_sentence=$((word_count / sentences))
echo "Average words per sentence: $avg_words_per_sentence"

if [ $avg_words_per_sentence -gt 25 ]; then
    echo "⚠️  Sentences might be too long - consider breaking them up"
else
    echo "✓ Good sentence length"
fi
```

## Publishing Workflow Issues

### GitHub Actions Deployment Problems

**Problem**: Blog posts not deploying automatically.

**Diagnostic Commands**:
```bash
# Check GitHub Actions status
gh run list --limit 10

# View specific workflow run
gh run view <run-id>

# Check workflow file syntax
yamllint .github/workflows/deploy-blog.yml

# Test workflow triggers
git log --oneline -10 content/blogs/
```

**Solutions**:

#### 1. Workflow Trigger Configuration
```yaml
# .github/workflows/deploy-blog.yml
name: Deploy Blog
on:
  push:
    branches: [main]
    paths: 
      - 'content/blogs/**'
      - 'content/guides/**'
  pull_request:
    branches: [main]
    paths:
      - 'content/blogs/**'
      - 'content/guides/**'
```

#### 2. Build Process Debugging
```yaml
steps:
  - name: Checkout
    uses: actions/checkout@v4
    
  - name: Debug file structure
    run: |
      echo "Content structure:"
      find content -name "*.md" | head -20
      
  - name: Validate markdown files
    run: |
      for file in content/blogs/**/*.md; do
        echo "Validating $file"
        head -10 "$file"
        echo "---"
      done
```

#### 3. Deployment Status Check Script
```bash
#!/bin/bash
# deployment-status.sh

echo "=== GitHub Actions Status ==="
gh run list --limit 5 --json status,conclusion,url

echo -e "\n=== Recent Blog Changes ==="
git log --oneline -10 --grep="blog\|content" content/

echo -e "\n=== Deployment Health ==="
curl -s -o /dev/null -w "Blog site: %{http_code}\n" https://yourdomain.com/blog/

echo -e "\n=== Recent Blog Posts ==="
find content/blogs -name "*.md" -newer $(date -d '7 days ago' +'%Y-%m-%d') | head -10
```

## Content Quality Assurance

### Automated Content Validation Script

```bash
#!/bin/bash
# content-validator.sh - Comprehensive content quality check

CONTENT_DIR="content/blogs"
ERRORS=0

echo "=== CloudJourneyBlog Content Validation ==="
echo "Checking content in: $CONTENT_DIR"
echo ""

# Function to check individual file
check_file() {
    local file="$1"
    local basename=$(basename "$file")
    echo "Checking: $basename"
    
    # Check frontmatter exists
    if ! grep -q "^---$" "$file"; then
        echo "  ✗ Missing frontmatter"
        ((ERRORS++))
    else
        echo "  ✓ Has frontmatter"
    fi
    
    # Check required fields
    required=("title" "date" "author" "description")
    for field in "${required[@]}"; do
        if grep -q "^$field:" "$file"; then
            echo "  ✓ Has $field"
        else
            echo "  ✗ Missing $field"
            ((ERRORS++))
        fi
    done
    
    # Check file naming convention
    if [[ "$basename" =~ ^[a-z0-9-]+\.md$ ]]; then
        echo "  ✓ Good filename format"
    else
        echo "  ✗ Filename should be lowercase with hyphens: $basename"
        ((ERRORS++))
    fi
    
    # Check content length
    word_count=$(wc -w < "$file")
    if [ $word_count -ge 800 ]; then
        echo "  ✓ Good length ($word_count words)"
    else
        echo "  ⚠ Short content ($word_count words)"
    fi
    
    echo ""
}

# Check all markdown files
find "$CONTENT_DIR" -name "*.md" | while read file; do
    check_file "$file"
done

echo "=== Validation Complete ==="
if [ $ERRORS -eq 0 ]; then
    echo "✓ All content passes validation!"
    exit 0
else
    echo "✗ Found $ERRORS errors"
    exit 1
fi
```

Save these scripts in `tools/scripts/` and run them to maintain content quality!
