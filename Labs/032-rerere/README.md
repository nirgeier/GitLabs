# rerere.sh

This script demonstrates the use of Git's `rerere` (reuse recorded resolution) feature, which helps automate the resolution of repeated merge conflicts.


## What does it do?

- Sets up a demo Git repository in `/tmp/rerere-demo`.
- Creates two branches with conflicting changes to the same file.
- Walks you through a manual conflict resolution.
- Shows how `rerere` can automatically resolve the same conflict if it occurs again.


## Steps performed by the script

1. **Repository Setup**: Initializes a new Git repository and creates a file (`demo-file.txt`) with different content on two branches.
2. **First Merge (Conflict)**: Merges the branches, causing a conflict. You resolve the conflict manually.
3. **Recording the Resolution**: Git records your manual resolution because `rerere` is enabled.
4. **Reverting and Repeating**: The script resets the repository to before the resolution and repeats the merge. This time, Git automatically applies the previously recorded resolution.


## Usage

Run the script in your terminal:

```bash
bash rerere.sh
```

You will be prompted to press a key at various steps to observe the process.


## Prerequisites

- Bash shell
- Git installed


