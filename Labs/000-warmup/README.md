# Lab 000 - Warmup

---

## Overview

In this warmup lab, you'll learn Git fundamentals by creating simple commits and exploring what happens under the hood in the `.git` folder. This lab consists of two exercises covering basic Git operations and the three states of Git.

---

## Core Concepts

- **Git Objects**: Understand blobs, trees, and commit objects stored in `.git/objects`
- **Staging Area**: Learn how Git tracks changes through the staging area
- **Three States**: Working directory, staging area (index), and Git repository
- **Interactive Staging**: Use `git add -p` for selective staging

## Exercises

### Exercise 01 - Under The Hood of a Simple Commit

Explore Git's internal object storage by creating commits and examining the `.git` folder structure.

**Skills Learned:**
- Creating Git repositories
- Understanding Git object storage
- Inspecting commit, tree, and blob objects

### Exercise 02 - 3 States

Master Git's three-state model: working directory, staging area, and committed files.

**Skills Learned:**
- Managing the staging area
- Viewing staged content with `git ls-files -s`
- Interactive staging with `git add -p`
- Understanding file states in Git

## Lab Files

- [Lab01-SimpleCommit.md](./Lab01-SimpleCommit.md) - Simple commit walkthrough
- [Lab02-StagingAndStashing.md](./Lab02-StagingAndStashing.md) - Three states deep dive

## Prerequisites

- Git installed on your system
- `tree` command (Ubuntu: `apt install tree`, MacOS: `brew install tree`)

## Next Steps

Proceed to [Lab 001 - Smudge Clean](../001-smudge-clean/README.md) to learn about Git filters.
