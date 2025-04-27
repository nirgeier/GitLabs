#!/bin/bash

clear
# Load the colors script
ROOT_FOLDER=$(git rev-parse --show-toplevel)
source ${ROOT_FOLDER}/_utils/colors.sh
source ${ROOT_FOLDER}/_utils/utils.sh

REPO_NAME="check-attr-demo"
echo -e "${CYAN}* Creating demo repository${NO_COLOR}"
rm -rf $REPO_NAME
mkdir $REPO_NAME
cd $REPO_NAME
git init --quiet

echo -e "${CYAN}* Creating .gitattributes with patterns${NO_COLOR}"
echo -e "*.txt text
*.sh eol=lf
*.jpg binary
important.txt customattr=foo" > .gitattributes
cat .gitattributes

echo -e "${CYAN}* Creating files${NO_COLOR}"
touch file.txt script.sh image.jpg important.txt

echo -e "${CYAN}* Checking attributes for all files${NO_COLOR}"
git check-attr --all -- file.txt script.sh image.jpg important.txt

echo -e "${CYAN}* Checking specific attribute (text)${NO_COLOR}"
git check-attr text -- file.txt script.sh image.jpg important.txt

echo -e "${CYAN}* Checking custom attribute (customattr)${NO_COLOR}"
git check-attr customattr -- important.txt file.txt
