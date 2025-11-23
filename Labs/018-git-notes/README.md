# Lab 018 - Git Notes

---

## Overview

Learn how to use Git notes to add metadata and annotations to commits without modifying the commits themselves. This is perfect for code reviews, build information, or any supplementary data.

---

## Core Concepts

- **Notes Objects**: Metadata attached to commits
- **Non-Intrusive**: Doesn't modify commit history
- **Namespaces**: Organize notes by category
- **Sharing Notes**: Push/pull notes separately
- **Multiple Notes**: Different note types per commit

## What You'll Learn

- Adding notes to commits
- Viewing and listing notes
- Editing and removing notes
- Using note namespaces
- Sharing notes with others
- Practical use cases

## Demo Script

- Script demonstrates git notes features

## Usage

```bash
cd Labs/018-git-notes
./*.sh
```

## Key Commands

```bash
# Add note to HEAD
git notes add -m "Review: Approved"

# Add note to specific commit
git notes add -m "Build: #1234" <commit>

# Edit note
git notes edit <commit>

# Show note
git notes show <commit>

# List all notes
git notes list

# Remove note
git notes remove <commit>

# Show commits with notes in log
git log --show-notes
```

## Note Namespaces

Different types of notes can be stored in namespaces:

```bash
# Add note to specific namespace
git notes --ref=builds add -m "Build #5678" HEAD

# Show notes from namespace
git notes --ref=builds show HEAD

# List notes in namespace
git notes --ref=builds list

# Configure default namespace to show
git config notes.displayRef refs/notes/builds
```

## Common Namespaces

```bash
# Code review notes
git notes --ref=reviews add -m "LGTM" <commit>

# Build information
git notes --ref=builds add -m "Passed CI" <commit>

# Deployment info
git notes --ref=deploys add -m "Deployed to production" <commit>

# Bug tracking
git notes --ref=bugs add -m "Fixes #123" <commit>
```

## Sharing Notes

Notes are not pushed/pulled by default:

```bash
# Push notes
git push origin refs/notes/*

# Fetch notes
git fetch origin refs/notes/*:refs/notes/*

# Pull notes
git pull origin refs/notes/*
```

## Configure Automatic Fetching

```bash
# Fetch notes automatically
git config remote.origin.fetch '+refs/notes/*:refs/notes/*'
```

## Viewing Notes in Log

```bash
# Show notes in log
git log --show-notes

# Show specific namespace in log
git log --notes=builds

# Show multiple namespaces
git log --notes=builds --notes=reviews
```

## Practical Use Cases

### Code Review

```bash
git notes add -m "Reviewed-by: Alice <alice@example.com>"
```

### Build Status

```bash
git notes --ref=ci add -m "Build #456: SUCCESS"
```

### Deployment Tracking

```bash
git notes --ref=deploy add -m "Deployed: 2023-11-23 14:30:00 UTC"
```

### Bug References

```bash
git notes add -m "Resolves: #123, #456"
```

## Merging Notes

When notes conflict:

```bash
# Set merge strategy for notes
git config notes.rewriteRef refs/notes/commits

# Merge strategies
git config notes.mergeStrategy cat_sort_uniq  # Concatenate and sort
git config notes.mergeStrategy union           # Simple union
```

## Notes vs Commit Messages

**Use Commit Messages for:**
- Essential information
- What and why of the change
- Permanent part of history

**Use Notes for:**
- Supplementary information
- Metadata added later
- Review comments
- Build/deploy information
- External references

## Next Steps

Proceed to [Lab 019 - Format Patch](../019-format-patch/README.md) to learn about creating patch files.
