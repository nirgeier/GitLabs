#!/bin/bash

# This script demonstrates Git maintenance commands by showing garbage collection, repository verification, pruning, and optimization tasks.

clear

# Load the colors script
ROOT_FOLDER=$(git rev-parse --show-toplevel)
source ${ROOT_FOLDER}/_utils/colors.sh
source ${ROOT_FOLDER}/_utils/utils.sh

echo -e "${CYAN}=== Git Maintenance Demo ===${NO_COLOR}"
echo -e ""

# Create temporary directory for demo
DEMO_DIR="/tmp/git-maintenance-demo"
rm -rf $DEMO_DIR
mkdir -p $DEMO_DIR
cd $DEMO_DIR

# Create repository
echo -e "${CYAN}* Creating demo repository${NO_COLOR}"
mkdir repo
cd repo
git init --quiet

# Add initial commits with some content
for i in {1..20}; do
    echo "Content for commit $i" > file$i.txt
    git add .
    git commit -m "Commit $i" --quiet
done

echo -e "${GREEN}* Repository created with 20 commits${NO_COLOR}"

echo -e ""
echo -e "${RED}>>> Press any key to check repository status${NO_COLOR}"
read -t 600 -n 1

# Check initial repository stats
echo -e ""
echo -e "${YELLOW}=== Repository Statistics ===${NO_COLOR}"
echo -e "${CYAN}* Counting objects${NO_COLOR}"
echo -e "${PURPLE}  $ git count-objects -v${NO_COLOR}"
git count-objects -v

echo -e ""
echo -e "${CYAN}* Repository size:${NO_COLOR}"
du -sh .git | awk '{print "  " $1}'

echo -e ""
echo -e "${RED}>>> Press any key to create loose objects${NO_COLOR}"
read -t 600 -n 1

# Create loose objects
echo -e ""
echo -e "${YELLOW}=== Creating Loose Objects ===${NO_COLOR}"
echo -e "${CYAN}* Creating and removing files to generate loose objects${NO_COLOR}"

for i in {1..10}; do
    echo "Temporary file $i with some content" > temp$i.txt
    git add temp$i.txt
    git commit -m "Add temp$i" --quiet
    git rm temp$i.txt --quiet
    git commit -m "Remove temp$i" --quiet
done

echo -e "${GREEN}* Created 10 files and removed them${NO_COLOR}"

echo -e ""
echo -e "${CYAN}* Updated object count:${NO_COLOR}"
echo -e "${PURPLE}  $ git count-objects -v${NO_COLOR}"
git count-objects -v

echo -e ""
echo -e "${RED}>>> Press any key to run garbage collection${NO_COLOR}"
read -t 600 -n 1

# Run garbage collection
echo -e ""
echo -e "${YELLOW}=== Running Garbage Collection ===${NO_COLOR}"
echo -e "${CYAN}* Running git gc${NO_COLOR}"
echo -e "${PURPLE}  $ git gc${NO_COLOR}"
git gc 2>&1

echo -e "${GREEN}* Garbage collection complete${NO_COLOR}"

echo -e ""
echo -e "${CYAN}* After gc object count:${NO_COLOR}"
echo -e "${PURPLE}  $ git count-objects -v${NO_COLOR}"
git count-objects -v

echo -e ""
echo -e "${RED}>>> Press any key to verify repository${NO_COLOR}"
read -t 600 -n 1

# Verify repository
echo -e ""
echo -e "${YELLOW}=== Repository Verification ===${NO_COLOR}"
echo -e "${CYAN}* Running fsck to verify integrity${NO_COLOR}"
echo -e "${PURPLE}  $ git fsck${NO_COLOR}"

FSCK_OUTPUT=$(git fsck 2>&1)
if [ -z "$FSCK_OUTPUT" ]; then
    echo -e "${GREEN}* Repository is healthy - no issues found${NO_COLOR}"
else
    echo "$FSCK_OUTPUT" | head -10
fi

echo -e ""
echo -e "${RED}>>> Press any key to demonstrate pruning${NO_COLOR}"
read -t 600 -n 1

# Demonstrate pruning
echo -e ""
echo -e "${YELLOW}=== Pruning Unreachable Objects ===${NO_COLOR}"

echo -e "${CYAN}* Creating orphaned commits${NO_COLOR}"
git checkout -b temp-branch --quiet
for i in {1..3}; do
    echo "Orphan $i" > orphan$i.txt
    git add orphan$i.txt
    git commit -m "Orphan commit $i" --quiet
done

echo -e "${CYAN}* Deleting branch (orphaning commits)${NO_COLOR}"
git checkout main --quiet 2>/dev/null || git checkout master --quiet
git branch -D temp-branch

echo -e ""
echo -e "${CYAN}* Checking for unreachable objects${NO_COLOR}"
echo -e "${PURPLE}  $ git fsck --unreachable${NO_COLOR}"
UNREACHABLE=$(git fsck --unreachable 2>&1 | grep "unreachable commit" | wc -l)
echo -e "${YELLOW}* Found $UNREACHABLE unreachable commit(s)${NO_COLOR}"

echo -e ""
echo -e "${CYAN}* Running prune (dry-run first)${NO_COLOR}"
echo -e "${PURPLE}  $ git prune --dry-run --verbose${NO_COLOR}"
git prune --dry-run --verbose 2>&1 | head -5

echo -e ""
echo -e "${CYAN}* Actually pruning unreachable objects${NO_COLOR}"
echo -e "${PURPLE}  $ git prune --verbose${NO_COLOR}"
git prune --verbose 2>&1 | head -5

echo -e "${GREEN}* Prune complete${NO_COLOR}"

echo -e ""
echo -e "${RED}>>> Press any key to optimize repository${NO_COLOR}"
read -t 600 -n 1

# Repository optimization
echo -e ""
echo -e "${YELLOW}=== Repository Optimization ===${NO_COLOR}"

echo -e "${CYAN}* Repacking objects${NO_COLOR}"
echo -e "${PURPLE}  $ git repack -a -d${NO_COLOR}"
git repack -a -d 2>&1 | grep -v "^$"

echo -e "${GREEN}* Repack complete${NO_COLOR}"

echo -e ""
echo -e "${CYAN}* Packing references${NO_COLOR}"
echo -e "${PURPLE}  $ git pack-refs --all${NO_COLOR}"
git pack-refs --all

echo -e "${GREEN}* References packed${NO_COLOR}"

echo -e ""
echo -e "${CYAN}* Final object count:${NO_COLOR}"
echo -e "${PURPLE}  $ git count-objects -v${NO_COLOR}"
git count-objects -v

echo -e ""
echo -e "${CYAN}* Final repository size:${NO_COLOR}"
du -sh .git | awk '{print "  " $1}'

echo -e ""
echo -e "${YELLOW}=== Maintenance Commands Reference ===${NO_COLOR}"
echo -e "${CYAN}* git maintenance start${NO_COLOR}"
echo -e "  Enable background maintenance (requires Git 2.30+)"
echo -e ""
echo -e "${CYAN}* git gc --auto${NO_COLOR}"
echo -e "  Automatic garbage collection (runs when needed)"
echo -e ""
echo -e "${CYAN}* git gc --aggressive --prune=now${NO_COLOR}"
echo -e "  Aggressive cleanup (slower but thorough)"

echo -e ""
echo -e "${GREEN}=== Maintenance Demo Complete ===${NO_COLOR}"
echo -e "${YELLOW}Key Takeaways:${NO_COLOR}"
echo -e "  1. git gc consolidates and optimizes objects"
echo -e "  2. git fsck verifies repository integrity"
echo -e "  3. git prune removes unreachable objects"
echo -e "  4. git repack optimizes object storage"
echo -e "  5. Regular maintenance keeps repos healthy"
echo -e "  6. Use --auto for automatic optimization"
