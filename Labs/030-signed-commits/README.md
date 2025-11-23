# Lab 030 - Signed Commits

---

## Overview

Learn how to sign Git commits using GPG keys to verify the authenticity and integrity of your commits. Signed commits provide cryptographic proof that commits were created by you.

---

## Core Concepts

- **GPG Keys**: Cryptographic keys for signing
- **Commit Signing**: Adding cryptographic signatures to commits
- **Verification**: Verifying signed commits
- **Trust**: Building a web of trust

## What You'll Learn

- Generating GPG keys
- Configuring Git for signing
- Signing commits and tags
- Verifying signatures
- Managing GPG keys
- GitHub integration

## Demo Script

- Script demonstrates signing commits with GPG

## Usage

```bash
cd Labs/030-signed-commits
./*.sh
```

## Setup GPG

### Generate GPG Key

```bash
# Generate new GPG key
gpg --full-generate-key

# Select:
# - RSA and RSA (default)
# - 4096 bits
# - Key doesn't expire (or set expiration)
# - Enter name and email (must match Git config)
```

### List GPG Keys

```bash
# List all GPG keys
gpg --list-secret-keys --keyid-format=long

# Output shows:
# sec   rsa4096/ABCD1234EFGH5678 2023-11-23
# uid   Your Name <your@email.com>
```

### Configure Git

```bash
# Set your GPG key ID
git config --global user.signingkey ABCD1234EFGH5678

# Enable auto-signing for all commits
git config --global commit.gpgSign true

# Enable auto-signing for all tags
git config --global tag.gpgSign true
```

## Signing Commits

### Sign Individual Commit

```bash
# Sign a specific commit
git commit -S -m "Signed commit message"

# Or if auto-sign is enabled
git commit -m "Auto-signed commit"
```

### Sign Previous Commits

```bash
# Amend last commit with signature
git commit --amend -S --no-edit

# Rebase and sign multiple commits
git rebase -i HEAD~3 --exec "git commit --amend --no-edit -S"
```

## Signing Tags

### Create Signed Tag

```bash
# Create annotated signed tag
git tag -s v1.0.0 -m "Release version 1.0.0"

# Verify tag signature
git tag -v v1.0.0
```

## Verification

### Verify Commits

```bash
# Show commit with signature
git show --show-signature <commit>

# Verify specific commit
git verify-commit <commit>

# Show log with signature status
git log --show-signature

# Compact signature status in log
git log --pretty="format:%h %G? %aN  %s"
```

### Signature Status Codes

```text
G = Good signature
B = Bad signature
U = Good signature, unknown validity
X = Good signature, expired
Y = Good signature, expired key
R = Good signature, revoked key
E = Signature cannot be checked
N = No signature
```

## GitHub Integration

### Add GPG Key to GitHub

```bash
# Export public key
gpg --armor --export ABCD1234EFGH5678

# Copy output and add to GitHub:
# Settings → SSH and GPG keys → New GPG key
```

### Verified Badge on GitHub

Once added, signed commits show "Verified" badge on GitHub.

## GPG Key Management

### Export Keys

```bash
# Export public key
gpg --armor --export ABCD1234EFGH5678 > public-key.asc

# Export private key (keep secure!)
gpg --armor --export-secret-keys ABCD1234EFGH5678 > private-key.asc
```

### Import Keys

```bash
# Import public key
gpg --import public-key.asc

# Import private key
gpg --import private-key.asc

# Trust imported key
gpg --edit-key ABCD1234EFGH5678
# In GPG prompt:
# gpg> trust
# Select: 5 = I trust ultimately
# gpg> quit
```

### Backup Keys

```bash
# Backup directory
mkdir -p ~/gpg-backup

# Export all keys
gpg --export --armor > ~/gpg-backup/public-keys.asc
gpg --export-secret-keys --armor > ~/gpg-backup/private-keys.asc

# Backup trust database
gpg --export-ownertrust > ~/gpg-backup/ownertrust.txt
```

## Troubleshooting

### GPG Agent Issues

```bash
# Start GPG agent
gpgconf --launch gpg-agent

# Kill and restart
gpgconf --kill gpg-agent
gpgconf --launch gpg-agent

# Test signing
echo "test" | gpg --clear-sign
```

### TTY Issues

```bash
# Add to ~/.bashrc or ~/.zshrc
export GPG_TTY=$(tty)

# Or configure Git
git config --global gpg.program gpg
```

### Signature Verification Failed

```bash
# Import author's public key
gpg --recv-keys <key-id>

# Or from keyserver
gpg --keyserver keys.openpgp.org --recv-keys <key-id>
```

## Best Practices

### Key Security

1. **Use strong passphrase** for GPG key
2. **Backup keys** securely (encrypted storage)
3. **Set expiration** on keys (renew periodically)
4. **Revoke compromised keys** immediately
5. **Don't share private keys**

### Commit Signing

```bash
# Always sign release tags
git tag -s v1.0.0 -m "Release 1.0.0"

# Sign merge commits
git merge --gpg-sign feature-branch

# Sign when amending
git commit --amend -S --no-edit
```

## Automation

### Sign All Commits Automatically

```bash
# Enable globally
git config --global commit.gpgSign true

# Or per repository
git config commit.gpgSign true
```

### Pre-commit Hook

```bash
#!/bin/sh
# .git/hooks/pre-commit

# Ensure GPG agent is running
if ! gpg-agent; then
    gpgconf --launch gpg-agent
fi
```

## Advanced Usage

### Multiple Keys

```bash
# List all keys
gpg --list-keys

# Use specific key for signing
GIT_COMMITTER_KEY=ABCD1234 git commit -S -m "Signed with specific key"
```

### Subkeys

```bash
# Generate signing subkey
gpg --edit-key ABCD1234EFGH5678
# gpg> addkey
# Select: RSA (sign only)
# gpg> save

# Use subkey for signing
git config user.signingkey SUBKEY1234!
```

## Verification in Scripts

```bash
#!/bin/bash
# verify-commits.sh

BRANCH=${1:-HEAD}

git log --format="%H %G?" $BRANCH | while read hash status; do
    case $status in
        G) echo "✓ $hash - Good signature" ;;
        B) echo "✗ $hash - Bad signature" ;;
        N) echo "- $hash - No signature" ;;
        *) echo "? $hash - Unknown status: $status" ;;
    esac
done
```

## Next Steps

Proceed to [Lab 031 - Submodules](../031-submodules/README.md) to learn about managing Git submodules.
