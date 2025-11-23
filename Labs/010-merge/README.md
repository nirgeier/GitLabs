# Lab 010 - Git Merge

---

## Overview

Explore different Git merge strategies and when to use each one. Understanding merge strategies is crucial for maintaining a clean and meaningful Git history.

---

## Core Concepts

- **Fast-Forward Merge**: Linear history when possible
- **Recursive Strategy**: Default three-way merge
- **Ours/Theirs Strategy**: Conflict resolution preferences
- **Squash Merge**: Combine commits into one
- **No-FF Merge**: Always create a merge commit

## What You'll Learn

- Different merge strategies and their use cases
- Fast-forward vs non-fast-forward merges
- Squashing commits during merge
- Choosing the right merge strategy
- Understanding merge history

## Demo Script

- Script demonstrates various merge strategies

## Usage

```bash
cd Labs/010-merge
./*.sh
```

## Merge Strategies

### Fast-Forward (FF)

```bash
# Default if possible
git merge feature-branch

# Explicit fast-forward
git merge --ff-only feature-branch
```

**When to use:** Simple linear history, feature is ahead of main

### No Fast-Forward (--no-ff)

```bash
git merge --no-ff feature-branch
```

**When to use:** Preserve feature branch history, group related commits

### Squash Merge

```bash
git merge --squash feature-branch
git commit -m "Implemented feature X"
```

**When to use:** Clean history, many small commits in feature branch

### Strategy Options

```bash
# Prefer current branch on conflicts
git merge -X ours feature-branch

# Prefer incoming branch on conflicts
git merge -X theirs feature-branch

# Use specific strategy
git merge -s recursive feature-branch
```

## Merge vs Rebase

**Merge:**
- Preserves complete history
- Shows when branches diverged and merged
- Safe for public branches

**Rebase:**
- Linear history
- Cleaner log
- Rewrites history (avoid on public branches)

## Visualizing Merges

```bash
# See merge history
git log --graph --oneline --all

# See merge commits only
git log --merges
```

## Next Steps

Proceed to [Lab 011 - Git MV](../011-git-mv/README.md) to learn about moving and renaming files in Git.
