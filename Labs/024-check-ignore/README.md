# Lab 024 - Check Ignore (Advanced)

---

## Overview

Advanced `.gitignore` debugging techniques, including pattern testing, precedence analysis, and troubleshooting complex ignore scenarios.

---

## Core Concepts

- **Complex Patterns**: Advanced glob patterns
- **Precedence Rules**: Multiple .gitignore files
- **Negation Patterns**: Exceptions and overrides
- **Performance**: Efficient ignore patterns

## What You'll Learn

- Advanced gitignore pattern debugging
- Testing patterns before adding
- Understanding complex precedence
- Performance optimization
- Common pitfalls and solutions

## Usage

```bash
cd Labs/024-check-ignore
# Demo files may be available
```

## Advanced Patterns

### Double Asterisk (**)

```gitignore
# Ignore node_modules anywhere
**/node_modules/

# Ignore all .log files in any subdirectory
**/*.log

# Different from
*.log  # Only in root directory
```

### Negation Patterns

```gitignore
# Ignore all .log files
*.log

# Except important.log in root
!/important.log

# Except all .log files in keep/ directory
!/keep/*.log
```

### Complex Examples

```gitignore
# Ignore everything in build/
build/**

# Except the .gitkeep files
!build/**/.gitkeep

# Ignore all .txt files
*.txt

# Except in docs/
!docs/**/*.txt
```

## Testing Patterns

### Test Before Adding

```bash
# Test pattern without modifying .gitignore
echo "test.log" | git check-ignore --stdin -v

# Test with custom pattern
git check-ignore -v --no-index "test.log" 
```

### Batch Testing

```bash
# Create test file list
cat > test-files.txt << 'EOF'
build/output.jar
src/main.java
test.log
docs/readme.txt
EOF

# Test all files
git check-ignore -v --stdin < test-files.txt
```

## Precedence Debugging

### Multiple .gitignore Files

```bash
# Check which .gitignore is being used
git check-ignore -v src/file.txt

# Output shows:
# path/to/.gitignore:5:*.txt    src/file.txt
```

### Override Detection

```bash
# Find all .gitignore files
find . -name .gitignore

# Check each one
for ignore in $(find . -name .gitignore); do
    echo "=== $ignore ==="
    cat "$ignore"
done
```

## Common Pitfalls

### Already Tracked Files

```bash
# Problem: File is tracked but should be ignored

# Check if tracked
git ls-files | grep <file>

# Solution: Untrack but keep local
git rm --cached <file>

# Now .gitignore applies
git check-ignore -v <file>
```

### Whitespace Issues

```bash
# Trailing spaces in .gitignore
git check-ignore -v "test.log "  # Won't match
git check-ignore -v "test.log"   # Will match
```

### Directory vs File Patterns

```bash
# Directory only (trailing slash)
logs/

# Files and directories
logs

# Test difference
git check-ignore -v logs/file.txt  # Different behavior
```

## Performance Optimization

### Slow .gitignore

```bash
# Find expensive patterns
time git status

# Optimize patterns
# BAD: **/**/node_modules/**  (redundant **)
# GOOD: **/node_modules/
```

### Pattern Order

```gitignore
# More specific patterns first
/specific/file.txt

# Then general patterns
*.txt

# Then negations
!important.txt
```

## Debugging Tools

### Visual Debug

```bash
# Create script to visualize
#!/bin/bash
find . -type f | while read file; do
    if git check-ignore -q "$file"; then
        echo "IGNORED: $file"
    else
        echo "TRACKED: $file"
    fi
done
```

### Find Unignored Files

```bash
# Files that should be ignored but aren't
git ls-files -o --exclude-standard | while read file; do
    git check-ignore -v "$file" || echo "NOT IGNORED: $file"
done
```

## Global Ignore

```bash
# Set global ignore file
git config --global core.excludesFile ~/.gitignore_global

# Create it
cat > ~/.gitignore_global << 'EOF'
# OS files
.DS_Store
Thumbs.db

# Editor files
.vscode/
.idea/
*.swp

# Build outputs
*.o
*.so
*.dll
EOF
```

## Repository Exclude

```bash
# Per-repo excludes (not committed)
# Edit .git/info/exclude

cat >> .git/info/exclude << 'EOF'
# Local development
.env.local
*.local
EOF
```

## Advanced Check Commands

```bash
# Show all ignored files in tree
git ls-files -o -i --exclude-standard

# Show why each is ignored
git ls-files -o -i --exclude-standard | git check-ignore -v --stdin

# Find files ignored by global config
git check-ignore -v --no-index <file>
```

## Next Steps

Proceed to [Lab 025 - Create GitHub Repository](../025-createGithubRepository/README.md) to learn about creating repos via API.
