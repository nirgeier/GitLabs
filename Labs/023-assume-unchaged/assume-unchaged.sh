#!/bin/bash

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

GIT_REPO=git@github.com:nirgeier/demo-git-assume-unchanged.git

function printReadme(){
  echo -e ""
  echo -e "${GREEN}Current README.md file content${NO_COLOR}"
  echo -e "---------------------------------------------------------------------------"
  echo -e "${CYAN}$(cat README.md) ${NO_COLOR}"
  echo -e "---------------------------------------------------------------------------"
  echo -e ""
}

echo -e "${GREEN}* Creating demo repository${NO_COLOR}"
### Create the demo repository
rm -rf      /tmp/assumeUnChanged

### Init the empty repository
echo -e "${YELLOW}  * Cloning the remote repository${NO_COLOR}"
git clone $GIT_REPO /tmp/assumeUnChanged --quiet

echo -e "${YELLOW}  * Switch to the demo repository${NO_COLOR}"
cd /tmp/assumeUnChanged --quiet

echo -e "${YELLOW}  * Checkout the main branch${NO_COLOR}"
git checkout main --quiet

# Generate the local README.md file
echo -e "${GREEN}* Initializing README.md file${NO_COLOR}"
cat << EOF > README.md
## assume-unchanged demo
This is a simple project to demonstrate how \`git assume-unchanged\` works.
EOF

printReadme

# Add all files
echo -e "${GREEN}* Adding content (README) to demo repository${NO_COLOR}"
git add .

# Commit changes
echo -e "${YELLOW}  * Committing content to demo repository${NO_COLOR}"
git commit -m"Initial Commit" --quiet

echo -e "${YELLOW}  * Adding second commit with change to demo repository${NO_COLOR}"
echo "And this is another line added by other developer." >> README.md
echo "" >> README.md

printReadme

# Add all files
echo -e "${YELLOW}* Adding content to demo repository${NO_COLOR}"
git add . 

# Commit changes
echo -e "${YELLOW}* Committing content to demo repository${NO_COLOR}"
git commit -q -m"Second Commit" --quiet

# Push content to server
echo -e "${YELLOW}* Pushing content to demo repository: ${PURPLE}$GIT_REPO${NO_COLOR}"
git push --set-upstream origin main -f --quiet

echo -e "${YELLOW}* Waiting for User interaction to continue${NO_COLOR}"
echo -e "${RED}Enter any key to continue${NO_COLOR}"
read  -n 1 -t 30

# Go back commit to simulate changes on server but not locally
echo -e "${Red}* 'Undo' second commit - in order to simulate changes on server${NO_COLOR}"
git reset HEAD^1 --hard 

# Show diff between local README to the server 
echo -e "${YELLOW}* Show diff between local to server${NO_COLOR}"
git diff origin/main

# Show diff between local README to the server 
echo -e "${YELLOW}* Add local change to the file${NO_COLOR}"
echo "Added local line" >> README.md
echo "" >> README.md

# Mark the file as assume unchanged
echo -e "${YELLOW}* Mark the file as assume unchanged${NO_COLOR}"
echo -e "${PURPLE}  $ git update-index --assume-unchanged README.md${NO_COLOR}"
git update-index --assume-unchanged README.md

# Mark the file as assume unchanged
echo -e "${YELLOW}* Verify assume unchanged${NO_COLOR}"
echo -e "${PURPLE}  $ git ls-files -v | grep '^h'${NO_COLOR}"
git ls-files -v | grep '^h'

echo -e "${YELLOW}* Waiting for User interaction to continue${NO_COLOR}"
echo -e "${RED}Enter any key to continue${NO_COLOR}"
read  -n 1 -t 30

# Pull changes from server
echo -e "${YELLOW}* Update content from server${NO_COLOR}"
echo -e "${PURPLE}  $ git status${NO_COLOR}"
git status 

echo -e "${YELLOW}* Update content from server ${RED}[Should fail]${NO_COLOR}"
echo -e "${PURPLE}  $ git pull${NO_COLOR}"
git pull --quiet

printReadme

echo -e "${YELLOW}* Show diff between local to server${NO_COLOR}"
git diff main origin/main