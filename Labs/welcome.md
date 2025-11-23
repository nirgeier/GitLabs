
<div markdown class="center">
# Git Labs

<img src="https://raw.githubusercontent.com/nirgeier/labs-assets/main/assets/images/code-wizard-training.png" >
</div>

---

<img src="../assets/images/tldr.png" style="width:100px; border-radius: 10px; box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);">

for dir in */; do file=$(ls "$dir"*.sh 2>/dev/null | head -1); if [ -n "$file" ]; then echo "### ${dir%/}"; head -10 "$file" 2>/dev/null | grep -E "^#|echo" | head -3; fi; done! success "Getting Started Tip"
    Each lab is self-contained with demo scripts. Simply navigate to the lab folder and run the script to see Git features in action.

## Intro

- This tutorial is for teaching Git through hands-on labs designed as practical exercises.
- Each lab is packaged in its own folder and includes demo scripts and assets required to understand advanced Git features.
- Every lab folder includes a \`README\` that describes the lab's objectives, concepts, and hands-on demonstrations.
- The Git Labs are a series of Git exercises designed to teach advanced Git skills & features.
- The inspiration for this project is to provide practical learning experiences for Git power users.

## Pre-Requirements

- This tutorial will test your \`Git\` and command-line skills.
- You should be familiar with the following topics:
  - Basic Git commands (\`add\`, \`commit\`, \`push\`, \`pull\`)
  - Basic Linux/command line navigation
  - Understanding of version control concepts
- For advanced Labs:
  - Git internals (objects, refs, HEAD)
  - Branching and merging strategies

## Usage

- Each lab contains demo scripts (\`.sh\` files) that demonstrate the Git feature
- Simply navigate to a lab folder and execute the script:

  \`\`\`bash
  cd Labs/001-smudge-clean
  ./demo.sh
  \`\`\`

- Some labs may require additional setup - check each lab's README for specific requirements

---

for dir in */; do file=$(ls "$dir"*.sh 2>/dev/null | head -1); if [ -n "$file" ]; then echo "### ${dir%/}"; head -10 "$file" 2>/dev/null | grep -E "^#|echo" | head -3; fi; done! warning ""
    - Ensure you have Git installed on your system
    - Some labs may modify your git configuration temporarily
    - Enjoy, and don't forget to star the project on GitHub!

## Preface

### What is Git?

- \`Git\` is a distributed version control system designed to handle everything from small to very large projects with speed and efficiency.
- \`Git\` was created by Linus Torvalds in 2005 for development of the Linux kernel.
- Git tracks changes in source code during software development, enabling multiple developers to work together on non-linear development.
- The most powerful feature of \`Git\` is its branching model, which allows for isolated development and experimentation.
- \`Git\` is used by millions of developers worldwide and is the foundation of platforms like GitHub, GitLab, and Bitbucket.

### How Git Works?

- Git is a \`distributed version control system\`.
- Every Git directory on every computer is a full-fledged repository with complete history and full version-tracking capabilities.
- Git stores data as snapshots of the project over time, not as file-based changes.
- Each commit in Git represents a snapshot of all files at that point in time.
- Git uses SHA-1 hashing to ensure integrity of data.

---

### Git Object Model

- Git's core is a simple key-value data store where you can insert any kind of content and get back a unique key.

<div class="grid cards" markdown>

- #### Blob Objects

  - Store file content
  - No filename or directory structure
  - Just raw file data

- #### Tree Objects

  - Represent directories
  - Store filenames and references to blobs
  - Can reference other tree objects

- #### Commit Objects

  - Point to a tree object (snapshot)
  - Include author, committer, message
  - Reference parent commit(s)

- #### Tag Objects

  - Reference specific commits
  - Can be lightweight or annotated
  - Often used for releases

</div>

- Understanding these objects is crucial for mastering advanced Git techniques covered in these labs.

