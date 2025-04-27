#!/bin/bash

clear
# Load the colors script
ROOT_FOLDER=$(git rev-parse --show-toplevel)
source ${ROOT_FOLDER}/_utils/colors.sh
source ${ROOT_FOLDER}/_utils/utils.sh

REPO_NAME="clean-demo"
echo -e "${CYAN}* Creating demo repository${NO_COLOR}"
rm -rf $REPO_NAME
mkdir $REPO_NAME
cd $REPO_NAME
git init --quiet

echo -e "${CYAN}* Creating files and folders${NO_COLOR}"
echo "tracked file" > tracked.txt
echo "untracked file" > untracked.txt
mkdir untracked_dir
echo "file in dir" > untracked_dir/file.txt
touch .gitignore
echo "ignored.txt" > .gitignore
echo "ignored file" > ignored.txt
git add tracked.txt .gitignore
git commit -m "Initial commit with tracked and ignored files" --quiet

echo -e "${CYAN}* Current status:${NO_COLOR}"
git status -s

echo -e "\n${YELLOW}# git clean -n${NO_COLOR} (dry run, shows what would be deleted)"
git clean -n

echo -e "\n${YELLOW}# git clean -f${NO_COLOR} (force, actually deletes untracked files)"
git clean -f

echo -e "${CYAN}* Status after -f:${NO_COLOR}"
git status -s

echo "untracked again" > untracked2.txt
mkdir untracked_dir2
echo "file in dir2" > untracked_dir2/file2.txt

echo -e "\n${YELLOW}# git clean -fd${NO_COLOR} (force, delete untracked files and directories)"
git clean -fd

echo -e "${CYAN}* Status after -fd:${NO_COLOR}"
git status -s

echo "ignored file" > ignored.txt

echo -e "\n${YELLOW}# git clean -fx${NO_COLOR} (force, remove ignored files as well)"
git clean -fx

echo -e "${CYAN}* Status after -fx:${NO_COLOR}"
git status -s

echo "ignored file" > ignored.txt

echo -e "\n${YELLOW}# git clean -fX${NO_COLOR} (force, remove only ignored files)"
git clean -fX

echo -e "${CYAN}* Status after -fX:${NO_COLOR}"
git status -s

echo "untracked again" > untracked3.txt

echo -e "\n${YELLOW}# git clean -fi${NO_COLOR} (force, interactive mode)"
echo "n" | git clean -fi

echo -e "${CYAN}* Status after -fi (should be unchanged):${NO_COLOR}"
git status -s
