#!/bin/bash

# This script demonstrates the use of git bisect to identify the commit that introduced a bug by creating a repository with commits, introducing a bug, and running bisect with a test script.

clear

# Set the number of the desired commits
NUMBER_OF_COMMITS=1000

# Load the colors script
# Get the root folder of our demo folder
ROOT_FOLDER=$(git rev-parse --show-toplevel)
# Load the colors script
source ${ROOT_FOLDER}/_utils/colors.sh
source ${ROOT_FOLDER}/_utils/utils.sh

# Set the script directory
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# Create the repository with first 1000 commits
generate_repository $NUMBER_OF_COMMITS

echo -e "${CYAN}* Adding the ${RED}bug${CYAN} to the code [${YELLOW}'Here is the bug.'${CYAN}]${NO_COLOR}"
echo 'Here is the bug.' >> random1.txt
echo -e "${CYAN}* Committing the bug${NO_COLOR}"
git add . 
git commit -m "The bug is in this commit" --quiet

echo -e "${YELLOW}\t----------------------------------------- ${NO_COLOR}"
echo -e "${GREEN}\t The SHA-1 of the commit with the bug:     ${NO_COLOR}"
echo -e "${YELLOW}\t $(git rev-parse HEAD)                     ${NO_COLOR}"
echo -e "${YELLOW}\t----------------------------------------- ${NO_COLOR}"

echo -e "${CYAN}* Randomize repository content with additional ${YELLOW}$NUMBER_OF_COMMITS${CYAN} commits ${NO_COLOR}"
generate_commits $NUMBER_OF_COMMITS

# Get the total number of commits in the repository
TOTAL_NUMBER_OF_COMMIT=$(git rev-list --all --count)
echo -e "${YELLOW}* Number of commits: ${GREEN}" $TOTAL_NUMBER_OF_COMMIT ${NO_COLOR}

# Start the bisect demo
echo -e "${CYAN}* Starting bisect ${NO_COLOR}"
echo -e ""
git bisect good HEAD~$((TOTAL_NUMBER_OF_COMMIT-1))
echo -e ""
git bisect bad HEAD

echo -e "${CYAN}* Searching for the bug ${NO_COLOR}"
echo -e ""
git bisect run $SCRIPT_DIR/bisectScript.sh










