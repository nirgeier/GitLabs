#!/bin/bash

# This script demonstrates Git rerere (reuse recorded resolution) to automatically resolve recurring merge conflicts.

clear
# Load the colors script
ROOT_FOLDER=$(git rev-parse --show-toplevel)
source ${ROOT_FOLDER}/_utils/colors.sh
source ${ROOT_FOLDER}/_utils/utils.sh

# The demo file name which we will use
FILE_NAME=demo-file.txt

git config --local rerere.enabled false
echo -e "${CYAN}* Creating demo repository ${NO_COLOR}"

### Build the repo for bisect
rm -rf  /tmp/rerere-demo
mkdir   /tmp/rerere-demo
cd      /tmp/rerere-demo

echo -e "${CYAN}* Initialize demo repository ${NO_COLOR}"
git init  --quiet
git commit --allow-empty -m "Initial commit" --quiet

## Get the current branch name
BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)

echo -e "${CYAN}* Creating second branch [${YELLOW}demo-branch${CYAN}] ${NO_COLOR}"
git branch demo-branch --quiet

###
###
### Working on main branch
###
###
### Creating shared file which will be merged
echo -e "${CYAN}* Creating shared file which will be merged [${YELLOW}${FILE_NAME}${CYAN}] ${NO_COLOR}"

# Add text to the file
echo -e "Line from ${BRANCH_NAME}"      > ${FILE_NAME}

echo -e "${GREEN}Content of the demo file: [${YELLOW}${BRANCH_NAME} - ${FILE_NAME}} ${NO_COLOR}]"
echo -e "${GREEN}----- [${YELLOW}${BRANCH_NAME} - ${FILE_NAME}} ${GREEN}] ----- ${NO_COLOR}"
cat ${FILE_NAME}
echo -e "${GREEN}-----------------------------------${NO_COLOR}"

echo -e "${CYAN}* Adding repository content ${NO_COLOR}"
git add . 

echo -e "${CYAN}* Commit changes to [${YELLOW}${BRANCH_NAME}${CYAN}] ${NO_COLOR}"
git commit -m 'Commit changes' --quiet

echo -e "${GREEN}Press any key to continue...${NO_COLOR}"
echo -e ""
read -t 120

###
###
### Working on side branch
###
###
echo -e "${CYAN}* Switching to ${YELLOW}demo-branch${CYAN} branch ${NO_COLOR}"
git checkout demo-branch --quiet

# Get the current branch name
BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)

# Creating shared file which will be merged
echo -e "${CYAN}* Creating shared file which will be merged [${YELLOW}${FILE_NAME}${CYAN}] ${NO_COLOR}"
echo -e "Line from ${BRANCH_NAME}"      > ${FILE_NAME}

echo -e "Content of the demo file: [${YELLOW}${BRANCH_NAME} - ${FILE_NAME}} ${NO_COLOR}]"
echo -e "${GREEN}----- [cat ${FILE_NAME}] ----- ${NO_COLOR}"
cat ${FILE_NAME}
echo -e "${GREEN}-------------------------------${NO_COLOR}"

echo -e "${CYAN}* Adding repository content ${NO_COLOR}"
git add . 

echo -e "${CYAN}* Commit changes to [${YELLOW}${BRANCH_NAME}${CYAN}] ${NO_COLOR}"
git commit -m 'Commit changes' --quiet

echo -e "${GREEN}Press any key to continue...${NO_COLOR}"
echo -e ""
read -t 120

###
###
### This is the heart of this demo
### 
###
echo -e "${CYAN}* Setting config ${YELLOW}rerere.enabled ${NO_COLOR}=${GREEN}'true' ${NO_COLOR}"
git config --local rerere.enabled true

echo -e "${CYAN}* Current branch: [${YELLOW}${BRANCH_NAME}${CYAN}] ${NO_COLOR}"
echo -e "${CYAN}   * Current commit [$(git rev-parse HEAD)]${NO_COLOR}"

echo -e "${CYAN}* Merging from second branch into [${YELLOW}${BRANCH_NAME}${CYAN}] ${NO_COLOR}"
echo -e "${GREEN}---------------------------------------------------------------- ${NO_COLOR}"
git merge -
echo -e "${GREEN}---------------------------------------------------------------- ${NO_COLOR}"

echo -e ""

echo -e "${GREEN}----- [cat ${FILE_NAME}] ----- ${NO_COLOR}"
cat ${FILE_NAME}
echo -e "${GREEN}-------------------------------${NO_COLOR}"

echo -e "${GREEN}Press any key to continue...${NO_COLOR}"
echo -e ""
read -t 120

###
###
### Now we have a conflict, let's resolve it manually
###
### Demo - manual demo
### https://stackoverflow.com/questions/35415925/is-it-possible-to-setup-git-merge-for-automatic-resolving-git-rerere/35417944#35417944

echo -e "${CYAN}* Resolving conflict & committing it ${NO_COLOR}"
echo 'Resolution' > ${FILE_NAME}
git add .
git commit -q -m "Resolved conflict"

echo -e "${GREEN}----- [cat ${FILE_NAME}] ----- ${NO_COLOR}"
cat ${FILE_NAME}
echo -e "${GREEN}-------------------------------${NO_COLOR}"
echo -e ""

echo -e "${GREEN}Press any key to continue...${NO_COLOR}"
echo -e ""
read -t 120

###
###
### Revetting back to the commit before the resolution 
### So we can see how rerere works
### 
### 

echo -e "${YELLOW}* Revert back to the commit before the resolution ${NO_COLOR}"
git reset HEAD~1 --hard

echo -e "${GREEN}----- [cat ${FILE_NAME}] ----- ${NO_COLOR}"
cat ${FILE_NAME}
echo -e "${GREEN}-------------------------------${NO_COLOR}"
echo -e ""


echo -e "${CYAN}* Merging from second branch into [${YELLOW}${BRANCH_NAME} - (git merge -)${CYAN}] ${NO_COLOR}"
echo -e "${GREEN}---------------------------------------------------------------- ${NO_COLOR}"
git merge -
echo -e "${GREEN}---------------------------------------------------------------- ${NO_COLOR}"
echo -e ""

echo -e "${CYAN}* Content of the resolved file ${NO_COLOR}"
echo -e "${GREEN}----- [cat ${FILE_NAME}] ----- ${NO_COLOR}"
cat ${FILE_NAME}
echo -e "${GREEN}-------------------------------${NO_COLOR}"
echo -e ""

git status
