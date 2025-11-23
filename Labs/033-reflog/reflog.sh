#!/bin/bash

# This script demonstrates Git reflog to recover lost commits and undo mistakes by creating scenarios with resets, deleted branches, and rebases.

clear

# Set the number of the desired commits
NUMBER_OF_COMMITS=10

# Load the colors script
ROOT_FOLDER=$(git rev-parse --show-toplevel)
source ${ROOT_FOLDER}/_utils/colors.sh
source ${ROOT_FOLDER}/_utils/utils.sh

# Set the script directory
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

echo -e "${CYAN}=== Git Reflog Demo ===${NO_COLOR}"
echo -e ""

# Create the repository
echo -e "${CYAN}* Creating demo repository with ${YELLOW}$NUMBER_OF_COMMITS${CYAN} commits${NO_COLOR}"
generate_repository $NUMBER_OF_COMMITS

echo -e ""
echo -e "${CYAN}* Showing current reflog${NO_COLOR}"
echo -e "${PURPLE}  $ git reflog${NO_COLOR}"
git reflog | head -5

echo -e ""
echo -e "${RED}>>> Press any key to continue${NO_COLOR}"
read -t 600 -n 1

# Scenario 1: Accidental hard reset
echo -e ""
echo -e "${YELLOW}=== Scenario 1: Accidental Hard Reset ===${NO_COLOR}"
echo -e "${CYAN}* Current HEAD: ${GREEN}$(git rev-parse --short HEAD)${NO_COLOR}"

echo -e "${CYAN}* Performing hard reset to 5 commits back${NO_COLOR}"
echo -e "${PURPLE}  $ git reset --hard HEAD~5${NO_COLOR}"
BEFORE_RESET=$(git rev-parse HEAD)
git reset --hard HEAD~5 --quiet

echo -e "${CYAN}* After reset HEAD: ${GREEN}$(git rev-parse --short HEAD)${NO_COLOR}"
echo -e "${RED}* Lost 5 commits!${NO_COLOR}"

echo -e ""
echo -e "${RED}>>> Press any key to recover${NO_COLOR}"
read -t 600 -n 1

echo -e ""
echo -e "${CYAN}* Checking reflog to find lost commits${NO_COLOR}"
echo -e "${PURPLE}  $ git reflog${NO_COLOR}"
git reflog | head -5

echo -e ""
echo -e "${CYAN}* Recovering lost commits${NO_COLOR}"
echo -e "${PURPLE}  $ git reset --hard HEAD@{1}${NO_COLOR}"
git reset --hard HEAD@{1} --quiet

echo -e "${GREEN}* Recovered! HEAD: $(git rev-parse --short HEAD)${NO_COLOR}"

echo -e ""
echo -e "${RED}>>> Press any key to continue to next scenario${NO_COLOR}"
read -t 600 -n 1

# Scenario 2: Deleted branch recovery
echo -e ""
echo -e "${YELLOW}=== Scenario 2: Recover Deleted Branch ===${NO_COLOR}"
echo -e "${CYAN}* Creating feature branch${NO_COLOR}"
echo -e "${PURPLE}  $ git checkout -b feature-branch${NO_COLOR}"
git checkout -b feature-branch --quiet

echo -e "${CYAN}* Adding commits to feature branch${NO_COLOR}"
for i in {1..3}; do
    echo "Feature $i" >> feature.txt
    git add .
    git commit -m "Feature commit $i" --quiet
done
FEATURE_COMMIT=$(git rev-parse HEAD)

echo -e "${CYAN}* Switching back to main${NO_COLOR}"
git checkout main --quiet

echo -e ""
echo -e "${RED}* Accidentally deleting feature branch${NO_COLOR}"
echo -e "${PURPLE}  $ git branch -D feature-branch${NO_COLOR}"
git branch -D feature-branch

echo -e "${RED}* Branch deleted!${NO_COLOR}"
echo -e "${PURPLE}  $ git branch${NO_COLOR}"
git branch

echo -e ""
echo -e "${RED}>>> Press any key to recover branch${NO_COLOR}"
read -t 600 -n 1

echo -e ""
echo -e "${CYAN}* Finding deleted branch in reflog${NO_COLOR}"
echo -e "${PURPLE}  $ git reflog | grep 'feature-branch'${NO_COLOR}"
git reflog | grep 'feature-branch' | head -3

echo -e ""
echo -e "${CYAN}* Recovering branch from reflog${NO_COLOR}"
echo -e "${PURPLE}  $ git branch feature-branch ${FEATURE_COMMIT}${NO_COLOR}"
git branch feature-branch ${FEATURE_COMMIT}

echo -e "${GREEN}* Branch recovered!${NO_COLOR}"
echo -e "${PURPLE}  $ git branch${NO_COLOR}"
git branch

echo -e ""
echo -e "${RED}>>> Press any key to continue${NO_COLOR}"
read -t 600 -n 1

# Scenario 3: Time-based reflog access
echo -e ""
echo -e "${YELLOW}=== Scenario 3: Time-Based Reflog Access ===${NO_COLOR}"
echo -e "${CYAN}* Viewing reflog with timestamps${NO_COLOR}"
echo -e "${PURPLE}  $ git reflog show --date=iso${NO_COLOR}"
git reflog show --date=iso | head -10

echo -e ""
echo -e "${CYAN}* Accessing HEAD from 5 operations ago${NO_COLOR}"
echo -e "${PURPLE}  $ git show HEAD@{5} --stat${NO_COLOR}"
git show HEAD@{5} --stat 2>/dev/null || echo -e "${RED}Not enough reflog entries${NO_COLOR}"

echo -e ""
echo -e "${GREEN}=== Reflog Demo Complete ===${NO_COLOR}"
echo -e "${YELLOW}Key Takeaways:${NO_COLOR}"
echo -e "  1. Reflog tracks all HEAD movements"
echo -e "  2. Lost commits can be recovered"
echo -e "  3. Deleted branches can be restored"
echo -e "  4. Time-based access available"
echo -e "  5. Reflog is your safety net!"
