# Lab 017 - Assume Unchanged

---

## Overview

Learn how to use the `assume-unchanged` flag to tell Git to temporarily ignore changes to tracked files. This is useful for local configuration files that you don't want to commit.

---

## Core Concepts

- **Assume Unchanged**: Tell Git to ignore changes to tracked files
- **Skip Worktree**: Alternative approach for local modifications
- **Local Changes**: Keep local modifications without committing
- **Performance**: Improve Git performance on large files

## What You'll Learn

- Setting assume-unchanged flag on files
- Listing files marked as assume-unchanged
- Removing assume-unchanged flag
- Difference between assume-unchanged and skip-worktree
- Use cases and limitations

## Demo Script

- Script demonstrates assume-unchanged workflow

## Usage

```bash
cd Labs/017-assume-unchaged
./*.sh
```

## Key Commands

```bash
# Mark file as assume-unchanged
git update-index --assume-unchanged <file>

# Unmark file
git update-index --no-assume-unchanged <file>

# List assume-unchanged files
git ls-files -v | grep '^h'
```

## How It Works

When you mark a file as assume-unchanged:
- Git pretends the file hasn't changed
- `git status` won't show it as modified
- `git add` won't stage local changes
- Improves performance (Git doesn't stat the file)

## Common Use Cases

### Local Configuration Files

```bash
# Don't track local database config
git update-index --assume-unchanged config/database.yml
```

### Large Files

```bash
# Skip checking large files frequently
git update-index --assume-unchanged large-file.dat
```

### Development Settings

```bash
# Keep local debug settings
git update-index --assume-unchanged .env
```

## Listing Assumed-Unchanged Files

```bash
# Show all files with status
git ls-files -v

# Filter assume-unchanged files (h prefix)
git ls-files -v | grep '^h'

# Create alias
git config --global alias.assumed "ls-files -v | grep '^h'"
git assumed
```

## Assume-Unchanged vs Skip-Worktree

### Assume-Unchanged

```bash
git update-index --assume-unchanged <file>
```

- **Purpose**: Performance optimization
- **Intent**: "This file won't change"
- **Behavior**: May be overwritten by Git operations
- **Use when**: File rarely changes on filesystem

### Skip-Worktree

```bash
git update-index --skip-worktree <file>
```

- **Purpose**: Local modifications
- **Intent**: "I have local changes"
- **Behavior**: Preserved across Git operations
- **Use when**: Maintaining local modifications

## ⚠️ Limitations

1. **Not Shared**: Flag is local, not pushed to remote
2. **Can Be Overwritten**: Git operations may clear the flag
3. **Merge Issues**: May cause conflicts during merge/pull
4. **Stash Problems**: May interfere with stashing

## Recovering

If Git overwrites your changes:

```bash
# Unmark the file
git update-index --no-assume-unchanged <file>

# Check status
git status

# Restore from backup if needed
```

## Reset All Assume-Unchanged

```bash
# List and reset all
git ls-files -v | grep '^h' | cut -c 3- | xargs git update-index --no-assume-unchanged
```

## Better Alternative: .gitignore

For truly ignored files, use `.gitignore`:

```bash
# Add to .gitignore
echo "config/local.yml" >> .gitignore
git add .gitignore
git commit -m "Ignore local config"
```

## Next Steps

Proceed to [Lab 018 - Git Notes](../018-git-notes/README.md) to learn about adding metadata to commits.
