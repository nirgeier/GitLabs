# Lab 026 - Git Notes (Advanced)

---

## Overview

Advanced Git notes techniques including namespaces, automation, sharing strategies, and integration with CI/CD workflows.

---

## Core Concepts

- **Note Namespaces**: Organizing different types of metadata
- **Automation**: Adding notes via scripts and hooks
- **Sharing**: Team-wide note synchronization
- **CI/CD Integration**: Build and deployment tracking

## What You'll Learn

- Advanced namespace management
- Automating note creation
- Sharing notes across teams
- CI/CD integration patterns
- Note querying and reporting

## Usage

```bash
cd Labs/026-git-notes
# Demo files may be available
```

## Namespace Strategies

### Organize by Purpose

```bash
# Code reviews
git notes --ref=reviews add -m "Approved by: Alice"

# Build information
git notes --ref=builds add -m "Build #123: SUCCESS"

# Deployments
git notes --ref=deploys add -m "Deployed to prod: 2023-11-23"

# Testing
git notes --ref=tests add -m "Tests: 156 passed, 0 failed"
```

### Configure Display

```bash
# Show specific namespaces in log
git config notes.displayRef refs/notes/reviews
git config --add notes.displayRef refs/notes/builds
git config --add notes.displayRef refs/notes/deploys

# Now git log shows all configured notes
git log --oneline
```

## Automation Examples

### Post-Commit Hook

```bash
#!/bin/sh
# .git/hooks/post-commit

# Auto-add build timestamp
git notes --ref=timestamps add -m "Created: $(date -Iseconds)"
```

### CI/CD Integration

```bash
#!/bin/bash
# ci-script.sh

COMMIT=$1
BUILD_NUMBER=$2
STATUS=$3

# Add build information
git notes --ref=ci add -m "Build #$BUILD_NUMBER: $STATUS" "$COMMIT"

# Push notes
git push origin refs/notes/ci
```

### Deployment Tracker

```bash
#!/bin/bash
# deploy-script.sh

COMMIT=$(git rev-parse HEAD)
ENVIRONMENT=$1

git notes --ref=deploys add -m "Deployed to $ENVIRONMENT: $(date -Iseconds)" "$COMMIT"
git push origin refs/notes/deploys
```

## Querying Notes

### Extract Notes Data

```bash
# Get all CI notes
git log --format="%(trailers:key=Build,valueonly)" --notes=ci

# Get deployment history
git log --notes=deploys --format="%H %s" | while read hash msg; do
    NOTE=$(git notes --ref=deploys show "$hash" 2>/dev/null)
    [ -n "$NOTE" ] && echo "$hash: $NOTE"
done
```

### Generate Reports

```bash
#!/bin/bash
# deployment-report.sh

echo "Deployment History"
echo "=================="

git log --all --format="%H|%ai|%s" | while IFS='|' read hash date msg; do
    deploy=$(git notes --ref=deploys show "$hash" 2>/dev/null)
    if [ -n "$deploy" ]; then
        echo "$date | $msg"
        echo "  → $deploy"
    fi
done
```

## Team Synchronization

### Automatic Fetch

```bash
# Configure fetch for all note namespaces
git config --add remote.origin.fetch '+refs/notes/*:refs/notes/*'

# Now notes are fetched with git pull
git pull
```

### Push All Notes

```bash
# Push all note namespaces
git push origin 'refs/notes/*'

# Or specific namespace
git push origin refs/notes/reviews
```

### Pre-Push Hook

```bash
#!/bin/sh
# .git/hooks/pre-push

# Automatically push notes
git push origin 'refs/notes/*' 2>/dev/null || true
```

## Advanced Queries

### Find Commits with Specific Notes

```bash
# Find all reviewed commits
git log --all --format="%H" | while read hash; do
    if git notes --ref=reviews show "$hash" >/dev/null 2>&1; then
        echo "$hash: $(git log -1 --format="%s" $hash)"
        git notes --ref=reviews show "$hash"
    fi
done
```

### Note Statistics

```bash
#!/bin/bash
# note-stats.sh

echo "Note Statistics"
echo "==============="

for ref in reviews builds deploys tests; do
    count=$(git notes --ref=$ref list 2>/dev/null | wc -l)
    echo "$ref: $count commits"
done
```

## Merging Notes

### Configure Merge Strategy

```bash
# Concatenate notes on conflict
git config notes.mergeStrategy cat_sort_uniq

# Or use union (faster but no deduplication)
git config notes.mergeStrategy union
```

### Manual Merge

```bash
# If conflicts occur
git notes merge refs/notes/remote-name

# Resolve conflicts
git notes merge --commit

# Or abort
git notes merge --abort
```

## Practical Workflows

### Code Review Workflow

```bash
# Reviewer adds note
git notes --ref=reviews add -m "Reviewed-by: Alice
Changes requested:
- Add error handling
- Update tests" <commit>

# After fixes
git notes --ref=reviews append -m "
Re-reviewed: Approved" <commit>
```

### Release Management

```bash
# Tag with release notes
git notes --ref=releases add -m "Version: 1.2.0
Features:
- Feature A
- Feature B
Fixes:
- Bug #123" <commit>

# Generate release notes
git notes --ref=releases show <tag>
```

## Next Steps

Proceed to [Lab 027 - Git Similarity](../027-git-similarity/README.md) to learn about analyzing code similarity.
