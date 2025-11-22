#!/bin/bash

# This script demonstrates setting up Git hooks to enforce commit message formatting standards by configuring hooksPath and attempting commits with different messages.

clear

# Set the number of the desired commits
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

# Create the repository with first 1000 commits
generate_repository $NUMBER_OF_COMMITS

# Set hooks path
echo -e "${CYAN}* Setting hooksPath configuration ${NO_COLOR}"
echo -e "${PURPLE}  $ git config --local core.hooksPath $SCRIPT_DIR${NO_COLOR}"
git config --local core.hookspath $SCRIPT_DIR

echo -e "${CYAN}* Adding     ${YELLOW}file.txt ${NO_COLOR}"
echo 'text' > file.txt
git add .
echo -e "${CYAN}* Committing ${YELLOW}file.txt ${NO_COLOR}"
git commit -q -m "No Secret"

# Wait for user input to continue (max timeout 600 seconds)
echo -e "${RED}>>> Press any key to continue${NO_COLOR}"
read -t 600 -n 1

echo -e ""

echo -e "${CYAN}* Adding     ${YELLOW}secret.txt ${PURPLE}echo 'secret' > secret.txt${NO_COLOR}"
echo 'secret' > secret.txt
git add .
echo -e "${CYAN}* Committing ${YELLOW}secret.txt ${NO_COLOR}"
git commit -q -m "Secret Added"











