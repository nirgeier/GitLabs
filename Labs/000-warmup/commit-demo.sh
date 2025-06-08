#!/bin/bash

clear
# Load the colors script
ROOT_FOLDER=$(git rev-parse --show-toplevel)
source ${ROOT_FOLDER}/_utils/colors.sh
source ${ROOT_FOLDER}/_utils/utils.sh

REPO_NAME="commit-demo"
echo -e "${CYAN}* Creating demo repository${NO_COLOR}"
rm -rf $REPO_NAME
mkdir $REPO_NAME
cd $REPO_NAME
git init --quiet

echo -e "${CYAN}* Creating a file and making the first commit${NO_COLOR}"
echo "Hello, Git!" > hello.txt
git add hello.txt
git commit -m "Initial commit: Add hello.txt" --quiet

echo -e "${CYAN}* Making a second commit${NO_COLOR}"
echo "Another line" >> hello.txt
git add hello.txt
git commit -m "Add another line to hello.txt" --quiet

echo -e "${CYAN}* Showing commit history${NO_COLOR}"
git log --oneline --decorate --graph --all

echo -e "${CYAN}* Cleaning up demo repository${NO_COLOR}"
cd ..
rm -rf $REPO_NAME
