# Lab 022 - Check Attr

---

## Overview

Learn how to use `git check-attr` to query Git attributes set in `.gitattributes` files. Attributes control how Git handles files for operations like diff, merge, and text conversion.

---

## Core Concepts

- **.gitattributes**: File for setting path-specific attributes
- **Attributes**: Settings that affect Git operations
- **Query Attributes**: Check what attributes apply to files
- **Built-in Attributes**: text, binary, diff, merge, filter

## What You'll Learn

- Querying Git attributes
- Understanding .gitattributes
- Common attribute use cases
- Debugging attribute application
- Custom attributes

## Demo Script

- Script demonstrates check-attr usage

## Usage

```bash
cd Labs/022-check-attr
./*.sh
```

## Key Commands

```bash
# Check specific attribute
git check-attr diff file.txt

# Check multiple attributes
git check-attr diff merge file.txt

# Check all attributes
git check-attr -a file.txt

# Check for multiple files
git check-attr diff *.txt

# Check with pattern
git check-attr --stdin diff < file-list.txt
```

## Understanding Output

```bash
$ git check-attr diff README.md
README.md: diff: markdown
```

Format: `<file>: <attribute>: <value>`

Values:
- `set`: Attribute is set (true)
- `unset`: Attribute is explicitly unset
- `unspecified`: No value set
- `<value>`: Custom value

## Common Attributes

### Text Handling

```gitattributes
# Treat as text
*.txt text

# Treat as binary
*.png binary

# Auto-detect
* text=auto
```

### Line Endings

```gitattributes
# Convert to LF on checkin, CRLF on checkout (Windows)
*.txt text eol=crlf

# Always LF
*.sh text eol=lf

# Don't convert
*.bin -text
```

### Diff Drivers

```gitattributes
# Use markdown diff driver
*.md diff=markdown

# Don't diff images
*.png -diff

# Custom diff driver
*.json diff=json
```

### Merge Strategies

```gitattributes
# Use ours strategy for merges
database.config merge=ours

# Don't merge generated files
package-lock.json -merge
```

### Filters

```gitattributes
# Apply filter (e.g., smudge/clean)
*.secret filter=encrypt
```

## Checking Attributes

### For Specific File

```bash
# Check text attribute
git check-attr text README.md

# Check if binary
git check-attr binary image.png

# Check diff driver
git check-attr diff file.md
```

### For Multiple Files

```bash
# Check all markdown files
git check-attr diff *.md

# Check specific attribute for all files
git ls-files | git check-attr --stdin diff
```

### All Attributes

```bash
# Show all attributes for file
git check-attr -a README.md

# Output
README.md: diff: markdown
README.md: merge: union
README.md: text: set
```

## .gitattributes Examples

### Comprehensive Example

```gitattributes
# Auto-detect text files and normalize line endings
* text=auto

# Declare text files
*.txt text
*.md text
*.yaml text

# Binary files
*.png binary
*.jpg binary
*.pdf binary

# Diff drivers
*.md diff=markdown
*.json diff=json
*.ipynb diff=ipynb

# Merge strategies
*.lock merge=union
*.generated -merge

# Line endings
*.sh text eol=lf
*.bat text eol=crlf

# Filters
*.secret filter=secret-filter

# Export ignore (don't include in archives)
.gitignore export-ignore
.gitattributes export-ignore
```

## Custom Attributes

You can define custom attributes:

```gitattributes
# Custom attribute
*.config configfile

# Check it
git check-attr configfile app.config
# Output: app.config: configfile: set
```

## Debugging

### Why isn't my attribute working?

```bash
# Check what Git sees
git check-attr -a problematic-file.txt

# Verify .gitattributes is tracked
git ls-files .gitattributes
```

### Pattern Testing

```bash
# Test pattern without modifying .gitattributes
echo "*.tmp text" | git check-attr --stdin -a test.tmp
```

## Precedence

Git reads attributes from:

1. `.gitattributes` in same directory
2. `.gitattributes` in parent directories
3. `.git/info/attributes`
4. Global attributes file

Higher precedence = closer to file

## Next Steps

Proceed to [Lab 023 - Assume Unchanged](../023-assume-unchaged/README.md) for more on the assume-unchanged flag.
