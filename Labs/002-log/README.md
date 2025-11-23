# Lab 002 - Git Log

---

## Overview

Master Git's powerful log command to track changes, find deleted files, and explore commit history with various formatting options.

---

## Core Concepts

- **Git Log Options**: Customize log output with various flags
- **Finding Deleted Files**: Track down when and where files were deleted
- **Commit History**: Navigate and search through project history
- **Log Formatting**: Create custom log formats

## What You'll Learn

- How to find deleted files in Git history
- Advanced `git log` options and formatting
- Searching commit history effectively
- Filtering commits by author, date, and content

## Demo Scripts

- `00-find_deleted_file.sh` - Demonstrates finding deleted files in history
- `01-print-list-of-files.sh` - Lists files in commits

## Usage

```bash
cd Labs/002-log
./00-find_deleted_file.sh
./01-print-list-of-files.sh
```

## Key Commands

```bash
# Find when a file was deleted
git log --all --full-history -- <file_path>

# Custom log format
git log --pretty=format:"%h - %an, %ar : %s"

# Show files changed
git log --stat

# Search commits
git log --grep="search term"
```

## Next Steps

Proceed to [Lab 003 - Multiple Remotes](../003-multiple-remotes/README.md) to learn about working with multiple Git remotes.
