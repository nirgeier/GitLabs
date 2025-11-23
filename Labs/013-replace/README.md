# Lab 013 - Git Replace

---

## Overview

Learn how to use `git replace` to substitute one commit with another in your repository's history without actually rewriting history. This is useful for fixing mistakes or testing alternative histories.

---

## Core Concepts

- **Replace Objects**: Create substitute objects in Git
- **Non-Destructive**: Original history remains intact
- **Temporary Changes**: Replace refs can be removed
- **Testing Scenarios**: Try alternative histories

## What You'll Learn

- Creating replace references
- Using replaced commits
- Removing replace references
- Use cases for git replace
- Understanding .git/refs/replace

## Demo Script

- Script demonstrates git replace workflow

## Usage

```bash
cd Labs/013-replace
./*.sh
```

## Key Commands

```bash
# Replace one commit with another
git replace <bad-commit> <good-commit>

# List all replace references
git replace -l

# Delete a replace reference
git replace -d <commit>

# View replaced commit
git log <bad-commit>
```

## How It Works

When you replace a commit:
1. Git creates a ref in `.git/refs/replace/`
2. Commands treat the old commit as if it's the new one
3. Original commit still exists in repository
4. Replace ref can be removed anytime

## Use Cases

### Fix a Mistake in Published History

```bash
# Create a corrected version of a commit
git commit --amend

# Replace the old commit with the new one
git replace <old-commit> <new-commit>
```

### Test Alternative History

```bash
# Try different commit without rewriting history
git replace <original> <alternative>

# If it works, keep it; otherwise remove
git replace -d <original>
```

### Hide Sensitive Information

```bash
# Create cleaned version
# Replace problematic commit
git replace <commit-with-secrets> <cleaned-commit>
```

## Sharing Replace References

Replace refs are local by default:

```bash
# Push replace refs
git push origin 'refs/replace/*'

# Fetch replace refs
git fetch origin 'refs/replace/*:refs/replace/*'
```

## Limitations

- Replace refs are not pushed by default
- All users need to fetch replace refs
- Can be confusing for collaborators
- Not a permanent solution

## When to Use

✅ Testing fixes before force-pushing  
✅ Temporary history modifications  
✅ Local development experiments  
✅ Debugging complex histories  

❌ Long-term history fixes (use rebase/filter-branch)  
❌ Team-wide changes (use proper rewriting)

## Next Steps

Proceed to [Lab 014 - Range Diff](../014-range-diff/README.md) to learn about comparing commit ranges.
