#!/bin/bash

# This script demonstrates Git worktree feature to work on multiple branches simultaneously.

clear
# Load the colors script
ROOT_FOLDER=$(git rev-parse --show-toplevel)
source ${ROOT_FOLDER}/_utils/colors.sh
source ${ROOT_FOLDER}/_utils/utils.sh

REPO_NAME="worktree-demo"
echo -e "${CYAN}* Creating demo repository${NO_COLOR}"
rm -rf $REPO_NAME $REPO_NAME-feature
mkdir $REPO_NAME
cd $REPO_NAME
git init --quiet

echo -e "${CYAN}* Creating initial commit${NO_COLOR}"
echo "main branch" > file.txt
git add file.txt
git commit -m "Initial commit on main" --quiet

echo -e "${CYAN}* Creating a new branch 'feature'${NO_COLOR}"
git branch feature

echo -e "${CYAN}* Adding a worktree for 'feature' branch${NO_COLOR}"
git worktree add ../${REPO_NAME}-feature feature

echo -e "${CYAN}* Listing all worktrees${NO_COLOR}"
git worktree list

echo -e "${CYAN}* Making a commit in the 'feature' worktree${NO_COLOR}"
cd ../${REPO_NAME}-feature
echo "feature branch" > feature.txt
git add feature.txt
git commit -m "Add feature.txt on feature branch" --quiet

echo -e "${CYAN}* Worktree status after commit:${NO_COLOR}"
git status

echo -e "${CYAN}* Returning to main worktree and showing status${NO_COLOR}"
cd ../$REPO_NAME
git status

echo -e "${CYAN}* Cleaning up worktrees${NO_COLOR}"
cd ..
rm -rf ${REPO_NAME}-feature $REPO_NAME
