# Lab 039 - Git LFS (Large File Storage)

---

## Overview

Master Git LFS for managing large files in repositories. Learn how to track binary files, media assets, and large datasets efficiently without bloating repository size.

---

## Core Concepts

- **Pointer Files**: Small text pointers instead of large files
- **Separate Storage**: Large files stored externally
- **On-Demand Download**: Fetch large files only when needed
- **Bandwidth Optimization**: Reduce clone and fetch times

## What You'll Learn

- Installing and configuring Git LFS
- Tracking large files
- Migrating existing files to LFS
- Managing LFS objects
- LFS with remote repositories

## Demo Script

- `lfs.sh` - Demonstrates Git LFS operations

## Usage

```bash
cd Labs/039-lfs
./lfs.sh
```

## Key Commands

```bash
# Install LFS in repository
git lfs install

# Track file patterns
git lfs track "*.psd"
git lfs track "*.zip"

# List tracked patterns
git lfs track

# List LFS files
git lfs ls-files

# Fetch LFS objects
git lfs fetch

# Pull LFS objects
git lfs pull

# Migrate existing files
git lfs migrate import --include="*.mp4"

# Show LFS file info
git lfs ls-files --size
```

## Installation

```bash
# macOS
brew install git-lfs

# Ubuntu/Debian
sudo apt install git-lfs

# Initialize for user
git lfs install

# Initialize for repository
git lfs install --local
```

## Tracking Files

```bash
# Track specific extensions
git lfs track "*.psd"
git lfs track "*.ai"
git lfs track "*.mp4"

# Track specific files
git lfs track "large-dataset.csv"

# Track directory
git lfs track "assets/**"

# Updates .gitattributes
git add .gitattributes
git commit -m "Configure LFS tracking"
```

## Common Patterns

**Media Files**:
```bash
git lfs track "*.png"
git lfs track "*.jpg"
git lfs track "*.mp4"
git lfs track "*.mov"
```

**Design Files**:
```bash
git lfs track "*.psd"
git lfs track "*.ai"
git lfs track "*.sketch"
```

**Archives**:
```bash
git lfs track "*.zip"
git lfs track "*.tar.gz"
```

**Data Files**:
```bash
git lfs track "*.csv"
git lfs track "*.parquet"
```

## Migrating Existing Files

```bash
# Migrate specific files to LFS
git lfs migrate import --include="*.zip"

# Migrate and rewrite history
git lfs migrate import --include="*.mp4" --everything

# Include specific refs
git lfs migrate import --include="*.psd" --include-ref=main
```

## LFS Management

### Check Status

```bash
# List LFS files
git lfs ls-files

# Show file sizes
git lfs ls-files --size

# Show LFS environment
git lfs env
```

### Fetch/Pull

```bash
# Fetch LFS objects for current ref
git lfs fetch

# Fetch for specific ref
git lfs fetch origin main

# Pull (fetch + checkout)
git lfs pull
```

### Prune Old LFS Objects

```bash
# Remove old LFS files
git lfs prune

# Verify first
git lfs prune --dry-run

# Prune but keep recent
git lfs prune --verify-remote
```

## .gitattributes Example

```
# Graphics
*.png filter=lfs diff=lfs merge=lfs -text
*.jpg filter=lfs diff=lfs merge=lfs -text
*.psd filter=lfs diff=lfs merge=lfs -text

# Videos
*.mp4 filter=lfs diff=lfs merge=lfs -text
*.mov filter=lfs diff=lfs merge=lfs -text

# Archives
*.zip filter=lfs diff=lfs merge=lfs -text
*.tar.gz filter=lfs diff=lfs merge=lfs -text
```

## Best Practices

1. **Track early** - Set up LFS before adding large files
2. **Be specific** - Track only necessary large files
3. **Document patterns** - Note what's tracked in README
4. **Test clones** - Verify LFS works for new clones
5. **Monitor storage** - Track LFS bandwidth and storage limits
6. **Use .gitattributes** - Commit tracking configuration

## LFS Hosting

**GitHub**: Free tier includes 1GB storage, 1GB/month bandwidth

**GitLab**: Free tier includes 10GB storage

**Bitbucket**: 1GB storage, 1GB/month bandwidth

**Self-hosted**: Run your own LFS server

## Next Steps

Proceed to [Lab 040 - Partial Clone](../040-partial-clone/README.md) to learn about Git partial clones.
