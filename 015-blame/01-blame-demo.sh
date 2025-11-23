#!/bin/bash

# This script demonstrates Git blame with options to track code origins, ignoring whitespace and following copies.

clear
# Load the colors script
ROOT_FOLDER=$(git rev-parse --show-toplevel)
source ${ROOT_FOLDER}/_utils/colors.sh
source ${ROOT_FOLDER}/_utils/utils.sh

REPO_NAME="blame-demo"
echo -e "${CYAN}* Creating demo repository${NO_COLOR}"
rm -rf $REPO_NAME
mkdir $REPO_NAME
cd $REPO_NAME
git init --quiet

echo -e "${CYAN}* Creating initial file and commit${NO_COLOR}"
echo -e "line 1\nline 2\nline 3" > original.txt
git add original.txt
git commit -m "Initial commit with original.txt" --quiet

echo -e "${CYAN}* Copying file and modifying with whitespace changes${NO_COLOR}"
cp original.txt copied.txt
# Add whitespace changes and a new line
echo -e "  line 1\nline 2  \nline 3\nline 4" > copied.txt
git add copied.txt
git commit -m "Add copied.txt with whitespace changes and new line" --quiet

echo -e "${CYAN}* Using git blame -w -C -C -C on copied.txt${NO_COLOR}"
echo -e "${YELLOW}    git blame -w -C -C -C copied.txt${NO_COLOR}"
git blame -w -C -C -C copied.txt
