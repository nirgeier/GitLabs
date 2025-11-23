# Lab 005 - Git Subtree

---

## Overview

Learn how to use `git subtree split` to extract a subdirectory from your repository and create a new repository from it while preserving commit history.

---

## Core Concepts

- **Subtree Split**: Extract directories into separate repositories
- **History Preservation**: Maintain commit history during splits
- **Monorepo to Multi-repo**: Split monolithic repositories
- **Directory Filtering**: Isolate specific paths

## What You'll Learn

- Splitting subdirectories into new repositories
- Preserving commit history during splits
- Creating independent repositories from subdirectories
- Managing repository restructuring

## Demo Script

- `subtree-split.sh` - Demonstrates subtree split workflow

## Usage

```bash
cd Labs/005-subtree
./subtree-split.sh
```

## Key Commands

```bash
# Split a subdirectory into a new branch
git subtree split --prefix=<directory> -b <new-branch>

# Push the split branch to a new repository
git push <new-remote> <new-branch>:main

# Add a subtree from another repository
git subtree add --prefix=<directory> <remote> <branch>
```

## Use Cases

- Extracting client/server code into separate repos
- Creating library packages from monorepos
- Splitting frontend/backend codebases
- Repository reorganization and refactoring

## Subtree vs Submodule

- Subtree: Integrates external code into your repository
- Submodule: References external repository
- Subtree: Simpler for contributors
- Submodule: Better for separate development

## Next Steps

Proceed to [Lab 006 - Hooks](../006-hooks/README.md) to learn about Git hooks.
