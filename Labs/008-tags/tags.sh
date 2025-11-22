#!/bin/bash

# This script demonstrates creating Git tags (lightweight and annotated) on random commits in a repository and displaying tag information.

clear

ROOT_FOLDER=$(git rev-parse --show-toplevel)
source ${ROOT_FOLDER}/_utils/colors.sh

# Load the colors script
# Get the root folder of our demo folder
ROOT_FOLDER=$(git rev-parse --show-toplevel)

# Load the colors script
source ${ROOT_FOLDER}/_utils/colors.sh
source ${ROOT_FOLDER}/_utils/utils.sh
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# Disable git pager
git config --replace-all core.pager "less -F -X"

### Define the desired tags.
TAG1=v1.0
TAG2=v2.0

### Choose a random commit for tag1
RANDOM_COMMIT1=$(( ( $RANDOM % 15 )  + 10 ))

### Choose a random commit for tag2
RANDOM_COMMIT2=$(( ( $RANDOM % 15 )  + 10 ))

echo -e ""
echo -e "${CYAN}* Pre-defined tags commit numbers:${NO_COLOR}"
echo -e "------------------------------------------------"
echo -e "${CYAN}TAG1:\t${GREEN}${TAG1} -> ${RANDOM_COMMIT1}${NO_COLOR}"
echo -e "${CYAN}TAG2:\t${GREEN}${TAG2} -> ${RANDOM_COMMIT2}${NO_COLOR}"
echo -e ""

echo -e "${CYAN}* Creating\t demo repository${NO_COLOR}"
### Create the demo repository
rm -rf      /tmp/demo_tags
mkdir -p    /tmp/demo_tags
cd          /tmp/demo_tags

## Init git repo
git init --quiet

## Add few commits
echo -e "${CYAN}* Adding some commits, will be tagged later${NO_COLOR}"
for i in {10..25}
do
  # Create the dummy file(s)
  touch ./file_${i}.txt
  # Add and commit the files
  git add . && git commit -q -m"File #${i}"
  # Add tag if its the first commit
  if [ "$i" -eq "$RANDOM_COMMIT1" ]; 
  then
    echo -e "${PURPLE}* Tagging [${YELLOW}$TAG1${CYAN}]${NO_COLOR}"
    git tag $TAG1
  fi

  # Add annotated tag if its the first commit
  if [ "$i" -eq "$RANDOM_COMMIT2" ]; 
  then
    echo -e "${PURPLE}* Tagging annotated tag [${YELLOW}$TAG2${CYAN}]${NO_COLOR}"
    git tag -a $TAG2 -m"Made by script (Commit #${i})"
  fi
done

# Wait for user input to continue (max timeout 600 seconds)
echo -e "${RED}>>> Press any key to continue${NO_COLOR}"
read -t 600 -n 1

echo -e ""
echo -e "Display tags:"
echo -e "------------------------------------------------"
echo -e "${CYAN}TAG1:\t${GREEN}${TAG1} -> ${RANDOM_COMMIT1}${NO_COLOR}"
echo -e ""
git show $TAG1 --no-patch
echo -e "------------------------------------------------"
echo -e "${CYAN}TAG2:\t${GREEN}${TAG2} -> ${RANDOM_COMMIT2}${NO_COLOR}"
echo -e ""
git show $TAG2 --no-patch
