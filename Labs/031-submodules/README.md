# Lab 031 - Git Submodules

---

## Overview

Learn how to manage Git submodules to include external repositories as dependencies in your project. Submodules allow you to keep a Git repository as a subdirectory of another Git repository.

---

## Core Concepts

- **Submodules**: Git repositories nested inside another repository
- **References**: Specific commits from external repos
- **Independence**: Submodules maintain their own history
- **Synchronization**: Managing submodule updates

## What You'll Learn

- Adding and initializing submodules
- Cloning repositories with submodules
- Updating submodules
- Working with submodule branches
- Removing submodules
- Best practices and alternatives

## Usage

```bash
cd Labs/031-submodules
# Demo files may be available
```

## Basic Operations

### Add Submodule

```bash
# Add submodule
git submodule add https://github.com/user/repo.git path/to/submodule

# Add with specific branch
git submodule add -b main https://github.com/user/repo.git libs/repo

# Commit the changes
git commit -m "Add submodule"
```

### Clone Repository with Submodules

```bash
# Clone and initialize submodules
git clone --recursive https://github.com/user/repo.git

# Or after cloning
git clone https://github.com/user/repo.git
cd repo
git submodule init
git submodule update
```

### Initialize and Update

```bash
# Initialize submodules
git submodule init

# Update to commits specified in superproject
git submodule update

# Or combined
git submodule update --init

# Include nested submodules
git submodule update --init --recursive
```

## Working with Submodules

### Update Submodule to Latest

```bash
# Enter submodule
cd path/to/submodule

# Pull latest changes
git checkout main
git pull origin main

# Return to parent
cd ../..

# Commit updated submodule reference
git add path/to/submodule
git commit -m "Update submodule to latest"
```

### Update All Submodules

```bash
# Update all submodules to their latest commit
git submodule update --remote

# Update to specific branch
git submodule update --remote --merge

# Update recursively
git submodule update --remote --recursive
```

### Make Changes in Submodule

```bash
# Enter submodule
cd path/to/submodule

# Create branch and make changes
git checkout -b feature-branch
# ... make changes ...
git commit -am "Add feature"

# Push to submodule remote
git push origin feature-branch

# Return to parent
cd ../..

# Commit new submodule commit reference
git add path/to/submodule
git commit -m "Update submodule with new feature"
```

## Submodule Configuration

### .gitmodules File

```ini
[submodule "libs/mylib"]
    path = libs/mylib
    url = https://github.com/user/mylib.git
    branch = main
    update = merge
```

### Submodule Branch Tracking

```bash
# Set branch to track
git config -f .gitmodules submodule.path/to/submodule.branch main

# Update to track branch
git submodule update --remote
```

## Advanced Operations

### List Submodules

```bash
# List all submodules
git submodule status

# Show recursive submodules
git submodule status --recursive

# Detailed info
git config --file .gitmodules --get-regexp path
```

### Execute Command in All Submodules

```bash
# Run command in each submodule
git submodule foreach 'git pull origin main'

# Recursive
git submodule foreach --recursive 'git checkout main'

# Custom script
git submodule foreach 'echo "Processing $name at $path"'
```

### Remove Submodule

```bash
# 1. Deinitialize submodule
git submodule deinit -f path/to/submodule

# 2. Remove from .git/modules
rm -rf .git/modules/path/to/submodule

# 3. Remove from working tree
git rm -f path/to/submodule

# 4. Commit changes
git commit -m "Remove submodule"
```

## Common Workflows

### Initial Setup for New Team Member

```bash
# Clone repository
git clone https://github.com/team/project.git
cd project

# Initialize and update all submodules
git submodule update --init --recursive
```

### Keep Submodules Updated

```bash
# Pull parent repo changes
git pull

# Update submodules to referenced commits
git submodule update --recursive

# Or in one command
git pull --recurse-submodules
```

### Update Submodule to Specific Version

```bash
# Enter submodule
cd path/to/submodule

# Checkout specific commit/tag
git checkout v1.2.3

# Return and commit
cd ../..
git add path/to/submodule
git commit -m "Update submodule to v1.2.3"
```

## Automation

### Automatic Submodule Updates

```bash
# Always pull submodule updates
git config --global submodule.recurse true

# Automatically update on pull
git config --global pull.rebase true
git config --global submodule.recurse true
```

### Git Aliases

```bash
# Update all submodules
git config --global alias.supdate 'submodule update --remote --merge'

# Clone with submodules
git config --global alias.sclone 'clone --recursive'

# Pull with submodules
git config --global alias.spull 'pull --recurse-submodules'
```

## Troubleshooting

### Detached HEAD in Submodule

```bash
# Submodules checkout specific commits (detached HEAD)
# This is normal behavior

# To work on a branch
cd path/to/submodule
git checkout main
```

### Submodule Not Initialized

```bash
# Error: Submodule not initialized
git submodule update --init path/to/submodule
```

### Merge Conflicts in Submodules

```bash
# After merge conflict in .gitmodules
# 1. Resolve conflict
# 2. Update submodule
git submodule sync
git submodule update --init --recursive
```

## Best Practices

### DO:

- **Document submodules** in README
- **Pin to specific commits/tags** for stability
- **Update regularly** but deliberately
- **Test after updates** before committing
- **Use shallow clones** for large submodules

### DON'T:

- **Forget to push submodule changes** before parent
- **Modify submodules** without proper branch
- **Use for frequently changing code**
- **Nest submodules** excessively

## Alternatives to Submodules

### Git Subtree

```bash
# More integrated than submodules
git subtree add --prefix=libs/mylib https://github.com/user/mylib.git main
```

### Package Managers

- **npm/yarn**: For JavaScript projects
- **pip**: For Python projects
- **maven/gradle**: For Java projects
- **go modules**: For Go projects

### Monorepo

- Single repository for all code
- Simpler dependency management
- Tools: Nx, Turborepo, Bazel

## Shallow Submodules

```bash
# Add shallow submodule (faster cloning)
git submodule add --depth 1 https://github.com/user/repo.git path/to/repo

# Clone with shallow submodules
git clone --recursive --shallow-submodules https://github.com/user/project.git
```

## Next Steps

Proceed to [Lab 032 - Rerere](../032-rerere/README.md) to learn about reusing recorded resolutions.
