# Lab 004 - Git Bisect

---

## Overview

Use Git bisect to perform binary search through commit history to identify the commit that introduced a bug. This powerful debugging tool can save hours of manual searching.

---

## Core Concepts

- **Binary Search**: Efficiently find bug-introducing commits
- **Good/Bad Commits**: Mark commits as working or broken
- **Automated Testing**: Combine bisect with test scripts
- **Bisect Workflow**: Navigate through commit history systematically

## What You'll Learn

- How to start and run git bisect
- Marking commits as good or bad
- Automating bisect with test scripts
- Understanding bisect's binary search algorithm

## Demo Script

- `bisect.sh` - Creates a repository and demonstrates bisect workflow

## Visual Aid

- `binarySearch.png` - Visual representation of binary search algorithm

## Usage

```bash
cd Labs/004-bisect
./bisect.sh
```

## Key Commands

```bash
# Start bisect
git bisect start

# Mark current commit as bad
git bisect bad

# Mark a good commit (known working state)
git bisect good <commit-hash>

# Let Git find the commit automatically with a test script
git bisect run <test-script>

# Reset bisect
git bisect reset
```

## When to Use Bisect

- Finding when a bug was introduced
- Identifying performance regressions
- Tracking down breaking changes
- Debugging mysterious failures

## Next Steps

Proceed to [Lab 005 - Subtree](../005-subtree/README.md) to learn about Git subtree operations.
