# Lab 025 - Create GitHub Repository

---

## Overview

Learn how to create GitHub repositories programmatically using the GitHub API. This is useful for automation, scripts, and DevOps workflows.

---

## Core Concepts

- **GitHub API**: RESTful API for GitHub operations
- **Authentication**: Personal access tokens
- **Repository Creation**: Automated repo setup
- **Remote Configuration**: Adding remotes programmatically

## What You'll Learn

- Creating repositories via GitHub API
- Authenticating with personal access tokens
- Configuring repository settings
- Adding remotes to local repositories
- Automating repository creation

## Demo Script

- Script demonstrates GitHub API repository creation

## Usage

```bash
cd Labs/025-createGithubRepository
# Edit script with your GitHub token
./*.sh
```

## Prerequisites

### Create Personal Access Token

1. Go to GitHub → Settings → Developer settings → Personal access tokens
2. Generate new token (classic)
3. Select scopes: `repo` (full control of repositories)
4. Copy the token

### Set Environment Variable

```bash
# Add to ~/.bashrc or ~/.zshrc
export GITHUB_TOKEN="your_token_here"

# Or use in script
GITHUB_TOKEN="your_token_here"
```

## Creating Repository via API

### Basic Repository

```bash
curl -H "Authorization: token $GITHUB_TOKEN" \
     -H "Accept: application/vnd.github.v3+json" \
     https://api.github.com/user/repos \
     -d '{
       "name": "my-new-repo",
       "description": "Created via API",
       "private": false
     }'
```

### Repository with Options

```bash
curl -H "Authorization: token $GITHUB_TOKEN" \
     -H "Accept: application/vnd.github.v3+json" \
     https://api.github.com/user/repos \
     -d '{
       "name": "my-repo",
       "description": "Repository created via GitHub API",
       "homepage": "https://github.com",
       "private": false,
       "has_issues": true,
       "has_projects": true,
       "has_wiki": true,
       "auto_init": true,
       "gitignore_template": "Node",
       "license_template": "mit"
     }'
```

## Complete Workflow Script

```bash
#!/bin/bash
# create-repo.sh

REPO_NAME="$1"
GITHUB_TOKEN="$2"

if [ -z "$REPO_NAME" ] || [ -z "$GITHUB_TOKEN" ]; then
    echo "Usage: $0 <repo-name> <github-token>"
    exit 1
fi

# Create repository
echo "Creating repository: $REPO_NAME"
RESPONSE=$(curl -s -H "Authorization: token $GITHUB_TOKEN" \
     -H "Accept: application/vnd.github.v3+json" \
     https://api.github.com/user/repos \
     -d "{\"name\":\"$REPO_NAME\",\"private\":false}")

# Extract clone URL
CLONE_URL=$(echo "$RESPONSE" | grep -o '"clone_url": "[^"]*' | cut -d'"' -f4)

if [ -z "$CLONE_URL" ]; then
    echo "Error creating repository"
    echo "$RESPONSE"
    exit 1
fi

echo "Repository created: $CLONE_URL"

# Initialize local repository
git init
echo "# $REPO_NAME" > README.md
git add README.md
git commit -m "Initial commit"

# Add remote and push
git remote add origin "$CLONE_URL"
git push -u origin main

echo "Done! Repository setup complete."
```

## API Endpoints

### User Repositories

```bash
# Create for authenticated user
POST https://api.github.com/user/repos

# Create for organization
POST https://api.github.com/orgs/{org}/repos
```

### Repository Settings

```json
{
  "name": "repo-name",                  // Required
  "description": "Description",
  "homepage": "https://example.com",
  "private": false,                     // Public or private
  "has_issues": true,
  "has_projects": true,
  "has_wiki": true,
  "has_downloads": true,
  "auto_init": true,                    // Initialize with README
  "gitignore_template": "Python",
  "license_template": "mit",
  "allow_squash_merge": true,
  "allow_merge_commit": true,
  "allow_rebase_merge": true,
  "delete_branch_on_merge": true
}
```

## Adding Remote to Existing Repo

```bash
# Get username
GITHUB_USER=$(curl -s -H "Authorization: token $GITHUB_TOKEN" \
  https://api.github.com/user | grep -o '"login": "[^"]*' | cut -d'"' -f4)

# Add remote
git remote add origin "https://github.com/$GITHUB_USER/$REPO_NAME.git"

# Or with SSH
git remote add origin "git@github.com:$GITHUB_USER/$REPO_NAME.git"

# Push
git push -u origin main
```

## Error Handling

```bash
# Check response status
HTTP_STATUS=$(curl -s -o response.json -w "%{http_code}" \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  https://api.github.com/user/repos \
  -d "{\"name\":\"$REPO_NAME\"}")

if [ "$HTTP_STATUS" -eq 201 ]; then
    echo "Success!"
else
    echo "Error: HTTP $HTTP_STATUS"
    cat response.json
fi
```

## Security Best Practices

1. **Never commit tokens** to repositories
2. **Use environment variables** for sensitive data
3. **Limit token scopes** to minimum required
4. **Rotate tokens** regularly
5. **Use GitHub CLI** (`gh`) when possible

## Using GitHub CLI (Alternative)

```bash
# Install GitHub CLI
brew install gh  # macOS
# apt install gh  # Linux

# Authenticate
gh auth login

# Create repository
gh repo create my-repo --public --description "Created with gh CLI"

# Clone and initialize
gh repo create my-repo --public --clone
```

## Next Steps

Proceed to [Lab 026 - Git Notes](../026-git-notes/README.md) for advanced Git notes usage.
