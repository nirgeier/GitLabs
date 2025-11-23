# Lab 006 - Git Hooks

---

## Overview

Implement Git hooks to automate checks and enforce standards during Git operations. Hooks are scripts that Git executes before or after events like commit, push, and receive.

---

## Core Concepts

- **Client-Side Hooks**: Run on local operations (commit, merge, push)
- **Server-Side Hooks**: Run on repository server (receive, update, post-receive)
- **Hook Types**: pre-commit, commit-msg, pre-push, pre-receive, etc.
- **Enforcement**: Validate commit messages, code quality, tests

## What You'll Learn

- Creating and installing Git hooks
- Enforcing commit message standards
- Running pre-commit checks
- Implementing server-side hooks
- Hook best practices

## Demo Scripts

- `hooks.sh` - General hooks demonstration
- `enforce_commit.sh` - Pre-receive hook for commit message validation

## Usage

```bash
cd Labs/006-hooks
./hooks.sh
./enforce_commit.sh
```

## Common Hooks

### Client-Side Hooks

- `pre-commit`: Run before commit is created
- `prepare-commit-msg`: Modify commit message template
- `commit-msg`: Validate commit message format
- `post-commit`: Run after commit is created
- `pre-push`: Run before push to remote

### Server-Side Hooks

- `pre-receive`: Run when receiving pushed commits
- `update`: Run for each branch being updated
- `post-receive`: Run after successful push

## Example: Commit Message Format

```bash
#!/bin/sh
# .git/hooks/commit-msg

commit_msg=$(cat "$1")
if ! echo "$commit_msg" | grep -qE "^(feat|fix|docs|style|refactor|test|chore):"; then
    echo "Error: Commit message must start with type (feat|fix|docs|...)"
    exit 1
fi
```

## Next Steps

Proceed to [Lab 007 - Case Sensitive](../007-case-sensitive/README.md) to understand Git's case sensitivity.
