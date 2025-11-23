# Lab 009 - Git Conflicts

---

## Overview

Master the art of resolving Git merge conflicts. Learn how conflicts occur, how to identify them, and various strategies for resolution.

---

## Core Concepts

- **Merge Conflicts**: When and why they occur
- **Conflict Markers**: Understanding `<<<<<<<`, `=======`, `>>>>>>>`
- **Conflict Resolution**: Manual and tool-assisted approaches
- **Merge Strategies**: Different ways to handle conflicts

## What You'll Learn

- Understanding conflict scenarios
- Reading conflict markers
- Resolving conflicts manually
- Using merge tools
- Preventing conflicts
- Conflict resolution strategies

## Demo Script

- Script creates branches with conflicting changes

## Usage

```bash
cd Labs/009-conflicts
./*.sh
```

## Conflict Markers Explained

```text
<<<<<<< HEAD (current branch)
Current branch content
=======
Incoming branch content
>>>>>>> feature-branch (incoming changes)
```

## Resolution Strategies

### Manual Resolution

1. Open the conflicted file
2. Remove conflict markers
3. Keep desired changes
4. Stage the resolved file
5. Complete the merge

### Using Merge Tools

```bash
# Configure merge tool
git config --global merge.tool vimdiff

# Launch merge tool
git mergetool
```

## Common Conflict Scenarios

- Same line modified in both branches
- File deleted in one branch, modified in another
- File renamed in one branch, modified in another
- Binary file conflicts

## Best Practices

- Commit frequently
- Pull changes regularly
- Communicate with team
- Use feature branches
- Keep branches short-lived

## Preventing Conflicts

- Small, focused commits
- Regular rebasing
- Clear code ownership
- Good communication

## Next Steps

Proceed to [Lab 010 - Merge](../010-merge/README.md) to learn about advanced merge strategies.
