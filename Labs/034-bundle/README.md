# Lab 034 - Git Bundle

---

## Overview

Learn how to create Git bundles to share repositories and branches offline. Bundles package Git objects into a single file for transfer without network access.

---

## Core Concepts

- **Bundle Files**: Single file containing Git objects
- **Offline Transfer**: Share repositories without network
- **Incremental Bundles**: Transfer only new commits
- **Verification**: Ensure bundle integrity

## What You'll Learn

- Creating Git bundles
- Cloning from bundles
- Fetching updates from bundles
- Creating incremental bundles
- Verifying bundle contents

## Demo Script

- `bundle.sh` - Demonstrates creating and using Git bundles

## Usage

```bash
cd Labs/034-bundle
./bundle.sh
```

## Key Commands

```bash
# Create bundle with all refs
git bundle create repo.bundle --all

# Create bundle with specific branch
git bundle create feature.bundle main

# Create bundle with range
git bundle create updates.bundle origin/main..main

# Verify bundle
git bundle verify repo.bundle

# Clone from bundle
git clone repo.bundle new-repo

# Fetch from bundle
git fetch bundle.bundle
```

## Common Use Cases

### Share Repository Offline

```bash
# Create complete bundle
git bundle create project.bundle --all

# Transfer file (USB, email, etc.)

# Clone from bundle
git clone project.bundle project
```

### Incremental Updates

```bash
# First bundle (complete)
git bundle create initial.bundle --all

# Later, create update bundle
git bundle create update.bundle HEAD~10..HEAD

# Apply update
git fetch update.bundle main:main
```

### Backup Repository

```bash
# Create timestamped backup
git bundle create backup-$(date +%Y%m%d).bundle --all

# Verify backup
git bundle verify backup-20231123.bundle
```

## Bundle Types

**Complete Bundle**: All history
```bash
git bundle create complete.bundle --all
```

**Branch Bundle**: Specific branch
```bash
git bundle create feature.bundle feature-branch
```

**Range Bundle**: Commit range
```bash
git bundle create updates.bundle HEAD~5..HEAD
```

## Best Practices

1. **Verify bundles** after creation
2. **Use descriptive names** with dates
3. **Document bundle contents**
4. **Test bundles** before distributing
5. **Include tags** when relevant

## Next Steps

Proceed to [Lab 035 - Archive](../035-archive/README.md) to learn about Git archive.
