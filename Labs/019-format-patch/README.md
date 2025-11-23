# Lab 019 - Format Patch

---

## Overview

Learn how to create and apply patch files using `git format-patch` and `git am`. This is essential for email-based workflows and sharing changes without using Git remotes.

---

## Core Concepts

- **Patch Files**: Text files containing commit changes
- **Email Workflow**: Send commits via email
- **Format Patch**: Generate patch files from commits
- **Apply Mailbox**: Apply patches to repository
- **Series of Patches**: Multiple commits as patches

## What You'll Learn

- Creating patch files from commits
- Applying patches to repositories
- Generating patch series
- Email-based Git workflow
- Patch numbering and formatting
- Handling patch application failures

## Usage

```bash
cd Labs/019-format-patch
# Check for demo scripts
```

## Key Commands

### Creating Patches

```bash
# Create patch for last commit
git format-patch -1

# Create patch for last 3 commits
git format-patch -3

# Create patches for all commits on branch
git format-patch main..feature

# Create patches with custom output directory
git format-patch -o patches/ main..feature

# Create single patch file for all commits
git format-patch --stdout main..feature > feature.patch
```

### Applying Patches

```bash
# Apply a single patch
git am < 0001-patch-file.patch

# Apply all patches in directory
git am patches/*.patch

# Apply with 3-way merge
git am -3 < patch.patch

# Skip current patch and continue
git am --skip

# Abort patch application
git am --abort
```

## Patch File Format

```text
From abc123... Mon Sep 17 00:00:00 2001
From: John Doe <john@example.com>
Date: Mon, 23 Nov 2023 10:00:00 +0000
Subject: [PATCH] Add new feature

Detailed description of the change.

---
 file.txt | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/file.txt b/file.txt
index 123..456 100644
--- a/file.txt
+++ b/file.txt
@@ -1 +1,6 @@
+new line
```

## Patch Series Options

```bash
# Number patches with cover letter
git format-patch -n --cover-letter main..feature

# Add subject prefix
git format-patch --subject-prefix="PATCH v2" main..feature

# Include version in subject
git format-patch -v2 main..feature

# Start numbering from specific number
git format-patch --start-number=5 main..feature
```

## Cover Letter

When creating a patch series:

```bash
# Generate cover letter
git format-patch --cover-letter -3

# Edit 0000-cover-letter.patch
# Add series description and changelog
```

## Checking Patches

```bash
# Check if patch can be applied
git apply --check patch.patch

# Show what patch would do
git apply --stat patch.patch

# Dry run
git apply --dry-run patch.patch
```

## Handling Conflicts

If patch fails to apply:

```bash
# Try 3-way merge
git am -3 < patch.patch

# If still fails, resolve manually
git am --show-current-patch
# Fix conflicts
git add fixed-files
git am --continue
```

## Email Workflow

### Sending Patches

```bash
# Configure email
git config sendemail.smtpserver smtp.gmail.com
git config sendemail.smtpuser your@email.com

# Send patches
git send-email *.patch --to=maintainer@project.com
```

### Receiving Patches

```bash
# Save email to file
# Then apply
git am < email.txt
```

## Use Cases

1. **Contributing to Linux Kernel**: Uses email-based workflow
2. **Offline Sharing**: Share commits without network
3. **Code Review**: Review changes as text files
4. **Backporting**: Apply changes across branches
5. **Archiving**: Store commits as files

## Format-Patch vs Diff

**git format-patch:**
- Preserves commit metadata (author, date, message)
- Can be applied with `git am`
- Maintains commit history

**git diff:**
- Just the changes
- Applied with `git apply`
- No commit metadata

## Next Steps

Proceed to [Lab 020 - Interpret Trailers](../020-interpret-trailers/README.md) to learn about managing commit message trailers.
