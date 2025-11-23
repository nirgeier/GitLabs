# Lab 035 - Git Archive

---

## Overview

Learn how to use `git archive` to create compressed snapshots of your repository at specific points in time. Perfect for releases, deployments, and distributions.

---

## Core Concepts

- **Archive Creation**: Export repository snapshots
- **Format Support**: tar, zip, and custom formats
- **Path Filtering**: Include/exclude specific files
- **No .git Directory**: Clean exports without version control

## What You'll Learn

- Creating tar and zip archives
- Archiving specific commits or tags
- Filtering paths in archives
- Using archive with remote repositories
- Custom archive attributes

## Demo Script

- `archive.sh` - Demonstrates various archive operations

## Usage

```bash
cd Labs/035-archive
./archive.sh
```

## Key Commands

```bash
# Create tar archive
git archive --format=tar HEAD > repo.tar

# Create gzipped tar
git archive --format=tar HEAD | gzip > repo.tar.gz

# Create zip archive
git archive --format=zip HEAD > repo.zip

# Archive specific tag
git archive --format=tar v1.0.0 > release-v1.0.0.tar

# Archive with prefix
git archive --prefix=project/ HEAD | gzip > project.tar.gz

# Archive specific path
git archive HEAD src/ > src.tar
```

## Common Use Cases

### Create Release Archive

```bash
# Tag release
git tag -a v1.2.0 -m "Release 1.2.0"

# Create release archive
git archive --format=tar.gz --prefix=myproject-1.2.0/ v1.2.0 > myproject-1.2.0.tar.gz
```

### Export Without .git

```bash
# Clean export for deployment
git archive --format=zip HEAD > deploy.zip
```

### Archive Subdirectory

```bash
# Export only docs folder
git archive --format=tar HEAD:docs/ | gzip > docs.tar.gz
```

## Archive Formats

**TAR**: Unix standard
```bash
git archive --format=tar HEAD > repo.tar
```

**ZIP**: Cross-platform
```bash
git archive --format=zip HEAD > repo.zip
```

**Compressed TAR**: Space-efficient
```bash
git archive HEAD | gzip > repo.tar.gz
git archive HEAD | bzip2 > repo.tar.bz2
```

## .gitattributes Integration

Control what's included in archives:

```gitattributes
# Don't include in archives
.gitignore export-ignore
.gitattributes export-ignore
tests/ export-ignore
*.test.js export-ignore
```

## Best Practices

1. **Use tags** for versioned archives
2. **Add prefix** for extraction organization
3. **Exclude unnecessary files** via gitattributes
4. **Include version** in filename
5. **Document archive contents**

## Next Steps

Proceed to [Lab 036 - Cherry Pick](../036-cherry-pick/README.md) to learn about selective commit application.
