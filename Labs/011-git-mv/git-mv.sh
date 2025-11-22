#!/bin/bash

# This script demonstrates the difference between using the 'mv' command and 'git mv' for renaming files in a Git repository.

clear

# Set the number of the desired commits
NUMBER_OF_COMMITS=5

# Load the colors script
# Get the root folder of our demo folder
ROOT_FOLDER=$(git rev-parse --show-toplevel)
# Load the colors script
source ${ROOT_FOLDER}/_utils/colors.sh
source ${ROOT_FOLDER}/_utils/utils.sh

# Create the repository with first 1000 commits
generate_repository $NUMBER_OF_COMMITS

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

################################################################
### Demo Code to explain mv vs git mv
################################################################

# Add some dummy content
echo -e "${YELLOW}* Adding new files with lowercase ${NO_COLOR}"
echo -e "${CYAN}  * echo \$RANDOM > a.txt ${NO_COLOR}"
echo -e "${CYAN}  * echo \$RANDOM > b.txt ${NO_COLOR}"
echo $RANDOM > a.txt
echo $RANDOM > b.txt

# Commit the changes
echo -e "${YELLOW}* Add & commit changes ${NO_COLOR}"
git add .
git commit -q -m "Initial commit"

# Demo main code
echo -e "${YELLOW}---------------------------------------------------------------- ${NO_COLOR}"
echo -e "$     mv a.txt A1.txt"
echo -e "$ git mv b.txt B1.txt"
echo -e "${YELLOW}---------------------------------------------------------------- ${NO_COLOR}"

mv      a.txt A1.txt
git mv  b.txt B1.txt

echo -e "${YELLOW}* Check for changes ${NO_COLOR}"
echo -e " ${NO_COLOR}$ git status ${NO_COLOR}"
git status


