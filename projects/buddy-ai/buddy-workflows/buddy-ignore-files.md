# Buddy Ignore Files Workflow

## Overview
This workflow explains how to comprehensively manage `.gitignore` patterns to exclude specific files and directories from git tracking across your entire repository.

## Use Cases
- Adding new files/folders to be ignored by git
- Removing already-tracked files from git while keeping them locally
- Setting up global patterns for tool-specific files (like `.gemini/`, `.goosehints`, etc.)
- Testing ignore patterns to ensure they work correctly

## Prerequisites
- Git repository initialized
- Basic understanding of git commands
- Access to terminal/command line

## Step-by-Step Workflow

### 1. Identify Files and Directories to Ignore

First, find all instances of files/directories you want to ignore across your repository:

```bash
# Find directories by name (recursive search)
find . -name ".gemini" -type d
find . -name ".obsidian" -type d

# Find files by name pattern
find . -name ".goosehints" -type f
find . -name "*.goosehint" -type f
find . -name "Ana-lazy-ing" -type d

# Search for specific patterns in file names
find . -name "*secret*" -type f
find . -name "*.log" -type f
```

### 2. Check Current Git Status

Before making changes, understand what's currently tracked:

```bash
# Check current git status
git status --porcelain

# List files currently tracked by git that match your patterns
git ls-files | grep -E "(\.gemini|\.goosehints|Ana-lazy-ing)"

# Check what files are being ignored
git status --ignored
```

### 3. Update .gitignore Patterns

Add comprehensive patterns to your `.gitignore` file. Use global patterns to catch files anywhere in the repository:

```gitignore
# Directory patterns (anywhere in repo)
Ana-lazy-ing/
**/.gemini/
**/.obsidian/

# File patterns (anywhere in repo)
.goosehints
**/.goosehints
*.goosehint
*.log

# Specific file patterns
.env
.env.*
!.env.example
```

### 4. Pattern Types Explained

| Pattern | Description | Example |
|---------|-------------|---------|
| `filename` | Ignores file in root directory only | `.gitignore` |
| `filename/` | Ignores directory in root only | `logs/` |
| `**/filename` | Ignores file anywhere in repo | `**/.goosehints` |
| `**/dirname/` | Ignores directory anywhere in repo | `**/.gemini/` |
| `*.extension` | Ignores all files with extension | `*.log` |
| `!filename` | Exception - don't ignore this file | `!.env.example` |

### 5. Test Your Patterns

Before removing tracked files, test your patterns:

```bash
# Create test files to verify patterns work
mkdir -p test-dir/.gemini
echo "test content" > test-dir/.gemini/test.md
echo "test content" > test-dir/.goosehints
echo "test content" > test-dir/test.goosehint

# Test if patterns are working
git check-ignore -v test-dir/.gemini/
git check-ignore -v test-dir/.goosehints
git check-ignore -v test-dir/test.goosehint

# Check git status - these files should not appear
git status --porcelain | grep test-dir

# Clean up test files
rm -rf test-dir
```

### 6. Remove Already-Tracked Files

If files are already tracked by git, you need to remove them from tracking:

```bash
# Remove individual files from tracking (keeps local files)
git rm --cached .goosehints
git rm --cached .gemini/GEMINI.md

# Remove directories from tracking
git rm -r --cached .obsidian/
git rm -r --cached Ana-lazy-ing/

# Remove files matching pattern from tracking
git rm --cached $(git ls-files | grep -E "\.goosehint$")
```

### 7. Verify Ignore Patterns

After updating `.gitignore` and removing tracked files:

```bash
# Verify specific files are now ignored
git check-ignore -v .gemini/
git check-ignore -v Ana-lazy-ing/
git check-ignore -v .goosehints

# Check git status - ignored files should not appear
git status

# Test with new files in various locations
mkdir -p deep/nested/path/.gemini
echo "test" > deep/nested/path/.gemini/test.md
echo "test" > deep/nested/.goosehints
echo "test" > deep/test.goosehint

# Verify they're ignored
git check-ignore -v deep/nested/path/.gemini/
git check-ignore -v deep/nested/.goosehints
git check-ignore -v deep/test.goosehint

# Clean up
rm -rf deep
```

### 8. Commit Changes

```bash
# Add the updated .gitignore
git add .gitignore

# Commit both the .gitignore changes and file removals
git commit -m "feat: update .gitignore patterns and remove tracked tool files

- Add comprehensive ignore patterns for .gemini/, .goosehints, Ana-lazy-ing/
- Remove previously tracked tool-specific files from git
- Use global patterns (**/) to ignore files anywhere in repository"
```

## Common Patterns for Development Tools

### AI/ML Tools
```gitignore
# Gemini AI CLI
.gemini/
**/.gemini/

# Goose AI
.goosehints
**/.goosehints
*.goosehint

# Other AI tools
.cursor/
**/.cursor/
```

### Development Environments
```gitignore
# IDEs
.idea/
.vscode/
**/.obsidian/

# Environment files
.env
.env.*
!.env.example
```

### Build and Cache
```gitignore
# Logs
*.log
logs/

# Dependencies
node_modules/
vendor/

# Build outputs
dist/
build/
```

## Troubleshooting

### Files Still Showing in Git Status
- **Problem**: Files appear in `git status` even after adding to `.gitignore`
- **Solution**: Files are already tracked. Use `git rm --cached filename` to untrack them.

### Pattern Not Working
- **Problem**: New files matching pattern still appear in git status
- **Solution**: 
  1. Verify pattern syntax in `.gitignore`
  2. Test with `git check-ignore -v filename`
  3. Ensure no spaces or typos in pattern

### Global Patterns Not Working
- **Problem**: `**/pattern` doesn't work as expected
- **Solution**: 
  1. Ensure git version supports `**` patterns (Git 1.8.2+)
  2. Try both `pattern` and `**/pattern` for comprehensive coverage

### Accidentally Removed Important Files
- **Problem**: Used `git rm` instead of `git rm --cached`
- **Solution**: 
  1. `git checkout HEAD -- filename` to restore file
  2. Then use `git rm --cached filename` to untrack only

## Best Practices

1. **Test First**: Always test patterns before removing tracked files
2. **Use Global Patterns**: Prefer `**/pattern` for files that can appear anywhere
3. **Be Specific**: Avoid overly broad patterns that might catch important files
4. **Document Changes**: Include clear commit messages explaining ignore changes
5. **Regular Maintenance**: Periodically review and clean up `.gitignore` patterns

## Advanced Commands

### Find Large Ignored Files
```bash
# List ignored files with sizes
git ls-files --others --ignored --exclude-standard --directory | xargs ls -lah
```

### Remove All Ignored Files
```bash
# CAUTION: This permanently deletes ignored files
git clean -fXd
```

### Check Ignore Status of Multiple Files
```bash
# Check multiple files at once
git check-ignore -v $(find . -name "*.log" -o -name ".gemini")
```

### Temporarily Track Ignored File
```bash
# Force add an ignored file (use sparingly)
git add -f ignored-file.log
```

## Workflow Checklist

- [ ] Identify files/directories to ignore
- [ ] Check current git status
- [ ] Add patterns to `.gitignore`
- [ ] Test patterns with temporary files
- [ ] Remove tracked files with `git rm --cached`
- [ ] Verify patterns work correctly
- [ ] Commit changes with descriptive message
- [ ] Test with new files in various locations

## Related Resources

- [Git Documentation - gitignore](https://git-scm.com/docs/gitignore)
- [GitHub .gitignore Templates](https://github.com/github/gitignore)
- [gitignore.io - Generate .gitignore files](https://www.toptal.com/developers/gitignore)

---

**Workflow Created**: 2025-01-06  
**Last Updated**: 2025-01-06  
**Author**: Buddy AI Assistant  
**Version**: 1.0
