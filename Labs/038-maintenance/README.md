# Lab 038 - Git Maintenance

---

## Overview

Learn Git maintenance commands to keep repositories healthy, fast, and optimized. Essential for long-running repositories and server administrators.

---

## Core Concepts

- **Garbage Collection**: Remove unreachable objects
- **Object Packing**: Optimize storage
- **Reference Packing**: Compress references
- **Pruning**: Remove old objects
- **Verification**: Check repository integrity

## What You'll Learn

- Running git gc (garbage collection)
- Using git maintenance tasks
- Pruning unreachable objects
- Verifying repository integrity
- Optimizing repository performance

## Demo Script

- `maintenance.sh` - Demonstrates maintenance operations

## Usage

```bash
cd Labs/038-maintenance
./maintenance.sh
```

## Key Commands

```bash
# Run garbage collection
git gc

# Aggressive garbage collection
git gc --aggressive --prune=now

# Auto garbage collection
git gc --auto

# Run maintenance tasks
git maintenance run

# Enable background maintenance
git maintenance start

# Verify repository
git fsck

# Prune unreachable objects
git prune

# Count objects
git count-objects -v
```

## Maintenance Tasks

### Manual GC

```bash
# Basic garbage collection
git gc

# Aggressive (slower, better compression)
git gc --aggressive

# Immediate pruning
git gc --prune=now
```

### Scheduled Maintenance

```bash
# Start background maintenance
git maintenance start

# Stop background maintenance
git maintenance stop

# Run specific task
git maintenance run --task=gc
```

### Available Tasks

- **gc**: Garbage collection and packing
- **commit-graph**: Optimize commit access
- **prefetch**: Update remote refs
- **loose-objects**: Consolidate loose objects
- **incremental-repack**: Pack objects incrementally

## Repository Health

### Check Size

```bash
# Count objects
git count-objects -v

# Show largest objects
git verify-pack -v .git/objects/pack/*.idx | \
  sort -k 3 -n | tail -10
```

### Verify Integrity

```bash
# Full verification
git fsck --full

# Unreachable objects
git fsck --unreachable

# Dangling objects
git fsck --lost-found
```

### Prune Old Objects

```bash
# Prune older than 2 weeks (default)
git prune

# Prune everything unreachable
git prune --expire=now

# Dry run first
git prune --dry-run
```

## Repository Optimization

### Repack Objects

```bash
# Create new pack
git repack

# Repack all objects
git repack -a

# Aggressive repacking
git repack -a -d --depth=250 --window=250
```

### Pack References

```bash
# Pack loose references
git pack-refs --all

# Include pruning
git pack-refs --all --prune
```

## Best Practices

1. **Run gc regularly** on active repositories
2. **Use --auto** for automatic optimization
3. **Enable maintenance** for large repos
4. **Verify before migration** or backup
5. **Schedule maintenance** during low usage
6. **Monitor repository size**

## When to Run Maintenance

- **After large operations** (import, filter-repo)
- **Regular schedule** (weekly/monthly)
- **Before backups**
- **After ref updates** (many branches/tags deleted)
- **Repository performance** degrades

## Next Steps

Proceed to [Lab 039 - Git LFS](../039-lfs/README.md) to learn about Git Large File Storage.
