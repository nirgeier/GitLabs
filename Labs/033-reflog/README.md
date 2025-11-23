# Lab 033 - Git Reflog

---

## Overview

Master Git reflog to recover lost commits, undo mistakes, and track repository state changes. Reflog is your safety net for Git operations.

---

## Core Concepts

- **Reference Logs**: History of HEAD and branch movements
- **Commit Recovery**: Retrieving "lost" commits
- **Time Travel**: Navigate through repository states
- **Garbage Collection**: Understanding reflog expiration

## What You'll Learn

- Using reflog to track changes
- Recovering deleted commits
- Undoing rebases and resets
- Finding lost work
- Reflog expiration and cleanup

## Demo Script

- `reflog.sh` - Demonstrates reflog usage and recovery scenarios

## Usage

```bash
cd Labs/033-reflog
./reflog.sh
```

## Key Commands

```bash
# Show reflog
git reflog

# Show reflog for specific branch
git reflog show main

# Show reflog with dates
git reflog show --date=iso

# Recover lost commit
git checkout <reflog-entry>

# Reset to previous state
git reset --hard HEAD@{2}
```

## Common Scenarios

### Undo Accidental Reset

```bash
# Accidentally reset hard
git reset --hard HEAD~3

# Find lost commits
git reflog

# Restore to previous state
git reset --hard HEAD@{1}
```

### Recover Deleted Branch

```bash
# Delete branch
git branch -D feature-branch

# Find last commit of deleted branch
git reflog | grep feature-branch

# Recreate branch
git branch feature-branch <commit-hash>
```

### Undo Rebase

```bash
# Before rebase
git reflog  # Note: HEAD@{0}

# After problematic rebase
git reflog  # Find pre-rebase state

# Restore
git reset --hard HEAD@{5}  # Adjust number as needed
```

## Reflog Entries

Format: `HEAD@{n}` where n is:
- Number: Steps back from current HEAD
- Time: Relative time (e.g., `HEAD@{2.hours.ago}`)
- Date: Absolute date (e.g., `HEAD@{2023-11-23}`)

## Best Practices

1. **Check reflog before panic** - Commits are rarely truly lost
2. **Use reflog for auditing** - Track who did what when
3. **Understand expiration** - Default 90 days for reachable, 30 for unreachable
4. **Don't rely on it forever** - Eventually entries expire

## Next Steps

Proceed to [Lab 034 - Bundle](../034-bundle/README.md) to learn about creating Git bundles.
