# Lab 003 - Multiple Remotes

---

## Overview

Learn how to work with multiple Git remotes, fetch from different sources, and cherry-pick commits between remotes. This is essential for contributing to open-source projects or maintaining forks.

---

## Core Concepts

- **Multiple Remotes**: Configure and manage multiple remote repositories
- **Fetching**: Retrieve changes from different remotes
- **Cherry-picking**: Select specific commits from other remotes
- **Remote Tracking**: Understand remote-tracking branches

## What You'll Learn

- Adding and managing multiple remotes
- Fetching from specific remotes
- Cherry-picking commits between remotes
- Viewing and comparing remote branches

## Demo Script

- `multipleRemotes.sh` - Complete demonstration of multiple remotes workflow

## Usage

```bash
cd Labs/003-multiple-remotes
./multipleRemotes.sh
```

## Key Commands

```bash
# Add a remote
git remote add <name> <url>

# List all remotes
git remote -v

# Fetch from specific remote
git fetch <remote-name>

# Cherry-pick from remote branch
git cherry-pick <remote>/<branch>~<n>
```

## Use Cases

- Contributing to forked repositories
- Syncing with upstream projects
- Managing internal and external remotes
- Working with mirror repositories

## Next Steps

Proceed to [Lab 004 - Bisect](../004-bisect/README.md) to learn about finding bug-introducing commits.
