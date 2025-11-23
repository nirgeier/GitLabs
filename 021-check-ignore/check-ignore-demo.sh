#!/bin/bash

clear
# Load the colors script
ROOT_FOLDER=$(git rev-parse --show-toplevel)
source ${ROOT_FOLDER}/_utils/colors.sh
source ${ROOT_FOLDER}/_utils/utils.sh

REPO_NAME="check-ignore-demo"
echo -e "${CYAN}* Creating demo repository${NO_COLOR}"
rm -rf $REPO_NAME
mkdir $REPO_NAME
cd $REPO_NAME
git init --quiet

echo -e "${CYAN}* Creating .gitignore with patterns${NO_COLOR}"
echo -e "*.log\nsecret.txt\nlogs/\n!important.log" > .gitignore
cat .gitignore

echo -e "${CYAN}* Creating files and directories${NO_COLOR}"
touch debug.log important.log secret.txt visible.txt
mkdir logs
cd logs
touch app.log error.log
cd ..

# Show which files are ignored

echo -e "${CYAN}* Checking which files are ignored${NO_COLOR}"
git check-ignore *

echo -e "${CYAN}* Checking files in logs/ directory${NO_COLOR}"
git check-ignore logs/*

echo -e "${CYAN}* Checking with -v (show matching pattern and source)${NO_COLOR}"
git check-ignore -v debug.log important.log secret.txt visible.txt

echo -e "${CYAN}* Checking multiple files recursively${NO_COLOR}"
git check-ignore -v -n $(find . -type f)
