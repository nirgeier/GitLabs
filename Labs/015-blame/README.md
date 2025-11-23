# Lab 015 - Git Blame

---

## Overview

Master `git blame` to track the origin of code lines, understand who changed what and when, and debug issues by finding when specific changes were introduced.

---

## Core Concepts

- **Line Attribution**: See who last modified each line
- **Historical Context**: Understand when and why changes were made
- **Ignore Options**: Filter out formatting changes
- **Copy Detection**: Track code moved between files

## What You'll Learn

- Using git blame to find code origins
- Ignoring whitespace changes
- Following code across file renames
- Detecting copied code
- Understanding blame output
- Blame options and flags

## Demo Script

- Script demonstrates blame with various options

## Usage

```bash
cd Labs/015-blame
./*.sh
```

## Key Commands

```bash
# Basic blame
git blame <file>

# Blame specific lines
git blame -L 10,20 <file>

# Ignore whitespace changes
git blame -w <file>

# Follow copies from same file
git blame -C <file>

# Follow copies from any file
git blame -CCC <file>

# Show email instead of name
git blame -e <file>

# Show commit hash only
git blame -s <file>
```

## Understanding Blame Output

```text
^abc1234 (John Doe 2023-01-15 10:30:00 +0000 1) First line
def5678  (Jane Smith 2023-02-20 14:45:00 +0000 2) Second line
```

Components:
- `abc1234`: Commit hash
- `John Doe`: Author name
- `2023-01-15 10:30:00`: Date and time
- `1`: Line number
- `First line`: Actual content

## Advanced Usage

### Ignore Specific Commits

Create `.git-blame-ignore-revs`:

```text
# Formatting commit
abc1234567890
# Another formatting commit
def1234567890
```

Use it:

```bash
git blame --ignore-revs-file .git-blame-ignore-revs <file>

# Configure globally
git config blame.ignoreRevsFile .git-blame-ignore-revs
```

### Blame with Range

```bash
# Blame specific line range
git blame -L 10,+5 <file>  # 5 lines starting from line 10
git blame -L '/pattern/,+5' <file>  # From pattern match
```

### Follow Renames

```bash
# Follow file across renames
git blame --follow <file>
```

## Use Cases

1. **Bug Investigation**: Find when bug was introduced
2. **Code Review**: Understand code context
3. **Documentation**: Find commit messages explaining changes
4. **Accountability**: Track code ownership
5. **Learning**: Understand codebase evolution

## IDE Integration

Most IDEs support git blame:
- VS Code: GitLens extension
- IntelliJ: Built-in annotations
- Vim: vim-fugitive plugin

## Next Steps

Proceed to [Lab 016 - Clean](../016-clean/README.md) to learn about removing untracked files.
