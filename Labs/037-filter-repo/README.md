# Lab 037 - Git Filter-Repo

---

## Overview

Learn to use `git filter-repo` for powerful repository history rewriting. Modern replacement for `filter-branch`, essential for removing sensitive data, restructuring repositories, and cleaning history.

---

## Core Concepts

- **History Rewriting**: Modify repository history safely
- **Path Filtering**: Remove or relocate files/directories
- **Content Filtering**: Remove sensitive data
- **Repository Cleanup**: Reduce repository size

## What You'll Learn

- Removing files from history
- Extracting subdirectories
- Removing sensitive data
- Path renaming and restructuring
- Repository size reduction

## Demo Script

- `filter-repo.sh` - Demonstrates filter-repo operations

## Usage

```bash
cd Labs/037-filter-repo
./filter-repo.sh
```

## Key Commands

```bash
# Remove file from history
git filter-repo --path file.txt --invert-paths

# Keep only specific paths
git filter-repo --path src/ --path docs/

# Remove by content
git filter-repo --replace-text expressions.txt

# Extract subdirectory as new repo
git filter-repo --path subdir/ --path-rename subdir/:

# Rename paths
git filter-repo --path-rename old/:new/
```

## Installation

```bash
# macOS
brew install git-filter-repo

# pip
pip3 install git-filter-repo

# Manual
wget https://raw.githubusercontent.com/newren/git-filter-repo/main/git-filter-repo
chmod +x git-filter-repo
```

## Common Use Cases

### Remove Sensitive File

```bash
# Remove passwords.txt from all history
git filter-repo --path passwords.txt --invert-paths --force
```

### Extract Subdirectory

```bash
# Extract module as separate repo
git filter-repo --path module/ --path-rename module/: --force
```

### Remove Large Files

```bash
# List large files
git filter-repo --analyze

# Remove specific large files
git filter-repo --path large-file.zip --invert-paths --force
```

### Replace Text

Create `expressions.txt`:
```
PASSWORD123==>***REMOVED***
api_key_abc123==>***REMOVED***
```

```bash
git filter-repo --replace-text expressions.txt --force
```

## Safety Precautions

⚠️ **IMPORTANT**: filter-repo rewrites history

1. **Backup first**: `git clone --mirror original backup`
2. **Fresh clone**: Work on fresh clone
3. **Coordinate team**: All must re-clone
4. **Force push**: Required after filtering

## Workflow

```bash
# 1. Backup
git clone --mirror https://example.com/repo.git backup

# 2. Fresh clone
git clone https://example.com/repo.git repo-clean
cd repo-clean

# 3. Filter
git filter-repo [options] --force

# 4. Verify
git log --all --oneline | head

# 5. Force push (if needed)
git remote add origin https://example.com/repo.git
git push --force --all
git push --force --tags
```

## Analysis Mode

Before filtering, analyze repository:

```bash
git filter-repo --analyze
cd .git/filter-repo/analysis/
ls
# blob-shas-and-paths.txt
# path-all-sizes.txt
# path-deleted-sizes.txt
```

## Best Practices

1. **Always backup** before filtering
2. **Work on fresh clone** not working copy
3. **Test on copy first** before real repo
4. **Document changes** for team
5. **Plan coordination** for force push

## Next Steps

Proceed to [Lab 038 - Maintenance](../038-maintenance/README.md) to learn about Git maintenance tasks.
