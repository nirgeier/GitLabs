# Lab 020 - Interpret Trailers

---

## Overview

Learn how to use `git interpret-trailers` to add, parse, and manage structured metadata in commit messages. Trailers are key-value pairs commonly used for sign-offs, issue tracking, and co-authors.

---

## Core Concepts

- **Trailers**: Structured metadata in commit messages
- **Standard Format**: Key: Value pairs at end of message
- **Automation**: Automatic trailer addition
- **Parsing**: Extract trailers from commits
- **Configuration**: Custom trailer behavior

## What You'll Learn

- Adding trailers to commit messages
- Parsing existing trailers
- Configuring trailer behavior
- Common trailer types
- Automation with hooks

## Demo Script

- Script demonstrates trailer management

## Usage

```bash
cd Labs/020-interpret-trailers
./*.sh
```

## Trailer Format

```text
Commit message title

Detailed description of the commit.

Signed-off-by: John Doe <john@example.com>
Reviewed-by: Jane Smith <jane@example.com>
Resolves: #123
```

## Key Commands

```bash
# Add trailer to message
git interpret-trailers --trailer "Signed-off-by: Name <email>" message.txt

# Add multiple trailers
echo "commit message" | git interpret-trailers \
  --trailer "Reviewed-by: Alice" \
  --trailer "Tested-by: Bob"

# Parse trailers from commit
git log --format="%(trailers)" -1

# Extract specific trailer
git log --format="%(trailers:key=Signed-off-by)" -1
```

## Common Trailers

### Signed-off-by

```bash
# Developer Certificate of Origin
Signed-off-by: John Doe <john@example.com>

# Add automatically to all commits
git config trailer.sign.key "Signed-off-by"
git config trailer.sign.cmd 'echo "$(git config user.name) <$(git config user.email)>"'
```

### Reviewed-by/Acked-by

```bash
Reviewed-by: Alice Smith <alice@example.com>
Acked-by: Bob Johnson <bob@example.com>
```

### Issue/Ticket References

```bash
Resolves: #123
Fixes: #456
Related-to: #789
```

### Co-authored-by

```bash
Co-authored-by: Jane Doe <jane@example.com>
```

## Configuration

```bash
# Configure trailer behavior
git config trailer.separators ":"
git config trailer.where "end"
git config trailer.ifexists "addIfDifferent"
git config trailer.ifmissing "add"

# Alias for adding signed-off trailer
git config trailer.sign.key "Signed-off-by"
```

## Automatic Trailers

### Via prepare-commit-msg Hook

```bash
#!/bin/sh
# .git/hooks/prepare-commit-msg

git interpret-trailers --in-place \
  --trailer "Signed-off-by: $(git config user.name) <$(git config user.email)>" \
  "$1"
```

### Via Commit Template

```bash
# Create template
cat > ~/.git-commit-template.txt << 'EOF'


Signed-off-by: Your Name <your@email.com>
EOF

# Configure Git to use it
git config commit.template ~/.git-commit-template.txt
```

## Parsing Trailers

### In Scripts

```bash
# Get all trailers
git log -1 --format="%(trailers)"

# Get specific trailer value
git log -1 --format="%(trailers:key=Resolves,valueonly)"

# Check if trailer exists
if git log -1 --format="%(trailers:key=Signed-off-by)" | grep -q "John Doe"; then
  echo "Signed by John"
fi
```

### Extracting from Multiple Commits

```bash
# Get all reviewers from last 10 commits
git log -10 --format="%(trailers:key=Reviewed-by,valueonly)" | sort -u
```

## Integration with Tools

### GitHub

```bash
# Close issues automatically
Closes: #123
Fixes: #456
```

### Jira

```bash
JIRA: PROJ-123
```

### Conventional Commits

```text
feat: add new feature

Implements feature X with Y functionality.

Refs: #123
Signed-off-by: Dev <dev@example.com>
```

## Next Steps

Proceed to [Lab 021 - Check Ignore](../021-check-ignore/README.md) to learn about debugging .gitignore rules.
