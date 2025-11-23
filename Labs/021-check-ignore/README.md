# Lab 021 - Check Ignore

---

## Overview

Debug and understand `.gitignore` rules using `git check-ignore`. This tool helps you figure out why files are or aren't being ignored.

---

## Core Concepts

- **.gitignore Rules**: Pattern matching for ignored files
- **Debugging**: Find which rule ignores a file
- **Precedence**: Understand ignore rule order
- **Negation**: Exceptions to ignore rules

## What You'll Learn

- Debugging .gitignore rules
- Finding which pattern ignores a file
- Testing ignore patterns
- Understanding ignore precedence
- Troubleshooting ignore issues

## Usage

```bash
cd Labs/021-check-ignore
# Demo files may be available
```

## Key Commands

```bash
# Check if file is ignored
git check-ignore file.txt

# Show which rule ignores the file
git check-ignore -v file.txt

# Check multiple files
git check-ignore file1.txt file2.txt

# Check all files in directory
git check-ignore dir/*

# Read filenames from stdin
find . -type f | git check-ignore --stdin

# Show verbose output for all files
git check-ignore -v --stdin < file-list.txt
```

## Understanding Output

### Simple Check

```bash
$ git check-ignore build/output.jar
build/output.jar
```

**Result**: File IS ignored (exit code 0)

### Verbose Output

```bash
$ git check-ignore -v build/output.jar
.gitignore:5:build/    build/output.jar
```

**Output explains**:
- `.gitignore`: The file containing the rule
- `5`: Line number
- `build/`: The pattern that matched
- `build/output.jar`: The file checked

## Common .gitignore Patterns

```gitignore
# Ignore all .log files
*.log

# Ignore directory
build/

# Ignore files in any node_modules directory
**/node_modules/

# Ignore all .class files except important.class
*.class
!important.class

# Ignore files only in root
/config.local

# Ignore all files in a specific directory
logs/**
```

## Debugging Scenarios

### Why Isn't My File Ignored?

```bash
# Check the file
git check-ignore -v file.txt

# No output? File is NOT ignored
# Check for negation rules or typos in .gitignore
```

### Why Is My File Ignored?

```bash
# Find the rule
git check-ignore -v file.txt
# Output shows which rule and from which file
```

### Check Entire Project

```bash
# Find all ignored files
git ls-files -o -i --exclude-standard | git check-ignore -v --stdin
```

## Ignore Precedence

Git checks ignore rules in this order:

1. Command-line patterns
2. `.gitignore` in same directory
3. `.gitignore` in parent directories (closer = higher priority)
4. `.git/info/exclude`
5. Global exclude file (`core.excludesFile`)

## Testing Patterns

```bash
# Test if pattern would ignore file (without adding to .gitignore)
echo "*.tmp" | git check-ignore --stdin -v test.tmp
```

## Common Issues

### Negation Not Working

```gitignore
# Wrong order - *.log is processed after !important.log
!important.log
*.log

# Correct order
*.log
!important.log
```

### Directory vs Files

```gitignore
# Ignores directory
build/

# Ignores files named 'build'
build

# Ignores both
build
build/
```

### Already Tracked Files

```bash
# .gitignore doesn't affect already-tracked files
# Need to untrack first
git rm --cached file.txt
# Now .gitignore will apply
```

## Useful Aliases

```bash
# Create alias for checking ignored files
git config --global alias.ignored 'ls-files -o -i --exclude-standard'

# Use it
git ignored
```

## Next Steps

Proceed to [Lab 022 - Check Attr](../022-check-attr/README.md) to learn about querying Git attributes.
