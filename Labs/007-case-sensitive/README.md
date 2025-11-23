# Lab 007 - Case Sensitive

---

## Overview

Understand how Git handles case sensitivity in file names across different operating systems. Learn about `core.ignorecase` and how file renames behave when only case changes.

---

## Core Concepts

- **Case Sensitivity**: Git vs filesystem behavior
- **core.ignorecase**: Configuration setting for case handling
- **File Renames**: Special handling for case-only changes
- **Cross-platform Issues**: Windows, macOS, Linux differences

## What You'll Learn

- How Git handles case-sensitive vs case-insensitive filesystems
- Setting and effects of `core.ignorecase`
- Renaming files with case-only changes
- Avoiding case sensitivity pitfalls

## Demo Script

- Script demonstrates case sensitivity behavior

## Usage

```bash
cd Labs/007-case-sensitive
./*.sh
```

## Key Concepts

### core.ignorecase

```bash
# Check current setting
git config core.ignorecase

# Set to true (case-insensitive)
git config core.ignorecase true

# Set to false (case-sensitive)
git config core.ignorecase false
```

### Renaming Files (Case Only)

```bash
# Wrong way (may not work)
mv file.txt File.txt
git add File.txt

# Right way
git mv file.txt File.txt
```

## Platform Behavior

- **Linux**: Case-sensitive filesystem
- **macOS**: Case-insensitive by default (but can be case-sensitive)
- **Windows**: Case-insensitive

## Next Steps

Proceed to [Lab 008 - Tags](../008-tags/README.md) to learn about Git tagging.
