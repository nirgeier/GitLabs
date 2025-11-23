# Lab 016 - Git Clean

---

## Overview

Learn how to use `git clean` to remove untracked and ignored files from your working directory. This is essential for maintaining a clean workspace and removing build artifacts.

---

## Core Concepts

- **Untracked Files**: Files not in Git's index
- **Ignored Files**: Files matched by .gitignore
- **Dry Run**: Preview what will be deleted
- **Force Flag**: Safety requirement for deletion
- **Interactive Mode**: Selective cleaning

## What You'll Learn

- Removing untracked files safely
- Using dry-run to preview deletions
- Cleaning directories
- Including ignored files
- Interactive cleaning mode
- Force clean operations

## Demo Script

- Script demonstrates various clean options

## Usage

```bash
cd Labs/016-clean
./*.sh
```

## Key Commands

```bash
# Dry run (preview what will be deleted)
git clean -n

# Remove untracked files (requires -f)
git clean -f

# Remove untracked files and directories
git clean -fd

# Remove ignored files too
git clean -fX

# Remove all untracked and ignored files
git clean -fdx

# Interactive mode
git clean -i
```

## Safety First: Dry Run

**Always use `-n` first:**

```bash
# See what would be deleted
git clean -n

# If OK, then clean
git clean -f
```

## Common Scenarios

### Clean Build Artifacts

```bash
# Remove ignored files (build outputs)
git clean -fX
```

### Reset to Clean State

```bash
# Remove all untracked files and directories
git clean -fd

# Also reset tracked files
git reset --hard
git clean -fd
```

### Clean Specific Directory

```bash
# Clean only specific path
git clean -fd path/to/dir
```

## Interactive Mode

```bash
git clean -i
```

Options:
- `clean`: Delete selected files
- `filter`: Filter files by pattern
- `select by numbers`: Choose specific files
- `ask each`: Confirm each file
- `quit`: Exit without cleaning
- `help`: Show help

## Clean Flags Explained

| Flag | Description |
|------|-------------|
| `-n` | Dry run (show what would be deleted) |
| `-f` | Force (required to actually delete) |
| `-d` | Remove directories |
| `-x` | Remove ignored files |
| `-X` | Remove only ignored files |
| `-i` | Interactive mode |
| `-e <pattern>` | Exclude pattern |

## Exclude Patterns

```bash
# Clean but keep .env files
git clean -fd -e "*.env"

# Multiple exclusions
git clean -fd -e "*.env" -e "*.log"
```

## Configuration

```bash
# Require force for clean (default)
git config clean.requireForce true

# Don't require force (dangerous!)
git config clean.requireForce false
```

## ⚠️ Warning

`git clean` is destructive and **cannot be undone**. Deleted files are not in Git history and cannot be recovered.

**Best Practices:**
1. Always dry-run first (`-n`)
2. Use interactive mode when unsure
3. Commit or stash changes before cleaning
4. Use exclusion patterns for important files

## Next Steps

Proceed to [Lab 017 - Assume Unchanged](../017-assume-unchaged/README.md) to learn about ignoring tracked files.
