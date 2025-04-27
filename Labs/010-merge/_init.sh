#!/bin/bash

clear

# Set the number of the desired commits
NUMBER_OF_COMMITS=5

# Load the colors script
# Get the root folder of our demo folder
ROOT_FOLDER=$(git rev-parse --show-toplevel)
# Load the colors script
source ${ROOT_FOLDER}/_utils/colors.sh
source ${ROOT_FOLDER}/_utils/utils.sh

# Create the repository with first 1000 commits
generate_repository $NUMBER_OF_COMMITS

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

echo -e "${CYAN}* Create feature branch and add commits${NO_COLOR}"
git checkout -b feature
for i in {1..3}; do
  echo "feature change $i" >> file.txt
  git add file.txt
  git commit -q -m "Feature commit $i"
done
git tag __feature_commit__

echo -e "${CYAN}* Switch back to main and add a commit${NO_COLOR}"
git checkout main
for i in {1..1}; do
  echo "main change $i" >> file.txt
  git add file.txt
  git commit -q -m "Main commit $i"
done

echo -e "${CYAN}* Tag the current commit so we will be able to return to it later${NO_COLOR}"
git tag __main_commit__

