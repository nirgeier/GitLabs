# Lab 011 - Git MV

---

## Overview

Understand the difference between using the regular `mv` command and `git mv` for renaming files in Git. Learn how Git tracks file renames and why `git mv` is preferred.

---

## Core Concepts

- **File Tracking**: How Git tracks renames
- **git mv vs mv**: Benefits of using `git mv`
- **Rename Detection**: Git's ability to detect renames
- **Staging Changes**: Automatic staging with `git mv`

## What You'll Learn

- Difference between `mv` and `git mv`
- How Git detects file renames
- Best practices for renaming files
- Impact on Git history
- Rename similarity threshold

## Demo Script

- Script demonstrates both approaches

## Usage

```bash
cd Labs/011-git-mv
./*.sh
```

## Command Comparison

### Using mv (Manual Approach)

```bash
# Move the file
mv oldname.txt newname.txt

# Stage deletion and addition
git add oldname.txt newname.txt
```

### Using git mv (Recommended)

```bash
# Move and stage in one command
git mv oldname.txt newname.txt
```

## What git mv Does

`git mv` is equivalent to:

```bash
mv oldname.txt newname.txt
git rm oldname.txt
git add newname.txt
```

## Rename Detection

Git detects renames based on content similarity:

```bash
# Check rename detection threshold
git config diff.renameLimit

# Set similarity threshold (default is 50%)
git config diff.renames true
```

## Viewing Renames in History

```bash
# Show renames in log
git log --follow <filename>

# Show renames in diff
git diff --find-renames

# Detect copies as well
git diff --find-copies
```

## Benefits of git mv

1. **Single Command**: One operation instead of multiple
2. **Automatic Staging**: Changes are staged immediately
3. **Clear Intent**: Explicitly shows rename operation
4. **Safer**: Less chance of errors
5. **Better History**: Clear rename tracking

## Common Scenarios

### Rename File

```bash
git mv old.txt new.txt
```

### Move to Different Directory

```bash
git mv src/file.txt lib/file.txt
```

### Rename Directory

```bash
git mv old-dir new-dir
```

## Next Steps

Proceed to [Lab 012 - Sparse Checkout](../012-sparse-checkout/README.md) to learn about selective checkout.
