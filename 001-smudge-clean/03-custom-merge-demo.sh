#!/bin/bash

# This script demonstrates the use of a custom Git merge driver to resolve merge conflicts automatically using a specified script.

clear
# Load the colors script
# Get the root folder of our demo folder
ROOT_FOLDER=$(git rev-parse --show-toplevel)
source ${ROOT_FOLDER}/_utils/colors.sh
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# Set the driver name and script
DRIVER_NAME=merge-custom-driver
DRIVER_SCRIPT=merge-script.sh
FILE_NAME=demo-file.txt

### Create the demo repository
echo -e "${CYAN}* Creating demo repository${NO_COLOR}"
rm -rf      /tmp/demo-smudge-merge-custom
mkdir -p    /tmp/demo-smudge-merge-custom
cd          /tmp/demo-smudge-merge-custom
git init  --quiet
cp $SCRIPT_DIR/03-custom-merge-script.sh /tmp/demo-smudge-merge-custom/${DRIVER_SCRIPT}

# Add the merge-script.sh to PATH
PATH=$PATH:`pwd`

echo -e "${CYAN}* Setting the desired custom driver in the .gitconfig${NO_COLOR}"
cat << EOF >> .git/config
###
### The driver property contains the command that 
### will be resolve the conflicts.
### 
### +----+---------------------------------------------------------+
### | %O | Ancestor’s    version of the conflicting file           |
### | %A | Current       version of the conflicting file           |
### | %B | Other         (branch) version of the conflicting file  |
### | %P | Path name     in which the merged result will be stored |
### | %L |               Conflict marker                           |
### +----+---------------------------------------------------------+

### The merge driver is expected to leave the result of the merge 
### in the file named with [%A] by overwriting it,
[merge "${DRIVER_NAME}"]
  name = A custom merge driver for Demo ....
  driver = ${DRIVER_SCRIPT} %O %A %B
EOF

echo -e "${CYAN}* Content of ${GREEN}.git/config${NO_COLOR}"
echo -e "------------------------------------------------"
echo -e "${YELLOW}$(cat .git/config)${NO_COLOR}"
echo -e "------------------------------------------------"

# Wait for user input to continue (max timeout 600 seconds)
echo -e "${RED}>>> Press any key to continue${NO_COLOR}"
read -t 600 -n 1

echo -e "${CYAN}* Adding the custom driver to the ${YELLOW}.gitattributes${NO_COLOR}"
echo "$FILE_NAME merge=${DRIVER_NAME}" > .gitattributes
echo -e "${CYAN}* Content of ${YELLOW}.gitattributes${NO_COLOR}"
echo -e "------------------------------------------------"
echo -e "${GREEN}$(cat .gitattributes)${NO_COLOR}"
echo -e "------------------------------------------------"

echo -e "${CYAN}* Committing changes${NO_COLOR}"
git add .
git commit -m"Initial Commit" --quiet

## Get the current branch name
BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)

echo -e "${CYAN}* Creating the demo branches${NO_COLOR}"
echo -e "${GREEN}\t${BRANCH_NAME}${NO_COLOR}"
echo -e "${GREEN}\tdemo-branch-1${NO_COLOR}"
git branch demo-branch-1
echo -e "${GREEN}\tdemo-branch-2${NO_COLOR}"
git branch demo-branch-2

### -----------------------------------------------------------------
### Build demo-branch-1
echo -e "${CYAN}* Creating content   in demo demo-branch-1${NO_COLOR}"
git checkout demo-branch-1 --quiet

BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)

echo $(git rev-parse --abbrev-ref HEAD) > $FILE_NAME
echo -e "${CYAN}* Committing changes to ${BRANCH_NAME}${NO_COLOR}"
git add .
git commit -m"Commit in: ${BRANCH_NAME}" --quiet

### -----------------------------------------------------------------
### Build demo-branch-2
echo -e "${CYAN}* Creating content   in demo demo-branch-2${NO_COLOR}"
git checkout demo-branch-2 --quiet

BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)

echo $(git rev-parse --abbrev-ref HEAD) > $FILE_NAME
echo -e "${CYAN}* Committing changes to ${BRANCH_NAME}${NO_COLOR}"
git add .
git commit -m"Commit in: ${BRANCH_NAME}" --quiet

# Wait for user input to continue (max timeout 600 seconds)
echo -e "${RED}>>> Press any key to continue${NO_COLOR}"
read -t 600 -n 1

### -----------------------------------------------------------------
### Merge and resolve the conflict
echo -e "${CYAN}* Content of ${GREEN}demo-branch-1:$FILE_NAME${NO_COLOR}"
echo -e "${YELLOW}      $(git show demo-branch-1:$FILE_NAME $FILE_NAME)${NO_COLOR}"

echo -e "${CYAN}* Content of ${GREEN}demo-branch-2:$FILE_NAME${NO_COLOR}"
echo -e "${YELLOW}      $(git show demo-branch-2:$FILE_NAME $FILE_NAME)${NO_COLOR}"

echo -e "${CYAN}* Merging: ${PURPLE}\$(git merge -m\"Merged in demo-branch-1\" demo-branch-1)${NO_COLOR}"
git merge -m"Merged in demo-branch-1" demo-branch-1

echo -e "------------------------------------------------"
### Merge and resolve the conflict
echo -e "${CYAN}* Content of ${GREEN}$FILE_NAME${CYAN} after merge${NO_COLOR}"
echo -e "------------------------------------------------"
echo -e "${YELLOW}      $(cat $FILE_NAME)${NO_COLOR}"
echo -e "------------------------------------------------"
