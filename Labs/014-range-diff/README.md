# Lab 014 - Range Diff

---

## Overview

Learn how to use `git range-diff` to compare two ranges of commits. This is especially useful when comparing different versions of the same patch series, such as before and after a rebase.

---

## Core Concepts

- **Range Comparison**: Compare two commit ranges
- **Rebase Review**: See changes after rebasing
- **Patch Evolution**: Track how commits changed
- **Commit Correspondence**: Match similar commits

## What You'll Learn

- Using git range-diff effectively
- Comparing commit ranges before and after operations
- Understanding range-diff output
- Reviewing rebased changes
- Detecting commit modifications

## Demo Script

- Script demonstrates range-diff with rebase scenario

## Usage

```bash
cd Labs/014-range-diff
./*.sh
```

## Key Commands

```bash
# Compare two ranges
git range-diff <base>..<old-tip> <base>..<new-tip>

# Compare with triple-dot syntax
git range-diff <old-base>...<old-tip> <new-base>...<new-tip>

# Simplified format
git range-diff <old-tip>~3..<old-tip> <new-tip>~3..<new-tip>
```

## Common Use Cases

### After Rebase

```bash
# Store original tip
git branch backup

# Perform rebase
git rebase main

# Compare original vs rebased
git range-diff backup~3..backup HEAD~3..HEAD
```

### Before Force Push

```bash
# Compare local vs remote branch
git range-diff origin/feature...feature^
```

### Review Patch Series Updates

```bash
# Compare v1 vs v2 of patch series
git range-diff v1-tag..v1-final v2-tag..v2-final
```

## Understanding the Output

```text
1:  abc1234 = 1:  def5678 First commit
2:  abc2345 ! 2:  def6789 Second commit
    @@ file.txt
    -old line
    +new line
3:  abc3456 < -:  ------- Removed commit
-:  ------- > 3:  def7890 Added commit
```

Symbols:
- `=`: Commits are identical
- `!`: Commits differ
- `<`: Commit removed
- `>`: Commit added

## Benefits

1. **Track Changes**: See how commits evolved
2. **Review Rebases**: Ensure rebase didn't break anything
3. **Compare Versions**: Compare patch series versions
4. **Spot Issues**: Find unintended changes
5. **Team Review**: Better code review for rebased branches

## Next Steps

Proceed to [Lab 015 - Blame](../015-blame/README.md) to learn about tracking code origins.
