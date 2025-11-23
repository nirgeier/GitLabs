# Lab 023 - Assume Unchanged (Advanced)

---

## Overview

Advanced usage of the `assume-unchanged` flag, including bulk operations, scripting, and integration with development workflows.

---

## Core Concepts

- **Bulk Operations**: Managing multiple files
- **Scripting**: Automating assume-unchanged workflows
- **Team Workflows**: Using assume-unchanged in teams
- **Recovery**: Handling edge cases

## What You'll Learn

- Advanced assume-unchanged techniques
- Bulk file management
- Script integration
- Best practices for teams
- Troubleshooting common issues

## Demo Script

- Script demonstrates advanced usage

## Usage

```bash
cd Labs/023-assume-unchaged
./*.sh
```

## Bulk Operations

### Mark Multiple Files

```bash
# Mark all config files
find config -name "*.local" | xargs git update-index --assume-unchanged

# Mark by pattern
git ls-files | grep "\.env$" | xargs git update-index --assume-unchanged
```

### Unmark All

```bash
# List and unmark all assume-unchanged files
git ls-files -v | grep '^h' | cut -c 3- | xargs git update-index --no-assume-unchanged
```

## Helper Scripts

### Mark Script

```bash
#!/bin/bash
# mark-assumed.sh

for file in "$@"; do
    git update-index --assume-unchanged "$file"
    echo "Marked as assume-unchanged: $file"
done
```

### Unmark Script

```bash
#!/bin/bash
# unmark-assumed.sh

git ls-files -v | grep '^h' | cut -c 3- | while read file; do
    git update-index --no-assume-unchanged "$file"
    echo "Unmarked: $file"
done
```

## Git Aliases

```bash
# List assumed files
git config --global alias.assumed '!git ls-files -v | grep "^h" | cut -c 3-'

# Mark file as assumed
git config --global alias.assume 'update-index --assume-unchanged'

# Unmark file
git config --global alias.unassume 'update-index --no-assume-unchanged'

# Unmark all
git config --global alias.unassume-all '!git assumed | xargs git update-index --no-assume-unchanged'
```

Usage:

```bash
git assume config/local.yml
git assumed
git unassume config/local.yml
git unassume-all
```

## Team Workflows

### Document Assumed Files

```bash
# Create .assumed-files list
cat > .assumed-files << 'EOF'
config/database.local.yml
config/secrets.local.yml
.env.local
EOF

# Team members can run
cat .assumed-files | xargs git update-index --assume-unchanged
```

### Post-Checkout Hook

```bash
#!/bin/sh
# .git/hooks/post-checkout

# Auto-mark files after checkout
if [ -f .assumed-files ]; then
    cat .assumed-files | xargs git update-index --assume-unchanged 2>/dev/null
fi
```

## Handling Updates

### Before Pull/Merge

```bash
# Unmark all before pulling
git unassume-all
git pull
# Remark after pull
cat .assumed-files | xargs git assume
```

### Check Before Commit

```bash
# List assumed files before committing
echo "Assumed unchanged files:"
git assumed
echo ""
echo "Proceed with commit? (y/n)"
```

## Debugging Issues

### File Still Shows as Modified

```bash
# Check status
git ls-files -v <file>

# If shows 'h', it's marked
# Clear and restart
git update-index --no-assume-unchanged <file>
git checkout -- <file>
git update-index --assume-unchanged <file>
```

### After Merge Conflicts

```bash
# Assume-unchanged may be cleared
# Check and re-mark
git check-attr -a <file>
cat .assumed-files | xargs git assume
```

## Comparison with Skip-Worktree

```bash
# Set skip-worktree (better for local modifications)
git update-index --skip-worktree <file>

# List skip-worktree files
git ls-files -v | grep '^S'

# Unset skip-worktree
git update-index --no-skip-worktree <file>
```

## When to Use Each

**Assume-Unchanged:**
- Performance optimization
- Large repositories
- Files that truly don't change

**Skip-Worktree:**
- Local configuration
- Files you actively modify
- Persistent local changes

## Next Steps

Proceed to [Lab 024 - Check Ignore](../024-check-ignore/README.md) for additional .gitignore debugging techniques.
