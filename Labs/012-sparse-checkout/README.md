# Advanced Git - Sparse Checkout

<div align="center">

<img src="/_utils/images/advanced_git.jpg" alt="Advanced Git" width="300px" height="auto" style="border-radius: 50%"/>

</div>


---
<!-- omit in toc -->
# Table of Contents
- [Advanced Git - Sparse Checkout](#advanced-git---sparse-checkout)
  - [Preface](#preface)
    - [`sparse-checkout init --cone`](#sparse-checkout-init---cone)
    - [`--cone` Mode:](#--cone-mode)
    - [What Happens Under the Hood:](#what-happens-under-the-hood)
    - [Demo Code Snippet:](#demo-code-snippet)

---

## Preface

1. Git `sparse checkout` allows you to check out only a subset of files from a Git repository, rather than the entire repository.
2. This can be useful when you only need to work with a specific set of files or directories within a large repository, reducing the amount of data that needs to be downloaded and stored on your local machine.
3. Sparse checkout is particularly useful in scenarios where:
   - You are working with a large repository that contains many files and directories, but you only need to work with a small subset of them.
   - You want to reduce the amount of disk space used by your local copy of the repository.
   - You want to speed up the checkout process by only downloading the files you need.
4. Sparse checkout is a feature of Git that allows you to specify which files or directories you want to check out from a repository, while ignoring the rest.
5. This is done by modifying the `.git/info/sparse-checkout` file, which contains a list of patterns that specify which files or directories should be included in the checkout.
6. The patterns in the `.git/info/sparse-checkout` file are used to match files and directories in the repository, and only those that match the patterns will be checked out.
7. The patterns can include wildcards and other special characters to specify complex matching rules.
8. It is important to note that sparse checkout does not affect the history of the repository or the way Git tracks changes to files.
9. The files that are not checked out are still present in the repository and can be accessed using Git commands, but they will not be included in the working directory.

### `sparse-checkout init --cone`

- The command `git sparse-checkout init --cone` initializes sparse-checkout in **"cone mode"**
- `cone` is a feature designed to optimize Git's behavior in large repositories by **restricting the working directory to specific directories** (and their subdirectories) instead of checking out **the entire project.** 
  
### `--cone` Mode:

> [!IMPORTANT]  
> **It's important to note that cone mode is not a replacement for sparse-checkout, but rather an optimization.** 
- In **cone mode**, Git only checks out the files and directories that match the specified patterns. 
- This means that you can work with a subset of the files in the repository, without having to download the entire project.
- Lets you work with a subset of files/directories in a repository (e.g., useful in monorepos or massive codebases).
- Reduces disk usage and speeds up operations like git status or git checkout.
- Simplifies the sparse-checkout process by allowing you to specify directories instead of complex patterns.

### What Happens Under the Hood:

- The .git/info/sparse-checkout file is updated with directory patterns (e.g., /*, /src/*, /docs/*).

- The .git/config file is updated to include the cone mode configuration.
- Git’s (staging area) tracks only the specified paths, ignoring others.

> [!CAUTION]
> After enabling sparse-checkout, files outside the specified paths may be **deleted** from your working directory.


----

### Demo Code Snippet:

```shell
# Clone repository with sparse checkout enabled
git clone --filter=blob:none --sparse . ../sparse-checkout-demo

# Switch to the cloned repository
cd ../sparse-checkout-demo

# Initialize sparse checkout in cone mode
git sparse-checkout init --cone

# Set which directory to keep (server folder)
git sparse-checkout set server

# Print list of files in the repository
tree .

# Check the status of the repository
git status
```
