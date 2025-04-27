#!/bin/bash

clear
# Load the colors script
ROOT_FOLDER=$(git rev-parse --show-toplevel)
source ${ROOT_FOLDER}/_utils/colors.sh
source ${ROOT_FOLDER}/_utils/utils.sh

# Set the script directory
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# Create a new directory for the demo
REPO_NAME="replace-demo"
echo -e "${CYAN}* Creating demo repository${NO_COLOR}"
rm -rf $REPO_NAME
mkdir $REPO_NAME
cd $REPO_NAME
git init --quiet

echo -e "${CYAN}* Creating initial file and commit${NO_COLOR}"
echo "First version" > file.txt
git add file.txt
git commit -m "Initial commit" --quiet

# Save the commit hash
echo -e "${CYAN}* Creating second commit${NO_COLOR}"
echo "Second version" > file.txt
git commit -am "Second commit" --quiet

# Save the commit hashes
FIRST_COMMIT=$(git rev-list --max-parents=0 HEAD)
SECOND_COMMIT=$(git rev-parse HEAD)

echo -e "${YELLOW}* Commit history before replace${NO_COLOR}"
git log --oneline --graph

echo -e "${CYAN}* Show content of first commit${NO_COLOR}"
git show $FIRST_COMMIT:file.txt

echo -e "${RED}--------------------------------------------${NO_COLOR}"
echo -e "${YELLOW}* Using git replace to replace first commit with second commit${NO_COLOR}"
echo -e "${YELLOW}    git replace ${GREEN}$FIRST_COMMIT $SECOND_COMMIT${NO_COLOR}"
git replace $FIRST_COMMIT $SECOND_COMMIT

echo -e "${CYAN}* Show content of first commit after replace (should match second commit)${NO_COLOR}"
git show $FIRST_COMMIT:file.txt

echo -e "${CYAN}* Show git log with replacements applied${NO_COLOR}"
git log --oneline --graph

echo -e "${CYAN}* List replacements:${NO_COLOR}"
echo -e "${YELLOW}    git replace -l${NO_COLOR}"
git replace -l

echo -e "${CYAN}* To remove the replacement:${NO_COLOR}"
echo -e "${YELLOW}    git replace -d $FIRST_COMMIT${NO_COLOR}"
git replace -d $FIRST_COMMIT