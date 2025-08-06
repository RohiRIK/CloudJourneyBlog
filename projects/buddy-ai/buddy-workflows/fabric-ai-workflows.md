# Fabric AI Workflows - Complete Integration Guide

**Purpose**: Comprehensive guide for leveraging Fabric AI's full capabilities within CloudJourneyBlog project  
**Scope**: 209 patterns, 9 strategies, 59 models, advanced features  
**Integration Level**: Deep integration with Buddy AI workflows  

## Overview

Fabric AI provides sophisticated AI-powered content analysis, generation, and processing through:
- **209 Specialized Patterns** - Expert-level prompts for specific tasks
- **9 Advanced Strategies** - Different reasoning approaches (CoT, ToT, Self-Refine, etc.)
- **59 AI Models** - Gemini, Ollama, and specialized models
- **Multi-Modal Capabilities** - Text, images, YouTube, web scraping, voice
- **Advanced Features** - Context management, sessions, extensions, web search

---

## Core Discovery Commands

### Quick Reference
```bash
# Essential discovery commands
fabric-ai --listpatterns         # List all 209 available patterns
fabric-ai --liststrategies       # List all 9 reasoning strategies  
fabric-ai --listmodels           # List all 59 available models
fabric-ai --listcontexts         # List saved contexts
fabric-ai --listsessions         # List active sessions
fabric-ai --listextensions       # List registered extensions
fabric-ai --listvendors          # List AI vendor integrations

# Quick search and filtering
fabric-ai --listpatterns | grep analyze    # Find analysis patterns
fabric-ai --listpatterns | grep create     # Find creation patterns
fabric-ai --listpatterns | grep extract    # Find extraction patterns
```

## Advanced Reasoning Strategies

Fabric AI supports 9 different reasoning strategies for enhanced output quality:

### Strategy Reference Guide
```bash
# Chain-of-Thought (default for complex reasoning)
fabric-ai --strategy cot --pattern "analyze_paper" "research-paper.pdf"

# Tree-of-Thought (for multi-path exploration)
fabric-ai --strategy tot --pattern "analyze_proposition" "business-proposal.md"

# Self-Consistency (multiple reasoning paths)
fabric-ai --strategy self-consistent --pattern "analyze_claims" "fact-check.txt"

# Self-Refinement (iterative improvement)
fabric-ai --strategy self-refine --pattern "create_summary" "long-document.md"

# Reflexion (self-reflection and correction)
fabric-ai --strategy reflexion --pattern "analyze_mistakes" "failure-report.md"

# Least-to-Most (problem decomposition)
fabric-ai --strategy ltm --pattern "coding_master" "complex-algorithm.py"

# Chain-of-Draft (iterative drafting)
fabric-ai --strategy cod --pattern "create_academic_paper" "research-notes.md"

# Atom-of-Thought (granular reasoning)
fabric-ai --strategy aot --pattern "analyze_debate" "discussion-transcript.txt"

# Standard (direct prompting)
fabric-ai --strategy standard --pattern "clean_text" "messy-document.txt"
```

## Model Selection Guide

### Recommended Models by Use Case

**Primary Recommendations:**
```bash
# Best overall performance (default choice)
--model "gemini-2.0-flash-exp"

# Complex reasoning and analysis
--model "gemini-2.5-pro"

# Fast processing for simple tasks  
--model "gemini-1.5-flash-8b"

# Thinking and planning tasks
--model "gemini-2.0-flash-thinking-exp"

# Image generation
--model "imagen-3.0-generate-002"

# Code analysis and generation
--model "deepseek-coder:6.7b"

# Embeddings and similarity
--model "text-embedding-004"
```

## Content Analysis Workflows

## Content Analysis Workflows

### Document Analysis & Intelligence

**Critical Analysis Patterns:**

```bash
# Deep document analysis
fabric-ai --strategy cot --pattern "analyze_paper" --model "gemini-2.5-pro" "research-document.pdf"

# Extract actionable insights
fabric-ai --strategy self-consistent --pattern "extract_insights" --model "gemini-2.0-flash-exp" "meeting-notes.md"

# Analyze log files and diagnostics
fabric-ai --strategy ltm --pattern "analyze_logs" --model "gemini-2.0-flash-thinking-exp" "system-logs.txt"

# Security threat analysis
fabric-ai --strategy reflexion --pattern "analyze_threat_report" --model "gemini-2.5-pro" "security-report.md"

# Code analysis and explanation
fabric-ai --strategy cot --pattern "coding_master" --model "deepseek-coder:6.7b" "complex-algorithm.py"

# Risk assessment
fabric-ai --strategy tot --pattern "analyze_risk" --model "gemini-2.5-pro" "project-proposal.md"
```

### Content Processing & Extraction

**Information Extraction Patterns:**

```bash
# Extract key claims and facts
fabric-ai --pattern "analyze_claims" --model "gemini-2.0-flash-exp" "article.md"

# Extract structured data
fabric-ai --pattern "analyze_prose_json" --model "gemini-2.0-flash-exp" "unstructured-text.txt"

# Extract wisdom and quotes
fabric-ai --pattern "capture_thinkers_work" --model "gemini-2.5-pro" "philosophy-book.pdf"

# Clean and format text
fabric-ai --pattern "clean_text" --model "gemini-1.5-flash-8b" "messy-document.txt"

# Convert to markdown
fabric-ai --pattern "convert_to_markdown" --model "gemini-1.5-flash" "html-content.html"

# Extract meeting action items
fabric-ai --pattern "get_actionables" --model "gemini-2.0-flash-exp" "meeting-transcript.txt"
```

## Content Creation Workflows

### Writing & Documentation

**Creation Patterns:**

```bash
# Create comprehensive summaries
fabric-ai --strategy self-refine --pattern "create_summary" --model "gemini-2.5-pro" "long-report.pdf"

# Generate academic papers
fabric-ai --strategy cod --pattern "create_academic_paper" --model "gemini-2.5-pro" "research-notes.md"

# Create technical documentation
fabric-ai --strategy cot --pattern "create_command" --model "gemini-2.0-flash-exp" "api-specifications.yml"

# Generate blog content
fabric-ai --strategy self-refine --pattern "create_blog_post" --model "gemini-2.0-flash-exp" "topic-outline.md"

# Create executive summaries
fabric-ai --pattern "create_executive_summary" --model "gemini-2.5-pro" "quarterly-report.pdf"

# Generate coding projects
fabric-ai --strategy ltm --pattern "create_coding_project" --model "deepseek-coder:6.7b" "project-requirements.md"
```

### Content Enhancement & Optimization

**Enhancement Patterns:**

```bash
# Improve writing quality
fabric-ai --strategy self-refine --pattern "improve_writing" --model "gemini-2.5-pro" "draft-article.md"

# Optimize for SEO
fabric-ai --pattern "write_seo_optimized_content" --model "gemini-2.0-flash-exp" "blog-draft.md"

# Create compelling headlines
fabric-ai --pattern "create_better_frame" --model "gemini-2.0-flash-exp" "article-content.md"

# Generate social media content
fabric-ai --pattern "create_social_media_post" --model "gemini-2.0-flash-exp" "blog-post.md"

# Create presentation content
fabric-ai --pattern "create_presentation" --model "gemini-2.5-pro" "meeting-agenda.md"
```

## Multi-Modal & Advanced Features

### YouTube Integration

```bash
# Extract and analyze YouTube content
fabric-ai --youtube "https://youtube.com/watch?v=VIDEO_ID" --transcript --pattern "create_summary" --model "gemini-2.5-pro"

# Get transcript with timestamps
fabric-ai --youtube "https://youtube.com/watch?v=VIDEO_ID" --transcript-with-timestamps --pattern "get_actionables"

# Analyze comments sentiment
fabric-ai --youtube "https://youtube.com/watch?v=VIDEO_ID" --comments --pattern "analyze_comments" --model "gemini-2.0-flash-exp"

# Extract video metadata
fabric-ai --youtube "https://youtube.com/watch?v=VIDEO_ID" --metadata --pattern "analyze_content"
```

### Web Scraping & Research

```bash
# Scrape and analyze websites
fabric-ai --scrape_url "https://example.com/article" --pattern "analyze_claims" --model "gemini-2.5-pro"

# Research specific questions
fabric-ai --scrape_question "best practices for kubernetes security" --pattern "create_summary" --model "gemini-2.0-flash-exp"

# Enable web search for real-time info
fabric-ai --search --search-location "America/Los_Angeles" --pattern "analyze_tech_impact" --model "gemini-2.5-pro" "AI trends 2025"
```

### Image Generation & Processing

```bash
# Generate images from text
fabric-ai --pattern "create_art_prompt" --model "imagen-3.0-generate-002" --image-file "output.png" --image-size "1024x1024" "detailed description"

# High quality image generation
fabric-ai --model "imagen-4.0-generate-preview-06-06" --image-quality "high" --image-file "hq-image.png" "photorealistic landscape"

# Generate presentation images
fabric-ai --pattern "create_presentation_visual" --model "imagen-3.0-generate-002" --image-background "transparent" "diagram concept"
```

## Advanced Configuration & Optimization

### Session & Context Management

```bash
# Work with persistent contexts
fabric-ai --context "project-research" --pattern "analyze_paper" --model "gemini-2.5-pro" "new-document.pdf"

# Create and manage sessions
fabric-ai --session "analysis-session" --pattern "extract_insights" --model "gemini-2.0-flash-exp" "data.txt"

# Print current context/session
fabric-ai --printcontext
fabric-ai --printsession

# Wipe contexts/sessions when needed
fabric-ai --wipecontext
fabric-ai --wipesession
```

### Performance Optimization

```bash
# Temperature control for creativity vs consistency
fabric-ai --temperature 0.1 --pattern "analyze_logs" --model "gemini-2.0-flash-exp" "error-logs.txt"  # Conservative
fabric-ai --temperature 0.9 --pattern "create_art_prompt" --model "gemini-2.0-flash-exp" "creative-brief.md"  # Creative

# Top-P sampling control
fabric-ai --topp 0.5 --pattern "coding_master" --model "deepseek-coder:6.7b" "algorithm.py"  # Focused
fabric-ai --topp 0.95 --pattern "create_blog_post" --model "gemini-2.0-flash-exp" "topic.md"  # Diverse

# Streaming for real-time output
fabric-ai --stream --pattern "create_summary" --model "gemini-2.5-pro" "long-document.pdf"

# Raw model mode (no system modifications)
fabric-ai --raw --pattern "analyze_claims" --model "gemini-2.0-flash-exp" "article.md"
```

### Variable & Template Usage

```bash
# Use pattern variables for customization
fabric-ai --pattern "create_presentation" --variable "#audience:developers" --variable "#duration:30min" --model "gemini-2.5-pro" "technical-topic.md"

# Apply variables to user input
fabric-ai --input-has-vars --pattern "create_summary" --variable "#length:5sentences" --model "gemini-2.0-flash-exp" "document.md"

# Dry run to preview what will be sent
fabric-ai --dry-run --pattern "analyze_paper" --model "gemini-2.5-pro" "research.pdf"
```

## Buddy AI Integration Patterns

### Automated Workflows for Buddy AI

**Pattern Selection Logic:**

```bash
# For diagnostic analysis (Buddy AI workflow)
fabric-ai --strategy reflexion --pattern "analyze_logs" --model "gemini-2.0-flash-thinking-exp" --output "analysis-results.md"

# For content research (Buddy AI workflow)  
fabric-ai --strategy cot --pattern "extract_insights" --model "gemini-2.5-pro" --scrape_question "topic research" --output "research-summary.md"

# For code review (Buddy AI workflow)
fabric-ai --strategy self-consistent --pattern "coding_master" --model "deepseek-coder:6.7b" --output "code-review.md"

# For documentation generation (Buddy AI workflow)
fabric-ai --strategy self-refine --pattern "create_summary" --model "gemini-2.5-pro" --output-session --output "documentation.md"
```

### Integration with Other Tools

**Fabric AI + VS Code Tools:**

```bash
# Combine with file operations
find . -name "*.log" | head -5 | xargs -I {} fabric-ai --pattern "analyze_logs" --model "gemini-2.0-flash-exp" "{}"

# Process multiple files
for file in $(find content/blogs -name "*.md"); do
    fabric-ai --pattern "analyze_prose" --model "gemini-2.0-flash-exp" "$file" --output "${file%.md}-analysis.md"
done

# Pipe content analysis
cat project-report.md | fabric-ai --pattern "extract_insights" --model "gemini-2.5-pro" --copy
```

## Troubleshooting & Optimization

### Common Issues & Solutions

**Connection & Service Issues:**

```bash
# Test service connectivity
fabric-ai --listmodels | head -5  # Quick connection test

# Check service health  
curl -s https://fabric-ai.rohi.life/health || echo "Service unavailable"

# Validate configuration
fabric-ai --dry-run --pattern "create_summary" --model "gemini-2.0-flash-exp" "test content"
```

**Pattern & Output Issues:**

- **Pattern Specificity**: Use `--listpatterns | grep keyword` to find exact patterns for your use case
- **Model Selection**: Use thinking models (`gemini-2.0-flash-thinking-exp`) for complex analysis
- **Strategy Selection**: Use `--strategy cot` for reasoning, `--strategy self-refine` for quality
- **Output Control**: Use `--temperature 0.1` for consistent results, `0.7-0.9` for creative tasks

**Performance Optimization:**

```bash
# For speed: Use faster models
fabric-ai --model "gemini-1.5-flash-8b" --pattern "clean_text" "document.txt"

# For quality: Use premium models + strategies
fabric-ai --strategy self-consistent --model "gemini-2.5-pro" --pattern "analyze_paper" "research.pdf"

# For consistency: Lower temperature
fabric-ai --temperature 0.1 --pattern "analyze_logs" --model "gemini-2.0-flash-exp" "logs.txt"

# For creativity: Higher temperature + top-p
fabric-ai --temperature 0.8 --topp 0.9 --pattern "create_art_prompt" --model "gemini-2.0-flash-exp" "concept.md"
```

## Buddy AI Output Management & Integration

### Structured Output for Buddy AI Interaction

**Output to buddy-output directory for analysis and processing:**

#### Confirmation Before Saving
Before any Fabric AI generated content is saved to a file, Buddy AI will present the content to the user and ask for explicit confirmation. This ensures the user has full control and can review the output before it is written to disk.

**Procedure:**
1.  **Present Content**: Buddy AI will display the generated content to the user.
2.  **Request Confirmation**: Buddy AI will ask the user, "Do you want to save this content to [proposed file path]?"
3.  **Save or Discard**: If the user confirms, the content will be saved. Otherwise, it will be discarded.

**Tools to Use:** User Input, `echo`, `write_file`



```bash
# Create organized output structure
mkdir -p projects/buddy-ai/buddy-output/{analysis,summaries,insights,code-review,research}

# Analysis outputs with timestamps
fabric-ai --strategy cot --pattern "analyze_paper" --model "gemini-2.5-pro" \
  --output "projects/buddy-ai/buddy-output/analysis/$(date +%Y%m%d_%H%M)_analysis.md" "target-document.pdf"

# Summary outputs for quick review
fabric-ai --strategy self-refine --pattern "create_5_sentence_summary" --model "gemini-2.0-flash-exp" \
  --output "projects/buddy-ai/buddy-output/summaries/$(basename $1 .md)_summary.md" "source-file.md"

# Insight extraction for decision making
fabric-ai --pattern "extract_insights" --model "gemini-2.5-pro" \
  --output "projects/buddy-ai/buddy-output/insights/$(date +%Y%m%d)_insights.md" "meeting-notes.md"

# Code analysis for development workflow
fabric-ai --strategy ltm --pattern "coding_master" --model "deepseek-coder:6.7b" \
  --output "projects/buddy-ai/buddy-output/code-review/$(basename $1)_review.md" "source-code.py"
```

### Buddy AI Automated Analysis Functions

**Functions for Buddy AI to automatically analyze Fabric AI outputs:**

```bash
# Buddy AI function to process and analyze Fabric AI results
analyze_fabric_output() {
    local output_file="$1"
    local analysis_type="$2"
    
    echo "🤖 Buddy AI analyzing Fabric AI output: $(basename $output_file)"
    
    # Use semantic search to understand the content
    # Use grep_search to find key patterns
    # Use read_file to examine specific sections
    
    # Generate follow-up analysis based on results
    fabric-ai --strategy reflexion --pattern "analyze_claims" --model "gemini-2.0-flash-exp" \
      --output "${output_file%.md}_buddy_analysis.md" "$output_file"
}

# Buddy AI function to create actionable items from insights
create_actionables_from_insights() {
    local insights_file="$1"
    
    fabric-ai --pattern "get_actionables" --model "gemini-2.0-flash-exp" \
      --output "projects/buddy-ai/buddy-output/actionables/$(date +%Y%m%d)_actions.md" "$insights_file"
}

# Buddy AI function to chain multiple analyses
chain_fabric_analysis() {
    local source_file="$1"
    local timestamp=$(date +%Y%m%d_%H%M)
    
    # Step 1: Extract insights
    fabric-ai --pattern "extract_insights" --model "gemini-2.5-pro" \
      --output "projects/buddy-ai/buddy-output/insights/${timestamp}_insights.md" "$source_file"
    
    # Step 2: Create summary
    fabric-ai --strategy self-refine --pattern "create_summary" --model "gemini-2.0-flash-exp" \
      --output "projects/buddy-ai/buddy-output/summaries/${timestamp}_summary.md" "$source_file"
    
    # Step 3: Get actionables
    fabric-ai --pattern "get_actionables" --model "gemini-2.0-flash-exp" \
      --output "projects/buddy-ai/buddy-output/actionables/${timestamp}_actions.md" "$source_file"
    
    echo "📋 Generated complete analysis suite in buddy-output/"
}
```

### Interactive Workflow Templates

**Templates for common Buddy AI + Fabric AI workflows:**

```bash
# Template 1: Document Intelligence Workflow
document_intelligence_workflow() {
    local document="$1"
    local timestamp=$(date +%Y%m%d_%H%M)
    local base_name=$(basename "$document" .md)
    
    echo "🔍 Starting Document Intelligence Workflow for: $document"
    
    # Analysis phase
    fabric-ai --strategy cot --pattern "analyze_paper" --model "gemini-2.5-pro" \
      --output "projects/buddy-ai/buddy-output/analysis/${timestamp}_${base_name}_analysis.md" "$document"
    
    # Insights extraction
    fabric-ai --pattern "extract_insights" --model "gemini-2.5-pro" \
      --output "projects/buddy-ai/buddy-output/insights/${timestamp}_${base_name}_insights.md" "$document"
    
    # Risk assessment
    fabric-ai --strategy tot --pattern "analyze_risk" --model "gemini-2.5-pro" \
      --output "projects/buddy-ai/buddy-output/analysis/${timestamp}_${base_name}_risks.md" "$document"
    
    # Claims verification
    fabric-ai --strategy self-consistent --pattern "analyze_claims" --model "gemini-2.0-flash-exp" \
      --output "projects/buddy-ai/buddy-output/analysis/${timestamp}_${base_name}_claims.md" "$document"
    
    echo "✅ Document Intelligence complete. Results in buddy-output/"
}

# Template 2: Content Creation Workflow
content_creation_workflow() {
    local topic="$1"
    local timestamp=$(date +%Y%m%d_%H%M)
    
    echo "📝 Starting Content Creation Workflow for: $topic"
    
    # Research phase
    fabric-ai --search --pattern "extract_insights" --model "gemini-2.5-pro" \
      --output "projects/buddy-ai/buddy-output/research/${timestamp}_research.md" "$topic"
    
    # Content creation
    fabric-ai --strategy self-refine --pattern "create_blog_post" --model "gemini-2.0-flash-exp" \
      --output "projects/buddy-ai/buddy-output/content/${timestamp}_draft.md" "projects/buddy-ai/buddy-output/research/${timestamp}_research.md"
    
    # SEO optimization
    fabric-ai --pattern "write_seo_optimized_content" --model "gemini-2.0-flash-exp" \
      --output "projects/buddy-ai/buddy-output/content/${timestamp}_seo_optimized.md" "projects/buddy-ai/buddy-output/content/${timestamp}_draft.md"
    
    echo "✅ Content Creation complete. Results in buddy-output/"
}

# Template 3: Code Analysis Workflow
code_analysis_workflow() {
    local code_file="$1"
    local timestamp=$(date +%Y%m%d_%H%M)
    local base_name=$(basename "$code_file")
    
    echo "💻 Starting Code Analysis Workflow for: $code_file"
    
    # Code explanation
    fabric-ai --strategy ltm --pattern "coding_master" --model "deepseek-coder:6.7b" \
      --output "projects/buddy-ai/buddy-output/code-review/${timestamp}_${base_name}_explanation.md" "$code_file"
    
    # Security analysis
    fabric-ai --pattern "analyze_malware" --model "deepseek-coder:6.7b" \
      --output "projects/buddy-ai/buddy-output/code-review/${timestamp}_${base_name}_security.md" "$code_file"
    
    # Performance review
    fabric-ai --strategy reflexion --pattern "analyze_tech_impact" --model "gemini-2.5-pro" \
      --output "projects/buddy-ai/buddy-output/code-review/${timestamp}_${base_name}_performance.md" "$code_file"
    
    echo "✅ Code Analysis complete. Results in buddy-output/"
}
```

### Buddy AI Output Processing Patterns

**Patterns for me (Buddy AI) to automatically process Fabric AI outputs:**

```bash
# Pattern 1: Automatic follow-up analysis
process_fabric_output() {
    local output_dir="projects/buddy-ai/buddy-output"
    
    # Find latest analysis files
    latest_analysis=$(find "$output_dir/analysis" -name "*.md" -type f -exec ls -t {} \; | head -1)
    latest_insights=$(find "$output_dir/insights" -name "*.md" -type f -exec ls -t {} \; | head -1)
    
    if [[ -f "$latest_analysis" ]]; then
        echo "🔄 Processing latest analysis: $(basename $latest_analysis)"
        # Buddy AI can read this file and generate follow-up actions
        # semantic_search for key findings
        # grep_search for specific patterns
        # create_file for action items
    fi
}

# Pattern 2: Synthesis and aggregation
synthesize_insights() {
    local insights_dir="projects/buddy-ai/buddy-output/insights"
    local synthesis_file="projects/buddy-ai/buddy-output/synthesis/$(date +%Y%m%d)_combined_insights.md"
    
    # Combine multiple insight files
    echo "# Combined Insights - $(date)" > "$synthesis_file"
    echo "" >> "$synthesis_file"
    
    for insight_file in "$insights_dir"/*.md; do
        if [[ -f "$insight_file" ]]; then
            echo "## $(basename $insight_file .md)" >> "$synthesis_file"
            cat "$insight_file" >> "$synthesis_file"
            echo "" >> "$synthesis_file"
        fi
    done
    
    # Use Fabric AI to analyze the combined insights
    fabric-ai --strategy self-consistent --pattern "extract_insights" --model "gemini-2.5-pro" \
      --output "${synthesis_file%.md}_meta_analysis.md" "$synthesis_file"
}

# Pattern 3: Quality assessment and validation
validate_fabric_output() {
    local output_file="$1"
    local validation_file="${output_file%.md}_validation.md"
    
    # Use Fabric AI to validate its own output
    fabric-ai --strategy reflexion --pattern "analyze_claims" --model "gemini-2.0-flash-thinking-exp" \
      --output "$validation_file" "$output_file"
    
    echo "✅ Validation complete for: $(basename $output_file)"
}
```

### Output Organization & Management

**Structured directory system for Buddy AI interaction:**

```bash
# Create comprehensive output structure
setup_buddy_output_structure() {
    mkdir -p projects/buddy-ai/buddy-output/{
        analysis,
        summaries,
        insights,
        code-review,
        research,
        content,
        actionables,
        synthesis,
        validation,
        archive
    }
    
    # Create index files for tracking
    echo "# Buddy AI Output Index" > projects/buddy-ai/buddy-output/README.md
    echo "Generated: $(date)" >> projects/buddy-ai/buddy-output/README.md
    echo "" >> projects/buddy-ai/buddy-output/README.md
    echo "## Directory Structure:" >> projects/buddy-ai/buddy-output/README.md
    echo "- **analysis/**: Deep document analysis results" >> projects/buddy-ai/buddy-output/README.md
    echo "- **summaries/**: Concise summaries of content" >> projects/buddy-ai/buddy-output/README.md
    echo "- **insights/**: Key insights and takeaways" >> projects/buddy-ai/buddy-output/README.md
    echo "- **code-review/**: Code analysis and reviews" >> projects/buddy-ai/buddy-output/README.md
    echo "- **research/**: Research findings and data" >> projects/buddy-ai/buddy-output/README.md
    echo "- **content/**: Generated content and drafts" >> projects/buddy-ai/buddy-output/README.md
    echo "- **actionables/**: Action items and next steps" >> projects/buddy-ai/buddy-output/README.md
    echo "- **synthesis/**: Combined analysis from multiple sources" >> projects/buddy-ai/buddy-output/README.md
    echo "- **validation/**: Quality validation of outputs" >> projects/buddy-ai/buddy-output/README.md
    echo "- **archive/**: Historical outputs" >> projects/buddy-ai/buddy-output/README.md
}

# Archive old outputs
archive_old_outputs() {
    local archive_date=$(date +%Y%m%d)
    local archive_dir="projects/buddy-ai/buddy-output/archive/$archive_date"
    
    mkdir -p "$archive_dir"
    
    # Move files older than 7 days to archive
    find projects/buddy-ai/buddy-output -name "*.md" -type f -mtime +7 \
        -not -path "*/archive/*" -exec mv {} "$archive_dir/" \;
    
    echo "📦 Archived old outputs to: $archive_dir"
}
```

### Quick Reference Cheat Sheet

### Most Useful Patterns by Category

**Analysis:** `analyze_paper`, `analyze_logs`, `analyze_claims`, `extract_insights`, `analyze_risk`  
**Creation:** `create_summary`, `create_blog_post`, `create_academic_paper`, `create_presentation`  
**Code:** `coding_master`, `explain_code`, `create_coding_project`, `analyze_malware`  
**Processing:** `clean_text`, `convert_to_markdown`, `get_actionables`, `capture_thinkers_work`  
**Enhancement:** `improve_writing`, `create_better_frame`, `write_seo_optimized_content`  

### Best Model Combinations

- **Analysis + Reasoning**: `gemini-2.5-pro` + `--strategy cot`
- **Fast Processing**: `gemini-1.5-flash-8b` + `--strategy standard`  
- **Creative Writing**: `gemini-2.0-flash-exp` + `--strategy self-refine` + `--temperature 0.8`
- **Code Tasks**: `deepseek-coder:6.7b` + `--strategy ltm`
- **Complex Thinking**: `gemini-2.0-flash-thinking-exp` + `--strategy reflexion`

### Essential Commands with Output Management

```bash
# Discovery
fabric-ai --listpatterns | grep -i [keyword]
fabric-ai --liststrategies  
fabric-ai --listmodels | grep -i [vendor]

# Quick analysis with output
fabric-ai --pattern "analyze_claims" --model "gemini-2.0-flash-exp" \
  --output "projects/buddy-ai/buddy-output/analysis/$(date +%Y%m%d_%H%M)_analysis.md" [file]

# Quality content creation with output
fabric-ai --strategy self-refine --pattern "create_summary" --model "gemini-2.5-pro" \
  --output "projects/buddy-ai/buddy-output/summaries/$(date +%Y%m%d_%H%M)_summary.md" [file]

# Fast processing with output
fabric-ai --model "gemini-1.5-flash-8b" --pattern "clean_text" \
  --output "projects/buddy-ai/buddy-output/processing/$(date +%Y%m%d_%H%M)_cleaned.md" [file]
```

### Buddy AI Integration Commands

```bash
# Setup the output structure
setup_buddy_output_structure

# Run document intelligence workflow
document_intelligence_workflow "important-document.md"

# Process latest Fabric AI outputs
process_fabric_output

# Synthesize insights from multiple analyses  
synthesize_insights

# Archive old outputs
archive_old_outputs
```

---

**Workflow Version**: 4.0  
**Updated**: August 6, 2025  
**New Features**: Buddy AI output management, interactive templates, processing patterns  
**Total Patterns**: 209  
**Total Strategies**: 9  
**Total Models**: 59  
**Author**: Buddy AI Assistant