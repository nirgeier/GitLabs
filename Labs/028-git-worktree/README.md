# Lab 028 - Git Worktree

---

## Overview

Learn how to use Git worktrees to work on multiple branches simultaneously without switching branches or cloning the repository multiple times.

---

## Core Concepts

- **Worktree**: Separate working directory for same repository
- **Linked Worktrees**: Share same .git directory
- **Parallel Development**: Work on multiple branches at once
- **No Context Switching**: Keep different branches in different directories

## What You'll Learn

- Creating and managing worktrees
- Working with multiple branches simultaneously
- Worktree best practices
- Cleaning up worktrees
- Advanced worktree workflows

## Demo Script

- Script demonstrates worktree feature

## Usage

```bash
cd Labs/028-git-worktree
./*.sh
```

## Basic Operations

### Create Worktree

```bash
# Create worktree for existing branch
git worktree add ../feature-worktree feature-branch

# Create worktree and new branch
git worktree add ../new-feature -b new-feature

# Create from specific commit
git worktree add ../hotfix abc1234
```

### List Worktrees

```bash
# List all worktrees
git worktree list

# Detailed information
git worktree list --porcelain
```

### Remove Worktree

```bash
# Remove worktree
git worktree remove ../feature-worktree

# Force removal (with uncommitted changes)
git worktree remove --force ../feature-worktree

# Prune stale references
git worktree prune
```

## Common Workflows

### Parallel Feature Development

```bash
# Main development in main directory
cd /path/to/repo

# Work on feature-1
git worktree add ../feature-1 -b feature-1
cd ../feature-1
# ... make changes ...

# Simultaneously work on feature-2
cd /path/to/repo
git worktree add ../feature-2 -b feature-2
cd ../feature-2
# ... make changes ...

# Both features available simultaneously
```

### Hotfix While Working

```bash
# Currently on feature branch with uncommitted changes
# Don't want to stash or commit

# Create worktree for hotfix
git worktree add ../hotfix -b hotfix/critical-bug

# Work on hotfix
cd ../hotfix
# ... fix bug ...
git commit -am "Fix critical bug"
git push origin hotfix/critical-bug

# Return to feature work
cd -
# Continue where you left off
```

### Code Review

```bash
# Review PR while continuing development
git worktree add ../pr-review pr-branch

# Review in separate directory
cd ../pr-review
# ... test and review ...

# Main work unaffected
cd -
```

## Worktree Structure

```text
repo/
├── .git/              # Main Git directory
│   └── worktrees/
│       ├── feature-1/
│       └── feature-2/
├── main files...
../feature-1/          # Linked worktree
├── .git (file)        # Points to repo/.git/worktrees/feature-1
└── feature-1 files...
../feature-2/          # Linked worktree
├── .git (file)
└── feature-2 files...
```

## Advanced Usage

### Temporary Worktrees

```bash
# Create temporary worktree
git worktree add --detach ../temp-work HEAD

# Use for testing
cd ../temp-work
# ... test changes ...

# Remove when done
cd -
git worktree remove ../temp-work
```

### Move Worktree

```bash
# Move worktree to new location
git worktree move ../old-location ../new-location
```

### Lock Worktree

```bash
# Prevent automatic cleanup
git worktree lock ../important-worktree

# Add reason
git worktree lock --reason "Long-running experiment" ../worktree

# Unlock
git worktree unlock ../important-worktree
```

## Worktree with Submodules

```bash
# Create worktree and update submodules
git worktree add ../feature
cd ../feature
git submodule update --init --recursive
```

## Cleaning Up

### Remove Stale Worktrees

```bash
# List stale worktrees
git worktree prune --dry-run

# Remove stale worktree references
git worktree prune

# Remove stale and expired
git worktree prune --expire now
```

### Remove All Worktrees

```bash
#!/bin/bash
# remove-all-worktrees.sh

git worktree list --porcelain | grep "^worktree " | cut -d' ' -f2 | \
while read worktree; do
    # Skip main worktree
    if [ "$worktree" != "$(git rev-parse --show-toplevel)" ]; then
        echo "Removing: $worktree"
        git worktree remove "$worktree" 2>/dev/null || \
        git worktree remove --force "$worktree"
    fi
done

git worktree prune
```

## Best Practices

### Naming Conventions

```bash
# Use descriptive names
git worktree add ../feature-user-auth feature/user-auth
git worktree add ../fix-memory-leak fix/memory-leak
git worktree add ../release-v2.0 release/v2.0
```

### Organization

```bash
# Keep worktrees in dedicated directory
mkdir ~/worktrees
git worktree add ~/worktrees/feature-1 -b feature-1
git worktree add ~/worktrees/feature-2 -b feature-2
```

### Cleanup Routine

```bash
# Add to .git/hooks/post-checkout or alias
git config --global alias.worktree-clean 'worktree prune --verbose'

# Run periodically
git worktree-clean
```

## Limitations

1. **One Branch Per Worktree**: Can't checkout same branch in multiple worktrees
2. **Shared .git**: All worktrees share same repository
3. **No Sparse Checkout**: Each worktree has full working tree
4. **Disk Space**: Each worktree uses disk space

## Troubleshooting

### Worktree Already Exists

```bash
# Error: worktree already exists
# Solution: Use different path or remove old one
git worktree remove ../old-worktree
git worktree add ../new-worktree branch-name
```

### Branch Already Checked Out

```bash
# Error: branch already checked out
# Solution: Create from specific commit or use different branch
git worktree add ../worktree -b new-branch origin/branch
```

## Alternatives to Worktree

```bash
# Traditional approach (slower)
git clone repo repo-feature
cd repo-feature
git checkout feature

# Or stashing (loses context)
git stash
git checkout other-branch
# ... work ...
git checkout original-branch
git stash pop
```

## Next Steps

Proceed to [Lab 029 - Interpret Trailers](../029-interpret-trailers/README.md) for advanced trailer management.
