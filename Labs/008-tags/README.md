# Lab 008 - Git Tags

---

## Overview

Learn how to create, manage, and use Git tags to mark specific points in your repository's history. Tags are commonly used for release versions and important milestones.

---

## Core Concepts

- **Lightweight Tags**: Simple pointers to commits
- **Annotated Tags**: Full Git objects with metadata
- **Tag Types**: When to use each type
- **Tag Management**: Listing, pushing, and deleting tags

## What You'll Learn

- Creating lightweight and annotated tags
- Viewing tag information
- Pushing tags to remote repositories
- Deleting local and remote tags
- Best practices for tagging

## Demo Script

- Script demonstrates creating and managing tags

## Usage

```bash
cd Labs/008-tags
./*.sh
```

## Key Commands

```bash
# Create lightweight tag
git tag v1.0.0

# Create annotated tag
git tag -a v1.0.0 -m "Release version 1.0.0"

# Tag a specific commit
git tag v1.0.0 <commit-hash>

# List all tags
git tag

# Show tag information
git show v1.0.0

# Push tag to remote
git push origin v1.0.0

# Push all tags
git push origin --tags

# Delete local tag
git tag -d v1.0.0

# Delete remote tag
git push origin --delete v1.0.0
```

## Lightweight vs Annotated Tags

**Lightweight Tags:**
- Just a pointer to a commit
- No additional metadata
- Like a branch that doesn't move

**Annotated Tags:**
- Full Git objects
- Include tagger name, email, date
- Can be signed and verified
- Can include a message
- **Recommended for releases**

## Tagging Convention

```bash
# Semantic versioning
v1.0.0
v1.2.3
v2.0.0-beta

# With prefix
release-v1.0.0
production-2023-11-23
```

## Next Steps

Proceed to [Lab 009 - Conflicts](../009-conflicts/README.md) to learn about handling merge conflicts.
