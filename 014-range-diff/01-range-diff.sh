#!/bin/bash

# This script demonstrates Git range-diff to compare commit ranges before and after operations like rebase.

clear
# Load the colors script
ROOT_FOLDER=$(git rev-parse --show-toplevel)
source ${ROOT_FOLDER}/_utils/colors.sh
source ${ROOT_FOLDER}/_utils/utils.sh

REPO_NAME="range-diff-demo"
echo -e "${CYAN}* Creating demo repository${NO_COLOR}"
rm -rf $REPO_NAME
mkdir $REPO_NAME
cd $REPO_NAME
git init --quiet

echo -e "${CYAN}* Creating base commit on main${NO_COLOR}"
echo "base" > file.txt
git add file.txt
git commit -m "Base commit" --quiet

echo -e "${CYAN}* Creating feature branch with two commits${NO_COLOR}"
git checkout -b feature
echo "feature1" > feature.txt
git add feature.txt
git commit -m "Feature commit 1" --quiet
echo "feature2" >> feature.txt
git commit -am "Feature commit 2" --quiet

echo -e "${CYAN}* Creating new base branch with a new commit${NO_COLOR}"
git checkout main
git checkout -b newbase
echo "newbase" >> file.txt
git commit -am "New base commit" --quiet

echo -e "${CYAN}* Rebasing feature onto newbase${NO_COLOR}"
git checkout feature
git rebase newbase

echo -e "${CYAN}* Using git range-diff to compare commit series before and after rebase${NO_COLOR}"
echo -e "${YELLOW}    git range-diff main..feature@{1} newbase..feature${NO_COLOR}"
git range-diff main..feature@{1} newbase..feature