#!/bin/bash

clear
# Load the colors script
ROOT_FOLDER=$(git rev-parse --show-toplevel)
source ${ROOT_FOLDER}/_utils/colors.sh
source ${ROOT_FOLDER}/_utils/utils.sh

REPO_NAME="interpret-trailers-demo"
echo -e "${CYAN}* Creating demo repository${NO_COLOR}"
rm -rf $REPO_NAME
mkdir $REPO_NAME
cd $REPO_NAME
git init --quiet

echo -e "${CYAN}* Creating a commit with a trailer${NO_COLOR}"
echo "hello world" > file.txt
git add file.txt
git commit -m $'Initial commit\n\nSigned-off-by: Alice <alice@example.com>' --quiet

COMMIT_HASH=$(git rev-parse HEAD)

echo -e "${CYAN}* Showing commit message with trailer${NO_COLOR}"
git log -1 --format=%B $COMMIT_HASH

echo -e "${CYAN}* Adding a new trailer using git interpret-trailers${NO_COLOR}"
git interpret-trailers --trailer "Reviewed-by: Bob <bob@example.com>" --in-place .git/COMMIT_EDITMSG <<< "$(git log -1 --format=%B $COMMIT_HASH)"

# Actually, let's use amend to add a trailer to the last commit
GIT_EDITOR="sed -i '' -e '$a\\nReviewed-by: Bob <bob@example.com>'" git commit --amend --no-edit

echo -e "${CYAN}* Showing updated commit message with new trailer${NO_COLOR}"
git log -1 --format=%B $COMMIT_HASH

echo -e "${CYAN}* Using git interpret-trailers to add another trailer${NO_COLOR}"
git interpret-trailers --trailer "Acked-by: Carol <carol@example.com>" --in-place .git/COMMIT_EDITMSG <<< "$(git log -1 --format=%B $COMMIT_HASH)"

# Amend again to add the new trailer
git commit --amend -F .git/COMMIT_EDITMSG --no-edit

echo -e "${CYAN}* Final commit message with all trailers${NO_COLOR}"
git log -1 --format=%B $COMMIT_HASH
