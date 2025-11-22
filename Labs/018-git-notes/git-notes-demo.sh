#!/bin/bash

# This script demonstrates Git notes feature to add metadata to commits.

clear
# Load the colors script
ROOT_FOLDER=$(git rev-parse --show-toplevel)
source ${ROOT_FOLDER}/_utils/colors.sh
source ${ROOT_FOLDER}/_utils/utils.sh

REPO_NAME="notes-demo"
echo -e "${CYAN}* Creating demo repository${NO_COLOR}"
rm -rf $REPO_NAME
mkdir $REPO_NAME
cd $REPO_NAME
git init --quiet

echo -e "${CYAN}* Creating a commit${NO_COLOR}"
echo "hello world" > file.txt
git add file.txt
git commit -m "Initial commit" --quiet

COMMIT_HASH=$(git rev-parse HEAD)

echo -e "${CYAN}* Adding a note to the commit${NO_COLOR}"
git notes add -m "This is a note for the initial commit."

echo -e "${CYAN}* Showing the note with git log --show-notes${NO_COLOR}"
git log --show-notes

echo -e "${CYAN}* Listing all notes${NO_COLOR}"
git notes list

echo -e "${CYAN}* Showing the note for the commit directly${NO_COLOR}"
git notes show $COMMIT_HASH

echo -e "${CYAN}* Editing the note${NO_COLOR}"
git notes append -m "Appended note."
git notes show $COMMIT_HASH

echo -e "${CYAN}* Removing the note${NO_COLOR}"
git notes remove $COMMIT_HASH

git log --show-notes
