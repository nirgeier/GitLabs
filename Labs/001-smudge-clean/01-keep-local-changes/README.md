<!-- omit in toc -->
# Keep Local Changes with Git Smudge and Clean Filters

<!-- omit in toc -->
## Table of Contents
- [Preface](#preface)
- [Overview](#overview)
- [Scenario](#scenario)
- [HOW TO?](#how-to)
- [Lab Steps](#lab-steps)
- [Key Commands Used](#key-commands-used)
- [Notes](#notes)
- [Learning Outcomes](#learning-outcomes)

---


## Preface

- Git's smudge and clean filters are powerful tools that allow you to automatically **transform files as they move between your working directory and the repository**. 
- These filters are especially useful for handling sensitive or environment-specific data, such as API keys, passwords, or IP addresses, that should not be stored in their raw form in version control. (Ex: [`git-crypt`](https://github.com/AGWA/git-crypt), [`git-lfs`](https://git-lfs.github.com/), [`git-secret`](https://github.com/sobolevn/git-secret))

- By configuring these filters, teams can ensure that sensitive information never leaves the developer's machine, while still allowing everyone to work with the files they need. 

## Overview

- **Lab Name**: Keep Local Changes with Git Smudge and Clean Filters
- This lab demonstrates how to use Git's smudge and clean filters to manage sensitive information (such as IP addresses, passwords, or API keys) in files like `.env`. 
- The goal is to keep sensitive production values out of your repository while allowing developers to work with safe, local values on their machines.

## Scenario

- You have a `.env` file containing a database IP address. 
- You want developers to use a **local IP** (e.g., `127.0.0.1`)
- You want to store the **production IP** (e.g., `10.10.10.10`) in the repository (for deployment).

## HOW TO? 

This is achieved using Git's **smudge** and **clean** filters:

| Filter Type    | When is it applied?                                 | What does it do?                                                      |
|---------------|-----------------------------------------------------|-----------------------------------------------------------------------|
| **Clean filter**  | When adding files to the repository (staging)        | Replaces the **local IP** with the production IP                           |
| **Smudge filter** | When checking out files from the repository          | Replaces the **production IP** with the local IP                           |

## Lab Steps

1. **Preparation**
   - Defines local and production IP addresses as environment variables.

2. **Demo Repository Setup**
   - Creates a new demo repository in `/tmp/demo_smudge`.
   - Initializes a sample `.env` file with a placeholder IP address and some feature flags.
   - Shows the initial content of `.env`.
   - Initializes a new Git repository and commits the initial state (without filters).

3. **Defining Filters**
   - Configures a Git clean filter to replace the local IP with the production IP when staging (`git add`).
   - Configures a Git smudge filter to replace the production IP with the local IP when checking out (`git checkout`).
   - Adds a `.gitattributes` file to apply the filter to `.env`.

3. **Testing the Filters**
   - Modifies the repository (adds a README change).
   - Adds and commits changes, triggering the filters.
   - Shows the diff of `.env` to demonstrate the filter in action.
   - Pushes the changes (if a remote is set).

3. **Verification**
   - Displays the current `.env` file (should show the local IP).
   - Shows the `.env` content as stored in the repository (should show the production IP).


## Key Commands Used

```sh
# Set the filter configuration for the local IP and production IP
git config \
        --local filter.cleanLocalhost.clean \
        "gsed -e 's/database.ip=.*/database.ip=${DB_IP_PROD}/g'"

git config \
        --local filter.cleanLocalhost.smudge \
        "gsed -e 's/database.ip=.*/database.ip=${DB_IP_LOCAL}/g'"

# Add the filter to .gitattributes
echo ".env filter=cleanLocalhost" > .gitattributes
```

## Notes

- **MacOS users**: The script uses `gsed` (GNU sed). Install it via `brew install gnu-sed` if not already available.
- The filters are defined inline for demo purposes. In real projects, use separate scripts for complex logic.
- This approach can be extended to any sensitive data, not just IP addresses.

## Learning Outcomes

- Understand how Git smudge and clean filters work.
- Learn to keep sensitive data out of your repository while maintaining a seamless local development experience.
- Practice configuring and testing custom Git filters.


