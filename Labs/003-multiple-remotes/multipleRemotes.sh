#!/bin/bash

cd "$(dirname "$0")"
SCRIPT_DIR="$(pwd)"

clear
# Load the colors script
# Get the root folder of our demo folder
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
ROOT_FOLDER=$(git rev-parse --show-toplevel)
source ${ROOT_FOLDER}/_utils/colors.sh
source ${ROOT_FOLDER}/_utils/utils.sh

GIT_REPOS=(
  "/tmp/git-demo-remoteA"
  "/tmp/git-demo-remoteB"
  "/tmp/git-demo-remoteC"
)

# Cleanup previous repositories
for repo in "${GIT_REPOS[@]}"; 
do
  echo -e "${CYAN}* Cleaning up  [${YELLOW}${repo}${CYAN}]${NO_COLOR}"
  rm -rf $repo

  # Create the required git repositories
  echo -e "${CYAN}* Creating the required repositories ${NO_COLOR}"
  git init -q $repo 

  # Add a remote to the first repository
  echo -e "${CYAN}* Commit code to [${YELLOW}${repo}${CYAN}]${NO_COLOR}"
  cd    $repo
  echo  $RANDOM > $RANDOM.txt
  git   add . 
  git   commit -q -m "Initial commit $repo" 
done

# Wait for user input to continue (max timeout 600 seconds)
echo -e "${RED}>>> Press any key to continue${NO_COLOR}"
read -t 600 -n 1

# Add a second remote to the second repository
echo -e "${CYAN}* Adding additional remotes to [${YELLOW}git-demo-remoteA${CYAN}]${NO_COLOR}"
cd      /tmp/git-demo-remoteA
git remote add remoteB /tmp/git-demo-remoteB
git remote add remoteC /tmp/git-demo-remoteC
echo -e "${CYAN}* List remotes in: /tmp/git-demo-remoteA ${NO_COLOR}"
git remote -v

# Wait for user input to continue (max timeout 600 seconds)
echo -e "${RED}>>> Press any key to continue${NO_COLOR}"
read -t 600 -n 1

echo -e "${YELLOW}* Fetch all remotes ${NO_COLOR}"
echo -e "${RED}---------------------------------------------------------------- ${GREEN}"
git fetch --all
echo -e "${RED}---------------------------------------------------------------- ${GREEN}"

echo -e ""
echo -e "${YELLOW}* List all Branches ${NO_COLOR}"
echo -e "${RED}---------------------------------------------------------------- ${NO_COLOR}"
git --no-pager branch -a
echo -e "${RED}---------------------------------------------------------------- ${NO_COLOR}"

exit 1;
echo -e "${YELLOW}* Pull Commits from different remotes ${NO_COLOR}"
cd /tmp/git-demo-remoteB
remoteB=$(git rev-parse HEAD)
echo -e "${CYAN}  * Latest commit on remoteB [${YELLOW}$remoteB${CYAN}]${NO_COLOR}"

cd /tmp/git-demo-remoteC
remoteC=$(git rev-parse HEAD)
echo -e "${CYAN}  * Latest commit on remoteC [${YELLOW}$remoteC${CYAN}]${NO_COLOR}"

echo -e "${YELLOW}* Pull remoteB commit to remoteA ${NO_COLOR}"
cd      /tmp/git-demo-remoteA
git cherry-pick $remoteB >> /dev/null

echo -e "${YELLOW}* Pull remoteB commit to remoteC ${NO_COLOR}"
cd      /tmp/git-demo-remoteA
git cherry-pick $remoteC >> /dev/null

echo -e "${YELLOW}* List commit on remoteA ${NO_COLOR}"
cd      /tmp/git-demo-remoteA
echo -e "${RED}---------------------------------------------------------------- ${NO_COLOR}"
git log --oneline --graph --decorate
echo -e "${RED}---------------------------------------------------------------- ${NO_COLOR}"

