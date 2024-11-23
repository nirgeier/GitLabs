#!/bin/bash

clear

cd "$(dirname "$0")"
SCRIPT_DIR="$(pwd)"

# Load the colors script
source ../_utils/colors.sh
source ../_utils/utils.sh

# Create the repository with first 1000 commits
generate_repository 1

echo -e "${GREEN}* Creating dummy git content ${NO_COLOR}"

# Create dummy content
mkdir -p {client,server}

# Create dummy commits in client folder
echo -e "${GREEN}* Commiting to client & server folders ${NO_COLOR}"
for i in {10..15}
do
    # Commit to the client folder
    echo "Commit #: $i" >> ./client/file.txt
    git add .
    git commit -m"Client - Commit #${i}" 1> /dev/null

    # Commit to the server folder
    echo "Commit #: $((i+10))" >> ./server/file.txt
    git add .
    git commit -m"Server - Commit #$((i+10))" 1> /dev/null
done

echo -e "${YELLOW}* List branches"
git branch -a

echo -e "${YELLOW}* List commits"
git log --oneline --graph --decorate

echo -e "${RED}Press any key to continue..."
read -n 1   

# echo -e "${GREEN}* Creating branch for split ${NO_COLOR}"
# git checkout -b branch1
# echo -e ""


echo -e "${GREEN}* Split the content [${YELLOW}client${GREEN}] to [${YELLOW}client_branch${GREEN}]${NO_COLOR}"
echo -e "${YELLOW}-----------------------------------"
git subtree split -P client -b client_branch 

echo -e "${GREEN}* Split the content [${YELLOW}server${GREEN}] to [${YELLOW}server_branch${GREEN}]${NO_COLOR}"
echo -e "${YELLOW}-----------------------------------"
git subtree split -P server -b server_branch 
echo -e "${YELLOW}-----------------------------------"

echo -e "${YELLOW}* List branches"
git branch -a

echo -e ""
echo -e "${RED}Press any key to continue..."
read -n 1   

echo -e "${YELLOW}------------------------------------------"
echo -e "${YELLOW}* View Client branch content"
git log --oneline --graph --decorate client_branch

echo -e "${YELLOW}------------------------------------------"
echo -e "${YELLOW}* View Server branch content"
git log --oneline --graph --decorate server_branch

