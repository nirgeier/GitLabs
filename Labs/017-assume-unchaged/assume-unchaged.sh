#!/bin/bash

# This script demonstrates Git assume-unchanged flag to ignore changes to tracked files.

clear

ROOT_FOLDER=$(git rev-parse --show-toplevel)
source ${ROOT_FOLDER}/_utils/colors.sh
source ${ROOT_FOLDER}/_utils/utils.sh

REPO_NAME="assume-unchanged-demo"
echo -e "${CYAN}* Creating demo repository${NO_COLOR}"
rm -rf $REPO_NAME
mkdir $REPO_NAME
cd $REPO_NAME
git init --quiet

echo -e "${CYAN}* Creating a tracked file${NO_COLOR}"
echo "original content" > tracked.txt
git add tracked.txt
git commit -m "Add tracked.txt" --quiet

echo -e "${CYAN}* Modifying tracked.txt${NO_COLOR}"
echo "modified content" > tracked.txt

echo -e "${CYAN}* Status before assume-unchanged:${NO_COLOR}"
git status -s

echo -e "${YELLOW}# Mark tracked.txt as assume-unchanged${NO_COLOR}"
git update-index --assume-unchanged tracked.txt

echo -e "${CYAN}* Status after assume-unchanged:${NO_COLOR}"
git status -s

echo -e "${CYAN}* Making another change to tracked.txt${NO_COLOR}"
echo "another change" > tracked.txt

echo -e "${CYAN}* Status after another change (still hidden):${NO_COLOR}"
git status -s

echo -e "${RED}### Resetting tracked.txt to original content${NO_COLOR}"
echo -e "${YELLOW}# Unset assume-unchanged for tracked.txt${NO_COLOR}"
git update-index --no-assume-unchanged tracked.txt

echo -e "${CYAN}* Status after unsetting assume-unchanged:${NO_COLOR}"
git status -s