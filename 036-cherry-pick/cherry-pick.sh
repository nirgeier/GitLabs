#!/bin/bash

# This script demonstrates Git cherry-pick by creating branches with different commits and selectively applying specific commits between branches.

clear

# Set the number of the desired commits
NUMBER_OF_COMMITS=8

# Load the colors script
ROOT_FOLDER=$(git rev-parse --show-toplevel)
source ${ROOT_FOLDER}/_utils/colors.sh
source ${ROOT_FOLDER}/_utils/utils.sh

# Set the script directory
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

echo -e "${CYAN}=== Git Cherry-Pick Demo ===${NO_COLOR}"
echo -e ""

# Create the repository
echo -e "${CYAN}* Creating demo repository${NO_COLOR}"
generate_repository $NUMBER_OF_COMMITS

echo -e ""
echo -e "${CYAN}* Creating feature branch with specific commits${NO_COLOR}"
git checkout -b feature-branch --quiet

# Add feature commits
for i in {1..4}; do
    echo "Feature $i" >> feature.txt
    git add .
    git commit -m "Feature $i: Add feature functionality" --quiet
done

FEATURE_COMMIT_2=$(git log --format="%H" --skip=2 -n 1)
FEATURE_COMMIT_3=$(git log --format="%H" --skip=1 -n 1)

echo -e "${GREEN}* Added 4 feature commits${NO_COLOR}"
echo -e "${PURPLE}  $ git log --oneline${NO_COLOR}"
git log --oneline -4

echo -e ""
echo -e "${RED}>>> Press any key to cherry-pick single commit${NO_COLOR}"
read -t 600 -n 1

# Cherry-pick single commit
echo -e ""
echo -e "${YELLOW}=== Cherry-Pick Single Commit ===${NO_COLOR}"
echo -e "${CYAN}* Switching to main branch${NO_COLOR}"
git checkout main --quiet

echo -e "${CYAN}* Current commits on main:${NO_COLOR}"
echo -e "${PURPLE}  $ git log --oneline -3${NO_COLOR}"
git log --oneline -3

echo -e ""
echo -e "${CYAN}* Cherry-picking Feature 2 commit from feature-branch${NO_COLOR}"
echo -e "${PURPLE}  $ git cherry-pick ${FEATURE_COMMIT_2:0:7}${NO_COLOR}"
git cherry-pick $FEATURE_COMMIT_2 --quiet

echo -e "${GREEN}* Cherry-pick successful!${NO_COLOR}"
echo -e "${CYAN}* Updated commits on main:${NO_COLOR}"
echo -e "${PURPLE}  $ git log --oneline -4${NO_COLOR}"
git log --oneline -4

echo -e ""
echo -e "${RED}>>> Press any key to cherry-pick with reference${NO_COLOR}"
read -t 600 -n 1

# Cherry-pick with -x flag
echo -e ""
echo -e "${YELLOW}=== Cherry-Pick with Reference (-x) ===${NO_COLOR}"
echo -e "${CYAN}* Cherry-picking with -x flag for traceability${NO_COLOR}"
echo -e "${PURPLE}  $ git cherry-pick -x ${FEATURE_COMMIT_3:0:7}${NO_COLOR}"
git cherry-pick -x $FEATURE_COMMIT_3 --quiet

echo -e "${GREEN}* Cherry-pick with reference complete${NO_COLOR}"
echo -e "${CYAN}* Checking commit message:${NO_COLOR}"
echo -e "${PURPLE}  $ git log -1${NO_COLOR}"
git log -1 --format="%B" | head -5

echo -e ""
echo -e "${RED}>>> Press any key to demonstrate conflict resolution${NO_COLOR}"
read -t 600 -n 1

# Create conflict scenario
echo -e ""
echo -e "${YELLOW}=== Cherry-Pick with Conflict ===${NO_COLOR}"
echo -e "${CYAN}* Creating conflicting change on main${NO_COLOR}"
echo "Main branch change" > conflict.txt
git add conflict.txt
git commit -m "Add conflict.txt on main" --quiet

echo -e "${CYAN}* Creating conflicting change on feature-branch${NO_COLOR}"
git checkout feature-branch --quiet
echo "Feature branch change" > conflict.txt
git add conflict.txt
git commit -m "Add conflict.txt on feature" --quiet
CONFLICT_COMMIT=$(git rev-parse HEAD)

echo -e ""
echo -e "${CYAN}* Switching back to main and attempting cherry-pick${NO_COLOR}"
git checkout main --quiet
echo -e "${PURPLE}  $ git cherry-pick ${CONFLICT_COMMIT:0:7}${NO_COLOR}"

if git cherry-pick $CONFLICT_COMMIT 2>&1 | grep -q "CONFLICT"; then
    echo -e "${RED}* Conflict detected!${NO_COLOR}"
    echo -e "${PURPLE}  $ git status${NO_COLOR}"
    git status -s
    
    echo -e ""
    echo -e "${CYAN}* Resolving conflict (keeping both changes)${NO_COLOR}"
    cat > conflict.txt << 'EOF'
Main branch change
Feature branch change
EOF
    
    git add conflict.txt
    echo -e "${PURPLE}  $ git cherry-pick --continue${NO_COLOR}"
    git cherry-pick --continue --no-edit
    
    echo -e "${GREEN}* Conflict resolved and cherry-pick completed${NO_COLOR}"
fi

echo -e ""
echo -e "${RED}>>> Press any key to cherry-pick range${NO_COLOR}"
read -t 600 -n 1

# Cherry-pick range
echo -e ""
echo -e "${YELLOW}=== Cherry-Pick Commit Range ===${NO_COLOR}"
echo -e "${CYAN}* Creating new branch for range demo${NO_COLOR}"
git checkout -b backport-branch --quiet

# Create base commits
for i in {1..3}; do
    echo "Base $i" >> base.txt
    git add .
    git commit -m "Base commit $i" --quiet
done

echo -e "${CYAN}* Creating hotfix branch with multiple fixes${NO_COLOR}"
git checkout -b hotfix --quiet
RANGE_START=$(git rev-parse HEAD)

for i in {1..3}; do
    echo "Hotfix $i" >> hotfix.txt
    git add .
    git commit -m "Hotfix $i" --quiet
done
RANGE_END=$(git rev-parse HEAD)

echo -e "${PURPLE}  $ git log --oneline -3${NO_COLOR}"
git log --oneline -3

echo -e ""
echo -e "${CYAN}* Cherry-picking range of commits${NO_COLOR}"
git checkout backport-branch --quiet
echo -e "${PURPLE}  $ git cherry-pick ${RANGE_START:0:7}..${RANGE_END:0:7}${NO_COLOR}"
git cherry-pick ${RANGE_START}..${RANGE_END} --quiet

echo -e "${GREEN}* Range cherry-pick complete${NO_COLOR}"
echo -e "${CYAN}* All commits now on backport-branch:${NO_COLOR}"
echo -e "${PURPLE}  $ git log --oneline -6${NO_COLOR}"
git log --oneline -6

echo -e ""
echo -e "${YELLOW}=== Cherry-Pick Without Committing ===${NO_COLOR}"
git checkout main --quiet

echo -e "${CYAN}* Cherry-picking without auto-commit (-n flag)${NO_COLOR}"
git checkout -b staging --quiet
echo "Change" >> staged.txt
git add staged.txt
git commit -m "Change to pick" --quiet
STAGE_COMMIT=$(git rev-parse HEAD)

git checkout main --quiet
echo -e "${PURPLE}  $ git cherry-pick -n ${STAGE_COMMIT:0:7}${NO_COLOR}"
git cherry-pick -n $STAGE_COMMIT --quiet

echo -e "${GREEN}* Changes staged but not committed${NO_COLOR}"
echo -e "${PURPLE}  $ git status -s${NO_COLOR}"
git status -s

echo -e ""
echo -e "${CYAN}* Making additional modifications before committing${NO_COLOR}"
echo "Additional change" >> staged.txt
git add staged.txt

echo -e "${PURPLE}  $ git commit -m 'Cherry-picked with modifications'${NO_COLOR}"
git commit -m "Cherry-picked with modifications" --quiet

echo -e "${GREEN}* Modified cherry-pick committed${NO_COLOR}"

echo -e ""
echo -e "${GREEN}=== Cherry-Pick Demo Complete ===${NO_COLOR}"
echo -e "${YELLOW}Key Takeaways:${NO_COLOR}"
echo -e "  1. Cherry-pick applies specific commits to current branch"
echo -e "  2. Use -x to reference original commit"
echo -e "  3. Conflicts resolved same as merge conflicts"
echo -e "  4. Can pick ranges with start..end"
echo -e "  5. Use -n to stage without committing"
echo -e "  6. Perfect for backporting fixes"
