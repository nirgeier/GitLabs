#!/bin/bash

clear

cd "$(dirname "$0")"
SCRIPT_DIR="$(pwd)"

# Load the colors script
source ../_utils/colors.sh
source ../_utils/utils.sh

# The demo file name which we will use
FILE_NAME=demo-file.txt

git config --local rerere.enabled false
echo -e "${CYAN}* Creating demo repository ${NO_COLOR}"

### Build the repo for bisect
rm -rf  rerere-demo
mkdir   rerere-demo
cd      rerere-demo

echo -e "${CYAN}* Initialize demo repository ${NO_COLOR}"
git init  --quiet
git commit --allow-empty -m "Initial commit" --quiet

## Get the current branch name
BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)

echo -e "${CYAN}* Creating second branch [${YELLOW}demo-branch${CYAN}] ${NO_COLOR}"
git branch demo-branch --quiet

### Working on main branch
# Creating shared file which will be merged
echo -e "${CYAN}* Creating shared file which will be merged [${YELLOW}shared-file.txt${CYAN}] ${NO_COLOR}"
echo -e "Line from ${BRANCH_NAME}"      > demo-file.txt

echo -e "Content of the demo file: [${YELLOW}${BRANCH_NAME} - demo-file.txt ${NO_COLOR}]"
echo -e "${RED}----- [cat demo-file.txt] ----- ${NO_COLOR}"
cat demo-file.txt
echo -e "${RED}-------------------------------${NO_COLOR}"

echo -e "${CYAN}* Adding repository content ${NO_COLOR}"
git add . 

echo -e "${CYAN}* Commit changes to [${YELLOW}${BRANCH_NAME}${CYAN}] ${NO_COLOR}"
git commit -m 'Commit changes' --quiet

echo -e "${CYAN}* Switching to ${YELLOW}demo-branch${CYAN} branch ${NO_COLOR}"
### Working on side branch
git checkout demo-branch --quiet

# Get the current branch name
BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)

# Createing shared file which will be merged
echo -e "${CYAN}* Createing shared file which will be merged [${YELLOW}shared-file.txt${CYAN}] ${NO_COLOR}"
echo -e "Line from ${BRANCH_NAME}"      > demo-file.txt

echo -e "Content of the demo file: [${YELLOW}${BRANCH_NAME} - demo-file.txt ${NO_COLOR}]"
echo -e "${RED}----- [cat demo-file.txt] ----- ${NO_COLOR}"
cat demo-file.txt
echo -e "${RED}-------------------------------${NO_COLOR}"

echo -e "${CYAN}* Adding repository content ${NO_COLOR}"
git add . 

echo -e "${CYAN}* Commit changes to [${YELLOW}${BRANCH_NAME}${CYAN}] ${NO_COLOR}"
git commit -m 'Commit changes' --quiet

echo -e "${CYAN}* Setting config ${YELLOW}rerere.enabled ${NO_COLOR}=${GREEN}'true' ${NO_COLOR}"
###
### This is the heart of this demo
### Unmark this line to see it in action
###
git config --global rerere.enabled true

echo -e "${CYAN}* Current branch: [${YELLOW}${BRANCH_NAME}${CYAN}] ${NO_COLOR}"
echo -e "${CYAN}   * Current commit [$(git rev-parse HEAD)]${NO_COLOR}"

echo -e "${CYAN}* Merging from second branch into [${YELLOW}${BRANCH_NAME}${CYAN}] ${NO_COLOR}"
echo -e "${RED}---------------------------------------------------------------- ${NO_COLOR}"
git merge -
echo -e "${RED}---------------------------------------------------------------- ${NO_COLOR}"

exit;
### Demo - manual demo
# https://stackoverflow.com/questions/35415925/is-it-possible-to-setup-git-merge-for-automatic-resolving-git-rerere/35417944#35417944

echo -e "${CYAN}* Resolving conflict & commiting it ${NO_COLOR}"
echo 'Resolution' > demo-file.txt
git add .
git commit -q -m "Resolved conflict"

echo -e "${YELLOW}* Revert back to the commit before the resolution ${NO_COLOR}"
git reset HEAD~1 --hard

echo -e "${CYAN}* Merging from second branch into [${YELLOW}${BRANCH_NAME}${CYAN}] ${NO_COLOR}"
echo -e "${RED}---------------------------------------------------------------- ${NO_COLOR}"
git merge -
echo -e "${RED}---------------------------------------------------------------- ${NO_COLOR}"

echo -e "${CYAN}* Content of the resolved file ${NO_COLOR}"
cat demo-file.txt
git status
