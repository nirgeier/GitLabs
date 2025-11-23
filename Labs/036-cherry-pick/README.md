# Lab 036 - Cherry Pick

---

## Overview

Master git cherry-pick to selectively apply commits from one branch to another. Essential for backporting fixes, selecting specific features, and maintaining multiple release branches.

---

## Core Concepts

- **Selective Application**: Pick specific commits
- **New Commit Creation**: Creates new commits with same changes
- **Conflict Resolution**: Handle cherry-pick conflicts
- **Range Selection**: Apply multiple commits at once

## What You'll Learn

- Cherry-picking single commits
- Applying commit ranges
- Handling cherry-pick conflicts
- Using -x flag for traceability
- Cherry-picking merge commits

## Demo Script

- `cherry-pick.sh` - Demonstrates cherry-pick scenarios

## Usage

```bash
cd Labs/036-cherry-pick
./cherry-pick.sh
```

## Key Commands

```bash
# Cherry-pick single commit
git cherry-pick <commit-hash>

# Cherry-pick with commit reference
git cherry-pick -x <commit-hash>

# Cherry-pick range
git cherry-pick A..B

# Cherry-pick without committing
git cherry-pick -n <commit-hash>

# Continue after resolving conflicts
git cherry-pick --continue

# Abort cherry-pick
git cherry-pick --abort
```

## Common Scenarios

### Backport Bug Fix

```bash
# On release branch
git checkout release-2.0

# Pick fix from main
git cherry-pick abc123

# With reference to original
git cherry-pick -x abc123
```

### Apply Multiple Commits

```bash
# Cherry-pick range
git cherry-pick feature-start..feature-end

# Cherry-pick specific commits
git cherry-pick abc123 def456 ghi789
```

### Cherry-Pick with Edit

```bash
# Pick commit and edit message
git cherry-pick -e <commit-hash>

# Pick without committing (stage only)
git cherry-pick -n <commit-hash>
# Make modifications
git commit
```

## Handling Conflicts

When conflicts occur:

```bash
# See conflict status
git status

# Edit conflicting files
# ... resolve conflicts ...

# Stage resolved files
git add <resolved-files>

# Continue cherry-pick
git cherry-pick --continue

# Or abort if needed
git cherry-pick --abort
```

## Best Practices

1. **Use -x flag** for traceability in shared branches
2. **Test after cherry-pick** - same change, different context
3. **Avoid cherry-picking merges** unless necessary
4. **Document the reason** in commit message
5. **Consider rebasing** for multiple related commits

## Cherry-Pick vs Merge

**Cherry-Pick**: Select specific commits
- Pros: Granular control, clean history
- Cons: Duplicate commits, more work

**Merge**: Bring all changes
- Pros: Complete history, less work
- Cons: All-or-nothing approach

## Next Steps

Proceed to [Lab 037 - Filter Branch](../037-filter-branch/README.md) to learn about repository history rewriting.
