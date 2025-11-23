# Lab 027 - Git Similarity

---

## Overview

Learn how to analyze code similarity between commits and files in a Git repository. This helps detect code duplication, track refactoring, and understand code evolution.

---

## Core Concepts

- **Similarity Index**: Percentage of similarity between files
- **Rename Detection**: Tracking file renames based on content
- **Copy Detection**: Finding copied code
- **Similarity Threshold**: Configuring detection sensitivity

## What You'll Learn

- Detecting file similarities
- Finding code duplicates
- Tracking refactoring
- Analyzing code evolution
- Configuring similarity detection

## Demo Script

- Script demonstrates similarity analysis

## Usage

```bash
cd Labs/027-git-similarity
./*.sh
```

## Similarity Detection

### Basic Rename Detection

```bash
# Show renames in diff
git diff --find-renames

# Show renames in log
git log --find-renames

# Specify similarity threshold (default 50%)
git diff --find-renames=80%

# Show similarity percentage
git diff --find-renames -M80%
```

### Copy Detection

```bash
# Detect copies within same commit
git diff --find-copies

# Detect copies from all files
git diff --find-copies --find-copies-harder

# Set copy threshold
git diff --find-copies=90%
```

## Analyzing Similarity

### Between Two Commits

```bash
# Show similarity in changes
git diff --find-copies-harder <commit1> <commit2>

# With similarity percentage
git diff -C -C <commit1> <commit2>
```

### In Commit History

```bash
# Show renames in history
git log --follow --find-renames <file>

# Show all renames with similarity
git log --name-status --find-renames=90%

# Find copies in history
git log --find-copies --find-copies-harder
```

## Configuration

### Global Settings

```bash
# Set rename detection threshold
git config --global diff.renames true
git config --global diff.renameLimit 1000

# Set copy detection
git config --global diff.copies true

# Similarity threshold (0-100)
git config --global diff.renamesThreshold 50
```

### Per-Repository Settings

```bash
# Enable rename detection
git config diff.renames true

# More aggressive copy detection
git config diff.copies true
```

## Similarity Flags

```bash
# -M or --find-renames[=<n>]
git diff -M       # Default threshold (50%)
git diff -M90%    # 90% similarity required

# -C or --find-copies[=<n>]
git diff -C       # Copies from modified files
git diff -C -C    # Copies from all files (harder)

# --find-copies-harder
git diff -C --find-copies-harder
```

## Practical Examples

### Find Refactored Code

```bash
# Look for code moved to different files
git log --find-copies-harder --find-renames --stat

# Show details
git show --find-copies-harder <commit>
```

### Track File Through Renames

```bash
# Follow file history across renames
git log --follow --find-renames -- <file>

# Show each rename
git log --follow --name-status --find-renames -- <file>
```

### Detect Code Duplication

```bash
# Find similar files in current commit
git diff-tree --find-copies-harder -r <commit>

# Compare all files
git diff --name-status --find-copies-harder <commit>^ <commit>
```

## Advanced Analysis

### Custom Similarity Script

```bash
#!/bin/bash
# similarity-report.sh

echo "Similarity Analysis Report"
echo "=========================="

# Analyze last N commits
COMMITS=10

for i in $(seq 1 $COMMITS); do
    commit=$(git rev-parse HEAD~$i)
    echo ""
    echo "Commit: $commit"
    git show --stat --find-copies-harder --find-renames $commit | \
        grep -E "rename|copy"
done
```

### Find Similar Files

```bash
#!/bin/bash
# find-similar.sh

FILE=$1
THRESHOLD=${2:-80}

git ls-files | while read other; do
    if [ "$other" != "$FILE" ]; then
        # Compare files
        similarity=$(git diff --no-index --stat "$FILE" "$other" 2>/dev/null | \
            grep -oP '\d+(?=% similarity)' || echo 0)
        
        if [ "$similarity" -ge "$THRESHOLD" ]; then
            echo "$other: ${similarity}% similar"
        fi
    fi
done
```

## Understanding Output

### Rename Notation

```text
R100  old-name.txt => new-name.txt  # 100% similar (rename)
R090  old.txt => new.txt            # 90% similar
```

### Copy Notation

```text
C100  original.txt => copy.txt      # 100% copy
C075  src.txt => dest.txt           # 75% similar copy
```

## Use Cases

### Code Review

```bash
# Check if code was copied
git diff --find-copies-harder HEAD^ HEAD
```

### Refactoring Analysis

```bash
# Track major refactoring
git log --find-renames=70% --stat
```

### License Compliance

```bash
# Find copied code from other sources
git diff --find-copies-harder <before-import> <after-import>
```

### Duplicate Detection

```bash
# Find potential duplicates in codebase
git diff-tree --find-copies-harder -r HEAD
```

## Performance Considerations

```bash
# Limit rename detection
git config diff.renameLimit 200

# Disable for large repositories
git config diff.renames false

# Enable only when needed
git diff --no-renames  # Disable for single command
```

## Next Steps

Proceed to [Lab 028 - Git Worktree](../028-git-worktree/README.md) to learn about working on multiple branches simultaneously.
