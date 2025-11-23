# Lab 029 - Interpret Trailers (Advanced)

---

## Overview

Advanced usage of Git trailers including automation, custom trailers, integration with workflows, and trailer-based tooling.

---

## Core Concepts

- **Custom Trailers**: Define your own trailer types
- **Automation**: Automatically add trailers via hooks
- **Workflows**: Integrate trailers into development process
- **Parsing**: Extract and process trailer data

## What You'll Learn

- Creating custom trailer configurations
- Automating trailer addition
- Building workflows around trailers
- Parsing trailers in scripts
- Integration with CI/CD

## Usage

```bash
cd Labs/029-interpret-trailers
# Demo files may be available
```

## Custom Trailer Configuration

### Define Custom Trailers

```bash
# Configure trailer behavior
git config trailer.bug.key "Bug"
git config trailer.bug.where "end"
git config trailer.bug.ifExists "addIfDifferent"
git config trailer.bug.ifMissing "doNothing"

# Configure command to generate trailer value
git config trailer.bug.command 'echo "#$(date +%s)"'
```

### Trailer Configuration Options

```bash
# Key name (what appears in commit)
git config trailer.<token>.key "Actual-Key"

# Where to add (end, start, after, before)
git config trailer.<token>.where "end"

# If trailer exists (addIfDifferent, addIfDifferentNeighbor, add, replace, doNothing)
git config trailer.<token>.ifExists "addIfDifferent"

# If missing (add, doNothing)
git config trailer.<token>.ifMissing "add"

# Command to generate value
git config trailer.<token>.command "command to run"
```

## Automation Examples

### Auto Sign-off

```bash
# Configure sign-off trailer
git config trailer.sign.key "Signed-off-by"
git config trailer.sign.command 'echo "$(git config user.name) <$(git config user.email)>"'
git config trailer.sign.ifExists "doNothing"

# Use in prepare-commit-msg hook
#!/bin/sh
# .git/hooks/prepare-commit-msg

git interpret-trailers --in-place --trailer "sign" "$1"
```

### Auto Ticket Reference

```bash
#!/bin/sh
# .git/hooks/prepare-commit-msg

# Extract ticket from branch name (e.g., feature/PROJ-123-description)
BRANCH=$(git symbolic-ref --short HEAD)
TICKET=$(echo "$BRANCH" | grep -oE '[A-Z]+-[0-9]+')

if [ -n "$TICKET" ]; then
    git interpret-trailers --in-place \
        --trailer "Ticket: $TICKET" \
        "$1"
fi
```

### Auto-add Reviewers

```bash
#!/bin/bash
# add-reviewers.sh

COMMIT_MSG=$1

# Get files changed
FILES=$(git diff --cached --name-only)

# Determine reviewers based on files
REVIEWERS=""
echo "$FILES" | while read file; do
    case "$file" in
        src/auth/*)
            REVIEWERS="$REVIEWERS\n--trailer 'Reviewer: auth-team@example.com'"
            ;;
        src/api/*)
            REVIEWERS="$REVIEWERS\n--trailer 'Reviewer: api-team@example.com'"
            ;;
    esac
done

# Add reviewers
echo -e "$REVIEWERS" | xargs git interpret-trailers --in-place "$COMMIT_MSG"
```

## Complex Workflows

### Pull Request Workflow

```bash
#!/bin/bash
# pr-trailers.sh

# Add PR-specific trailers
git interpret-trailers --trailer "PR-Status: ready-for-review" \
    --trailer "Reviewers-Needed: 2" \
    --trailer "CI-Required: true" \
    --in-place .git/COMMIT_EDITMSG
```

### Release Management

```bash
#!/bin/bash
# release-trailers.sh

VERSION=$1
COMMIT_MSG=$2

git interpret-trailers \
    --trailer "Release-Version: $VERSION" \
    --trailer "Release-Date: $(date -I)" \
    --trailer "Release-Manager: $(git config user.name)" \
    --in-place "$COMMIT_MSG"
```

## Parsing Trailers in Scripts

### Extract Specific Trailer

```bash
#!/bin/bash
# get-trailer.sh

COMMIT=$1
TRAILER_KEY=$2

git log -1 --format="%(trailers:key=$TRAILER_KEY,valueonly)" "$COMMIT"
```

### Parse All Trailers

```bash
#!/bin/bash
# parse-trailers.sh

COMMIT=${1:-HEAD}

# Get all trailers as key-value pairs
git log -1 --format="%(trailers)" "$COMMIT" | \
while IFS=': ' read key value; do
    echo "Key: $key"
    echo "Value: $value"
    echo "---"
done
```

### Generate Reports

```bash
#!/bin/bash
# trailer-report.sh

echo "Commit Trailer Report"
echo "====================="

git log --format="%H|%s" -20 | while IFS='|' read hash subject; do
    echo ""
    echo "Commit: $hash"
    echo "Subject: $subject"
    
    # Get specific trailers
    reviewed=$(git log -1 --format="%(trailers:key=Reviewed-by,valueonly)" $hash)
    ticket=$(git log -1 --format="%(trailers:key=Ticket,valueonly)" $hash)
    
    [ -n "$reviewed" ] && echo "  Reviewed: $reviewed"
    [ -n "$ticket" ] && echo "  Ticket: $ticket"
done
```

## CI/CD Integration

### Check Required Trailers

```bash
#!/bin/bash
# check-trailers.sh

COMMIT=$1
REQUIRED_TRAILERS=("Signed-off-by" "Ticket")

for trailer in "${REQUIRED_TRAILERS[@]}"; do
    value=$(git log -1 --format="%(trailers:key=$trailer,valueonly)" "$COMMIT")
    
    if [ -z "$value" ]; then
        echo "Error: Missing required trailer: $trailer"
        exit 1
    fi
done

echo "All required trailers present"
```

### Auto-deployment Based on Trailers

```bash
#!/bin/bash
# auto-deploy.sh

COMMIT=$1

# Check Deploy-To trailer
deploy_to=$(git log -1 --format="%(trailers:key=Deploy-To,valueonly)" "$COMMIT")

case "$deploy_to" in
    production)
        echo "Deploying to production..."
        ./deploy-prod.sh
        ;;
    staging)
        echo "Deploying to staging..."
        ./deploy-staging.sh
        ;;
    "")
        echo "No deployment trailer found, skipping deployment"
        ;;
    *)
        echo "Unknown deployment target: $deploy_to"
        exit 1
        ;;
esac
```

## Advanced Trailer Patterns

### Conditional Trailers

```bash
#!/bin/bash
# conditional-trailers.sh

# Add trailers based on conditions
if git diff --cached | grep -q "TODO"; then
    git interpret-trailers --trailer "Contains-TODO: true" --in-place "$1"
fi

if [ $(git diff --cached --stat | wc -l) -gt 100 ]; then
    git interpret-trailers --trailer "Large-Change: true" --in-place "$1"
fi
```

### Trailer Templates

```bash
# Create trailer templates
cat > ~/.git-trailers/feature.txt << 'EOF'
Type: feature
Reviewed-by: 
Tested-by: 
Documentation: pending
EOF

# Use in commit
git interpret-trailers --trailer-file ~/.git-trailers/feature.txt \
    --in-place .git/COMMIT_EDITMSG
```

## Next Steps

Proceed to [Lab 030 - Signed Commits](../030-signed-commits/README.md) to learn about signing commits with GPG.
