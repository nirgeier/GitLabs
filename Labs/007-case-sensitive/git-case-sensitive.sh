#!/bin/bash

clear

# Set the number of the desiYELLOW commits
NUMBER_OF_COMMITS=10

ROOT_FOLDER=$(git rev-parse --show-toplevel)
source ${ROOT_FOLDER}/_utils/colors.sh

# Load the colors script
# Get the root folder of our demo folder
ROOT_FOLDER=$(git rev-parse --show-toplevel)
# Load the colors script
source ${ROOT_FOLDER}/_utils/colors.sh
source ${ROOT_FOLDER}/_utils/utils.sh
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# Generate dummy repository
generate_repository

# Setup the ignore-case flag for the repository
echo -e ""
echo -e "${CYAN}-------------------------------       ${NO_COLOR}"
echo -e "${CYAN}Set up ignorecase flag to  ${YELLOW}true ${NO_COLOR}"
echo -e "${GREEN}git config core.ignorecase ${YELLOW}true  ${NO_COLOR}"
echo -e "${CYAN}-------------------------------       ${NO_COLOR}"
git config core.ignorecase true

## Create some content
echo -e ""
echo -e "${CYAN}* Creating file(s) with uppercase ${YELLOW}FILE.txt ${NO_COLOR}"
echo 'text' > FILE.txt

echo -e "${CYAN}* Adding and committing ${NO_COLOR}"
git add . && git commit -m "Added FILE.txt"

echo -e "${CYAN}* Review files in commit ${PURPLE}$ git diff-tree ... ${NO_COLOR}"
echo -e "${YELLOW}  $(git diff-tree --no-commit-id --name-only HEAD -r) ${NO_COLOR}"

echo -e "${CYAN}* Rename file to lowercase ${YELLOW}FILE.txt > file.txt${NO_COLOR}"
mv FILE.txt file.txt

echo -e "${CYAN}* List of files in the folder: ${PURPLE}find . -maxdepth 1 -type f${NO_COLOR}"
echo -e "${GREEN}$(find . -maxdepth 1 -type f) ${NO_COLOR}"

echo -e ""
echo -e "${CYAN}* View status for changes ${YELLOW}$(git config -l | grep core.ignorecase)${NO_COLOR}"
echo -e "${CYAN}---------------------------------------${NO_COLOR}"
echo -e "${GREEN}${YELLOW}$(git config -l | grep core.ignorecase) ${NO_COLOR}"

git status
echo -e "${CYAN}---------------------------------------${NO_COLOR}"

echo -e ""
echo -e "${CYAN}Set up ignorecase flag to  ${YELLOW}false ${NO_COLOR}"
echo -e "${GREEN}git config core.ignorecase ${YELLOW}false  ${NO_COLOR}"
echo -e "${CYAN}---------------------------------------${NO_COLOR}"
git config core.ignorecase false

echo -e "${CYAN}* View status for changes ${YELLOW}$(git config -l | grep core.ignorecase)${NO_COLOR}"
echo -e "${CYAN}---------------------------------------${NO_COLOR}"
git status
echo -e "${CYAN}---------------------------------------${NO_COLOR}"