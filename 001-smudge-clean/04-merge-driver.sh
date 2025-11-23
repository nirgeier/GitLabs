#!/bin/bash

# This script demonstrates Git's 'ours' merge strategy, which resolves conflicts by always taking the current branch's version.

clear
# Load the colors script
# Get the root folder of our demo folder
ROOT_FOLDER=$(git rev-parse --show-toplevel)
source ${ROOT_FOLDER}/_utils/colors.sh
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# Set the driver name and script
FILE_NAME=version.txt
DRIVER_NAME=ours

### Function to commit changes to a given branch
function commitChanges() {
  
  BRANCH_NAME=$1
  
  git checkout $BRANCH_NAME --quiet
  echo -e "${CYAN}* Creating content in [${YELLOW}${BRANCH_NAME}${CYAN}]${NO_COLOR}"

  echo "v1.0.0-$BRANCH_NAME" > $FILE_NAME
  echo -e "${CYAN}* Content of ${GREEN}[${BRANCH_NAME}:${YELLOW}$FILE_NAME${CYAN}]${NO_COLOR}"
  echo -e "${YELLOW}    $(cat $FILE_NAME)${NO_COLOR}"

  echo -e "${CYAN}* Committing changes  [${YELLOW}${BRANCH_NAME}${CYAN}]${NO_COLOR}"
  git add .
  git commit -m"Commit in: ${BRANCH_NAME}" --quiet

}

### Create the demo repository
echo -e "${CYAN}* Creating demo repository${NO_COLOR}"
rm -rf      /tmp/demo-smudge-merge-custom
mkdir -p    /tmp/demo-smudge-merge-custom
cd          /tmp/demo-smudge-merge-custom
git init  --quiet
git commit --allow-empty -m "Initial commit" --quiet

echo -e "${PURPLE}--------------------------------------------------------${NO_COLOR}"
echo -e "${PURPLE}Setting the configuration to use the desired driver${NO_COLOR}"
echo -e "${YELLOW}git config ${GREEN}merge.$DRIVER_NAME.driver true${GREEN}${NO_COLOR}"
git config merge.$DRIVER_NAME.driver true
echo -e "${PURPLE}--------------------------------------------------------${NO_COLOR}"

echo -e "${CYAN}* Mark the file which we wish to set merge strategies for [${YELLOW}$FILE_NAME${CYAN}]${NO_COLOR}"
echo -e "${GREEN}    echo '$FILE_NAME merge=$DRIVER_NAME' >> .gitattributes${NO_COLOR}"
echo "$FILE_NAME merge=$DRIVER_NAME" >> .gitattributes

echo -e "${CYAN}* Adding the custom driver to the ${YELLOW}.gitattributes${NO_COLOR}"
echo "$FILE_NAME merge=${DRIVER_NAME}" > .gitattributes
echo -e "${CYAN}* Content of ${YELLOW}.gitattributes${NO_COLOR}"
echo -e "${PURPLE}    $(cat .gitattributes)${NO_COLOR}"

# Wait for user input to continue (max timeout 600 seconds)
echo -e "${RED}>>> Press any key to continue${NO_COLOR}"
read -t 600 -n 1

## Get the current branch name
BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)

echo "v1.0.0-$BRANCH_NAME" > $FILE_NAME
echo -e "${CYAN}* Content of ${GREEN}[${YELLOW}$FILE_NAME${CYAN}]${NO_COLOR}"
echo -e "${YELLOW}    $(cat $FILE_NAME)${NO_COLOR}"

echo -e "${CYAN}* Committing changes${NO_COLOR}"
git add .
git commit -m"Initial Commit [$BRANCH_NAME]" --quiet

echo -e "${CYAN}* Creating the demo branches${NO_COLOR}"
echo -e "------------------------------------------------"
git branch demo-branch-1
git branch demo-branch-2
git --no-pager branch -a
echo -e "------------------------------------------------"

### -----------------------------------------------------------------
commitChanges demo-branch-1
commitChanges demo-branch-2

# Wait for user input to continue (max timeout 600 seconds)
echo -e "${RED}>>> Press any key to continue${NO_COLOR}"
read -t 600 -n 1

### -----------------------------------------------------------------
echo -e "${CYAN}* Content of ${GREEN}demo-branch-1:$FILE_NAME${NO_COLOR}"
echo -e "${YELLOW}      $(git show demo-branch-1:$FILE_NAME $FILE_NAME)${NO_COLOR}"

echo -e "${CYAN}* Content of ${GREEN}demo-branch-2:$FILE_NAME${NO_COLOR}"
echo -e "${YELLOW}      $(git show demo-branch-2:$FILE_NAME $FILE_NAME)${NO_COLOR}"

BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)
echo -e "${CYAN}* Current branch: ${GREEN}$BRANCH_NAME${NO_COLOR}"

echo -e "${CYAN}* Merging: ${PURPLE}\$(git merge demo-branch-1)${NO_COLOR}"
GIT_EDITOR=true git merge -

echo -e "------------------------------------------------"
### Merge and resolve the conflict
echo -e "${CYAN}* Content of ${GREEN}$FILE_NAME${CYAN} after merge${NO_COLOR}"
echo -e ""
echo -e "${CYAN}* Content of ${GREEN}demo-branch-1:$FILE_NAME${NO_COLOR}"
echo -e "${YELLOW}      $(git show demo-branch-1:$FILE_NAME $FILE_NAME)${NO_COLOR}"

echo -e "${CYAN}* Content of ${GREEN}demo-branch-2:$FILE_NAME${NO_COLOR}"
echo -e "${YELLOW}      $(git show demo-branch-2:$FILE_NAME $FILE_NAME)${NO_COLOR}"
